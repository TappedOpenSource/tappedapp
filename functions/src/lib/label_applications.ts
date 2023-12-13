/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { getFoundersDeviceTokens } from "./utils";
import { fcm, labelApplicationsRef } from "./firebase";
import { onRequest } from "firebase-functions/v2/https";
import { info } from "firebase-functions/logger";
import { Timestamp } from "firebase-admin/firestore";

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

