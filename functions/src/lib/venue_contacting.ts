/* eslint-disable import/no-unresolved */

import { onRequest } from "firebase-functions/v2/https";
import {
  contactVenuesRef,
  fcm,
  OPEN_AI_KEY,
  orphanEmailsRef,
  POSTMARK_SERVER_ID,
  SLACK_WEBHOOK_URL,
  streamKey,
  streamSecret,
  usersRef,
} from "./firebase";
// import sgMail from "@sendgrid/mail";
import { debug, error, info } from "firebase-functions/logger";
import * as postmark from "postmark";
// import { getFoundersDeviceTokens } from "./utils";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { StreamChat, User } from "stream-chat";
import { contactVenueTemplate } from "../email_templates/contact_venue";
import { UserModel, VenueContactRequest } from "../types/models";
import { getFoundersDeviceTokens } from "./utils";
import { chatGpt } from "./openai";
import { notifyFounders, slackNotification } from "./notifications";

function createEmailMessageId() {
  const currentTime = Date.now().toString(36);
  const randomPart = Math.floor(
    Math.random() * Number.MAX_SAFE_INTEGER
  ).toString(36);
  const messageId = `<${currentTime}.${randomPart}@tapped.ai>`;

  return messageId;
}

async function sendAsEmail({
  venueContactData,
  userId,
  venue,
}: {
  venueContactData: VenueContactRequest;
  userId: string;
  venue: UserModel;
}) {
  const bookingEmail = venueContactData.bookingEmail;
  if (!bookingEmail) {
    error("no bookingEmail found");
    return;
  }

  const note = venueContactData.note ?? "";

  const user = venueContactData.user as UserModel | undefined;
  if (user === undefined) {
    error("no user found");
    return;
  }

  const username = user.username;
  // const userEmail = user.email;

  // const devices = await getFoundersDeviceTokens();
  // const payload = {
  //   notification: {
  //     title: `${username} wants to contact ${venue?.artistName} \uD83D\uDE43`,
  //     body: `they used the email ${bookingEmail}`,
  //   }
  // };

  // fcm.sendToDevice(devices, payload);
  const client = new postmark.ServerClient(POSTMARK_SERVER_ID.value());
  const messageId = createEmailMessageId();

  const { subject, body } = await writeEmailWithAi({
    performer: user,
    venue: venueContactData?.venue,
    note,
  });

  const { text, html } = contactVenueTemplate({
    performer: user,
    emailText: body,
  });

  const ccs = [
    "johannes@tapped.ai",
    "ilias@tapped.ai",
    // userEmail,
  ].join(",");

  const emailObj = {
    Headers: [
      {
        Name: "Message-ID",
        Value: messageId,
      },
    ],
    From: `${username}@booking.tapped.ai`,
    To: bookingEmail,
    Cc: ccs,
    Subject: subject,
    HtmlBody: html,
    TextBody: text,
    MessageStream: "outbound",
    TrackOpens: true,
  };

  // add msg id to initial request
  await contactVenuesRef
    .doc(userId)
    .collection("venuesContacted")
    .doc(venue.id)
    .set(
      {
        subject,
        originalMessageId: messageId,
        latestMessageId: messageId,
      },
      { merge: true }
    );

  // add email to emails collection
  await contactVenuesRef
    .doc(userId)
    .collection("venuesContacted")
    .doc(venue.id)
    .collection("emailsSent")
    .add(emailObj);

  const res = await client.sendEmail(emailObj);
  debug({ res });
}

async function sendAsDirectMessage({
  streamClient,
  venueId,
  userId,
  note,
}: {
  streamClient: StreamChat;
  venueId: string;
  userId: string;
  note: string;
}) {
  // create DM channel between both parties
  const token = streamClient.createToken(userId);
  await streamClient.connectUser(
    {
      id: userId,
    },
    token
  );

  // join channel
  const channel = streamClient.channel("messaging", {
    members: [ userId, venueId ],
  });
  await channel.create();

  // post msg
  const noteString = note !== "" ? ` - ${note}` : "";
  await channel.sendMessage({
    text: `hey! I was recommended to contact you about performing at your venue ${noteString}`,
  });

  // disconnectUser
  await streamClient.disconnectUser();
}

async function dmAutoReply({
  streamClient,
  venueId,
  userId,
  autoReply,
}: {
  streamClient: StreamChat;
  venueId: string;
  userId: string;
  autoReply: string;
}) {
  // create DM channel between both parties
  const token = streamClient.createToken(venueId);
  await streamClient.connectUser(
    {
      id: venueId,
    },
    token
  );

  // join channel
  const channel = streamClient.channel("messaging", {
    members: [ userId, venueId ],
  });
  await channel.create();

  // post msg
  await channel.sendMessage({
    text: autoReply,
  });

  // disconnectUser
  await streamClient.disconnectUser();
}

async function sendStreamMessageFromEmail({
  streamClient,
  userId,
  venueId,
  message,
}: {
  streamClient: StreamChat;
  userId: string;
  venueId: string;
  message: string;
}) {
  // create DM channel between both parties
  const token = streamClient.createToken(venueId);
  await streamClient.connectUser(
    {
      id: venueId,
    },
    token
  );

  // join channel
  const channel = streamClient.channel("messaging", {
    members: [ userId, venueId ],
  });
  await channel.create();

  // post msg
  await channel.sendMessage({
    text: message,
  });

  // disconnectUser
  await streamClient.disconnectUser();
}

async function sendEmailFromStreamMessage({
  emailClient,
  user,
  venue,
  message,
}: {
  emailClient: postmark.ServerClient;
  user: User;
  venue: User;
  message: string;
}) {
  // get venue contact info (i.e. messageId)
  const contactRequestSnap = await contactVenuesRef
    .doc(user.id)
    .collection("venuesContacted")
    .doc(venue.id)
    .get();

  const contactRequestData = contactRequestSnap.data();
  const latestMessageId = contactRequestData?.latestMessageId;
  const subject = contactRequestData?.subject ?? "Booking Inquiry";
  const allEmails = contactRequestData?.allEmails ?? [];

  if (!latestMessageId) {
    error("no latest messageId found");
    throw new Error("no latest messageId found");
  }

  if (allEmails.length === 0) {
    error("no emails for this contact request found");
    throw new Error("no emails for this contact request found");
  }

  // add msg to emails collection
  const username = user.username;
  if (username === undefined) {
    error("no username found");
    throw new Error("no username found");
  }

  const messageId = createEmailMessageId();

  const emailObj = {
    From: `${username}@booking.tapped.ai`,
    To: allEmails.join(","),
    Headers: [
      {
        Name: "Message-ID",
        Value: messageId,
      },
      {
        Name: "References",
        Value: latestMessageId,
      },
      {
        Name: "In-Reply-To",
        Value: latestMessageId,
      },
    ],
    Subject: subject,
    HtmlBody: message,
    TextBody: message,
    MessageStream: "outbound",
  };

  await contactVenuesRef
    .doc(user.id)
    .collection("venuesContacted")
    .doc(venue.id)
    .update({
      latestMessageId: messageId,
    });

  // add email to emails collection
  await contactVenuesRef
    .doc(user.id)
    .collection("venuesContacted")
    .doc(venue.id)
    .collection("emailsSent")
    .add(emailObj);

  // send email to venue
  const emailRes = await emailClient.sendEmail(emailObj);
  debug({ emailRes });

  return;
}

async function writeEmailWithAi({
  performer,
  venue,
  note,
}: {
  performer: UserModel;
  venue: UserModel;
  note: string;
}): Promise<{
  subject: string;
  body: string;
}> {
  const username = performer.username;
  const displayName = performer.artistName || username;
  const genres = performer.performerInfo?.genres?.join(", ") ?? "";

  const venueName = venue.artistName;
  const subject = `Performance Inquiry from ${displayName}`;

  const res = await chatGpt(`
  Venue Name: ${venueName}
  Performer Name: ${displayName}
  ${genres !== "" ? `Perfomers Genres: ${genres}` : ""}

  Note: ${note}

  Given the information above, write an paragraph to send to venues to request a booking in the style
  of a musicians looking to perform there.
  The paragraph should be friendly, professional, and a little dry (i.e. straight to the point).
  Be sure to mention that you were recommended to reach out be Tapped Ai.
  Your response should ONLY use the information provider and assume that's all the information that's available.
  Don't include any intro like "dear venue owner" or signature like "sincerly" or "thanks".
  Be concise, to the point and keep it short.
  `);

  return {
    subject,
    body: res,
  };
}

export const notifyFoundersOnVenueContact = onDocumentCreated(
  {
    document: "contactVenues/{userId}/venuesContacted/{venueId}",
    secrets: [ POSTMARK_SERVER_ID, streamKey, streamSecret, OPEN_AI_KEY ],
  },
  async (event) => {
    try {
      process.env.OPENAI_API_KEY = OPEN_AI_KEY.value();
      const snapshot = event.data;
      const venueContactData = snapshot?.data() as
        | VenueContactRequest
        | undefined;
      if (venueContactData === undefined) {
        error("no venueContactData found");
        return;
      }

      const venueId = event.params.venueId;
      const userId = event.params.userId;

      const streamChat = new StreamChat(
        streamKey.value(),
        streamSecret.value()
      );

      // check if claimed or unclaimed
      // if claimed, send message as DM, and return;
      const venueSnap = await usersRef.doc(venueId).get();
      const venueData = venueSnap.data() as UserModel | undefined;
      if (venueData === undefined) {
        error("no venueData found");
        return;
      }

      // if autoreply setup, send autoreply as DM;
      const autoReply = venueData.venueInfo?.autoReply;
      if (autoReply !== undefined && autoReply !== null) {
        await dmAutoReply({
          streamClient: streamChat,
          venueId,
          userId,
          autoReply,
        });
        return;
      }

      const note = venueContactData.note ?? "";

      const unclaimed = venueData.unclaimed;
      if (!unclaimed) {
        await sendAsDirectMessage({
          streamClient: streamChat,
          userId,
          venueId,
          note,
        });
        return;
      }

      await sendAsEmail({
        venueContactData,
        userId,
        venue: venueData,
      });
    } catch (e: any) {
      error(e);
      await notifyFounders({
        title: "Error in venue contact",
        body: e.message,
      });
    }
  }
);

export const inboundEmailWebhook = onRequest(
  { secrets: [ POSTMARK_SERVER_ID, streamKey, streamSecret, SLACK_WEBHOOK_URL, ] },
  async (req, res) => {
    const body = req.body;
    try {
      const subject = body.Subject;
      const to = body.To;
      const from = body.From;
      const references = body.Headers.find(
        (h: { Name: string; Value: string }) => h.Name === "References"
      )?.Value;
      const replyToMessageId = body.Headers.find(
        (h: { Name: string; Value: string }) => h.Name === "In-Reply-To"
      )?.Value;
      const latestMessageId = body.Headers.find(
        (h: { Name: string; Value: string }) => h.Name === "Message-ID"
      )?.Value;

      if (!subject || !replyToMessageId) {
        throw new Error("no subject or reply-to messageId found");
      }

      const username = to.split("@")[0];
      const userSnap = await usersRef
        .where("username", "==", username)
        .limit(1)
        .get();
      if (userSnap.empty) {
        debug(`no user found for this username (${username})`);
        throw new Error("no user found for this username");
      }

      const userId = userSnap.docs[0].id;

      const venueContactsSnap = await contactVenuesRef
        .doc(userId)
        .collection("venuesContacted")
        .where("latestMessageId", "==", replyToMessageId)
        .limit(1)
        .get();
      if (venueContactsSnap.empty) {
        debug(
          `no venue contact found for this user and messageId (${userId},${references})`
        );
        throw new Error("no venue contact found for this user and messageId");
      }
      const venueContactData = venueContactsSnap.docs[0].data();
      const allEmails = venueContactData.allEmails ?? [];
      const newAllEmails = allEmails
        .concat([ from ])
        .filter((e: string, i: number, a: string[]) => a.indexOf(e) === i);

      const venueId = venueContactsSnap.docs[0].id;

      // add email to emails collection
      await contactVenuesRef
        .doc(userId)
        .collection("venuesContacted")
        .doc(venueId)
        .collection("emailsSent")
        .add(body);

      const messageContent = body.StrippedTextReply ?? body.TextBody;

      const streamChat = new StreamChat(
        streamKey.value(),
        streamSecret.value()
      );
      await sendStreamMessageFromEmail({
        streamClient: streamChat,
        userId,
        venueId,
        message: messageContent,
      });

      await contactVenuesRef
        .doc(userId)
        .collection("venuesContacted")
        .doc(venueId)
        .update({
          allEmails: newAllEmails,
          latestMessageId,
        });

      const foundsTokens = await getFoundersDeviceTokens();
      const payload = {
        notification: {
          title: "NEW EMAIL!!!",
          body: `New email from ${from} in response to ${username}`,
        },
      };
      await fcm.sendToDevice(foundsTokens, payload);

      slackNotification({
        title: "NEW EMAIL!!!",
        body: `New email from ${from} in response to ${username}`,
        slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
      });

      res.status(200).send("ok");
    } catch (e: any) {
      error(e.message);
      await orphanEmailsRef.add({
        email: {
          ...body,
        },
        error: e.message,
      });
      res.status(500).send("error");
    }
  }
);

export const streamBeforeMessageWebhook = onRequest(
  { secrets: [ streamKey, streamSecret, POSTMARK_SERVER_ID ] },
  async (req, res) => {
    const client = new StreamChat(streamKey.value(), streamSecret.value());

    const sig = req.headers["x-signature"];
    if (!sig || typeof sig !== "string") {
      res.status(400).send("no signature");
      return;
    }

    const valid = client.verifyWebhook(req.rawBody.toString(), sig);
    if (!valid) {
      res.status(403).send("invalid signature");
      return;
    }

    const json = req.body as {
      user: User | undefined;
      message:
        | {
            text: string;
          }
        | undefined;
      members:
        | {
            user_id: string;
            user: User;
          }[]
        | undefined;
    };
    info({ json });

    // get sender
    const senderUser: User | undefined = json.user;
    // debug({ senderUser });

    // get receiver
    const receiverUser: User | undefined = json.members?.find(
      (m: { user: User }) => m.user.username !== senderUser?.username
    )?.user;
    // debug({ receiverUser });

    // get message
    const msg = json.message?.text;
    // debug({ msg });

    if (!senderUser || !receiverUser || !msg) {
      res.status(400).send("bad request");
      return;
    }

    const receiverSnap = await usersRef.doc(receiverUser.id).get();
    if (!receiverSnap.exists) {
      res.status(400).send("bad request");
      return;
    }

    const receiverData = receiverSnap.data() as UserModel;
    // check if user is unclaimed
    if (!receiverData.unclaimed) {
      res.status(200).send("ok");
      return;
    }

    const occupations = receiverData.occupations ?? [];

    // is a venue or Venue
    if (!occupations.includes("venue") && !occupations.includes("Venue")) {
      error("user is not a venue");
      res.status(200).send("ok");
      return;
    }

    // check if ongoing venue contact thread going on
    const venueContactSnap = await contactVenuesRef
      .doc(senderUser.id)
      .collection("venuesContacted")
      .doc(receiverUser.id)
      .get();

    if (!venueContactSnap.exists) {
      error("no ongoing venue contact");
      res.status(200).send("ok");
      return;
    }

    // const venueContactData = venueContactSnap.data();
    // info({ venueContactData });

    // add to the thread if everything is golden
    const emailClient = new postmark.ServerClient(POSTMARK_SERVER_ID.value());
    await sendEmailFromStreamMessage({
      user: senderUser,
      venue: receiverUser,
      message: msg,
      emailClient,
    });

    res.status(200).send("ok");
  }
);

export const notifyFoundersOnOrphanEmail = onDocumentCreated(
  {
    document: "orphanEmails/{emailId}",
    secrets: [ POSTMARK_SERVER_ID, SLACK_WEBHOOK_URL ],
  },
  async (event) => {
    const snapshot = event.data;
    const documentData = snapshot?.data();
    const client = new postmark.ServerClient(POSTMARK_SERVER_ID.value());

    const error = documentData?.error;
    if (!error) {
      info("no error found");
      return;
    }

    const foundersTokens = await getFoundersDeviceTokens();

    const email = documentData?.email;
    await client.sendEmail({
      To: "johannes@tapped.ai",
      ...email,
    });

    const payload = {
      notification: {
        title: "Orphan Email",
        body: `An email was not able to be processed: ${error}`,
      },
    };

    slackNotification({
      title: "Orphan Email",
      body: `An email was not able to be processed: ${error}`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });

    fcm.sendToDevice(foundersTokens, payload);
  }
);

export const notifyFoundersOnEmail = onDocumentCreated(
  {
    document: "contactVenues/{userId}/venuesContacted/{venueId}/emailsSent/{emailId}",
    secrets: [ SLACK_WEBHOOK_URL ],
  },
  async (event) => {

    const snapshot = event.data;
    const documentData = snapshot?.data();
    const email = documentData ?? null;
    const venueId = event.params.venueId;
    const userId = event.params.userId;

    const venue = await usersRef.doc(venueId).get();
    const venueData = venue.data() as UserModel;
    const venueName = venueData.artistName ?? venueData.username;


    const user = await usersRef.doc(userId).get();
    const userData = user.data() as UserModel;
    const username = userData.artistName ?? userData.username;

    slackNotification({
      title: "New Email",
      body: `new email between ${username} and ${venueName}. Here's a sample of the email: ${email?.TextBody.substring(0, 50)}`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
  });