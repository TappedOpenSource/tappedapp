
/* eslint-disable import/no-unresolved */
import {
  onRequest,
} from "firebase-functions/v2/https"
import { SENDGRID_API_KEY } from "./firebase";

export const sendGridWebhook = onRequest(
  { secrets: [ SENDGRID_API_KEY ] },
  async (req, res) => {
    const body = req.body as Buffer;
    console.log({ content: body.toString("utf-8") });
    res.status(200).send("ok");
  });
