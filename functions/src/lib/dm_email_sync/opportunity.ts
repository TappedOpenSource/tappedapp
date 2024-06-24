/* eslint-disable import/no-unresolved */
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { OPEN_AI_KEY, POSTMARK_SERVER_ID, bookingsRef, contactVenuesRef, opportunitiesRef, usersRef } from "../firebase";
import { Booking, Opportunity, UserModel, VenueContactRequest } from "../../types/models";
import { debug, info } from "firebase-functions/logger";
import { Timestamp } from "firebase-admin/firestore";
import { _appendNewContactRequestToThread } from "./venue_contacting";
import * as postmark from "postmark";

export const notifyVenueOfInterestedOpportunities = onCall(
  { secrets: [ POSTMARK_SERVER_ID, OPEN_AI_KEY ] },
  async (request) => {
    // update update
    const { opportunityIds, userId, note } = request.data;
    process.env.OPENAI_API_KEY = OPEN_AI_KEY.value();

    const opportunities = (await Promise.all(
      opportunityIds.map(async (opId: string) => {
        const opSnap = await opportunitiesRef.doc(opId).get();
        if (!opSnap.exists) {
          return null;
        }

        return opSnap.data() as Opportunity;
      }),
    )).filter((op) => op !== null) as Opportunity[];

    if (opportunities.length <= 0) {
      throw new HttpsError("failed-precondition", "no opportunities found");
    }

    const fullOps = (await Promise.all(
      opportunities.map(
        async (op) => {
          if (op.userId === userId) {
            debug(`opportunity ${op.id} is owned by user ${userId}, skipping`);
            return null;
          }

          // check if referenceEventId exists
          if (op.referenceEventId === undefined || op.referenceEventId === null) {
            debug(`no reference id for ${op.id}, skipping`);
            return;
          }

          // get all bookings for that referenceEventId
          const bookingsSnap = await bookingsRef
            .where(
              "referenceEventId",
              "==",
              op.referenceEventId,
            )
            .get();

          const bookings = bookingsSnap.docs.map((doc) => doc.data() as Booking);
          return {
            ...op,
            referenceBookings: bookings,
          };
        }),
    )).filter((op) => op !== null) as (Opportunity & { referenceBookings: Booking[] })[];

    const opsByVenue: Record<string, (Opportunity & { referenceBookings: Booking[] })[]> = {};
    for (const op of fullOps) {
      const refernceBookings = op.referenceBookings;
      if (refernceBookings.length <= 0) {
        debug(`no bookings for event if ${op.id}, skipping`)
        continue;
      }

      // get the venue (requesterId) from one of the bookings
      const venueId = refernceBookings[0].requesterId;
      if (venueId === undefined || venueId === null) {
        debug(`no venue id for ${op.id}, skipping`);
        continue;
      }

      if (opsByVenue[venueId] === undefined) {
        opsByVenue[venueId] = [];
      }

      opsByVenue[venueId].push(op);
    } 

    for (const entries of Object.entries(opsByVenue)) {
      const [ venueId, ops ] = entries;

      const venueSnap = await usersRef.doc(venueId).get();
      const venue = venueSnap.data() as UserModel;

      // check if venue is unclaimed (and if not, return)
      if (!venue.unclaimed) {
        debug(`venue ${venue.id} is claimed, skipping`);
        return;
      }

      // check if there is already a contactVenue email thread open
      const contactVenueSnap = await contactVenuesRef
        .doc(userId)
        .collection("venuesContacted")
        .doc(venue.id)
        .get();

      const bookingEmail = venue.venueInfo?.bookingEmail;
      if (bookingEmail === undefined || bookingEmail === null) {
        debug(`no booking email for ${venue.id}, skipping`);
        return;
      }

      const venueContactedAlready = contactVenueSnap.exists;
      debug(`venue ${venue.id} contacted already? ${venueContactedAlready}`);

      // if there isn't, create a new contactVenue email thread
      // what to add to the object to change the prompt? 
      if (!venueContactedAlready) {
        const userSnap = await usersRef.doc(userId).get();
        const user = userSnap.data() as UserModel;

        const contactRequset: VenueContactRequest = {
          venue,
          user,
          bookingEmail: bookingEmail,
          attachments: [],
          note,
          timestamp: Timestamp.now(),
          originalMessageId: null,
          latestMessageId: null,
          subject: null,
          allEmails: [ bookingEmail ],
          collaborators: [],
          opportunityIds: ops.map((op) => op.id),
        }

        await contactVenuesRef
          .doc(userId)
          .collection("venuesContacted")
          .doc(venue.id)
          .set(contactRequset, { merge: true });

        info(`venue ${venue.id} context request sent by user ${userId}`);

        return;
      }

      // if there is, add to the thread with context on the performance opportunity
      const emailClient = new postmark.ServerClient(POSTMARK_SERVER_ID.value());
      await _appendNewContactRequestToThread({
        userId: userId,
        venueId: venue.id,
        opportunityIds: ops.map((op) => op.id),
        note,
        collaboratorIds: [],
        bookingEmail,
        emailClient,
      });
    }
  }
);

