
/* eslint-disable import/no-unresolved */
import {
  onRequest,
} from "firebase-functions/v2/https"
import { 
  POSTMARK_SERVER_ID, 
  // fcm, 
  streamKey, 
  streamSecret, 
  usersRef, 
  contactVenuesRef,
} from "./firebase";
// import sgMail from "@sendgrid/mail";
import { debug, error, info } from "firebase-functions/logger";
import * as postmark from "postmark";
// import { getFoundersDeviceTokens } from "./utils";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { UserModel } from "../types/models";
import { StreamChat, User } from "stream-chat";

function createEmailMessageId() {
  const currentTime = Date.now().toString(36);
  const randomPart = Math.floor(Math.random() * Number.MAX_SAFE_INTEGER).toString(36);
  const messageId = `<${currentTime}.${randomPart}@tapped.ai>`;

  return messageId;
}

async function sendStreamMessageFromEmail({ streamClient, userId, venueId, message }: {
  streamClient: StreamChat
  userId: string;
  venueId: string;
  message: string;
}) { 
  // create DM channel between both parties
  const token = await streamClient.createToken(venueId);
  await streamClient.connectUser({
    id: venueId,
  }, token);

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

async function sendEmailFromStreamMessage({ emailClient, user, venue, message }: {
  emailClient: postmark.ServerClient,
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
    "From": `${username}@booking.tapped.ai`,
    "To": allEmails.join(","),
    "Headers": [
      {
        "Name": "Message-ID",
        "Value": messageId,
      },
      {
        "Name": "References",
        "Value": latestMessageId,
      },
      {
        "Name": "In-Reply-To",
        "Value": latestMessageId,
      }
    ],
    "Subject": subject,
    "HtmlBody": message,
    "TextBody": message,
    "MessageStream": "outbound"
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

export const notifyFoundersOnVenueContact = onDocumentCreated(
  {
    document: "contactVenues/{userId}/venuesContacted/{venueId}",
    secrets: [ POSTMARK_SERVER_ID ],
  },
  async (event) => {
    const snapshot = event.data;
    const documentData = snapshot?.data();

    const user = documentData?.user as UserModel | undefined;
    const username = user?.username;
    // const venue = documentData?.venue as UserModel | undefined;
    // const bookingEmail = documentData?.bookingEmail;

    const userId = event.params.userId;
    const venueId = event.params.venueId;

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
    const subject = "Booking Inquiry";

    const emailObj = {
      "Headers": [
        {
          "Name": "Message-ID",
          "Value": messageId,
        }
      ],
      "From": `${username}@booking.tapped.ai`,
      "To": "johannes@tapped.ai",
      "Subject": subject,
      "HtmlBody": "this is a <strong>test</strong> email from Tapped",
      "TextBody": "this is a test email from Tapped",
      "MessageStream": "outbound"
    }

    // add msg id to initial request
    await contactVenuesRef
      .doc(userId)
      .collection("venuesContacted")
      .doc(venueId)
      .update({
        subject,
        originalMessageId: messageId,
        latestMessageId: messageId,
      });

    // add email to emails collection
    await contactVenuesRef
      .doc(userId)
      .collection("venuesContacted")
      .doc(venueId)
      .collection("emailsSent")
      .add(emailObj);


    const res = await client.sendEmail(emailObj);
    debug({ res });
  }
);

export const inboundEmailWebhook = onRequest(
  { secrets: [ POSTMARK_SERVER_ID, streamKey, streamSecret ] },
  async (req, res) => {
    try {
      const body = req.body;

      const subject = body.Subject;
      const to = body.To;
      const from = body.From;
      const referenceMessageId = body.Headers.find((h: { Name: string; Value: string }) => h.Name === "References")?.Value;
      const replyToMessageId = body.Headers.find((h: { Name: string; Value: string }) => h.Name === "In-Reply-To")?.Value;
      const latestMessageId = body.Headers.find((h: { Name: string; Value: string }) => h.Name === "Message-ID")?.Value; 

      if (!subject || !referenceMessageId) {
        error("no subject or messageId found")
        res.status(400).send("bad request");
        return;
      }

      const username = to.split("@")[0];

      const userSnap = await usersRef.where("username", "==", username).limit(1).get();
      if (userSnap.empty) {
        error(`no user found for this username (${username})`);
        res.status(400).send("bad request");
        return;
      }

      const userId = userSnap.docs[0].id;

      const venueContactsSnap = await contactVenuesRef.doc(userId).collection("venuesContacted").where("latestMessageId", "==", replyToMessageId).limit(1).get();
      if (venueContactsSnap.empty) {
        error(`no venue contact found for this user and messageId (${userId},${referenceMessageId})`);
        error({ body });
        res.status(400).send("bad request");
        return;
      }
      const venueContactData = venueContactsSnap.docs[0].data();
      const allEmails = venueContactData.allEmails ?? [];
      const newAllEmails = allEmails.concat([ from ]).filter((e: string, i: number, a: string[]) => a.indexOf(e) === i);

      const venueId = venueContactsSnap.docs[0].id;

      // add email to emails collection
      await contactVenuesRef
        .doc(userId)
        .collection("venuesContacted")
        .doc(venueId)
        .collection("emailsSent")
        .add(body);

      const messageContent = body.StrippedTextReply ?? body.TextBody;
 
      const streamChat = new StreamChat(streamKey.value(), streamSecret.value());
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

      res.status(200).send("ok");
    } catch (e) {
      error(e);
      res.status(500).send("error");
    }
  });

export const streamBeforeMessageWebhook = onRequest(
  { secrets: [ streamKey, streamSecret, POSTMARK_SERVER_ID ] },
  async (req, res) => {
    const client = new StreamChat(
      streamKey.value(), 
      streamSecret.value(),
    );

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
      message: {
        text: string;
      } | undefined;
      members: {
        user_id: string;
        user: User;
      }[] | undefined;
    };
    info({ json });

    // get sender
    const senderUser: User | undefined = json.user;
    // debug({ senderUser });

    // get receiver
    const receiverUser: User | undefined = json.members?.find((m: { user: User }) => m.user.username !== senderUser?.username)?.user;
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
  });
