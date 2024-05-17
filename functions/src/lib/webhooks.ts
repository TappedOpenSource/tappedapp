/* eslint-disable import/no-unresolved */
import { onRequest } from "firebase-functions/v2/https";
import { RESEND_API_KEY } from "./firebase";
import { error, info } from "firebase-functions/logger";
import { sendEmailSubscriptionExpiration, sendEmailSubscriptionPurchase } from "./email_triggers";

// send email on subscription purchase
export const sendEmailOnSubscriptionPurchase = onRequest(
  { secrets: [ RESEND_API_KEY ] },
  async (req, res) => {
    try {
      info("sendEmailOnSubscriptionPurchase", req.body);
      const { event } = req.body;
      const { app_user_id: userId } = event; 
    
      await sendEmailSubscriptionPurchase(RESEND_API_KEY.value(), userId);

      // add them to group chat

      res.sendStatus(200);
    } catch (e: any) {
      error(e.message);
      res.status(500);
    }
  });

export const sendEmailOnSubscriptionExpiration = onRequest(
  { secrets: [ RESEND_API_KEY ] },
  async (req, res) => {
    try {
      info("sendEmailOnSubscriptionExpiration", req.body);
      const { event } = req.body;
      const { app_user_id: userId } = event;

      await sendEmailSubscriptionExpiration(RESEND_API_KEY.value(), userId);

      // remove from group chat

    } catch (e: any) {
      error(e.message);
      res.status(500);
    }
  });

