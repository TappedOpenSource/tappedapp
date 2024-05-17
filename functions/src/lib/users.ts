/* eslint-disable import/no-unresolved */
import { Timestamp } from "firebase-admin/firestore";
import type { 
  Booking, 
  UserModel,
} from "../types/models";
import { 
  auth,
  bookingsRef, 
  opportunitiesRef, 
  reviewsRef, 
  usersRef,
} from "./firebase";
import { v4 as uuidv4 } from "uuid";
import { sanitizeUsername } from "./utils";

export async function transferUser({
  origUserId,
  otherUserId,
}: {
    origUserId: string;
    otherUserId: string;
  }): Promise<void> {

  // move bookings over as requester
  const bookingsRequesterSnap = await bookingsRef
    .where("requesterId", "==", otherUserId)
    .get();
  await Promise.all(
    bookingsRequesterSnap.docs.map(async (snap) => {
      const booking = snap.data() as Omit<Booking, "id">;
      await snap.ref.update({
        requesterId: origUserId,
      });
      console.log(`[+] moved requester booking: ${booking.name}`);
    }),
  );

  // move bookings over as requestee
  const bookingsRequesteeSnap = await bookingsRef
    .where("requesteeId", "==", otherUserId)
    .get();
  await Promise.all(
    bookingsRequesteeSnap.docs.map(async (snap) => {
      const booking = snap.data() as Omit<Booking, "id">;
      await snap.ref.update({
        requesteeId: origUserId,
      });
      console.log(`[+] moved requestee booking: ${booking.name}`);
    }),
  );

  // move performer reviews over
  const performerReviewsSnap = await reviewsRef
    .doc(otherUserId)
    .collection("performerReviews")
    .get();
  await Promise.all(
    performerReviewsSnap.docs.map(async (snap) => {
      const review = snap.data();
      await reviewsRef
        .doc(origUserId)
        .collection("performerReviews")
        .doc(review.id)
        .set({
          performerId: origUserId,
          ...review,
        });
      console.log(`[+] moved performer review: ${review.id}`);
    }),
  );

  // move booker reviews over
  const bookerReviewsSnap = await reviewsRef
    .doc(otherUserId)
    .collection("bookerReviews")
    .get();
  await Promise.all(
    bookerReviewsSnap.docs.map(async (snap) => {
      const review = snap.data();
      await reviewsRef
        .doc(origUserId)
        .collection("bookerReviews")
        .doc(review.id)
        .set({
          bookerId: origUserId,
          ...review,
        });
      console.log(`[+] moved booker review: ${review.id}`);
    }),
  );

  // move opportunities over
  const opportunitiesSnap = await opportunitiesRef
    .where("userId", "==", otherUserId)
    .get();
  await Promise.all(
    opportunitiesSnap.docs.map(async (snap) => {
      const opportunity = snap.data();
      await snap.ref.update({
        userId: origUserId,
      });
      console.log(`[+] moved opportunity: ${opportunity.id}`);
    }),
  );

  // add review Count and booking count
  const origUserSnap = await usersRef.doc(origUserId).get();
  const origUserData = origUserSnap.data() as Omit<UserModel, "id">;

  const otherUserSnap = await usersRef.doc(otherUserId).get();
  const otherUserData = otherUserSnap.data() as Omit<UserModel, "id">;
  await usersRef.doc(origUserId).set(
    {
      performerInfo: {
        reviewCount:
        (origUserData.performerInfo?.reviewCount ?? 0) +
        (otherUserData.performerInfo?.reviewCount ?? 0),
      },
      bookerInfo: {
        bookingCount:
        (origUserData.bookerInfo?.reviewCount ?? 0) +
        (otherUserData.bookerInfo?.reviewCount ?? 0),
      },
    },
    { merge: true },
  );

  // move user data over
  await usersRef.doc(origUserId).set(
    {
      profilePicture: otherUserData.profilePicture ?? null,
      bio: otherUserData.bio ?? null,
      artistName: otherUserData.artistName ?? null,
      username: otherUserData.username ?? null,
      socialFollowing: otherUserData.socialFollowing ?? null,
      venueInfo: otherUserData.venueInfo ?? null,
      performerInfo: otherUserData.performerInfo ?? null,
      bookerInfo: otherUserData.bookerInfo ?? null,
    },
    { merge: true },
  );
}

export async function createUnclaimedUser(artistName: string): Promise<string> {

  const username = sanitizeUsername(artistName);

  const uid = uuidv4();
  const email = `${uid}@tapped.ai`;
  const password = uuidv4();

  // create new auth user
  await auth.createUser({
    uid,
    email,
    password,
  });


  const userObj: {
    id: string;
    email: string;
    timestamp: Timestamp;
    username: string;
    artistName: string;
    bio: string;
    profilePicture: string | null;
    unclaimed: true;
    location: Location | null;
    performerInfo: {
      genres: string[];
      label: "Independent";
      rating: number;
      reviewCount: number;
    };
    deleted: false;
  } = {
    location: null,
    id: uid,
    email,
    timestamp: Timestamp.now(),
    username,
    artistName,
    bio: "",
    profilePicture: null,
    performerInfo: {
      label: "Independent",
      genres: [],
      rating: 5.0,
      reviewCount: 0,
    },
    unclaimed: true,
    deleted: false,
  }

  // create user in firestore
  await usersRef.doc(uid).set(userObj);

  return uid;
}