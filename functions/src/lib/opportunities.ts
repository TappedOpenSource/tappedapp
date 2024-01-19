/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import {
  onDocumentCreated,
  onDocumentUpdated,
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import { createActivity } from "./activities";
import { creditsRef, fcm, getSecretValue, opportunitiesRef, opportunityFeedsRef, tokensRef, usersRef } from "./firebase";
import { Opportunity, OpportunityFeedItem, UserModel } from "../types/models";
import { Timestamp } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import { debug, error, info } from "firebase-functions/logger";
import { onSchedule } from "firebase-functions/v2/scheduler";
// import { v4 as uuidv4 } from "uuid";
// import { llm } from "./openai";

export const virginiaVenueIds = [
  "DGeZx8VvolPscUOJzFX8cfgE3Rr2", // Jungle Room
  "z9INma3qmmPOTw3ncnzHTWSEvPF2", // The Canal Club
  "tloWCuKGHYScMCp3YamsHKVi3XU2", // Brown's Island
  "jyz81JbwQycJoBzTTs4N724Gffc2", // The National
  "I1ZA0M2h1ITitcqOQHaj891dKWq2", // Banditos
  "Gh9aJvgx6hWe9oQU111d66RYV6D3", // The Hof
  "FrtrbxFXtFZWe6UhHGJ6BxNkzvn1", // Gallery 5
  "ETpFbKBUazdkda9cCxRZ0pMosjm1", // Switch RVA
  "D495K9XmCxfdfhMZOqghPvGKpQB3", // The Broadberry
  "9FKyhrndDreJtzXnJc3eh6dt0QB2", // Sine's
  "8R4gqTCxxzaNt1Bt4nLjqUEn6jd2", // Get Right
  "8R4gqTCxxzaNt1Bt4nLjqUEn6jd2", // Altria
  "blWPqZivnqMmbLbJBSegtFixUey1", // Black Iris
  "Y1wv3xMl9VN5yHH9PCCyws0ABPy2", // Ashland Threatre
  "TzivAopcsugl0lTk2FmcnT0eHJx1", // Richmond Music Hall
  "QSxvMxvLlHgAhqJbJf18IzNAP3D3", // In Your Ear
  "8ObJtER8PDUYKmQ0w7Tze0P6SHa2", // The Camel
  "drGG9B3UwPTCugiUqwFIzYDo45v2", // Therapy
  "xYiQfClgLsSxSdkxd0oeP8aYIdG2", // Kabana
  "3HzyzGTkZCN0lcVsBrQJG7kP3Zr2", // The Park 
  "QGSNkGPB2wbEchwdD8VxJkhaBFN2", // VACU Ampitheatre
  "5aisevPU3lW97dJZ2eJbIrDMfXI3", // Fallout
  "MejIpHsC1EWyA2Xuvh1PVhEMesa2", // The 4 cyber cafe
  "FsQWuDwH5lZxEpd7TpwXi7fFKqj1", // Alley RVA
  "Mleihxk6vIh3LOLR0P03Rjft6vJ2", // The Golden Pony
  "S506h6zIMLM3BPtnEuiJWEFtrbh2", // The Loud
];

export const dcVenueIds = [
  "00ZIBU93q0eLmzuPu5qliQHnDE92",
  "5KXpcoAMYGW8q2PBF2WntltjC6z2",
  "7MIWjtTGTHRSf1kppWmtntuQs2l2",
  "cvdmcGyu7wMsBQMZbdCthXq1CCX2",
  "tm3MiUbcpQQwAvqwTsOY5kJM1mQ2",
  "Qar0DrUBCDerthNqajKM51LSzFn2",
  "tga3oqoyIDXYozsKtkpus3gpMeP2",
  "EyRV4VE5zbPLWdmsHew4KSvRCt72",
  "RzQD4ooYk2Ss56aW5dc6DulaaDw1",
  "kgTTomDB24OXOZlUwKuqLU8UdAW2",
  "L5eCmlC8Ctg5NfB4J8VAo6FZFrH2",
  "Qa2sP9JDgrX3cRuY3GyzBCpXW8c2",
  "Y39CGyTENNRbFhgGa3aXZQXNgBb2",
  "FzQEr1y6FRgPKDw27v6vmSFIoEr1",
  "RsIn7VT7eseAw6DdvLnFvRGLMqy1",
  "oH56wniKfvYa95OWTf5WANOxAbj2",
  "GiLBU7RIAwdNw4kzfIi6O8dGebF2",
  "NXhLa2fRxYee1FcpN4eEHM0LSxq1",
  "QiZjKYKkrbN7ess6NvmGRp6Y5sr1",
  "vdtlKMOSp9bEvw2ffZW0Pek95Xa2",
  "YpqhcL4Ze4WIvDo9MvLcjZs5g2f2",
  "VPiVSXeJwWdWEw9Vd1pAZPiWssY2",
  "E3Z6FpYv5LXV6vGVw1n9A0TMsNH2",
  "6GHkazi3dxPbhLJOcsfEQ9r9BFg2",
  "n9J2e7h2HGeW0TyCPYo2cwRu9Lg1",
  "UkqQj5ge19auK0Wr34Z8Zc9Oj6I2",
  "1hXOE6zzYMUy2Tly9bDjHuZJ9Yz2",
  "bMo6zfOwKbNwDxIZYXKubiiTdRl1",
  "5X0ufOuSsXNevw8bZOQRqWkLPGB3",
  "7isjJFsTxoTC0GlDjhgXBKncwd83",
  "TXAvfUxOLzUCigFpPS83Jsnbi7l2",
  "cIqJxvbC9wW1UYXWJ1MO0xDPs5D2",
  "L9qTUbocx1fLwRVdrSu3aA11MXR2",
  "WU9ItYebvAYwNTALeIRcpuOYZhp1",
  "Cy2AmwSUAXcAhK3kzpY3bZK75zn1",
  "M3uI6vhozgQFHi3fhkmcUS9L9Kb2",
  "xsmeqE6zXEOGX0yI1dlq3rYX1jl2",
  "CvjoKHvvsRgVVnkBbphvOXamZx03",
  "yjjgckaVYseiPsbu36nFdPmJ2083",
  "xAKOdUE1s8SVIGoOqyDvoI2uKOh1",
  "oFK0eAAm3dacy5U7p3HpXW1ozA53",
  "bHDyyJUT1mfCc17UWPwbuLdKPrF2",
  "gYrjJB496iTREW7ncnRVtXT9jQw2",
  "gx6LSAEkBGTWd62N8XniNBmIdZl2",
  "dBoVTxi1lLT9r03NISpXWXoDtCt1",
  "UT8F6eUeqzbco8LIBxee2RvKNdc2",
  "0NAIabACqsQrBm7niDQRdNy26lA2",
  "kIfc37QVjcVu6loGrBz5yIGUfq63",
  "UIhIJfzDbuSJQwqFEFhtZDp5aQP2",
  "qNcrA5Y5o4M6jg4qbq2NmmGcu1h1",
  "qVI1SiXaDmXHpnrGG2XgohJyZb02",
  "5V4mdhkQSYd3WnbJPBuaUOxqxJe2",
  "GSS7g8bA5zR1TSAmbdBYJiZxwao1",
  "8ZQmLcRUQLTVKfdaeGesuimElfk2",
  "qw4v44tIZfbzNpveXxD13gKKm1J2",
  "oABMmMY0TNbbCQ1sKtcZC2GqJr32",
  "yVdp6tFlD6dUFhY66g5eumpHbqI3",
  "fgq2S5E4tVN3A4zMtoFW0tBLoLi2",
  "07dnM8g68eg2cmRWH8QCYMh5oiI2",
  "EU2AkkXc5ddRFKg99bhfp9C2Ryj2",
  "C81BKW3SdtO17NMmsV6AYBYSYMH2",
  "bX9WH19YQXT7yetLkTqHSFhC5tz1",
  "KEqohZWF3zWhBFuCvAZHoD1VqYf2",
  "GtUBlO8R0Ybx9exDZ4OUDk8yKCl2",
  "pwZDZDPMevc1esklmaREH2R2wLa2",
  "lIDR0JCS0YPiM550iAskxYTom9M2",
  "yCUWh4ITEWQqIqv7gcPWEN6Nc7P2",
  "GSS7g8bA5zR1TSAmbdBYJiZxwao1",
  "3I75may4fxVX2lZv5k5tY8qCHDH3",
  "wsruDo3yQcb5oJWfI1mLzyAn8z93",
  "PQfDlQkXdqhPqLYW37ZB3gKQ2Tr2",
  "60N3iJIUT3VSQMtG8KVMuwJ22sO2",
  "xYydBkRmRrTQ1HvBc7TNh0CeaM32"
];

export const novaVenueIds = [
  "9i5dUZgjaFQpP0dwr2ADWVkR4r42",
  "LureUTJhufbo3WtVTOBxu8CrCLc2",
  "x9riU2yNGLfVsVJsxdI1k6kTHCg2",
  "y08QlfbgCrQLlrGzohCbgMwRfZw2",
  "lkPs1LGKz5gznMj0bRpPWQKAWmi1",
  "YgMLQ7sbDncrQyGn2wA4IS2jU0r1",
  "miqneFyZ3lVmji81wik5h3RyUnF2",
  "buH3UwX0UhUzpOKxBsgyPuJPpZD3",
  "wkH5Ns6nYNQZhZ7NrivhYN7rTg82",
  "tJifcvFdZJf8REVsn9UA46FY4Wz2",
  "K4lMYs46JCgeP4Xnwj7FKyaE1Ht2",
  "xY3051DN7MOGzLVZNGWNfGQhXFZ2",
  "W2Zy3dlEmhTohNO2sa7aK1Uebl92",
  "uYGJDSGA78clq9mzvFuCJUMJf8U2",
  "DJOt2UF7viQOWCbBDtCGVh9RQgp1",
  "2PMu6d6xosNBgRmOlJsVPl5vMIM2",
  "NuLHoBVVNKQ4W5YnBEfc6bjKzNv1",
  "LEZk5gdIkVayBvZgXHGlYoj3OG53",
  "z7dilUXtStfxwo1ONV7lSuuvB973",
  "dyhAON8hnKWhgQgPFXeCaXJuf6k2",
  "zm3qGbA64xUhDoMwHmqk3AqfomB2",
  "hOwoaYqD3Ee0x27Mc6bD2YPsFk72",
  "RUaxeKNvfeNz7QSVz001JfjVl1w1",
  "sRVA1QSoB2TTkT5H2XJtDCBFRoN2",
  "DqJIJawDQVZ30jRjSmzGC4MKg6R2",
  "xH0o8jPxrtMzoSSrs0zrWwb3y2l1",
  "MEXvzNpe7RZHy6mN2U5yLKpPkRt2",
  "2MCo5FTXmCN8JnshBpIDEkBgocs1",
  "QgjyZCCznKdEowMXxBNuoipEs3B3",
  "dG2Hk5C25AMiA4cvXdkyAYjWoXF2",
  "vzLnzq1herXo7CbvUOHanr7NLId2",
  "spT2s3VhnhQj80la5NIeaSRjNZo1",
  "PMd9TPodfXRx5vYLPdRDjo7A4om2",
  "moM87sjaPFPxdnyRomE5FF5Kmq62",
  "7lJyh250I7frC6dHTnCAAmkRgKL2"
];

export const marylandVenueIds = [
  "ckTmjlrn3JhmPCmYVMN9HeOYnBB3",
  "15v8PhLD2kO18Urleipgu6P4YRC2",
  "ndI4JztVvVdUVzuWZmxSVJH5ENj2",
  "okWXRjc5PxTyAvLeoYMgmpGOig92",
  "kIfc37QVjcVu6loGrBz5yIGUfq63"
];

export const virginiaBeachVenueIds: string[] = [];



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

// const _copyOpportunityToFeeds = async (opportunity: Opportunity) => {
//   const usersSnap = await usersRef.get();

//   await Promise.all(
//     usersSnap.docs.map(async (userDoc) => {
//       if (userDoc.id === opportunity.userId) {
//         return;
//       }

//       const email = userDoc.data().email;
//       if (email.includes("tapped.ai")) {
//         return;
//       }

//       await _addOpportunityToUserFeed(userDoc.id, opportunity);
//     }),
//   );
// };

// const _createRandomOpportunity = async ({ venues, openaiKey }: {
//   venues: UserModel[];
//   openaiKey: string;
// }) => {
//   const eventTypes: {
//     type: string;
//     paid: number; // the probability that this event is paid
//     prompt: string; // the prompt for this event
//   }[] = [
//     {
//       type: "gig",
//       paid: 0.75,
//       prompt: "a gig opportunity",
//     },
//     {
//       type: "openMic",
//       paid: 0,
//       prompt: "a open mic"
//     },
//     {
//       type: "albumRelease",
//       paid: 0.75,
//       prompt: "needing an opening musician for an album release party",
//     },
//     {
//       type: "themedNight",
//       paid: 0.3,
//       prompt: "needing a musicians for a themed nights",
//     },
//     {
//       type: "battleOfTheBands",
//       paid: 0.9,
//       prompt: "battle of the bands opportunity for local bands",
//     },
//     {
//       type: "songwriterShowcase",
//       paid: 0.2,
//       prompt: "songwriter showcases opportunity for local songwriters",
//     },
//     {
//       type: "jamSession",
//       paid: 0,
//       prompt: "jam sessions for local bands",
//     },
//     {
//       type: "charityConcert",
//       paid: 0,
//       prompt: "needing local musicians for a charity concert",
//     },
//     {
//       type: "onlineStream",
//       paid: 0.5,
//       prompt: "needing local musicians for an online streaming event",
//     },
//   ];

//   const uuid = uuidv4();
//   const randomVenue = venues[Math.floor(Math.random() * venues.length)];
//   const currentDate = new Date();
//   const plusOneMonth = new Date(currentDate.setMonth(currentDate.getMonth() + 1));
//   const plusThreeMonths = new Date(currentDate.setMonth(currentDate.getMonth() + 3));
//   const randomDate = _generateRandomDate(plusOneMonth, plusThreeMonths);
//   const oneHourAhead = new Date(randomDate.getTime() + 60 * 60 * 1000);
//   const eventType = eventTypes[Math.floor(Math.random() * eventTypes.length)];

//   const randomPrompt = (() => {
//     // 8% of the time it'll have a crazy good prompt
//     // if (Math.random() > 0.05) {
//     //     return crazyIliasIdeaPrompt;
//     // }

//     const thePrompt = `you're a promoter looking to post online about ${eventType.prompt}. 
//         what would the title of the event be and what would the 2 sentence description be? 
//         the venue is called ${randomVenue.artistName}. 
//         format your response as a valid JSON object`;
//     return thePrompt;
//   })();

//   const { title, description } = await (async () => {
//     // you get 3 tries to do this correctly
//     for (let i = 0; i < 3; i++) {
//       try {
//         const res = await llm(randomPrompt, openaiKey, { temperature: 0.4 });
//         const { title, description } = JSON.parse(res);
//         return { title, description };
//       } catch (e) {
//         console.error(e);
//         continue;
//       }
//     }

//     throw new Error(`your prompt fkn sucks - ${randomPrompt}`);
//   })()

//   if (title === undefined || description === undefined) {
//     console.log(`your prompt fkn sucks - ${randomPrompt}`);
//     return;
//   }

//   const op: Opportunity = {
//     id: uuid,
//     userId: randomVenue.id,
//     title,
//     description,
//     placeId: randomVenue.placeId!,
//     geohash: randomVenue.geohash!,
//     lat: randomVenue.lat!,
//     lng: randomVenue.lng!,
//     timestamp: new Date(),
//     startTime: randomDate,
//     endTime: oneHourAhead,
//     isPaid: Math.random() < eventType.paid,
//     touched: null,
//   }

//   console.log({ op });

//   await opportunitiesRef.doc(uuid).set({
//     ...op,
//     aiGenerated: true,
//   });

//   await _copyOpportunityToFeeds(op);
// }

// const _createMockOpportunities = async ({ count, openaiKey }: {
//   count: number;
//   openaiKey: string;
// }) => {
//   const venueBlacklist: string[] = [
//     "8ObJtER8PDUYKmQ0w7Tze0P6SHa2", // The Camel
//     "FsQWuDwH5lZxEpd7TpwXi7fFKqj1", // Alley RVA
//     "8R4gqTCxxzaNt1Bt4nLjqUEn6jd2", // Get Tight
//     "QGSNkGPB2wbEchwdD8VxJkhaBFN2", // VACU Ampitheatre
//     "jyz81JbwQycJoBzTTs4N724Gffc2", // The National
//     "tloWCuKGHYScMCp3YamsHKVi3XU2", // Brown's Island
//     "9FKyhrndDreJtzXnJc3eh6dt0QB2", // Sine's
//   ];

//   const virginiaVenues = await Promise.all(
//     virginiaVenueIds.concat(
//       dcVenueIds,
//       novaVenueIds,
//       marylandVenueIds,
//       virginiaBeachVenueIds,
//     ).filter(
//       (venueId) => !venueBlacklist.includes(venueId),
//     ).map(async (venueId) => {
//       const venueSnap = await usersRef.doc(venueId).get();
//       const venue = venueSnap.data()!;
//       return venue as UserModel;
//     }),
//   );

//   // const crazyIliasIdeaPrompt = `you're a promoter looking to post online about ${eventType}. 
//   // what would the title of the event be and what would the 2 sentence description be? 
//   // the venue is called ${randomVenue.artistName}. 
//   // format your response as a valid JSON object`

//   const opPromises: Promise<void>[] = [];
//   for (let i = 0; i < count; i++) {
//     opPromises.push(_createRandomOpportunity({ venues: virginiaVenues, openaiKey }));
//   }

//   await Promise.all(opPromises);
// };

// function _generateRandomDate(from: Date, to: Date) {
//   return new Date(
//     from.getTime() +
//     Math.random() * (to.getTime() - from.getTime()),
//   );
// }

const _sendUserQuotaNotification = async (
  userId: string, 
  openaiKey: string,
) => {

  // add new opportunities to the feed
  // try {
  //   await _createMockOpportunities({ count: 10, openaiKey });
  // } catch (e) {
  //   error("error creating mock opportunities", e);
  // }

  // get userId device tokens
  const tokensSnap = await tokensRef
    .doc(userId)
    .collection("tokens")
    .get();


  const tokens: string[] = tokensSnap.docs.map((snap) => snap.id);
  await Promise.all(tokens.map(async (token) => {
    try {

      await fcm.send({
        token,
        notification: {
          title: "you're back!",
          body: "you can apply for 5 more opportunities today!",
        },
      });
    } catch (e) {
      error(`error sending quota notification to ${userId} - ${token}`, e);
      await tokensRef.doc(userId).collection("tokens").doc(token).delete();
    }
  }));
}

const _setDailyOpportunityQuota = async (openaiKey: string) => {
  const usersSnap = await usersRef
    .where("deleted", "!=", true)
    .get();

  await Promise.all(
    usersSnap.docs.map(async (userDoc) => {
      const email: string | undefined = userDoc.data().email;
      if (email === undefined || email?.includes("tapped.ai")) {
        return;
      }

      try {
        await creditsRef.doc(userDoc.id).set({
          opportunityQuota: 5,
        });
      } catch (e) {
        error("error setting daily opportunity quota", e);
      }

      try {
        await _sendUserQuotaNotification(userDoc.id, openaiKey);
      } catch (e) {
        error("error sending quota notification", e);
      }
    }),
  );
  info("daily opportunity quotas set");
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

export const createOpportunityFeedOnUserCreated = functions
  .auth
  .user()
  .onCreate(async (user) => {
    const numOpsPerFeed = 500;
    const opportunitiesSnap = await opportunitiesRef
      .where("startTime", ">", Timestamp.now())
      .limit(numOpsPerFeed)
      .get();

    await creditsRef.doc(user.uid).set({
      opportunityQuota: 5,
    });

    await Promise.all(
      opportunitiesSnap.docs.map(async (opDoc) => {
        const op = opDoc.data() as Opportunity;
        await _addOpportunityToUserFeed(user.uid, op);
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
      .limit(25)
      .get();

    await Promise.all(
      opportunitiesSnap.docs.map(async (opDoc) => {
        const op = opDoc.data() as Opportunity;
        await _addOpportunityToUserFeed(user.id, op);
      }),
    );
  });

export const setDailyOpportunityQuota = onSchedule("0 0 * * *", async () => {
  const openaiKey = await getSecretValue("OPEN_AI_KEY")
  if (openaiKey === null) {
    throw new Error("OPEN_AI_KEY is null");
  }

  await _setDailyOpportunityQuota(openaiKey);
});
