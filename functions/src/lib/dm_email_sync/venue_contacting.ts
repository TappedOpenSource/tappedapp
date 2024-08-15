/* eslint-disable import/no-unresolved */

import { onCall } from "firebase-functions/v2/https";
import {
  contactVenuesRef,
  OPEN_AI_KEY,
  opportunitiesRef,
  POSTMARK_SERVER_ID,
  RESEND_API_KEY,
  SLACK_WEBHOOK_URL,
  streamKey,
  streamSecret,
  usersRef,
} from "../firebase";
import { debug, error, info } from "firebase-functions/logger";
import * as postmark from "postmark";
// import { getFoundersDeviceTokens } from "./utils";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { StreamChat, User } from "stream-chat";
import { contactVenueTemplate } from "../../email_templates/contact_venue";
import { Opportunity, UserModel, VenueContactRequest } from "../../types/models";
import { slackNotification } from "../notifications";
import { Timestamp } from "firebase-admin/firestore";
import { authenticatedRequest } from "../utils";
import { Resend } from "resend";
// import _ from "lodash";
import { _sendEmailOnVenueContacting } from "../email_triggers";
import { writeAiEmailReply, writeEmailWithAi } from "./compose_email";
import { createEmailMessageId } from "./utils";
import { dmAutoReply, sendStreamMessage } from "./messaging";

async function sendAsEmail({
  venueContactData,
  userId,
  venue,
}: {
  venueContactData: VenueContactRequest;
  userId: string;
  venue: UserModel;
}): Promise<string | null> {
  const opIds = venueContactData.opportunityIds ?? [];
  const opportunities = (await Promise.all(
    opIds.map(async (id: string) => {
      const snap = await opportunitiesRef.doc(id).get();
      if (!snap.exists) {
        error("no opportunity found");
        return null;
      }

      return snap.data() as Opportunity;
    })
  )).filter((o) => o !== null) as Opportunity[];

  const collaborators = venueContactData.collaborators ?? [];

  const bookingEmail = venueContactData.bookingEmail;
  if (!bookingEmail) {
    error("no bookingEmail found");
    return null;
  }

  const note = venueContactData.note ?? "";

  const user = venueContactData.user as UserModel | undefined;
  if (user === undefined) {
    error("no user found");
    return null;
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
    opportunities,
  });

  const { text, html } = contactVenueTemplate({
    performer: user,
    collaborators,
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

  return body;
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

  // join channel
  const channel = streamClient.channel("messaging", {
    members: [ userId, venueId ],
    created_by_id: venueId,
  });
  await channel.create();

  // post msg
  const noteString = note !== "" ? ` - ${note}` : "";
  await channel.sendMessage({
    text: `hey! I was recommended to contact you about performing at your venue ${noteString}`,
    user_id: userId,
  });
}

export async function sendEmailFromStreamMessage({
  emailClient,
  user,
  venue,
  message,
}: {
  emailClient: postmark.ServerClient;
  user: User;
  venue: User;
  message: string;
}): Promise<void> {
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

export const _appendNewContactRequestToThread = async ({
  userId,
  venueId,
  collaboratorIds,
  note,
  opportunityIds,
  emailClient,
}: {
  userId: string;
  venueId: string;
  collaboratorIds: string[];
  note: string;
  opportunityIds: string[];
  emailClient: postmark.ServerClient;
}): Promise<void> => {
  // get the current thread
  const contactVenueSnap = await contactVenuesRef
    .doc(userId)
    .collection("venuesContacted")
    .doc(venueId)
    .get();
  const contactVenueData = contactVenueSnap.data() as VenueContactRequest | undefined;

  if (contactVenueData === undefined) {
    error("no contactVenueData found");
    return;
  }

  const allEmails = contactVenueData?.allEmails ?? [ contactVenueData.bookingEmail ];

  const userSnap = await usersRef.doc(userId).get();
  const userData = userSnap.data() as UserModel;

  if (userData === undefined) {
    error("no userData found");
    return;
  }

  const emailsSentSnap = await contactVenuesRef
    .doc(userId)
    .collection("venuesContacted")
    .doc(venueId)
    .collection("emailsSent")
    .get();

  const allEmailSents = emailsSentSnap.docs.map((d) => d.data() as postmark.Message);

  const collaborators = (await Promise.all(
    collaboratorIds.map(async (id: string) => {
      const snap = await usersRef.doc(id).get();
      if (!snap.exists) {
        error("no collaborator found");
        return null;
      }

      return snap.data() as UserModel;
    }),
  )).filter((u) => u !== null) as UserModel[];

  const opportunities = (await Promise.all(
    opportunityIds.map(async (id: string) => {
      const snap = await opportunitiesRef.doc(id).get();
      if (!snap.exists) {
        error("no opportunity found");
        return null;
      }

      return snap.data() as Opportunity;
    })
  )).filter((o) => o !== null) as Opportunity[];

  const message = await writeAiEmailReply({
    opportunities,
    note,
    userData,
    contactVenueData,
    emailsSent: allEmailSents,
  });

  const { text, html } = contactVenueTemplate({
    performer: userData,
    collaborators,
    emailText: message,
  });

  if (contactVenueData.latestMessageId === null) {
    error("no latestMessageId found");
    return;
  }

  if (contactVenueData.subject === null) {
    error("no subject found");
    return;
  }

  // add email to thread from chatgpt
  const messageId = createEmailMessageId();

  const emailObj: postmark.Message = {
    From: `${userData.username}@booking.tapped.ai`,
    To: allEmails.join(","),
    Headers: [
      {
        Name: "Message-ID",
        Value: messageId,
      },
      {
        Name: "References",
        Value: contactVenueData.latestMessageId,
      },
      {
        Name: "In-Reply-To",
        Value: contactVenueData.latestMessageId,
      },
    ],
    Subject: contactVenueData.subject,
    HtmlBody: html,
    TextBody: text,
    MessageStream: "outbound",
  };

  await contactVenuesRef
    .doc(userId)
    .collection("venuesContacted")
    .doc(venueId)
    .update({
      latestMessageId: messageId,
    });

  // add email to emails collection
  await contactVenuesRef
    .doc(userId)
    .collection("venuesContacted")
    .doc(venueId)
    .collection("emailsSent")
    .add(emailObj);

  // send email to venue
  const emailRes = await emailClient.sendEmail(emailObj);
  debug({ emailRes });

  return;
}

export const sendEmailToVenueFromStreamMessage = async ({
  receiverData,
  receiver,
  sender,
  msg,
  postmarkServerId,
}: {
  receiverData: UserModel,
  receiver: User;
  sender: User;
  msg: string;
  postmarkServerId: string;
}): Promise<void> => {
  const occupations = receiverData.occupations ?? [];

  // is a venue or Venue
  if (!occupations.includes("venue") && !occupations.includes("Venue")) {
    error("user is not a venue");
    return;
  }

  // check if ongoing venue contact thread going on
  const venueContactSnap = await contactVenuesRef
    .doc(sender.id)
    .collection("venuesContacted")
    .doc(receiver.id)
    .get();

  if (!venueContactSnap.exists) {
    error("no ongoing venue contact");
    return;
  }

  // const venueContactData = venueContactSnap.data();
  // info({ venueContactData });

  // add to the thread if everything is golden
  const emailClient = new postmark.ServerClient(postmarkServerId);
  await sendEmailFromStreamMessage({
    user: sender,
    venue: receiver,
    message: msg,
    emailClient,
  });

}

export const notifyFoundersOnVenueContact = onDocumentCreated(
  {
    document: "contactVenues/{userId}/venuesContacted/{venueId}",
    secrets: [ 
      POSTMARK_SERVER_ID, streamKey, streamSecret, OPEN_AI_KEY, SLACK_WEBHOOK_URL ],
  },
  async (event) => {
    process.env.OPENAI_API_KEY = OPEN_AI_KEY.value();
    const snapshot = event.data;
    const venueContactData = snapshot?.data() as
      | VenueContactRequest
      | undefined;

    try {
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
      const autoReply = venueData.venueInfo?.autoReply ?? null;
      if (autoReply !== null) {
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

      const emailBody = await sendAsEmail({
        venueContactData,
        userId,
        venue: venueData,
      });

      if (emailBody === null) {
        error("no emailBody found");
        return;
      }

      await sendStreamMessage({
        streamClient: streamChat,
        receiverId: venueId,
        senderId: userId,
        message: emailBody,
        freeze: true,
      });
    } catch (e: any) {
      error(e);
      await slackNotification({
        title: "error in venue contact",
        body: `${JSON.stringify(venueContactData)} - ${e.message}`,
        slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
      });
    }
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

    const email = documentData?.email;
    await client.sendEmail({
      To: "johannes@tapped.ai",
      ...email,
    });

    slackNotification({
      title: "Orphan Email",
      body: `An email was not able to be processed: ${error}`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
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

    const sender = email?.From;
    const receiver = email?.To;

    slackNotification({
      title: `new email (${username} and ${venueName})`,
      body: `${sender} => ${receiver}`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
  });

export const setLatestContactRequest = onDocumentCreated(
  { document: "contactVenues/{userId}/venuesContacted/{venueId}" },
  async (event) => {
    const userId = event.params.userId;
    const snapshot = event.data;
    const documentData = snapshot?.data() as VenueContactRequest | undefined;
    if (documentData === undefined) {
      error("no document data found");
      return;
    }

    await contactVenuesRef
      .doc(userId)
      .set({
        latestContactRequest: documentData,
        timestamp: Timestamp.now(),
      }, { merge: true });
  });

export const genericContactVenues = onCall(
  { secrets: [ RESEND_API_KEY, POSTMARK_SERVER_ID, OPEN_AI_KEY ] },
  async (request) => {
    authenticatedRequest(request);
    process.env.OPENAI_API_KEY = OPEN_AI_KEY.value();

    const userId = request.data.userId as string | undefined;
    const venueIds = request.data.venueIds as string[] | undefined;
    const note = request.data.note as string | undefined ?? "";
    const collaborators = request.data.collaborators as string[] | undefined ?? [];

    if (!userId) {
      throw new Error("no userId found");
    }

    if (!venueIds) {
      throw new Error("no venueIds found");
    }

    await Promise.all(
      venueIds.map(async (venueId) => {
        // for each venueId, check if user has open email thread with venue
        const venueSnap = await usersRef.doc(venueId).get();
        if (!venueSnap.exists) {
          error(`no venue found for id ${venueId}`);
          return;
        }
        const venueData = venueSnap.data() as UserModel;

        const bookingEmail = venueData.venueInfo?.bookingEmail;
        if (!bookingEmail) {
          error(`no bookingEmail found for venue ${venueId}`);
          return;
        }

        const contactVenueSnap = await contactVenuesRef
          .doc(userId)
          .collection("venuesContacted")
          .doc(venueId)
          .get();


        const alreadyContacted = contactVenueSnap.exists;
        const resend = new Resend(RESEND_API_KEY.value());

        // if not, create new email thread (make ContactVenueRequest)
        if (!alreadyContacted) {
          await contactVenuesRef
            .doc(userId)
            .collection("venuesContacted")
            .doc(venueId)
            .set({
              opportunityIds: [],
              collaborators,
              note,
              bookingEmail,
              user: null,
              venue: null,
              allEmails: [ bookingEmail ],
              latestMessageId: null,
              originalMessageId: null,
              subject: null,
            });

          // send email to user that they've send the request
          await _sendEmailOnVenueContacting({
            resend,
            userId,
          });
          return;
        }

        // if so, add email to thread
        const emailClient = new postmark.ServerClient(POSTMARK_SERVER_ID.value());
        await _appendNewContactRequestToThread({
          userId,
          venueId,
          collaboratorIds: collaborators,
          note,
          opportunityIds: [],
          emailClient,
        });

        // send email to user that they've send the request
        await _sendEmailOnVenueContacting({
          resend,
          userId,
        });
      }),
    );
  });