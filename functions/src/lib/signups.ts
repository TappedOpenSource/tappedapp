/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { getFoundersDeviceTokens } from "./utils";
import { fcm } from "./firebase";

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