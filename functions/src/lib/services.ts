/* eslint-disable import/no-unresolved */
import { v4 as uuidv4 } from "uuid";
import * as functions from "firebase-functions";
import { Booking, UserModel } from "../types/models";
import { servicesRef } from "./firebase";
import { HttpsError } from "firebase-functions/v2/https";
import { FieldValue } from "firebase-admin/firestore";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

const _createDefaultServices = async (user: UserModel) => {
  const userId = user.id;
  const services = [
    {
      id: uuidv4(),
      userId: userId,
      title: "30 min set",
      description: "30 min set",
      rate: 0,
      rateType: "hourly",
      count: 0,
      deleted: false,
    },
    {
      id: uuidv4(),
      userId: userId,
      title: "45 min set",
      description: "45 min set",
      rate: 0,
      rateType: "hourly",
      count: 0,
      deleted: false,
    },
    {
      id: uuidv4(),
      userId: userId,
      title: "60 min set",
      description: "60 min set",
      rate: 0,
      rateType: "hourly",
      count: 0,
      deleted: false,
    },
  ]

  await Promise.all(
    services.map((service) => {
      return servicesRef
        .doc(user.id)
        .collection("userServices")
        .doc(service.id)
        .set(service);
    }),
  );
}

export const incrementServiceCountOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (snapshot, context) => {
    const booking = snapshot.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not exist`,);
    }

    if (booking.serviceId === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not have a serviceId`,);
    }

    await servicesRef
      .doc(booking.serviceId)
      .update({ bookingCount: FieldValue.increment(1) });
  });

// TODO: on user created, add a few services for them by default
export const createDefaultServicesOnUserCreated = onDocumentCreated(
  { document: "users/{userId}" },
  async (event) => {
    const snapshot = event.data;
    const user = snapshot?.data() as UserModel | undefined;
    if (user === undefined) {
      throw new HttpsError("failed-precondition", "user does not exist");
    }

    _createDefaultServices(user);
  });

