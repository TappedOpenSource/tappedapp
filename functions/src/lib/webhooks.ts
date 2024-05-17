/* eslint-disable import/no-unresolved */
import { onRequest } from "firebase-functions/v2/https";
import { RESEND_API_KEY, streamKey, streamSecret } from "./firebase";
import { addUserToPremiumChat, removeUserFromPremiumChat } from "./direct_messaging";
import { error, info } from "firebase-functions/logger";
import { sendEmailSubscriptionExpiration, sendEmailSubscriptionPurchase } from "./email_triggers";

// send email on subscription purchase
export const sendEmailOnSubscriptionPurchase = onRequest(
  { secrets: [ RESEND_API_KEY, streamKey, streamSecret ] },
  async (req, res) => {
    try {
      info("sendEmailOnSubscriptionPurchase", req.body);
      const { event } = req.body;
      const { app_user_id: userId } = event; 
    
      await sendEmailSubscriptionPurchase(RESEND_API_KEY.value(), userId);

      // add them to group chat
      await addUserToPremiumChat(userId, {
        streamKey: streamKey.value(),
        streamSecret: streamSecret.value(),
      });

      res.sendStatus(200);
    } catch (e: any) {
      error(e.message);
      res.status(500);
    }
  });

export const sendEmailOnSubscriptionExpiration = onRequest(
  { secrets: [ RESEND_API_KEY, streamKey, streamSecret ] },
  async (req, res) => {
    try {
      info("sendEmailOnSubscriptionExpiration", req.body);
      const { event } = req.body;
      const { app_user_id: userId } = event;

      await sendEmailSubscriptionExpiration(RESEND_API_KEY.value(), userId);

      // remove from group chat
      await removeUserFromPremiumChat(userId, {
        streamKey: streamKey.value(),
        streamSecret: streamSecret.value(),
      });

    } catch (e: any) {
      error(e.message);
      res.status(500);
    }
  });

