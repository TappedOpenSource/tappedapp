/* eslint-disable import/no-unresolved */
import type { 
  BookingReminderActivity, 
  BookingRequestActivity, 
  BookingUpdateActivity, 
  FollowActivity, 
  OpportunityInterest, 
  SearchAppearanceActivity,
} from "../types/models";
import { HttpsError } from "firebase-functions/v2/https";
import * as functions from "firebase-functions";
import { activitiesRef, fcm, tokensRef, usersRef } from "./firebase";
import { Timestamp } from "firebase-admin/firestore";
import { authenticated } from "./utils";
import { messaging } from "firebase-admin";
import { debug } from "firebase-functions/logger";

export const sendToDevice = functions.firestore
  .document("activities/{activityId}")
  .onCreate(async (snapshot) => {
    const activity = snapshot.data();

    const userDoc = await usersRef.doc(activity["toUserId"]).get();
    const user = userDoc.data();
    if (user === null || user === undefined) {
      throw new Error("User not found");
    }

    if (user.email?.endsWith("@tapped.ai")) {
      debug("Skipping notification for tapped.ai user");
      return;
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

export const addActivity = functions.https.onCall((data, context) => {
  authenticated(context);
  return createActivity(data);
});

export const createActivity = async (
  activity: FollowActivity
    | BookingRequestActivity
    | BookingUpdateActivity
    | OpportunityInterest
    | BookingReminderActivity
    | SearchAppearanceActivity
): Promise<{ id: string }> => {
  // Checking attribute.A
  if (activity.toUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new HttpsError(
      "invalid-argument",
      "The function argument 'toUserId' cannot be empty"
    );
  }

  const allowedActivityTypes = [
    "bookingRequest",
    "bookingUpdate",
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

