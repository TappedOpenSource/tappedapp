/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { usersRef } from "./firebase";
import { createActivity } from "./activities";

export const transformLoopPayloadForSearch = functions.https
  .onCall((data) => {

    const { lat, lng, ...rest } = data;

    const payload: Record<string, any> = rest;

    if (lat !== undefined && lat !== null && lng !== undefined && lng !== null) {
      payload._geoloc = { lat, lng }
    }

    return payload;
  })

export const sendSearchAppearances = onSchedule("0 0/3 * * *", async (event) => {
  const min = 20;
  const max = 50;
  const randomNumber = Math.floor(Math.random() * (max - min)) + min;

  const usersSnapshot = await usersRef.get();
  const randomUserId = usersSnapshot.docs[Math.floor(Math.random() * usersSnapshot.docs.length)].id;

  await createActivity({
    toUserId: randomUserId,
    type: "searchAppearance",
    count: randomNumber,
  });
});