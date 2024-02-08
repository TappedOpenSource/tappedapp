
/* eslint-disable import/no-unresolved */
import {
  onRequest,
} from "firebase-functions/v2/https"
import { POSTMARK_SERVER_ID, fcm, streamKey, streamSecret, usersRef, venueContactsRef, } from "./firebase";
// import sgMail from "@sendgrid/mail";
import { debug, error, info } from "firebase-functions/logger";
import * as postmark from "postmark";
import { getFoundersDeviceTokens } from "./utils";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { UserModel } from "../types/models";
import { StreamChat, User } from "stream-chat";

function createEmailMessageId() {
  const currentTime = Date.now().toString(36);
  const randomPart = Math.floor(Math.random() * Number.MAX_SAFE_INTEGER).toString(36);
  const messageId = `<${currentTime}.${randomPart}@tapped.ai>`;

  return messageId;
}

async function sendStreamInitialReply({ userId, venueId, message }: {
  userId: string;
  venueId: string;
  message: string;
}) { 
  // create DM channel between both parties

  // send initial message

  // send Venue's reply

  // MAKE SURE THIS DOESN'T TRIGGER THE WEBHOOK OTHERWISE LOOP
}

async function sendVenueEmailResponse({ user, venue, message }: {
  user: User;
  venue: User;
  message: string;
}) {
  // get venue contact info (i.e. messageId)

  // add msg to emails collection

  // send email to venue

  return;
}

export const notifyFoundersOnVenueContact = onDocumentCreated(
  {
    document: "venueContacts/{userId}/venuesContacted/{venueId}",
    secrets: [ POSTMARK_SERVER_ID ],
  },
  async (event) => {
    const snapshot = event.data;
    const documentData = snapshot?.data();

    const user = documentData?.user as UserModel | undefined;
    const username = user?.username;
    const venue = documentData?.venue as UserModel | undefined;
    const bookingEmail = documentData?.bookingEmail;

    const userId = user?.id;
    if (!userId) {
      return;
    }

    const venueId = venue?.id;
    if (!venueId) {
      return;
    }

    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: `${username} wants to contact a ${venue?.artistName} \uD83D\uDE43`,
        body: `they used the email ${bookingEmail}`,
      }
    };

    fcm.sendToDevice(devices, payload);
    const client = new postmark.ServerClient(POSTMARK_SERVER_ID.value());
    const messageId = createEmailMessageId();

    const emailObj = {
      "Headers": [
        {
          "Name": "Message-ID",
          "Value": messageId,
        }
      ],
      "From": `${username}@booking.tapped.ai`,
      "To": "johannes@tapped.ai",
      "Subject": "Booking Inquiry",
      "HtmlBody": "this is a <strong>test</strong> email from Tapped",
      "TextBody": "this is a test email from Tapped",
      "MessageStream": "outbound"
    }

    // add msg id to initial request
    await venueContactsRef
      .doc(userId)
      .collection("venuesContacted")
      .doc(venueId)
      .update({
        messageId,
      });

    // add email to emails collection
    await venueContactsRef
      .doc(user.id)
      .collection("venuesContacted")
      .doc(venue.id)
      .collection("emailsSent")
      .add(emailObj);


    const res = await client.sendEmail(emailObj);
    debug({ res });
  }
);

export const inboundEmailWebhook = onRequest(
  { secrets: [ POSTMARK_SERVER_ID ] },
  async (req, res) => {
    try {
      const body = req.body;
      info({ content: body });

      const subject = body.Subject;
      const to = body.To;
      const from = body.From;
      const messageId = body.Headers.find((h: { Name: string; Value: string }) => h.Name === "Message-ID")?.Value;

      if (!subject || !messageId) {
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

      const venueContactsSnap = await venueContactsRef.doc(userId).collection("venuesContacted").where("messageId", "==", messageId).limit(1).get();
      if (venueContactsSnap.empty) {
        error(`no venue contact found for this user and messageId (${userId},${messageId})`);
        res.status(400).send("bad request");
        return;
      }
      const venueContactData = venueContactsSnap.docs[0].data();
      const allEmails = venueContactData.allEmails ?? [];
      const newAllEmails = allEmails.concat([ from ]).filter((e: string, i: number, a: string[]) => a.indexOf(e) === i);

      const venueId = venueContactsSnap.docs[0].id;

      // add email to emails collection
      await venueContactsRef
        .doc(userId)
        .collection("venuesContacted")
        .doc(venueId)
        .collection("emailsSent")
        .add(body);

      // add email to all emails
      await venueContactsRef
        .doc(userId)
        .collection("venuesContacted")
        .doc(venueId)
        .update({
          allEmails: newAllEmails,
        });

      await sendStreamInitialReply({
        userId,
        venueId,
        message: body.TextBody,
      });

      res.status(200).send("ok");
    } catch (e) {
      error(e);
      res.status(500).send("error");
    }
  });

export const streamBeforeMessageWebhook = onRequest(
  { secrets: [ streamKey, streamSecret ] },
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

    // get sender
    const senderUser: User | undefined = json.user;
    console.log({ senderUser });

    // get receiver
    const receiverUser: User | undefined = json.members?.find((m: { user: User }) => m.user.username !== senderUser?.username)?.user;
    console.log({ receiverUser });

    // get message 
    const msg = json.message?.text;
    console.log({ msg });

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
      info("user is not a venue");
      res.status(200).send("ok");
      return;
    }

    // check if ongoing venue contact thread going on
    const venueContactSnap = await venueContactsRef
      .doc(receiverData.id)
      .collection("venuesContacted")
      .doc(receiverUser.id)
      .get();


    if (!venueContactSnap.exists) {
      info("no ongoing venue contact");
      res.status(200).send("ok");
      return;
    }

    const venueContactData = venueContactSnap.data();
    info({ venueContactData });

    // add to the thread if everything is golden
    await sendVenueEmailResponse({
      user: senderUser,
      venue: receiverUser,
      message: msg,
    });

    info({ content: req.body });
  });
