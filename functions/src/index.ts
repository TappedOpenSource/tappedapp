/* eslint-disable import/no-unresolved */
import { messaging } from "firebase-admin";

import * as functions from "firebase-functions";
import {
  FieldValue,
  Timestamp,
} from "firebase-admin/firestore";

import { StreamChat } from "stream-chat";
import { HttpsError, UserRecord } from "firebase-functions/v1/auth";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { onCall, onRequest } from "firebase-functions/v2/https";

import Stripe from "stripe";
import { v4 as uuidv4 } from "uuid";

import {
  Booking,
  Loop,
  Comment,
  FollowActivity,
  LikeActivity,
  CommentActivity,
  BookingRequestActivity,
  BookingUpdateActivity,
  CommentMentionActivity,
  LoopMentionActivity,
  BookingStatus,
  CommentLikeActivity,
  OpportunityInterest,
  SearchAppearanceActivity,
  BookingReminderActivity,
  MarketingPlan,
  UserModel,
  // GuestMarketingPlan,
  // UserModel,
  // BookerReview,
} from "./models";
import { sd } from "./leapai";
import {
  auth,
  activitiesRef,
  bookerReviewsSubcollection,
  commentsRef,
  feedsRef,
  loopCommentsGroupRef,
  loopsFeedSubcollection,
  loopsRef,
  mainBucket,
  performerReviewsSubcollection,
  remote,
  usersRef,
  fcm,
  servicesRef,
  bookingsRef,
  tokensRef,
  followingRef,
  followersRef,
  stripeKey,
  stripePublishableKey,
  LEAP_API_KEY,
  verifyUserBadgeId,
  streamSecret,
  streamKey,
  OPEN_AI_KEY,
  verifiedBotUuid,
  bookingBotUuid,
  LEAP_WEBHOOK_SECRET,
  avatarsRef,
  aiModelsRef,
  trainingImagesRef,
  projectId,
  marketingPlansRef,
  stripeTestKey,
  stripeTestEndpointSecret,
  marketingFormsRef,
  guestMarketingPlansRef,
  RESEND_API_KEY,
  labelApplicationsRef,
  creditsRef,
  creditsPerPriceId,
  creditsPerTestPriceId,
  stripeCoverArtTestWebhookSecret,
  stripeCoverArtWebhookSecret,
} from "./firebase";
import {
  authenticatedRequest,
  authenticated,
  getFoundersDeviceTokens,
  getFileFromURL,
} from "./utils";
import { error, info } from "firebase-functions/logger";
import { Resend } from "resend";
import { marked } from "marked";
import {
  basicEnhancedBio,
  generateBasicAlbumName,
  generateBasicMarketingPlan,
  generateSingleBasicMarketingPlan,
} from "./openai";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

export * from "./email_triggers";

const WEBHOOK_URL = `https://us-central1-${projectId}.cloudfunctions.net/trainWebhook`;
const IMAGE_WEBHOOK_URL = `https://us-central1-${projectId}.cloudfunctions.net/imageWebhook`;

const prompts = [
  "8k portrait of @subject in the style of jackson pollock's 'abstract expressionism,' featuring drips, splatters, and energetic brushwork.",

  "8k portrait of @subject in the style of salvador dalí's 'surrealism,' featuring unexpected juxtapositions, melting objects, and a dreamlike atmosphere.",

  "8k portrait of @subject in the style of Retro comic style artwork, highly detailed spiderman, comic book cover, symmetrical, vibrant",

  "8k close up linkedin profile picture of @subject, professional jack suite, professional headshots, photo-realistic, 4k, high-resolution image, workplace settings, upper body, modern outfit, professional suit, businessman, blurred background, glass building, office window",
];



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
    username: "*deleted*",
    deleted: true,
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
  mainBucket.deleteFiles({ prefix: `images/users/${data.id}` });

  // TODO: delete follower table stuff?
  // TODO: delete following table stuff?
  // TODO: delete stream info?
};

const _addActivity = async (
  activity: FollowActivity
    | LikeActivity
    | CommentActivity
    | BookingRequestActivity
    | BookingUpdateActivity
    | LoopMentionActivity
    | CommentMentionActivity
    | CommentLikeActivity
    | OpportunityInterest
    | BookingReminderActivity
    | SearchAppearanceActivity
) => {
  // Checking attribute.A
  if (activity.toUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new HttpsError(
      "invalid-argument",
      "The function argument 'toUserId' cannot be empty"
    );
  }

  const allowedActivityTypes = [
    "follow",
    "like",
    "comment",
    "bookingRequest",
    "bookingUpdate",
    "loopMention",
    "commentMention",
    "commentLike",
    "opportunityInterest",
    "bookingReminder",
    "searchAppearance",
  ];

  if (!allowedActivityTypes.includes(activity.type)) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'type' must be either " +
      allowedActivityTypes.join(", ")
    );
  }

  const docRef = await activitiesRef.add({
    ...activity,
    timestamp: Timestamp.now(),
    markedRead: false,
  });

  return { id: docRef.id };
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

const _copyUserLoopsToFeed = async (data: {
  loopsOwnerId: string;
  feedOwnerId: string;
}) => {
  const loopsQuerySnapshot = await loopsRef
    .where("userId", "==", data.loopsOwnerId)
    .limit(1000)
    .get();

  loopsQuerySnapshot.docs.forEach((doc) => {
    feedsRef
      .doc(data.feedOwnerId)
      .collection(loopsFeedSubcollection)
      .doc(doc.id)
      .set({
        timestamp: doc.data()["timestamp"] || Timestamp.now(),
        userId: data.loopsOwnerId,
      });
  });

  return data.feedOwnerId;
};

const _deleteUserLoopsFromFeed = (data: {
  loopsOwnerId: string;
  feedOwnerId: string;
}) => {
  feedsRef
    .doc(data.feedOwnerId)
    .collection(loopsFeedSubcollection)
    .where("userId", "==", data.loopsOwnerId)
    .limit(1000)
    .get()
    .then((query) => {
      query.docs.forEach((doc) => {
        doc.ref.delete();
      });
    });

  return data.feedOwnerId;
};

const _createStripeCustomer = async (email?: string) => {
  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const customer = await stripe.customers.create({ email: email });

  return customer.id;
}

const _createPaymentIntent = async (data: {
  destination?: string;
  amount?: number,
  customerId?: string,
  receiptEmail?: string,
}) => {


  if (data.destination === undefined || data.destination === null || data.destination === "") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'destination' cannot be empty"
    );
  }

  if (data.amount === undefined || data.amount === null || data.amount < 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'amount' cannot be empty or negative"
    );
  }

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });


  const customerId = (data.customerId === undefined || data.customerId === null || data.customerId === "")
    ? (await _createStripeCustomer(data.receiptEmail))
    : data.customerId

  // Use an existing Customer ID if this is a returning customer.
  const ephemeralKey = await stripe.ephemeralKeys.create(
    { customer: customerId },
    { apiVersion: "2022-11-15" }
  );

  const remoteTemplate = await remote.getTemplate()
  const bookingFeeValue = remoteTemplate.parameters.booking_fee?.defaultValue;
  // const bookingFee = await getValue(remote, "booking_fee").asNumber();

  if (bookingFeeValue === undefined || bookingFeeValue === null) return;

  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  const weirdTSError = bookingFeeValue.value;

  const bookingFee = parseFloat(weirdTSError);

  const application_fee = data.amount * bookingFee;

  const paymentIntent = await stripe.paymentIntents.create({
    amount: Math.floor(data.amount),
    currency: "usd",
    customer: customerId,
    application_fee_amount: Math.floor(application_fee),
    automatic_payment_methods: {
      enabled: true,
    },
    transfer_data: {
      destination: data.destination,
    },
    receipt_email: data.receiptEmail,
  });

  return {
    paymentIntent: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customerId,
    publishableKey: stripePublishableKey.value(),
  };
};

const _createStripeAccount = async ({ countryCode }: {
  countryCode?: string;
}) => {
  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const country = countryCode || "US";
  const account = await stripe.accounts.create({
    type: "express",
    settings: {
      payouts: {
        schedule: {
          interval: "manual",
        },
      },
    },
    // cross border payments only work with
    // recipient accounts
    // tos_acceptance: {
    //   service_agreement: "recipient", 
    // },
    country: country,
  });

  info(`Created Stripe account ${account.id} for ${country}`);

  return account.id;
}

const _createConnectedAccount = async ({ accountId, country }: {
  accountId: string;
  country?: string;
}) => {

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const account = (accountId === undefined || accountId === null || accountId === "")
    ? (await _createStripeAccount({
      countryCode: country,
    }))
    : accountId

  const subdomain = "tappednetwork";
  const deepLink = "https://tappednetwork.page.link/connect_payment";
  const appInfo = "&apn=com.intheloopstudio&isi=1574937614&ibi=com.intheloopstudio";

  const refreshUrl = `https://${subdomain}.page.link/?link=${deepLink}?account_id=${accountId}&refresh=true${appInfo}`;
  const returnUrl = `https://${subdomain}.page.link/?link=${deepLink}?account_id=${accountId}`;

  const accountLinks = await stripe.accountLinks.create({
    account: account,
    refresh_url: refreshUrl,
    return_url: returnUrl,
    type: "account_onboarding",
  })

  return { success: true, url: accountLinks.url, accountId: accountId };
}

const _getAccountById = async (data: { accountId: string }) => {
  if (data.accountId === undefined || data.accountId === null || data.accountId === "") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'accountId' cannot be empty"
    );
  }

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const account = await stripe.accounts.retrieve(data.accountId);

  return account;
}

const _updateOverallRating = async ({
  userId,
  currOverallRating,
  reviewCount,
  newRating,
}: {
  userId: string;
  currOverallRating: number;
  reviewCount: number;
  newRating: number;
}) => {
  const overallRating = (currOverallRating * (reviewCount - 1) + newRating) / (reviewCount);

  await usersRef.doc(userId).update({
    overallRating: overallRating,
  });
};

const _emailMarketingPlan = async ({
  checkoutSessionCompleteId,
  checkoutSession,
  customerEmail,
  resendApiKey,
}: {
  checkoutSessionCompleteId: string;
  checkoutSession: Stripe.Response<Stripe.Checkout.Session>;
  customerEmail: string | null;
  resendApiKey: string;
}) => {
  const resend = new Resend(resendApiKey);

  const { client_reference_id: clientReferenceId } = checkoutSession;
  if (clientReferenceId === null) {
    throw new Error("no client reference id");
  }
  info({ clientReferenceId });

  await guestMarketingPlansRef.doc(clientReferenceId).update({
    status: "processing",
  });

  const formDataRef = await marketingFormsRef.doc(clientReferenceId).get()


  const formData = formDataRef.data();
  if (!formData || !formDataRef.exists) {
    throw new Error("no form data");
  }

  info({ formData })

  // TODO: get use follower count
  // TODO: switch case for if it's a single, EP, or album
  const { content, prompt } = await generateBasicMarketingPlan({
    releaseType: formData["marketingType"],
    artistName: formData["artistName"],
    // artistGenres: formData.genre,
    // igFollowerCount,
    singleName: formData["productName"],
    aesthetic: formData["aesthetic"],
    targetAudience: formData["audience"],
    moreToCome: formData["moreToCome"] ?? "nothing",
    releaseTimeline: formData["timeline"],
    apiKey: OPEN_AI_KEY.value(),
  });

  // save marketing plan to firestore and update status to 'complete'
  await guestMarketingPlansRef.doc(clientReferenceId).update({
    status: "completed",
    checkoutSessionCompleteId,
    content,
    prompt,
  });

  // email marketing plan to user
  if (customerEmail !== null) {
    await resend.emails.send({
      from: "no-reply@tapped.ai",
      to: [
        customerEmail
      ],
      subject: "Your Marketing Plan",
      html: `<div>${marked.parse(content)}</div>`,
    });
  }
};

const _createDefaultServices = async (user: UserModel) => {
  const userId = user.id;
  const services = [
    {
      id: uuidv4(),
      userId: userId,
      title: "30 min set",
      description: "30 min set",
      rate: 0,
      rateType: "hourly",
      count: 0,
      deleted: false,
    },
    {
      id: uuidv4(),
      userId: userId,
      title: "45 min set",
      description: "45 min set",
      rate: 0,
      rateType: "hourly",
      count: 0,
      deleted: false,
    },
    {
      id: uuidv4(),
      userId: userId,
      title: "60 min set",
      description: "60 min set",
      rate: 0,
      rateType: "hourly",
      count: 0,
      deleted: false,
    },
  ]

  await Promise.all(
    services.map((service) => {
      return servicesRef
        .doc(user.id)
        .collection("userServices")
        .doc(service.id)
        .set(service);
    }),
  );
}

const _incrementCoverArtTestCredits = async (stripe: Stripe, checkoutSessionCompleted: {
  id: string;
  client_reference_id: string | null;
  customer_email: string | null;
  customer_details: {
    email: string;
  }
}) => {
  const userId = checkoutSessionCompleted.client_reference_id;

  if (userId === null) {
    throw new HttpsError("failed-precondition", "client reference id not set");
  }

  // create firestore document for marketing plan set to 'processing' keyed at session_id
  info({ checkoutSessionCompleted });
  info({ sessionId: checkoutSessionCompleted.id });

  // get form data from firestore
  const checkoutSession = await stripe.checkout.sessions.retrieve(checkoutSessionCompleted.id);
  info({ checkoutSession });

  // const customerEmail = checkoutSessionCompleted.customer_email ?? checkoutSessionCompleted.customer_details.email;

  const lineItems = await stripe.checkout.sessions.listLineItems(
    checkoutSessionCompleted.id
  );
  const quantity = lineItems.data[0].quantity;
  const priceId = lineItems.data[0].price!.id;
  const creditsPerUnit = creditsPerTestPriceId[priceId];
  const totalCreditsPurchased = quantity! * creditsPerUnit;

  console.log({ lineItems });
  console.log({ quantity });
  console.log({ priceId });
  console.log({ creditsPerUnit });

  console.log("totalCreditsPurchased: " + totalCreditsPurchased);

  await creditsRef.doc(userId).update({
    coverArtCredits: FieldValue.increment(totalCreditsPurchased),
  });
};

const _incrementCoverArtCredits = async (stripe: Stripe, checkoutSessionCompleted: {
  id: string;
  client_reference_id: string | null;
  customer_email: string | null;
  customer_details: {
    email: string;
  }
}) => {
  const userId = checkoutSessionCompleted.client_reference_id;

  if (userId === null) {
    throw new HttpsError("failed-precondition", "client reference id not set");
  }

  // create firestore document for marketing plan set to 'processing' keyed at session_id
  info({ checkoutSessionCompleted });
  info({ sessionId: checkoutSessionCompleted.id });

  // get form data from firestore
  const checkoutSession = await stripe.checkout.sessions.retrieve(checkoutSessionCompleted.id);
  info({ checkoutSession });

  // const customerEmail = checkoutSessionCompleted.customer_email ?? checkoutSessionCompleted.customer_details.email;

  const lineItems = await stripe.checkout.sessions.listLineItems(
    checkoutSessionCompleted.id
  );
  const quantity = lineItems.data[0].quantity;
  const priceId = lineItems.data[0].price!.id;
  const creditsPerUnit = creditsPerPriceId[priceId];
  const totalCreditsPurchased = quantity! * creditsPerUnit;

  console.log({ lineItems });
  console.log({ quantity });
  console.log({ priceId });
  console.log({ creditsPerUnit });

  console.log("totalCreditsPurchased: " + totalCreditsPurchased);

  await creditsRef.doc(userId).update({
    coverArtCredits: FieldValue.increment(totalCreditsPurchased),
  });
};

const _giveUserCoverArtCredits = async (userId: string, amount: number) => {
  await creditsRef.doc(userId).set({
    coverArtCredits: FieldValue.increment(amount),
  });
}

// --------------------------------------------------------
export const sendToDevice = functions.firestore
  .document("activities/{activityId}")
  .onCreate(async (snapshot) => {
    const activity = snapshot.data();

    const userDoc = await usersRef.doc(activity["toUserId"]).get();
    const user = userDoc.data();
    if (user === null || user === undefined) {
      throw new Error("User not found");
    }

    const activityType = activity["type"];

    let payload: messaging.MessagingPayload = {
      notification: {
        title: "New Activity",
        body: "You have new activity on your profile",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    switch (activityType) {
    case "comment":
      if (!user["pushNotificationsComments"]) return;

      payload = {
        notification: {
          title: "New Comment",
          body: "Someone commented on your loop 👀",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "like":
      if (!user["pushNotificationsLikes"]) return;
      payload = {
        notification: {
          title: "New Like",
          body: "Someone liked your loops 👍",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "follow":
      if (!user["pushNotificationsFollows"]) return;
      payload = {
        notification: {
          title: "New Follower",
          body: "You just got a new follower 🔥",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "bookingRequest":
      payload = {
        notification: {
          title: "New Booking Request",
          body: "You just got a new booking request 🔥",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "bookingUpdate":
      payload = {
        notification: {
          title: "Booking Update",
          body: "There was an update to one of your bookings",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "loopMention":
      payload = {
        notification: {
          title: "Mention",
          body: "Someone mentioned you in a loop",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "commentMention":
      payload = {
        notification: {
          title: "Mention",
          body: "Someone mentioned you in a comment",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "bookingReminder":
      payload = {
        notification: {
          title: "Booking Reminder",
          body: "You have a booking coming up soon!!!",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "searchAppearance":
      payload = {
        notification: {
          title: "You're on the map!",
          body: "you've showed up in new searches this week 👀",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    default:
      return;
    }

    const querySnapshot = await tokensRef
      .doc(activity["toUserId"])
      .collection("tokens")
      .get();

    const tokens: string[] = querySnapshot.docs.map((snap) => snap.id);
    if (tokens.length == 0) {
      functions.logger.debug("No tokens to send to");
    }

    try {
      const resp = await fcm.sendToDevice(tokens, payload);
      if (resp.failureCount > 0) {
        functions.logger.warn(`Failed to send message to some devices: ${resp.failureCount}`);
      }
    } catch (e: any) {
      functions.logger.error(`${user["id"]} : ${e}`);
      throw new Error(`cannot send notification to device, userId: ${user["id"]}, ${e.message}`);
    }
  });
export const createStreamUserOnUserCreated = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .firestore
  .document("users/{userId}")
  .onCreate(async (snapshot) => {
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );

    const user = snapshot.data();
    await streamClient.upsertUser({
      id: user.id,
      name: user.artistName,
      username: user.username,
      email: user.email,
      image: user.profilePicture,
    });
  })
export const autoFollowUsersOnUserCreated = functions
  .firestore
  .document("users/{userId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const userIdsToAutoFollow = [
      "8yYVxpQ7cURSzNfBsaBGF7A7kkv2", // Johannes
      "n4zIL6bOuPTqRC3dtsl6gyEBPQl1", // Ilias
      // "ToPGEF6jP1e7R6XJDsOHYSyBpf22", // Amberay
      // "aDsHZs9v2BcUWJZYIRAPbX6KSMs2", // Phil
      // "7wEC1jNzsShn3wd8BWXC0w89aIF3" // Xypper
      // "kNVsCCnDkFdYAxebMspLpnEudwq1", // Jayduhhhh
      // "xfxTCUerCyZCUB85likg7THcUGD2", // Yung Smilez
      // "EczWgsPTL1ROJ6EU93Q5vs0Osfx2", // Akimi
      "yTIvDDidqjORseS764JZH01Nkds1", // Ryan
    ];

    functions.logger.debug(`auto following users for ${userId}`)

    for (const userIdToAutoFollow of userIdsToAutoFollow) {
      await followingRef
        .doc(userId)
        .collection("Following")
        .doc(userIdToAutoFollow)
        .set({});
    }
  })

export const notifyFoundersOnSignUp = functions
  .auth
  .user()
  .onCreate(async (user) => {
    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: "You have a new user \uD83D\uDE43",
        body: `${user.displayName}, ${user.email} just signed up`,
      }
    };

    fcm.sendToDevice(devices, payload);
  });
export const notifyFoundersOnAppRemoved = functions
  .analytics
  .event("app_remove")
  .onLog(async (event) => {
    const devices = await getFoundersDeviceTokens();
    const user = event.user;
    const payload = {
      notification: {
        title: "You lost a user \uD83D\uDE1E",
        body: `${user?.deviceInfo.mobileModelName} from ${user?.geoInfo.city}, ${user?.geoInfo.country}`,
      }
    };

    fcm.sendToDevice(devices, payload);
  });
export const notifyFoundersOnLabelApplication = functions
  .firestore
  .document("label_applications/{applicationId}")
  .onCreate(async (snapshot) => {
    const application = snapshot.data();
    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: "New Label Application \uD83D\uDE43",
        body: `${application.name} just applied for the ai label`,
      }
    };

    fcm.sendToDevice(devices, payload);
  });
export const notifyFoundersOnMarketingForm = functions
  .firestore
  .document("marketingForm/{formId}")
  .onCreate(async (snapshot) => {
    const form = snapshot.data();

    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: "New Marketing Form \uD83D\uDE43",
        body: `${form.artistName} just created a marketing plan`,
      }
    };

    fcm.sendToDevice(devices, payload);
  });
export const notifyFoundersOnGuestMarketingPlan = functions
  .firestore
  .document("guestMarketingPlans/{planId}")
  .onCreate(async () => {
    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: "New Marketing Plan \uD83D\uDE43",
        body: "Someone just created a marketing plan",
      }
    };

    fcm.sendToDevice(devices, payload);
  });
export const updateStreamUserOnUserUpdate = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .firestore
  .document("users/{userId}")
  .onUpdate(async (snapshot) => {
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );

    const user = snapshot.after.data();
    streamClient.partialUpdateUser({
      id: user.id,
      set: {
        name: user.artistName,
        username: user.username,
        email: user.email,
        image: user.profilePicture,
      },
    });
  })

export const addFollowersEntryOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onCreate(async (snapshot, context) => {
    await followersRef
      .doc(context.params.followeeId)
      .collection("Followers")
      .doc(context.params.followerId)
      .set({});
  });
export const removeFollowersEntryOnUnfollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    await followersRef
      .doc(context.params.followeeId)
      .collection("Followers")
      .doc(context.params.followerId)
      .delete();
  });
export const decrementFollowersCountOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followeeId)
      .update({
        followerCount: FieldValue.increment(-1),
      });
  });
export const decrementFollowingCountOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onDelete(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followerId)
      .update({
        followingCount: FieldValue.increment(-1),
      });
  });
export const incrementFollowersCountOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followeeId)
      .update({
        followerCount: FieldValue.increment(1),
      });
  });
export const incrementFollowingCountOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followerId)
      .update({
        followingCount: FieldValue.increment(1),
      });
  });
export const copyLoopFeedOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onCreate(async (snapshot, context) => {
    _copyUserLoopsToFeed({
      loopsOwnerId: context.params.followeeId,
      feedOwnerId: context.params.followerId,
    });
  });

export const addActivityOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onCreate(async (snapshot, context) => {
    await _addActivity({
      toUserId: context.params.followeeId,
      fromUserId: context.params.followerId,
      type: "follow",
    });
  })

export const deleteUserLoopOnUnfollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    _deleteUserLoopsFromFeed({
      loopsOwnerId: context.params.followeeId,
      feedOwnerId: context.params.followerId,
    })
  });

export const deteteFollowersEntryOnUnfollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    const doc = await followersRef
      .doc(context.params.followeeId)
      .collection("Followers")
      .doc(context.params.followerId)
      .get();

    if (!doc.exists) {
      return;
    }

    doc.ref.delete()
  });

export const incrementLoopCountOnUpload = functions.firestore
  .document("loops/{loopId}")
  .onCreate(async (snapshot) => {
    const loop = snapshot.data();
    await usersRef
      .doc(loop.userId)
      .update({ loopsCount: FieldValue.increment(1) });
  })
export const notifyMentionsOnLoopUpload = functions.firestore
  .document("loops/{loopId}")
  .onCreate(async (snapshot) => {
    const loop = snapshot.data() as Loop;
    const description = loop.description;
    const userTagRegex = /^(.*?)(?<![\w@])@([\w@]+(?:[.!][\w@]+)*)/;

    description.match(userTagRegex)?.forEach(async (match: string) => {
      const username = match.replace("@", "");
      const userDoc = await usersRef.where("username", "==", username).get();
      if (userDoc.empty) {
        functions.logger.error(`user ${username} not found`)
        return;
      }

      const user = userDoc.docs[0].data();

      functions.logger.info(`new mention ${user.id} by ${loop.userId}`)
      await _addActivity({
        toUserId: user.id,
        fromUserId: loop.userId,
        type: "loopMention",
        loopId: loop.id,
      });
    });
  })
export const sendLoopToFollowers = functions.firestore
  .document("loops/{loopId}")
  .onCreate(async (snapshot) => {
    const loop = snapshot.data();
    const userDoc = await usersRef.doc(loop.userId).get();
    // add loops to owner's feed
    await feedsRef
      .doc(loop.userId)
      .collection(loopsFeedSubcollection)
      .doc(snapshot.id)
      .set({
        timestamp: Timestamp.now(),
        userId: loop.userId,
      });

    const isShadowBanned: boolean = userDoc.data()?.["shadowBanned"] || false
    if (isShadowBanned === true) {
      return;
    }
    // get followers
    const followerSnapshot = await followersRef
      .doc(loop.userId)
      .collection("Followers")
      .get();

    // add loops to followers feed
    await Promise.all(
      followerSnapshot.docs.map(async (docSnapshot) => {
        return feedsRef
          .doc(docSnapshot.id)
          .collection(loopsFeedSubcollection)
          .doc(snapshot.id).set({
            timestamp: Timestamp.now(),
            userId: loop.userId,
          });
      }),
    );

  });

export const incrementLikeCountOnLoopLike = functions.firestore
  .document("likes/{loopId}/loopLikes/{userId}")
  .onCreate(async (snapshot, context) => {
    await loopsRef
      .doc(context.params.loopId)
      .update({ likeCount: FieldValue.increment(1) });
  });

export const addActivityOnLoopLike = functions.firestore
  .document("likes/{loopId}/loopLikes/{userId}")
  .onCreate(async (snapshot, context) => {
    const loopSnapshot = await loopsRef.doc(context.params.loopId).get();
    const loop = loopSnapshot.data();
    if (loop === undefined) {
      return;
    }

    if (loop.userId !== context.params.userId) {
      _addActivity({
        fromUserId: context.params.userId,
        type: "like",
        toUserId: loop.userId,
        loopId: context.params.loopId,
      });
    }
  });

export const decrementLoopLikeCountOnUnlike = functions.firestore
  .document("likes/{loopId}/loopLikes/{userId}")
  .onDelete(async (snapshot, context) => {
    await loopsRef
      .doc(context.params.loopId)
      .update({ likeCount: FieldValue.increment(-1) });
  })

export const incrementLikeCountOnCommentLike = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}/commentLikes/{userId}")
  .onCreate(async (snapshot, context) => {
    await commentsRef
      .doc(context.params.loopId)
      .collection("loopComments")
      .doc(context.params.commentId)
      .update({ likeCount: FieldValue.increment(1) });
  });
export const decrementLoopLikeCountOnCommentUnlike = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}/commentLikes/{userId}")
  .onDelete(async (snapshot, context) => {
    await commentsRef
      .doc(context.params.loopId)
      .collection("loopComments")
      .doc(context.params.commentId)
      .update({ likeCount: FieldValue.increment(-1) });
  });
export const addActivityOnCommentLike = functions.firestore
  .document("comments/{rootId}/loopComments/{commentId}/commentLikes/{userId}")
  .onCreate(async (snapshot, context) => {
    const commentSnapshot = await commentsRef
      .doc(context.params.rootId)
      .collection("loopComments")
      .doc(context.params.commentId)
      .get();

    const comment = commentSnapshot.data();
    if (comment === undefined) {
      return;
    }

    if (comment.userId !== context.params.userId) {
      _addActivity({
        toUserId: comment.userId,
        fromUserId: context.params.userId,
        type: "commentLike",
        commentId: context.params.commentId,
        rootId: context.params.rootId,
      });
    }
  });

export const addActivityOnBooking = functions.firestore
  .document("bookings/{bookingId}")
  .onCreate(async (snapshot, context) => {
    const booking = snapshot.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not exist`,);
    }

    _addActivity({
      fromUserId: booking.requesterId,
      type: "bookingRequest",
      toUserId: booking.requesteeId,
      bookingId: context.params.bookingId,
    });
  });
export const addActivityOnBookingUpdate = functions.firestore
  .document("bookings/{bookingId}")
  .onUpdate(async (change, context) => {
    const booking = change.after.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not exist`,);
    }

    const status = booking.status as BookingStatus;

    const uid = context.auth?.uid;

    if (uid === undefined || uid === null) {
      throw new HttpsError("unauthenticated", "user is not authenticated");
    }

    for (const userId of [ booking.requesterId, booking.requesteeId ]) {
      if (userId === uid) {
        continue;
      }
      await _addActivity({
        fromUserId: uid,
        type: "bookingUpdate",
        toUserId: userId,
        bookingId: context.params.bookingId,
        status: status,
      });
    }
  });

export const incrementLoopCommentCountOnComment = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const loopSnapshot = await loopsRef.doc(context.params.loopId).get();
    const loop = loopSnapshot.data();

    if (loop === undefined) {
      throw new HttpsError("failed-precondition", `loop ${context.params.loopId} does not exist`);
    }

    await loopsRef
      .doc(context.params.loopId)
      .update({ commentCount: FieldValue.increment(1) });
  });
export const notifyMentionsOnComment = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const comment = snapshot.data() as Comment;

    const text = comment.content;
    const userTagRegex = /^(.*?)(?<![\w@])@([\w@]+(?:[.!][\w@]+)*)/;

    text.match(userTagRegex)?.forEach(async (match: string) => {
      const username = match.replace("@", "");
      const userDoc = await usersRef.where("username", "==", username).get();
      if (userDoc.empty) {
        return;
      }

      const user = userDoc.docs[0].data();

      functions.logger.info(`new mention ${user.id} by ${comment.userId}`)
      await _addActivity({
        toUserId: user.id,
        fromUserId: comment.userId,
        type: "commentMention",
        rootId: context.params.loopId,
        commentId: context.params.commentId,
      });
    });
  });

export const addActivityOnLoopComment = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const comment = snapshot.data();
    const loopSnapshot = await loopsRef.doc(context.params.loopId).get();
    const loop = loopSnapshot.data();

    if (loop === undefined) {
      throw new HttpsError("failed-precondition", `loop ${context.params.loopId} does not exist`);
    }

    if (loop.userId !== comment.userId) {
      _addActivity({
        toUserId: loop.userId,
        fromUserId: comment.userId,
        type: "comment",
        rootId: context.params.loopId,
        commentId: context.params.commentId,
      });
    }
  });

export const incrementBadgeCountOnBadgeSent = functions.firestore
  .document("badgesSent/{userId}/badges/{badgeId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.userId)
      .update({ badgesCount: FieldValue.increment(1) });
  });
export const onUserDeleted = functions.auth
  .user()
  .onDelete((user: UserRecord) => _deleteUser({ id: user.uid }));
export const deleteStreamUser = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .auth
  .user()
  .onDelete((user) => {
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );
    return streamClient.deleteUser(user.uid);
  });
export const addActivity = functions.https.onCall((data, context) => {
  authenticated(context);
  return _addActivity(data);
});
export const createPaymentIntent = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    authenticated(context);
    return _createPaymentIntent(data);
  });
export const createConnectedAccount = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    authenticated(context);
    return _createConnectedAccount(data);
  })
export const getAccountById = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    authenticated(context);
    return _getAccountById(data);
  });

export const incrementServiceCountOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (snapshot, context) => {
    const booking = snapshot.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not exist`,);
    }

    if (booking.serviceId === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not have a serviceId`,);
    }

    await servicesRef
      .doc(booking.serviceId)
      .update({ bookingCount: FieldValue.increment(1) });
  });

export const transformLoopPayloadForSearch = functions.https
  .onCall((data) => {

    const { lat, lng, ...rest } = data;

    const payload: Record<string, any> = rest;

    if (lat !== undefined && lat !== null && lng !== undefined && lng !== null) {
      payload._geoloc = { lat, lng }
    }

    return payload;
  })
export const notifyFoundersOnBookings = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (data) => {
    const booking = data.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${data.id} does not exist`,);
    }

    if (booking.serviceId === undefined) {
      throw new HttpsError("failed-precondition", `booking ${data.id} does not have a serviceId`,);
    }

    const serviceSnapshot = await servicesRef
      .doc(booking.requesteeId)
      .collection("userServices")
      .doc(booking.serviceId)
      .get();

    const service = serviceSnapshot.data();

    const requesterSnapshot = await usersRef.doc(booking.requesterId).get();
    const requester = requesterSnapshot.data();

    const requesteeSnapshot = await usersRef.doc(booking.requesteeId).get();
    const requestee = requesteeSnapshot.data();

    const payload: messaging.MessagingPayload = {
      notification: {
        title: "NEW TAPPED BOOKING!!!",
        body: `${requester?.artistName ?? "<UNKNOWN>"} booked ${requestee?.artistName ?? "<UNKNOWN>"} for service ${service?.title ?? "<UNKNOWN>"}`,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    const deviceTokens = await getFoundersDeviceTokens();

    try {
      const resp = await fcm.sendToDevice(deviceTokens, payload);
      if (resp.failureCount > 0) {
        functions.logger.warn(`Failed to send message to some devices: ${resp.failureCount}`);
      }
    } catch (e: any) {
      functions.logger.error(`ERROR : ${e}`);
      throw new Error(`cannot send notification to device ${e.message}`);
    }
  });
export const postFromBookingBotOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (data) => {
    const booking = data.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${data.id} does not exist`,);
    }

    if (booking.serviceId === undefined) {
      throw new HttpsError("failed-precondition", `booking ${data.id} does not have a serviceId`,);
    }

    const serviceSnapshot = await servicesRef
      .doc(booking.requesteeId)
      .collection("userServices")
      .doc(booking.serviceId)
      .get();

    const service = serviceSnapshot.data();

    const requesterSnapshot = await usersRef.doc(booking.requesterId).get();
    const requester = requesterSnapshot.data();

    const requesteeSnapshot = await usersRef.doc(booking.requesteeId).get();
    const requestee = requesteeSnapshot.data();

    const uuid = uuidv4();
    const post = {
      id: uuid,
      userId: bookingBotUuid,
      title: "🎫 NEW BOOKING",
      description: `@${requester?.username ?? "UNNKOWN"} booked @${requestee?.username ?? "UNKNOWN"} for service '${service?.title ?? "UNKNOWN"}'`,
      imagePaths: [],
      timestamp: Timestamp.now(),
      likeCount: 0,
      commentCount: 0,
      shareCount: 0,
      deleted: false,
    }
    await loopsRef.doc(uuid).set(post);
  });
export const postFromVerifiedBotOnVerification = functions
  .firestore
  .document(`badgesSent/{userId}/badges/${verifyUserBadgeId}`)
  .onCreate(async (data, context) => {
    const userSnapshot = await usersRef.doc(context.params.userId).get();
    const user = userSnapshot.data();

    const uuid = uuidv4();
    const post = {
      id: uuid,
      userId: verifiedBotUuid,
      title: "✔️ NEW VERIFICATION",
      description: `@${user?.username ?? "UNKNOWN"} is now verified!`,
      imagePaths: [],
      timestamp: Timestamp.now(),
      likeCount: 0,
      commentCount: 0,
      shareCount: 0,
      deleted: false,
    }
    await loopsRef.doc(uuid).set(post);
  });

export const cancelBookingIfExpired = onSchedule("0 * * * *", async (event) => {
  const pendingBookings = await bookingsRef.where("status", "==", "pending").get();

  for (const booking of pendingBookings.docs) {
    const bookingData = booking.data() as Booking;
    const timestamp = bookingData.timestamp.toMillis();
    const now = Date.now();

    const ONE_DAY_MS = 24 * 60 * 60 * 1000;
    if (now > (timestamp + ONE_DAY_MS)) {
      await booking.ref.update({
        status: "canceled",
      });
    }
  }
});

export const addActivityOnOpportunityInterest = functions
  .firestore
  .document("opportunities/{loopId}/interestedUsers/{userId}")
  .onCreate(async (data, context) => {
    const loopSnapshot = await loopsRef.doc(context.params.loopId).get();
    const loop = loopSnapshot.data() as Loop;

    _addActivity({
      toUserId: loop.userId,
      fromUserId: context.params.userId,
      type: "opportunityInterest",
      loopId: context.params.loopId,
    });
  });

export const unfollowUserOnBlock = functions
  .firestore
  .document("blocked/{userId}/blockedUsers/{blockedUserId}")
  .onCreate(async (data, context) => {
    const blockedUserId = context.params.blockedUserId;
    const userId = context.params.userId;

    const doc = await followingRef
      .doc(userId)
      .collection("Following")
      .doc(blockedUserId)
      .get();

    await doc.ref.delete();
  });

export const incrementReviewCountOnPerformerReview = functions
  .firestore
  .document(`reviews/{userId}/${performerReviewsSubcollection}/{reviewId}`)
  .onCreate(async (data, context) => {
    const userId = context.params.userId;
    const userRef = usersRef.doc(userId);

    await userRef.update({
      reviewCount: FieldValue.increment(1),
    });

    const currOverallRating = (await userRef.get()).data()?.overallRating || 0;
    const reviewCount = (await userRef.get()).data()?.reviewCount || 0;
    const newRating = data.data()?.overallRating || 0;

    _updateOverallRating({
      userId,
      currOverallRating,
      reviewCount,
      newRating,
    });
  });

export const incrementReviewCountOnBookerReview = functions
  .firestore
  .document(`reviews/{userId}/${bookerReviewsSubcollection}/{reviewId}`)
  .onCreate(async (data, context) => {
    const userId = context.params.userId;
    const userRef = usersRef.doc(userId);

    await userRef.update({
      reviewCount: FieldValue.increment(1),
    });

    const currOverallRating = (await userRef.get()).data()?.overallRating || 0;
    const reviewCount = (await userRef.get()).data()?.reviewCount || 0;
    const newRating = data.data()?.overallRating || 0;

    _updateOverallRating({
      userId,
      currOverallRating,
      reviewCount,
      newRating,
    });
  });

export const sendSearchAppearances = onSchedule("0 0/3 * * *", async (event) => {
  const min = 20;
  const max = 50;
  const randomNumber = Math.floor(Math.random() * (max - min)) + min;

  const usersSnapshot = await usersRef.get();
  const randomUserId = usersSnapshot.docs[Math.floor(Math.random() * usersSnapshot.docs.length)].id;

  await _addActivity({
    toUserId: randomUserId,
    type: "searchAppearance",
    count: randomNumber,
  });
});

export const onDeleteAvatar = functions
  .firestore
  .document("avatars/{userId}/userAvatars/{avatarId}")
  .onDelete(async (data) => {
    const avatar = data.data();
    const url = avatar?.url;
    const userId = avatar?.userId;

    if (url === undefined) {
      return;
    }

    if (userId === undefined) {
      return;
    }

    await mainBucket.deleteFiles({ prefix: `images/${userId}/avatar_${data.id}.png` });
  });

export const generateAlbumName = onCall(
  {
    secrets: [ OPEN_AI_KEY ],
  },
  async (request) => {
    const oak = OPEN_AI_KEY.value();
    const {
      artistName,
      artistGenres,
      igFollowerCount,
    } = request.data;

    if (!(typeof artistName === "string") || artistName.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"artistName\".");
    }

    if (!Array.isArray(artistGenres) || artistGenres.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"artistGenres\".");
    }

    if (!(typeof igFollowerCount === "number") || artistName.length <= 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"igFollowerCount\".");
    }

    // Checking that the user is authenticated.
    if (!request.auth) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("failed-precondition", "The function must be " +
        "called while authenticated.");
    }

    const genres = artistGenres.join(", ");

    const res = await generateBasicAlbumName({
      artistName,
      artistGenres: genres,
      igFollowerCount,
      apiKey: oak,
    });
    functions.logger.log({ res });

    return res;
  });

export const createAvatarInferenceJob = onCall(
  {
    secrets: [ LEAP_API_KEY, LEAP_WEBHOOK_SECRET ]
  },
  async (request) => {
    // // Checking that the user is authenticated.
    authenticatedRequest(request);

    const leapApiKey = LEAP_API_KEY.value();
    const { modelId, prompt } = request.data;

    if (!(typeof modelId === "string") || modelId.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"modelId\".");
    }

    if (!(typeof prompt === "string") || prompt.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"avatarStyle\".");
    }

    const userId = request.auth?.uid;

    // const prompt = `8k portrait of @subject in the style of ${avatarStyle}`;
    const negativePrompt = "(deformed iris, deformed pupils, semi-realistic, cgi, 3d, render, sketch, cartoon, drawing, anime:1.4), text, close up, cropped, out of frame, worst quality, low quality, jpeg artifacts, ugly, duplicate, morbid, mutilated, extra fingers, mutated hands, poorly drawn hands, poorly drawn face, mutation, deformed, blurry, dehydrated, bad anatomy, bad proportions, extra limbs, cloned face, disfigured, gross proportions, malformed limbs, missing arms, missing legs, extra arms, extra legs, fused fingers, too many fingers, long neck";

    const { inferenceId } = await sd.createInferenceJob({
      leapApiKey,
      modelId,
      prompt,
      negativePrompt,
      numberOfImages: 4,
      webhookUrl: `${IMAGE_WEBHOOK_URL}?user_id=${userId}&model_id=${modelId}&webhook_secret=${LEAP_WEBHOOK_SECRET.value()}`,
    });
    info({ inferenceId });

    return { inferenceId };
  });

export const getAvatarInferenceJob = onCall(
  {
    secrets: [ LEAP_API_KEY ],
  },
  async (request) => {
    // Checking that the user is authenticated.
    authenticatedRequest(request);

    const leapApiKey = LEAP_API_KEY.value();
    const { inferenceId } = request.data;

    if (!(typeof inferenceId === "string") || inferenceId.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"inferenceId\".");
    }

    const { inferenceJob } = await sd.getInferenceJob({
      leapApiKey,
      inferenceId,
    });

    return { inferenceJob };
  });

export const deleteInferenceJob = functions
  .runWith({ secrets: [ LEAP_API_KEY ] })
  .https
  .onCall(
    async (request) => {
      // Checking that the user is authenticated.
      if (!request.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new HttpsError("failed-precondition", "The function must be " +
          "called while authenticated.");
      }

      const leapApiKey = LEAP_API_KEY.value();
      const { inferenceId } = request.data;

      await sd.deleteInferenceJob({ inferenceId, leapApiKey });
    });

export const imageWebhook = onRequest(
  { secrets: [ LEAP_API_KEY, LEAP_WEBHOOK_SECRET ] },
  async (request, response): Promise<void> => {
    const {
      id: inferenceId,
      state: status,
      result,
    } = request.body;

    const userId = request.query.user_id as string;
    const modelId = request.query.model_id as string;
    const webhookSecret = request.query.webhook_secret as string;

    info({ userId, status, inferenceId });

    if (!webhookSecret) {
      response.status(500).json(
        "Malformed URL, no webhook_secret detected!",
      );
      return;
    }

    if (
      webhookSecret.toLowerCase() !== LEAP_WEBHOOK_SECRET.value().toLowerCase()
    ) {
      response.status(401).json("Unauthorized!");
      return;
    }

    if (!userId) {
      response.status(500).json(
        "Malformed URL, no user_id detected!",
      );
      return;
    }

    if (!modelId) {
      response.status(500).json(
        "Malformed URL, no model_id detected!",
      );
      return;
    }

    try {
      info({ images: result.images });
      await Promise.all(
        result.images.map(async (image: any) => {
          avatarsRef.doc(userId).collection("userAvatars").add({
            modelId: modelId,
            url: image.uri,
          });
        })
      );
      response.status(200).json("Success");
    } catch (e) {
      info(e);
      response.status(500).json(
        "Something went wrong!",
      );
    }
  });

export const trainModel = onCall(
  { secrets: [ LEAP_API_KEY, LEAP_WEBHOOK_SECRET ] },
  async (request) => {
    // Checking that the user is authenticated.
    if (!request.auth) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError(
        "failed-precondition",
        "The function must be called while authenticated."
      );
    }

    const userId = request.auth.uid;
    info({ userId });
    const { imageUrls, type, name }: {
      imageUrls: string[];
      type: string;
      name: string;
    } = request.data;

    if (imageUrls?.length < 4) {
      throw new HttpsError(
        "failed-precondition",
        "Upload at least 4 sample images",
      );
    }
    info({ imageUrls, type, name });

    // eslint-disable-next-line max-len
    const fullWebhook = `${WEBHOOK_URL.valueOf()}?user_id=${userId}&webhook_secret=${LEAP_WEBHOOK_SECRET.value()}&model_type=${type}`;

    const modelId = await sd.createTrainingJob({
      leapApiKey: LEAP_API_KEY.value(),
      imageUrls,
      name,
      type,
      userId,
      webhookUrl: fullWebhook,
    });

    // add model to DB
    await aiModelsRef
      .doc(userId)
      .collection("imageModels")
      .doc(modelId)
      .set({
        id: modelId,
        user_id: userId,
        name,
        type,
        timestamp: Timestamp.now(),
        status: "training",
      });

    await Promise.all(
      imageUrls.map(async (imageUrl) => {
        // get image from url
        const imagesSnap = await trainingImagesRef
          .doc(userId)
          .collection("userSamples")
          .where("url", "==", imageUrl)
          .get();

        if (imagesSnap.empty) return;

        // update image with modelId
        await Promise.all(
          imagesSnap.docs.map(async (doc) => {
            await doc.ref.update({
              modelId: modelId,
            });
          }),
        );
      }),
    );

    return {
      success: true,
    };
  });

export const trainWebhook = onRequest(
  { secrets: [ LEAP_API_KEY, LEAP_WEBHOOK_SECRET ] },
  async (request, response): Promise<void> => {

    const { id, state: status }: {
      id: string;
      state: string;
    } = await request.body;
    const userId = request.query.user_id as string;
    const webhookSecret = request.query.webhook_secret as string;
    const modelType = request.query.model_type as string;

    info({ status, id });

    if (!webhookSecret) {
      response.status(500).json(
        "Malformed URL, no webhook_secret detected!",
      );
      return;
    }

    if (
      webhookSecret.toLowerCase() !== LEAP_WEBHOOK_SECRET.value().toLowerCase()
    ) {
      response.status(401).json("Unauthorized!");
      return;
    }

    if (!userId) {
      response.status(500).json(
        "Malformed URL, no user_id detected!",
      );
      return;
    }

    const user = await auth.getUser(userId);
    if (!user) {
      response.status(401).json(
        "User not found!",
      );
      return;
    }

    try {
      if (status === "finished") {
        await aiModelsRef
          .doc(userId)
          .collection("imageModels")
          .doc(id)
          .update({
            status: "ready",
          });


        for (let index = 0; index < prompts.length; index++) {
          const { inferenceId } = await sd.createInferenceJob({
            leapApiKey: LEAP_API_KEY.value(),
            modelId: id,
            prompt: prompts[index].replace(
              "{model_type}",
              modelType ?? ""
            ),
            negativePrompt: "(deformed iris, deformed pupils, semi-realistic, cgi, 3d, render, sketch, cartoon, drawing, anime:1.4), text, close up, cropped, out of frame, worst quality, low quality, jpeg artifacts, ugly, duplicate, morbid, mutilated, extra fingers, mutated hands, poorly drawn hands, poorly drawn face, mutation, deformed, blurry, dehydrated, bad anatomy, bad proportions, extra limbs, cloned face, disfigured, gross proportions, malformed limbs, missing arms, missing legs, extra arms, extra legs, fused fingers, too many fingers, long neck",
            numberOfImages: 0,
            webhookUrl: `${IMAGE_WEBHOOK_URL}?user_id=${userId}&model_id=${id}&webhook_secret=${LEAP_WEBHOOK_SECRET.value()}`,
          });
          info({ inferenceId });
        }
      } else {
        await aiModelsRef
          .doc(userId)
          .collection("imageModels")
          .doc(id)
          .update({
            status: "errored",
          });
      }

      response.status(200).json(
        "Success",
      );
    } catch (e) {
      info(e);
      response.status(500).json(
        "Something went wrong!",
      );
    }
  });

export const createSingleMarketingPlan = onCall(
  { secrets: [ OPEN_AI_KEY ] },
  async (request) => {
    const openAiKey = OPEN_AI_KEY.value();
    const {
      userId,
      name,
      aesthetic,
      targetAudience,
      moreToCome,
      releaseTimeline,
    } = request.data;

    info({ userId, name, aesthetic, targetAudience, moreToCome, releaseTimeline });

    const userSnapshot = await usersRef.doc(userId).get();
    if (!userSnapshot.exists) {
      throw new HttpsError("failed-precondition", `user ${userId} does not exist`);
    }

    const artistName = userSnapshot.data()?.username;
    const artistGenres = userSnapshot.data()?.genres;

    // const labelApplicationsQuery = await labelApplicationsRef.where("id", "==", userId).get();
    // if (labelApplicationsQuery.empty) {
    //   throw new HttpsError("failed-precondition", `user ${userId} does not have a label application`);
    // }

    // const igFollowerCount = labelApplicationsQuery.docs[0].data().igFollowerCount;

    const { content, prompt } = await generateSingleBasicMarketingPlan({
      artistName,
      artistGenres,
      // igFollowerCount,
      singleName: name,
      aesthetic,
      targetAudience,
      moreToCome,
      releaseTimeline,
      apiKey: openAiKey,
    });

    const uuid = uuidv4();
    const marketingPlan: MarketingPlan = {
      id: uuid,
      userId: userId,
      name: name,
      type: "single",
      content: content,
      prompt: prompt,
      timestamp: Timestamp.now(),

    };
    await marketingPlansRef
      .doc(userId)
      .collection("userMarketingPlans")
      .doc(uuid)
      .set(marketingPlan);

    return {
      content,
      prompt,
    };
  });

export const marketingPlanStripeWebhook = onRequest(
  {
    secrets: [
      stripeTestKey,
      stripeTestEndpointSecret,
      RESEND_API_KEY,
      OPEN_AI_KEY,
    ]
  },
  async (req, res) => {
    const stripe = new Stripe(stripeTestKey.value(), {
      apiVersion: "2022-11-15",
    });

    info("marketingPlanStripeWebhook", req.body);
    const sig = req.headers["stripe-signature"];
    if (!sig) {
      res.status(400).send("No signature");
      return;
    }

    try {
      const event = stripe.webhooks.constructEvent(
        req.rawBody,
        sig,
        stripeTestEndpointSecret.value(),
      );

      // Handle the event
      switch (event.type) {
      case "checkout.session.completed":
        // eslint-disable-next-line no-case-declarations
        const checkoutSessionCompleted = event.data.object as unknown as {
            id: string;
            customer_email: string | null;
            customer_details: {
              email: string;
            }
          };

        // create firestore document for marketing plan set to 'processing' keyed at session_id
        info({ checkoutSessionCompleted });
        info({ sessionId: checkoutSessionCompleted.id });

        // get form data from firestore
        // eslint-disable-next-line no-case-declarations
        const checkoutSession = await stripe.checkout.sessions.retrieve(checkoutSessionCompleted.id);
        info({ checkoutSession });

        // eslint-disable-next-line no-case-declarations
        const customerEmail = checkoutSessionCompleted.customer_email ?? checkoutSessionCompleted.customer_details.email;
        await _emailMarketingPlan({
          checkoutSessionCompleteId: checkoutSessionCompleted.id,
          checkoutSession,
          customerEmail,
          resendApiKey: RESEND_API_KEY.value(),
        });
        break;
        // ... handle other event types
      default:
        console.log(`Unhandled event type ${event.type}`);
      }

      // Return a 200 response to acknowledge receipt of the event
      res.sendStatus(200);
    } catch (err: any) {
      error(err);
      res.status(400).send(`Webhook Error: ${err.message}`);
      return;
    }
  });

export const generateMarketingPlan = functions
  .runWith({
    secrets: [
      RESEND_API_KEY,
      OPEN_AI_KEY,
    ]
  })
  .firestore
  .document("marketingForms/{clientReferenceId}")
  .onCreate(
    async (request, context) => {
      const clientReferenceId = context.params.clientReferenceId;
      if (clientReferenceId === null) {
        throw new HttpsError("invalid-argument", "no client reference id");
      }
      info({ clientReferenceId });

      await guestMarketingPlansRef.doc(clientReferenceId).update({
        status: "processing",
      });

      const formDataRef = await marketingFormsRef.doc(clientReferenceId).get()


      const formData = formDataRef.data();
      if (!formData || !formDataRef.exists) {
        throw new HttpsError("failed-precondition", "no form data");
      }

      info({ formData })

      // TODO: get use follower count
      const { content, prompt } = await generateBasicMarketingPlan({
        releaseType: formData["marketingType"],
        artistName: formData["artistName"],
        // artistGenres: formData.genre,
        // igFollowerCount,
        singleName: formData["productName"],
        aesthetic: formData["aesthetic"],
        targetAudience: formData["audience"],
        moreToCome: formData["moreToCome"] ?? "nothing",
        releaseTimeline: formData["timeline"],
        apiKey: OPEN_AI_KEY.value(),
      });

      // save marketing plan to firestore and update status to 'complete'
      await guestMarketingPlansRef.doc(clientReferenceId).update({
        status: "completed",
        // checkoutSessionId: checkoutSessionCompleted.id,
        content,
        prompt,
      });
    });

export const checkoutSessionToClientReferenceId = onCall(
  { secrets: [ stripeTestKey ] },
  async (request) => {
    const stripe = new Stripe(stripeTestKey.value(), {
      apiVersion: "2022-11-15",
    });

    const { checkoutSessionId }: {
      checkoutSessionId: string;
    } = request.data;
    if (typeof checkoutSessionId !== "string" || checkoutSessionId.length === 0) {
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"checkoutSessionId\".");
    }

    const session = await stripe.checkout.sessions.retrieve(checkoutSessionId);
    info({ session });

    return {
      clientReferenceId: session.client_reference_id,
    };
  });

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

export const createLabelApplication = onRequest(
  { cors: true },
  async (req, res) => {
    const labelApplication = req.body;
    info({ labelApplication });
    await labelApplicationsRef.doc(labelApplication.id).set({
      timestamp: Timestamp.now(),
      ...labelApplication,
    })

    res.status(200).json("Success");
  });

export const generateEnhancedBio = onCall(
  { secrets: [ OPEN_AI_KEY ] },
  async (request) => {
    authenticatedRequest(request);
    // pull artist data
    const userId = request.auth?.uid;
    if (userId === undefined) {
      throw new HttpsError("unauthenticated", "user is not authenticated");
    }

    const userSnapshot = await usersRef.doc(userId).get();
    const userData = userSnapshot.data() as UserModel;

    const displayName = userData?.artistName ?? userData?.username ?? "";
    const twitterHandle = userData?.twitterHandle ?? "";
    const tiktokHandle = userData?.tiktokHandle ?? "";
    const instagramHandle = userData?.instagramHandle ?? "";
    const artistGenres = userData?.genres ?? [];

    const openAiKey = OPEN_AI_KEY.value();
    const { content } = await basicEnhancedBio({
      apiKey: openAiKey,
      artistName: displayName,
      twitterHandle,
      tiktokHandle,
      instagramHandle,
      artistGenres,
    });

    return {
      enhancedBio: content,
    };
  });

// TODO: on user created, add a few services for them by default
export const createDefaultServicesOnUserCreated = onDocumentCreated(
  { document: "users/{userId}" },
  async (event) => {
    const snapshot = event.data;
    const user = snapshot?.data() as UserModel | undefined;
    if (user === undefined) {
      throw new HttpsError("failed-precondition", "user does not exist");
    }

    _createDefaultServices(user);
  });

export const coverArtStripeTestWebhook = onRequest(
  {
    secrets: [
      stripeTestKey,
      stripeCoverArtTestWebhookSecret,
    ]
  },
  async (req, res) => {
    const stripe = new Stripe(stripeTestKey.value(), {
      apiVersion: "2022-11-15",
    });

    info("coverArtStripeTestWebhook", req.body);
    const sig = req.headers["stripe-signature"];
    if (!sig) {
      res.status(400).send("No signature");
      return;
    }

    try {
      const event = stripe.webhooks.constructEvent(
        req.rawBody,
        sig,
        stripeCoverArtTestWebhookSecret.value(),
      );

      // Handle the event
      switch (event.type) {
      case "checkout.session.completed":
        // eslint-disable-next-line no-case-declarations
        const checkoutSessionCompleted = event.data.object as unknown as {
            id: string;
            client_reference_id: string | null;
            customer_email: string | null;
            customer_details: {
              email: string;
            }
          };

        await _incrementCoverArtTestCredits(stripe, checkoutSessionCompleted);
        break;
        // ... handle other event types
      default:
        console.log(`Unhandled event type ${event.type}`);
      }

      // Return a 200 response to acknowledge receipt of the event
      res.sendStatus(200);
    } catch (err: any) {
      error(err);
      res.status(400).send(`Webhook Error: ${err.message}`);
      return;
    }
  });

export const coverArtStripeWebhook = onRequest(
  {
    secrets: [
      stripeKey,
      stripeCoverArtWebhookSecret,
    ]
  },
  async (req, res) => {
    const stripe = new Stripe(stripeKey.value(), {
      apiVersion: "2022-11-15",
    });

    info("coverArtStripeWebhook", req.body);
    const sig = req.headers["stripe-signature"];
    if (!sig) {
      res.status(400).send("No signature");
      return;
    }

    try {
      const event = stripe.webhooks.constructEvent(
        req.rawBody,
        sig,
        stripeCoverArtWebhookSecret.value(),
      );

      // Handle the event
      switch (event.type) {
      case "checkout.session.completed":
        // eslint-disable-next-line no-case-declarations
        const checkoutSessionCompleted = event.data.object as unknown as {
            id: string;
            client_reference_id: string | null;
            customer_email: string | null;
            customer_details: {
              email: string;
            }
          };
        await _incrementCoverArtCredits(stripe, checkoutSessionCompleted);
        break;
        // ... handle other event types
      default:
        console.log(`Unhandled event type ${event.type}`);
      }

      // Return a 200 response to acknowledge receipt of the event
      res.sendStatus(200);
    } catch (err: any) {
      error(err);
      res.status(400).send(`Webhook Error: ${err.message}`);
      return;
    }
  });

export const giveUserCoverArtCreditsOnCreate = functions
  .auth
  .user()
  .onCreate(async (user) => {
    await _giveUserCoverArtCredits(user.uid, 15);
  });

export const richmondEventsWebhook = onRequest(
  { cors: true },
  async (req, res) => {
    const { data } = req.body;
    info({ data });

    res.status(200).json("Success");
  });