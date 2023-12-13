/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { FieldValue } from "firebase-admin/firestore";
import { usersRef } from "./firebase";

export const incrementBadgeCountOnBadgeSent = functions.firestore
  .document("badgesSent/{userId}/badges/{badgeId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.userId)
      .update({ badgesCount: FieldValue.increment(1) });
  });