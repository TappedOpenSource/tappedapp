/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { SLACK_WEBHOOK_URL } from "./firebase";
import { debug } from "firebase-functions/logger";
import { slackNotification } from "./notifications";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { UserModel } from "../types/models";

export const notifyFoundersOnSignUp = functions
  .runWith({ secrets: [ SLACK_WEBHOOK_URL ] })
  .auth
  .user()
  .onCreate(async (user) => {
    if (user.email?.endsWith("@tapped.ai")) {
      debug("Skipping notification for tapped.ai user");
      return;
    }

    slackNotification({
      title: "You have a new user \uD83D\uDE43",
      body: `${user.displayName}, ${user.email} just signed up`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
  });

export const notifyFoundersOnUserOnboarded = onDocumentCreated(
  { document: "users/{userId}", secrets: [ SLACK_WEBHOOK_URL ] },
  async (event) => {
    const snapshot = event.data;
    const user = snapshot?.data() as UserModel | undefined;
    const username = user?.username;
    const unclaimed = user?.unclaimed;

    if (unclaimed) {
      debug("skipping notification for unclaimed user");
      return;
    }
      
    slackNotification({
      title: "user onboarded \uD83D\uDE0E",
      body: `${user?.email} just onboarded -> https://app.tapped.ai/u/${username}`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
  });

export const notifyFoundersOnUserDelete = functions
  .runWith({ secrets: [ SLACK_WEBHOOK_URL ] })
  .auth
  .user()
  .onDelete(async (user) => {
    const email = user.email;
    if (email?.endsWith("@tapped.ai")) {
      debug("Skipping notification for tapped.ai user");
      return;
    }

    slackNotification({
      title: "user deleted their account \uD83D\uDE1E",
      body: `${user.displayName}, ${user.email} just left`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
  });

export const notifyFoundersOnAppRemoved = functions
  .runWith({ secrets: [ SLACK_WEBHOOK_URL ] })
  .analytics
  .event("app_remove")
  .onLog(async (event) => {
    const user = event.user;

    slackNotification({
      title: "user deleted their app \uD83D\uDE1E",
      body: `${user?.deviceInfo.mobileModelName} from ${user?.geoInfo.city}, ${user?.geoInfo.country}`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
  });
