
/* eslint-disable import/no-unresolved */
import {
  onRequest,
} from "firebase-functions/v2/https"
import { SENDGRID_API_KEY } from "./firebase";
import sgMail from "@sendgrid/mail";

export const sendGridWebhook = onRequest(
  { secrets: [ SENDGRID_API_KEY ] },
  async (req, res) => {
    try {

      const body = req.body as Buffer;
      const json = JSON.parse(body.toString("utf-8"));
      console.log({ content: json });

      // sendgrid pong
      sgMail.setApiKey(SENDGRID_API_KEY.value());

      const bodyString = body.toString("utf-8");

      const msg = {
        to: "johannes@tapped.ai",
        from: "johannes@booking.tapped.ai",
        subject: "Pong",
        text: "and easy to do anywhere, even with Node.js " + bodyString,
        html: "<strong>and easy to do anywhere, even with Node.js</strong> " + bodyString,
      };

      const mailRes = await sgMail.send(msg);
      mailRes.forEach((response) => {
        console.log(response);
      });

      res.status(200).send("ok");
    } catch (e) {
      console.error(e);
      res.status(500).send("error");
    }
  });
