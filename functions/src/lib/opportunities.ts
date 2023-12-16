/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { 
  onDocumentCreated, 
  onDocumentUpdated, 
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import { createActivity } from "./activities";
import { creditsRef, opportunitiesRef, opportunityFeedsRef, usersRef } from "./firebase";
import { Opportunity, OpportunityFeedItem, UserModel } from "../types/models";
import { Timestamp } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import { debug } from "firebase-functions/logger";
import { onSchedule } from "firebase-functions/v2/scheduler";

const _addOpportunityToUserFeed = async (
  userId: string,
  opData: Opportunity,
) => {
  await opportunityFeedsRef
    .doc(userId)
    .collection("opportunities")
    .doc(opData.id)
    .set({
      ...opData,
    });

  return;
};

const _addInterestedUserToOpportunity = async (
  userId: string,
  opFeedItem: OpportunityFeedItem,
) => {
  await opportunitiesRef
    .doc(opFeedItem.id)
    .collection("interestedUsers")
    .doc(userId)
    .set({
      userComment: opFeedItem.userComment,
      timestamp: Timestamp.now(),
    });

  return;
};

export const addActivityOnOpportunityInterest = functions
  .firestore
  .document("opportunities/{opportunityId}/interestedUsers/{userId}")
  .onCreate(async (data, context) => {
    const opSnap = await opportunitiesRef.doc(context.params.opportunityId).get();
    const op = opSnap.data() as Opportunity;

    createActivity({
      toUserId: op.userId,
      fromUserId: context.params.userId,
      type: "opportunityInterest",
      opportunityId: context.params.opportunityId,
    });
  });

export const copyOpportunityToFeedsOnCreate = onDocumentWritten(
  { document: "opportunities/{opportunityId}" },
  async (event) => {
    const snapshot = event.data;
    const afterDoc = snapshot?.after;
    const opportunity = afterDoc?.data() as Opportunity | undefined;

    if (opportunity === undefined) {
      throw new HttpsError("failed-precondition", "opportunity does not exist");
    }

    const usersSnap = await usersRef.get();

    await Promise.all(
      usersSnap.docs.map(async (userDoc) => {

        if (userDoc.id === opportunity.userId) {
          return;
        }

        await _addOpportunityToUserFeed(userDoc.id, opportunity);
      }),
    );
  });

export const addInterestedUserOnApplyToOpportunity = onDocumentUpdated(
  { document: "opportunityFeeds/{userId}/opportunities/{opportunityId}" },
  async (event) => {
    const snapshot = event.data;
    const userId = event.params.userId;
    const beforeOpSnap = snapshot?.before;
    const afterOpSnap = snapshot?.after;

    const beforeOp = beforeOpSnap?.data() as Opportunity | undefined;
    const afterOp = afterOpSnap?.data() as Opportunity | undefined;

    if (beforeOp === undefined || afterOp === undefined) {
      throw new HttpsError("failed-precondition", "before or after does not exist");
    }

    if (beforeOp.touched !== undefined && beforeOp.touched !== null) {
      debug("beforeOp.touched is already set", { beforeOp });
      return;
    }

    if (afterOp.touched !== "like") {
      debug("afterOp.touched !== like", { afterOp });
      return;
    }

    await _addInterestedUserToOpportunity(userId, afterOp);
  });

export const copyOpportunitiesToFeedOnCreateUser = onDocumentCreated(
  { document: "users/{userId}" },
  async (event) => {
    const snapshot = event.data;
    const user = snapshot?.data() as UserModel | undefined;

    if (user === undefined) {
      throw new HttpsError("failed-precondition", "user does not exist");
    }

    const opportunitiesSnap = await opportunitiesRef
      .where("startTime", ">", Timestamp.now())
      .limit(500)
      .get();

    await Promise.all(
      opportunitiesSnap.docs.map(async (opDoc) => {
        const op = opDoc.data() as Opportunity;
        await _addOpportunityToUserFeed(user.id, op);
      }),
    );
  });

export const setDailyOpportunityQuota = onSchedule("0 0 * * *", async () => {
  const usersSnap = await usersRef.get();

  await Promise.all(
    usersSnap.docs.map(async (userDoc) => {
      creditsRef.doc(userDoc.id).update({
        opportunityQuota: 5,
      });
    }),
  );
});