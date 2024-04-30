/* eslint-disable import/no-unresolved */
import { error } from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

export const createBookingOnEventCrawled = onDocumentCreated(
  { document: "crawler/{link}" },
  async (event) => {
    const snapshot = event.data;
    if (snapshot === undefined) {
      error("snapshot is undefined");
      return;
    }

    const link = decodeURIComponent(snapshot.id);
    console.log(link);
  });
