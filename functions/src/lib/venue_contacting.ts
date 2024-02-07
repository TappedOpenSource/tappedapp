
/* eslint-disable import/no-unresolved */
import {
  onRequest,
} from "firebase-functions/v2/https"
import { POSTMARK_SERVER_ID, fcm } from "./firebase";
// import sgMail from "@sendgrid/mail";
import { debug, error, info } from "firebase-functions/logger";
import * as postmark from "postmark";
import { getFoundersDeviceTokens } from "./utils";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { UserModel } from "../types/models";

function createEmailMessageId() {
  const currentTime = Date.now().toString(36);
  const randomPart = Math.floor(Math.random() * Number.MAX_SAFE_INTEGER).toString(36);
  const messageId = `<${currentTime}.${randomPart}@tapped.ai>`;

  return messageId;
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
    const res = await client.sendEmail({
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
    });
    debug({ res });
  }
);

export const inboundEmailWebhook = onRequest(
  { secrets: [ POSTMARK_SERVER_ID ] },
  async (req, res) => {
    try {
      const body = req.body;
      info({ content: body });

      const client = new postmark.ServerClient(POSTMARK_SERVER_ID.value());

      const subject = body.Subject;
      const messageId = body.Headers.find((h: { Name: string; Value: string }) => h.Name === "Message-ID")?.Value;

      if (!subject || !messageId) {
        res.status(400).send("bad request");
        return;
      }

      const blah = await client.sendEmail({
        "From": "johannes@booking.tapped.ai",
        "To": "johannes@tapped.ai",
        "Headers": [
          {
            "Name": "Message-ID",
            "Value": messageId,
          }
        ],
        "Subject": subject,
        "HtmlBody": "this is an <strong>automated</strong> response that's mocking a user DMing",
        "TextBody": "this is an automated response that's mocking a user DMing",
        "MessageStream": "outbound"
      });
      debug({ blah });

      res.status(200).send("ok");
    } catch (e) {
      error(e);
      res.status(500).send("error");
    }
  });
