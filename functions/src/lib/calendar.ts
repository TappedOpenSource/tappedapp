/* eslint-disable import/no-unresolved */
import { info } from "firebase-functions/logger";
import { onRequest } from "firebase-functions/v2/https";

export const richmondEventsWebhook = onRequest(
  { cors: true },
  async (req, res) => {
    const { data } = req.body;
    info({ data });

    res.status(200).json("Success");
  });
