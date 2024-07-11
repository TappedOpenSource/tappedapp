/* eslint-disable import/no-unresolved */
import { onRequest } from "firebase-functions/v2/https";
import { POSTMARK_SERVER_ID, RESEND_API_KEY, SLACK_WEBHOOK_URL, contactVenuesRef, orphanEmailsRef, streamKey, streamSecret, usersRef } from "./firebase";
import { addUserToPremiumChat, removeUserFromPremiumChat } from "./direct_messaging";
import { debug, error, info } from "firebase-functions/logger";
import { sendEmailSubscriptionExpiration, sendEmailSubscriptionPurchase, sendEmailToPerformerFromStreamMessage } from "./email_triggers";
import { StreamChat, User } from "stream-chat";
import { UserModel } from "../types/models";
import { sendEmailToVenueFromStreamMessage } from "./dm_email_sync/venue_contacting";
import { sendStreamMessage } from "./dm_email_sync/messaging";
import { slackNotification } from "./notifications";

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

export const streamBeforeMessageWebhook = onRequest(
  { secrets: [ streamKey, streamSecret, POSTMARK_SERVER_ID, RESEND_API_KEY ] },
  async (req, res) => {
    const client = new StreamChat(streamKey.value(), streamSecret.value());

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
      message:
      | {
        text: string;
      }
      | undefined;
      members:
      | {
        user_id: string;
        user: User;
      }[]
      | undefined;
    };
    info({ json });

    // get sender
    const senderUser: User | undefined = json.user;
    // debug({ senderUser });

    // get receiver
    const receiverUser: User | undefined = json.members?.find(
      (m: { user: User }) => m.user.username !== senderUser?.username
    )?.user;
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
      throw new Error("no receiver found");
    }

    const receiverData = receiverSnap.data() as UserModel;
    // check if user is unclaimed
    if (!receiverData.unclaimed) {
      // send email to user if they have it in their settings
      await sendEmailToPerformerFromStreamMessage({
        msg,
        receiverData,
        senderUser,
        resendApiKey: RESEND_API_KEY.value(),
      });
    } else {
      // send email if venue
      await sendEmailToVenueFromStreamMessage({
        msg,
        receiverData,
        sender: senderUser,
        receiver: receiverUser,
        postmarkServerId: POSTMARK_SERVER_ID.value(),
      });
    }
    res.status(200).send("ok");
  }
);

export const inboundEmailWebhook = onRequest(
  { secrets: [ POSTMARK_SERVER_ID, streamKey, streamSecret, SLACK_WEBHOOK_URL, ] },
  async (req, res) => {
    const body = req.body;
    try {
      const subject = body.Subject;
      const to = body.To;
      const from = body.From;
      const references = body.Headers.find(
        (h: { Name: string; Value: string }) => h.Name === "References"
      )?.Value;
      const replyToMessageId = body.Headers.find(
        (h: { Name: string; Value: string }) => h.Name === "In-Reply-To"
      )?.Value;
      const latestMessageId = body.Headers.find(
        (h: { Name: string; Value: string }) => h.Name === "Message-ID"
      )?.Value;

      if (!subject || !replyToMessageId) {
        throw new Error("no subject or reply-to messageId found");
      }

      const username = to.split("@")[0];
      const userSnap = await usersRef
        .where("username", "==", username)
        .limit(1)
        .get();
      if (userSnap.empty) {
        debug(`no user found for this username (${username})`);
        throw new Error("no user found for this username");
      }

      const userId = userSnap.docs[0].id;

      const venueContactsSnap = await contactVenuesRef
        .doc(userId)
        .collection("venuesContacted")
        .where("latestMessageId", "==", replyToMessageId)
        .limit(1)
        .get();
      if (venueContactsSnap.empty) {
        debug(
          `no venue contact found for this user and messageId (${userId},${references})`
        );
        throw new Error("no venue contact found for this user and messageId");
      }
      const venueContactData = venueContactsSnap.docs[0].data();
      const allEmails = venueContactData.allEmails ?? [];
      const newAllEmails = allEmails
        .concat([ from ])
        .filter((e: string, i: number, a: string[]) => a.indexOf(e) === i);

      const venueId = venueContactsSnap.docs[0].id;

      // add email to emails collection
      await contactVenuesRef
        .doc(userId)
        .collection("venuesContacted")
        .doc(venueId)
        .collection("emailsSent")
        .add(body);

      const messageContent = body.StrippedTextReply ?? body.TextBody;

      const streamChat = new StreamChat(
        streamKey.value(),
        streamSecret.value()
      );
      await sendStreamMessage({
        streamClient: streamChat,
        receiverId: userId,
        senderId: venueId,
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

      slackNotification({
        title: "NEW EMAIL!!!",
        body: `New email from ${from} in response to ${username}`,
        slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
      });

      res.status(200).send("ok");
    } catch (e: any) {
      error(e.message);
      await orphanEmailsRef.add({
        email: {
          ...body,
        },
        error: e.message,
      });
      res.status(500).send("error");
    }
  }
);

