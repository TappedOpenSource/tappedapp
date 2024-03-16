/* eslint-disable import/no-unresolved */
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFoundersDeviceTokens } from "./utils";
import { SLACK_WEBHOOK_URL, fcm } from "./firebase";
import { slackNotification } from "./notifications";

export const notifyFoundersOnUserFeedbackSubmitted = onDocumentCreated(
  { document: "userFeedback/{feedbackId}", secrets: [ SLACK_WEBHOOK_URL ] },
  async (event) => {
    const snapshot = event.data;
    const feedback = snapshot?.data();
    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: "New User Feedback \uD83D\uDE43",
        body: feedback?.text ?? "[no text provided]",
      },
    };
    slackNotification({
      title: "New User Feedback \uD83D\uDE43",
      body: feedback?.text ?? "[no text provided]",
      slackWebhookUrl: SLACK_WEBHOOK_URL.value(),
    });
    fcm.sendToDevice(devices, payload);
  }
);
