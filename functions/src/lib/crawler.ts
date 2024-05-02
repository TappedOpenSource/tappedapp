/* eslint-disable import/no-unresolved */
import { v4 as uuidv4 } from "uuid";
import { Timestamp } from "firebase-admin/firestore";
import { error } from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { auth, bookingsRef, bucket, crawlerRef, usersRef } from "./firebase";
import { Option, Booking, EventData } from "../types/models";
// import fetch from "node-fetch";
import { sanitizeUsername } from "./utils";
import { getDownloadURL } from "firebase-admin/storage";

export async function getOrCreatePerformer({
  // location,
  performerName,
  bio,
  genres,
}: {
    performerName: string;
    bio?: string;
    genres: string[];
    // location: Option<Location>;
  }): Promise<string | null> {
  console.log(`[+] checking if performer exists: ${performerName}`);
  const sanitizedPerformerName = sanitizeUsername(performerName);
  const artistSnap = await usersRef
    .where("username", "==", sanitizedPerformerName)
    .limit(1)
    .get();
  if (!artistSnap.empty) {
    console.log(`[+] performer already exists: ${performerName}`);
    return artistSnap.docs[0].id;
  }
  
  try {
    const artistEmail = `${sanitizedPerformerName}-${
      Math.floor(Math.random() * 100) // random number between 1 and 100
    }@tapped.ai`;
    const userRecord = await auth.createUser({
      email: artistEmail,
      password: uuidv4(),
    });
    const uid = userRecord.uid;
    const performerObject: {
        id: string;
        email: string;
        timestamp: Timestamp;
        username: string;
        artistName: string;
        bio: string;
        occupations: string[];
        profilePicture: string | null;
        unclaimed: true;
        location: Option<Location>;
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
        email: artistEmail,
        timestamp: Timestamp.now(),
        username: sanitizedPerformerName,
        artistName: performerName,
        bio: bio ?? "",
        occupations: [],
        profilePicture: null,
        performerInfo: {
          label: "Independent",
          genres: genres,
          rating: 5.0,
          reviewCount: 1,
        },
        unclaimed: true,
        deleted: false,
      };
  
    // console.log({ artistObject });
    await usersRef.doc(uid).set(performerObject);
    console.log(`[+] created performer: ${performerObject.artistName}`);
    return uid;
  } catch (e) {
    console.error(`[!!!] failed to create performer: ${performerName} - ${e}`);
    return null;
  }
}


export async function convertToSignedUrl({
  url,
}: {
    url: string;
  }): Promise<string | null> {
  try {

    const filename = url.split("/").pop() ?? "flier.jpg";
    const extension = filename.split(".").pop();
    const imageRes = await fetch(url);
  
    const buf = await imageRes.arrayBuffer();
    const theBuf = Buffer.from(buf);

    const fileRef = bucket.file(`bookings/${filename}`);
    await fileRef.save(theBuf, {
      contentType: `image/${extension}`,
    });

  
    const downloadUrl = await getDownloadURL(fileRef);

    return downloadUrl;
  } catch (e) {
    console.error(`[!!!] failed to convert to signed url: ${url} - ${e}`);
    return null;
  }
}
  
export async function createBookingsFromEvent(
  encodedLink: string,
  data: EventData,
): Promise<void> {
  if (data.isMusicEvent === false) {
    console.log(`[+] skipping non-music event: ${data.title}`);
    return;
  }

  const venue = data.venue;
  const venueLocation = venue.location;
  const genres = venue.venueInfo?.genres ?? [];
  for (const performerName of data.performers) {
    const id = uuidv4();
    const requesterId = venue.id;
    const requesteeId = await getOrCreatePerformer({
      performerName,
      bio: "",
      genres,
    });
  
    if (requesteeId === null) {
      return;
    }
  
    const signedFlierUrl =
        data.flierUrl !== null
          ? await convertToSignedUrl({ url: data.flierUrl })
          : null;
  
    const booking: Booking = {
      addedByUser: false,
      location: venueLocation,
      crawlerInfo: {
        ...data.crawlerInfo,
        encodedLink,
      },
      id,
      name: data.title ?? "",
      note: data.description ?? "",
      serviceId: null,
      requesterId,
      requesteeId,
      status: "confirmed",
      rate: 0,
      startTime: data.startTime,
      endTime: data.endTime,
      timestamp: Timestamp.now(),
      flierUrl: signedFlierUrl,
      eventUrl: data.url,
      genres,
    };
  
    // check if booking like this exists already
    // const candidateBooking = await getBookingBySimilarity(booking);
    // if (candidateBooking !== null) {
    //   console.log(`[!!!] booking like this exists already: ${candidateBooking.id}`);
    //   return;
    // }
  
    await bookingsRef.doc(booking.id).set(booking);
    console.log(`[+] created booking: ${booking.name}`);
  
    // const bookingStartTime = booking.startTime.toDate();
    // if (bookingStartTime.getTime() < Date.now()) {
    //   console.log(`[+] creating reviews for booking: ${booking.name}`);
    //   await createReviewsForBooking({
    //     bookingId: booking.id,
    //     bookerId: booking.requesterId,
    //     performerId: booking.requesteeId,
    //   });
    // }

    await crawlerRef.doc(encodedLink).set({
      bookingId: booking.id,
    }, { merge: true })
  }
}
  
export const createBookingsFromCrawledData = async (): Promise<void> => {
  // get all crawled links
  const linkSnaps = await crawlerRef.get();

  for (const doc of linkSnaps.docs) {
    const link = doc.id;
    const eventData = doc.data() as EventData;
    const venue = eventData.venue;
  
    // check if link is a music event
    if (!eventData.isMusicEvent) {
      console.log(`[+] skipping non-music event: ${eventData.title}`);
      continue;
    }
  
    await createBookingsFromEvent(link, {
      ...eventData,
      venue,
    });
  }
}

export const createBookingOnEventCrawled = onDocumentCreated(
  { document: "crawler/{link}" },
  async (event) => {
    const snapshot = event.data;
    if (snapshot === undefined) {
      error("snapshot is undefined");
      return;
    }

    const encodedLink = snapshot.id;
    const link = decodeURIComponent(encodedLink);
    console.log(link);

    const eventData = snapshot.data() as EventData;

    if (!eventData.isMusicEvent) {
      console.log(`[+] skipping non-music event: ${eventData.title}`);
      return;
    }

    await createBookingsFromEvent(encodedLink, eventData);
  });
