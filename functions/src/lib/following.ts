/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { followersRef, followingRef, usersRef } from "./firebase";
import { FieldValue } from "firebase-admin/firestore";
import { createActivity } from "./activities";

export const autoFollowUsersOnUserCreated = functions
  .firestore
  .document("users/{userId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const userIdsToAutoFollow = [
      "8yYVxpQ7cURSzNfBsaBGF7A7kkv2", // Johannes
      "n4zIL6bOuPTqRC3dtsl6gyEBPQl1", // Ilias
      // "ToPGEF6jP1e7R6XJDsOHYSyBpf22", // Amberay
      // "aDsHZs9v2BcUWJZYIRAPbX6KSMs2", // Phil
      // "7wEC1jNzsShn3wd8BWXC0w89aIF3" // Xypper
      // "kNVsCCnDkFdYAxebMspLpnEudwq1", // Jayduhhhh
      // "xfxTCUerCyZCUB85likg7THcUGD2", // Yung Smilez
      // "EczWgsPTL1ROJ6EU93Q5vs0Osfx2", // Akimi
      // "yTIvDDidqjORseS764JZH01Nkds1", // Ryan
    ];

    functions.logger.debug(`auto following users for ${userId}`)

    for (const userIdToAutoFollow of userIdsToAutoFollow) {
      await followingRef
        .doc(userId)
        .collection("Following")
        .doc(userIdToAutoFollow)
        .set({});
    }
  })

export const addFollowersEntryOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onCreate(async (snapshot, context) => {
    await followersRef
      .doc(context.params.followeeId)
      .collection("Followers")
      .doc(context.params.followerId)
      .set({});
  });
export const removeFollowersEntryOnUnfollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    await followersRef
      .doc(context.params.followeeId)
      .collection("Followers")
      .doc(context.params.followerId)
      .delete();
  });
export const decrementFollowersCountOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followeeId)
      .update({
        followerCount: FieldValue.increment(-1),
      });
  });
export const decrementFollowingCountOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onDelete(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followerId)
      .update({
        followingCount: FieldValue.increment(-1),
      });
  });
export const incrementFollowersCountOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followeeId)
      .update({
        followerCount: FieldValue.increment(1),
      });
  });
export const incrementFollowingCountOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followerId)
      .update({
        followingCount: FieldValue.increment(1),
      });
  });

export const addActivityOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onCreate(async (snapshot, context) => {
    await createActivity({
      toUserId: context.params.followeeId,
      fromUserId: context.params.followerId,
      type: "follow",
    });
  })

export const deteteFollowersEntryOnUnfollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    const doc = await followersRef
      .doc(context.params.followeeId)
      .collection("Followers")
      .doc(context.params.followerId)
      .get();

    if (!doc.exists) {
      return;
    }

    doc.ref.delete()
  });

export const unfollowUserOnBlock = functions
  .firestore
  .document("blocked/{userId}/blockedUsers/{blockedUserId}")
  .onCreate(async (data, context) => {
    const blockedUserId = context.params.blockedUserId;
    const userId = context.params.userId;

    const doc = await followingRef
      .doc(userId)
      .collection("Following")
      .doc(blockedUserId)
      .get();

    await doc.ref.delete();
  });

