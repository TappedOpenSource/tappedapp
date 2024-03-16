/* eslint-disable import/no-unresolved */
import { getStorage } from "firebase-admin/storage";
import { getMessaging } from "firebase-admin/messaging";
import { getRemoteConfig } from "firebase-admin/remote-config";
import { getFirestore } from "firebase-admin/firestore";
import { getApp, getApps, initializeApp } from "firebase-admin/app";
import { defineSecret } from "firebase-functions/params";
import { getAuth } from "firebase-admin/auth";
import  { SecretManagerServiceClient } from "@google-cloud/secret-manager";

const client = new SecretManagerServiceClient();
const app = getApps().length <= 0 ?
  initializeApp() :
  getApp();

export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
export const fcm = getMessaging(app);
export const remote = getRemoteConfig(app);

export const usersRef = db.collection("users");
export const loopsRef = db.collection("loops");
export const activitiesRef = db.collection("activities");
export const followingRef = db.collection("following");
export const followersRef = db.collection("followers");
// const likesRef = db.collection("likes");
export const commentsRef = db.collection("comments");
export const loopCommentsGroupRef = db.collectionGroup("loopComments");
export const feedsRef = db.collection("feeds");
// const badgesRef = db.collection("badges");
// const badgesSentRef = db.collection("badgesSent");
export const bookingsRef = db.collection("bookings");
export const tokensRef = db.collection("device_tokens")
export const servicesRef = db.collection("services");
export const mailRef = db.collection("mail");
export const queuedWritesRef = db.collection("queued_writes");
// const reviewsRef = db.collection("reviews");
export const teamsRef = db.collection("teams");
export const avatarsRef = db.collection("avatars");
export const aiModelsRef = db.collection("aiModels");
export const trainingImagesRef = db.collection("trainingImages");
export const labelApplicationsRef = db.collection("label_applications");
export const marketingPlansRef = db.collection("marketingPlans");

export const marketingFormsRef = db.collection("marketingForms");
export const guestMarketingPlansRef = db.collection("guestMarketingPlans");

export const creditsRef = db.collection("credits");
export const opportunitiesRef = db.collection("opportunities");
export const opportunityFeedsRef = db.collection("opportunityFeeds");

export const googlePlacesCacheRef = db.collection("googlePlacesCache");
export const contactVenuesRef = db.collection("contactVenues");
export const orphanEmailsRef = db.collection("orphanEmails");

// const loopLikesSubcollection = "loopLikes";
// const loopCommentsSubcollection = "loopComments";
export const loopsFeedSubcollection = "userFeed";

export const bookerReviewsSubcollection = "bookerReviews";
export const performerReviewsSubcollection = "performerReviews";

export const mainBucket = storage.bucket("in-the-loop-306520.appspot.com")

export const streamKey = defineSecret("STREAM_KEY");
export const streamSecret = defineSecret("STREAM_SECRET");

export const stripeTestKey = defineSecret("STRIPE_TEST_KEY");
export const stripePublishableTestKey = defineSecret("STRIPE_PUBLISHABLE_TEST_KEY");
export const stripeEndpointSecret = defineSecret("STRIPE_ENDPOINT_SECRET");
export const stripeTestEndpointSecret = defineSecret("STRIPE_TEST_ENDPOINT_SECRET");
export const stripeKey = defineSecret("STRIPE_KEY");
export const stripePublishableKey = defineSecret("STRIPE_PUBLISHABLE_KEY");

export const stripeCoverArtTestWebhookSecret = defineSecret("STRIPE_COVER_ART_TEST_WEBHOOK_SECRET");
export const stripeCoverArtWebhookSecret = defineSecret("STRIPE_COVER_ART_WEBHOOK_SECRET");

export const OPEN_AI_KEY = defineSecret("OPEN_AI_KEY");
export const LEAP_API_KEY = defineSecret("LEAP_API_KEY");
export const LEAP_WEBHOOK_SECRET = defineSecret("LEAP_WEBHOOK_SECRET");
export const RESEND_API_KEY = defineSecret("RESEND_API_KEY");
export const GOOGLE_PLACES_API_KEY = defineSecret("GOOGLE_PLACES_API_KEY");
export const SENDGRID_API_KEY = defineSecret("SENDGRID_API_KEY");
export const POSTMARK_SERVER_ID = defineSecret("POSTMARK_SERVER_ID");
export const SLACK_WEBHOOK_URL = defineSecret("SLACK_WEBHOOK_URL");

export const starterCreditsTestPriceId = "price_1OE2ptDYybu1wznEqHNMGZax";
export const basicCreditsTestPriceId = "price_1OE2rrDYybu1wznEqv4mmjoK";
export const proCreditsTestPriceId = "price_1OE2tPDYybu1wznEZV2ZkUKk"

export const creditsPerTestPriceId: {
  [key: string]: number;
} = {
  [starterCreditsTestPriceId]: 5,
  [basicCreditsTestPriceId]: 15,
  [proCreditsTestPriceId]: 40,
};

export const starterCreditsPriceId = "price_1OE4tFDYybu1wznE4IsHY85G";
export const basicCreditsPriceId = "price_1OE4tADYybu1wznESg0YCIcd";
export const proCreditsPriceId = "price_1OE4t6DYybu1wznEkNrIhcQ9";

export const creditsPerPriceId: {
  [key: string]: number;
} = {
  [starterCreditsPriceId]: 5,
  [basicCreditsPriceId]: 15,
  [proCreditsPriceId]: 40,
};

export const bookingBotUuid = "90dc0775-3a0d-4e92-8573-9c7aa6832d94";
export const verifiedBotUuid = "1c0d9380-873c-493a-a3f8-1283d5408673";
export const verifyUserBadgeId = "0aa46576-1fbe-4312-8b69-e2fef3269083";

export const projectId = app.options.projectId;


export const getSecretValue = async (secretName: string): Promise<string | null> => {
  const fullName = `projects/${projectId}/secrets/${secretName}/versions/latest`;
  const [ version ] = await client.accessSecretVersion({ name: fullName })
  const secretValue = version.payload?.data?.toString();

  return secretValue ?? null;
}
