/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { UserRecord } from "firebase-functions/v1/auth";
import {
  SLACK_WEBHOOK_URL,
  bucket,
  usersRef,
} from "./lib/firebase";
import { slackNotification } from "./lib/notifications";
import { UserModel } from "./types/models";
import { createUnclaimedUser, transferUser } from "./lib/users";

export * from "./lib/rest";
export * from "./lib/webhooks";
export * from "./lib/email_triggers";
export * from "./lib/bookings";
export * from "./lib/activities";
export * from "./lib/payments";
export * from "./lib/stream";
export * from "./lib/ai_generators";
export * from "./lib/opportunities";
export * from "./lib/services";
export * from "./lib/signups";
export * from "./lib/search";
export * from "./lib/calendar";
export * from "./lib/places";
export * from "./lib/user_feedback";
export * from "./lib/venue_contacting";
export * from "./lib/notifications";
export * from "./lib/spotify";
export * from "./lib/chartmetric";
export * from "./lib/crawler";
export * from "./lib/users";
export * from "./lib/mailchimp";

const _deleteUser = async (user: UserModel, slackUrl: string) => {
  await slackNotification({
    title: `user (${user.username}) deleted permanently`,
    body: `user with id (${user.id}) was deleted`,
    slackWebhookUrl: slackUrl,
  });

  // delete all user data
  await usersRef.doc(user.id).delete();

  // *delete all images keyed at 'images/users/{UID}/{IMAGEURL}'*
  bucket.deleteFiles({ prefix: `images/users/${user.id}` });
  bucket.deleteFiles({ prefix: `press_kits/${user.id}` });
};
const _unclaimedUser = async (user: UserModel, slackUrl: string) => {
  await slackNotification({
    title: `user (${user.username}) unclaimed their account`,
    body: `user with id (${user.id}) deleted their claimed account and was transferred to an unclaimed account`,
    slackWebhookUrl: slackUrl,
  });

  // TODO create new user
  const displayName = user.artistName ?? user.username;
  if (!displayName || displayName.length === 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'displayName' cannot be empty"
    );
  }

  const newUserId = await createUnclaimedUser(displayName);

  // TODO: merge new unclaimed user with old user data
  await transferUser({
    origUserId: newUserId,
    otherUserId: user.id,
  });

  // delete old user
  await usersRef.doc(user.id).delete();
};

const _onDeleteUser = async (data: { id: string }) => {
  // Checking attribute.
  if (data.id.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'id' cannot be empty"
    );
  }

  const user = await usersRef.doc(data.id).get();
  if (!user.exists) {
    return;
  }

  const slackUrl = SLACK_WEBHOOK_URL.value();
  const userDoc = user.data() as UserModel;
  const unclaimed =  userDoc.unclaimed || false;

  if (unclaimed) {
    await _deleteUser(userDoc, slackUrl);
  } else {
    await _unclaimedUser(userDoc, slackUrl);
  }
};

// --------------------------------------------------------
export const onUserDeleted = functions
  .runWith({ secrets: [ SLACK_WEBHOOK_URL ] })
  .auth
  .user()
  .onDelete((user: UserRecord) => _onDeleteUser({ id: user.uid }));

// export const addNewsletterSubscriberToMailchimp = onRequest(
//   { secrets: [ ] },
//   async (req, res) => {
//     // get customer information
//     const stripe = new Stripe(stripeTestKey.value(), {
//       apiVersion: "2022-11-15",
//     });

//     info("marketingPlanStripeWebhook", req.body);
//     const sig = req.headers["stripe-signature"];
//     if (!sig) {
//       res.status(400).send("No signature");
//       return;
//     }


//     try {
//       const event = stripe.webhooks.constructEvent(
//         req.rawBody,
//         sig,
//         stripeTestEndpointSecret.value(),
//       );

//       // Handle the event
//       switch (event.type) {
//       case "checkout.session.completed":

//         break;
//         // ... handle other event types
//       default:
//         console.log(`Unhandled event type ${event.type}`);
//       }

//       // Return a 200 response to acknowledge receipt of the event
//       res.sendStatus(200);
//     } catch (err: any) {
//       error(err);
//       res.status(400).send(`Webhook Error: ${err.message}`);
//       return;
//     }
//     // add contact to mailchimp audience
//   });

// export const removeNewsletterUnsubscriberFromMailchimp = onRequest(
//   { secrets: [ ] },
//   async () => {
//     // get customer information

//     // remove contact from mailchimp audience
//   });
