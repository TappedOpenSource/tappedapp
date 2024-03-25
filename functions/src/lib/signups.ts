/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { SLACK_WEBHOOK_URL } from "./firebase";
import { debug } from "firebase-functions/logger";
import { slackNotification } from "./notifications";

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
export const notifyFoundersOnAppRemoved = functions
  .runWith({ secrets: [ SLACK_WEBHOOK_URL ] })
  .analytics
  .event("app_remove")
  .onLog(async (event) => {
    const user = event.user;

    slackNotification({
      title: "You lost a user \uD83D\uDE1E",
      body: `${user?.deviceInfo.mobileModelName} from ${user?.geoInfo.city}, ${user?.geoInfo.country}`,
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
  });
