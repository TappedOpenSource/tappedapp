/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import {
  FieldValue,
} from "firebase-admin/firestore";
import { UserRecord } from "firebase-functions/v1/auth";
import {
  commentsRef,
  loopCommentsGroupRef,
  loopsRef,
  mainBucket,
  usersRef,
} from "./lib/firebase";
import {
  getFileFromURL,
} from "./lib/utils";

export * from "./lib/rest";
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

const _deleteUser = async (data: { id: string }) => {
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

  usersRef.doc(data.id).set({
    unclaimed: true,
  });

  // *delete loop protocol*
  const userLoops = await loopsRef.where("userId", "==", data.id).get();
  userLoops.docs.forEach((snapshot) =>
    _deleteLoop({ id: snapshot.id, userId: data.id })
  );

  // *delete comment procotol*
  const userLoopsComments = await loopCommentsGroupRef
    .orderBy("timestamp", "desc")
    .where("userId", "==", data.id)
    .get();
  userLoopsComments.docs.forEach((snapshot) => {
    const comment = snapshot.data();
    _deleteComment({
      id: snapshot.id,
      rootId: comment.rootId,
      userId: comment.userId,
    });
  });

  // *delete all loops keyed at 'audio/loops/{UID}/{LOOPURL}'*
  mainBucket.deleteFiles({ prefix: `audio/loops/${data.id}` });

  // *delete all images keyed at 'images/users/{UID}/{IMAGEURL}'*
  // mainBucket.deleteFiles({ prefix: `images/users/${data.id}` });

  // TODO: delete follower table stuff?
  // TODO: delete following table stuff?
  // TODO: delete stream info?
};

const _deleteComment = async (data: {
  id: string;
  userId: string
  rootId: string,
}) => {
  // Checking attribute.
  if (data.id.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'id' cannot be empty"
    );
  }
  if (data.userId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'rootId' cannot be empty"
    );
  }
  if (data.rootId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'rootId' cannot be empty"
    );
  }

  const commentSnapshot = await commentsRef
    .doc(data.rootId)
    .collection("loopComments")
    .doc(data.id)
    .get();

  const rootId = commentSnapshot.data()?.["rootId"];
  loopsRef
    .doc(rootId)
    .update({ commentCount: FieldValue.increment(-1) });

  commentSnapshot.ref.update({
    content: "*deleted*",
    deleted: true,
  });
};

const _deleteLoop = async (data: { id: string; userId: string }) => {
  // Checking attribute.
  if (data.id.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'id' cannot be empty"
    );
  }

  const loopSnapshot = await loopsRef.doc(data.id).get();

  loopsRef.doc(data.id).update({
    audioPath: FieldValue.delete(),
    commentCount: FieldValue.delete(),
    downloads: FieldValue.delete(),
    likeCount: FieldValue.delete(),
    tags: FieldValue.delete(),
    timestamp: FieldValue.delete(),
    title: "*deleted*",
    deleted: true,
  });

  usersRef.doc(data.userId).update({
    loopsCount: FieldValue.increment(-1),
  });

  // *delete loops keyed at refFromURL(loop.audioPath)*
  if (loopSnapshot.data()?.audioPath != null) {
    mainBucket.file(getFileFromURL(loopSnapshot.data()?.audioPath)).delete();
  }
};

// --------------------------------------------------------
export const onUserDeleted = functions.auth
  .user()
  .onDelete((user: UserRecord) => _deleteUser({ id: user.uid }));

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
