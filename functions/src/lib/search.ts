/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { usersRef } from "./firebase";
import { createActivity } from "./activities";
import { Booking, UserModel } from "../types/models";

export const transformLocationPayloadForSearch = functions.https
  .onCall((data) => {

    const { location, ...rest } = data;
    if (!location) {
      return rest;
    }

    const { lat, lng } = location;

    const payload: Record<string, any> = {
      location,
      ...rest,
    };

    if (lat !== undefined && lat !== null && lng !== undefined && lng !== null) {
      payload._geoloc = { lat, lng }
    }

    return payload;
  })

export const transformBookingPayloadForSearch = functions.https
  .onCall(async (data) => {

    const { lat, lng, ...rest } = data as Booking;

    const { requesterArtistName, requesterUsername } = await (async () => {
      try {
        const user = await usersRef.doc(rest.requesterId).get();
        const userData = user.data() as UserModel;

        return {
          requesterArtistName: userData?.artistName ?? "",
          requesterUsername: userData?.username ?? "",
        };
      } catch (error) {
        console.log("can't get requester info", error);
        throw error;
      }
    })();

    const { requesteeArtistName, requesteeUsername } = await (async () => {
      try {

        const user = await usersRef.doc(rest.requesteeId).get();
        const userData = user.data() as UserModel;

        return {
          requesteeArtistName: userData.artistName ?? "",
          requesteeUsername: userData.username ?? "",
        };
      } catch (error) {
        console.log("can't get requestee info", error);
        throw error;
      }
    })();

    const payload: Record<string, any> = rest;

    if (lat !== undefined && lat !== null && lng !== undefined && lng !== null) {
      payload._geoloc = { lat, lng }
    }

    return {
      ...payload,
      requesterArtistName,
      requesterUsername,
      requesteeArtistName,
      requesteeUsername,
    };
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