
/* eslint-disable import/no-unresolved */
import {
  onRequest,
} from "firebase-functions/v2/https"
import { POSTMARK_SERVER_ID } from "./firebase";
// import sgMail from "@sendgrid/mail";
import { error, info } from "firebase-functions/logger";
import * as postmark from "postmark";

export const sendGridWebhook = onRequest(
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
        "From": "johannes@tapped.ai",
        // "To": "ebe63b4b00c9dded9244d7882acad5e9@inbound.postmarkapp.com",
        "To": "johannes@tapped.ai",
        "Headers": [
          {
            "Name": "Message-ID",
            "Value": messageId,
          }
        ],
        "Subject": subject,
        "HtmlBody": "<strong>Hello</strong> dear Postmark user.",
        "TextBody": "Hello from Postmark!",
        "MessageStream": "outbound"
      });
      console.log({ blah });

      res.status(200).send("ok");
    } catch (e) {
      error(e);
      res.status(500).send("error");
    }
  });
