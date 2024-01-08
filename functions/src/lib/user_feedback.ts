/* eslint-disable import/no-unresolved */
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFoundersDeviceTokens } from "./utils";
import { fcm } from "./firebase";

export const notifyFoundersOnUserFeedbackSubmitted = onDocumentCreated(
  { document: "userFeedback/{feedbackId}" },
  async (event) => {
    const snapshot = event.data;
    const feedback = snapshot?.data();
    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: "New User Feedback \uD83D\uDE43",
        body: feedback?.text ?? "[no text provided]",
      }
    };

    fcm.sendToDevice(devices, payload);
  });