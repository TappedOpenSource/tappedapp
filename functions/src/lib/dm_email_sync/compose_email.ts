import { Booking, Opportunity, UserModel, VenueContactRequest } from "../../types/models";
import { bookingsRef, usersRef } from "../firebase";
import { chatGpt } from "../openai";
import * as postmark from "postmark";

export async function writeEmailWithAi({
  performer,
  venue,
  note,
  opportunities,
}: {
  performer: UserModel;
  venue: UserModel;
  note: string;
  opportunities: Opportunity[];
}): Promise<{
  subject: string;
  body: string;
}> {
  const username = performer.username;
  const displayName = performer.artistName || username;
  const genres = performer.performerInfo?.genres?.join(", ") ?? "";

  const venueName = venue.artistName;
  const subject = `Performance Inquiry from ${displayName}`;

  if (opportunities.length > 0) {
    const shortenedOps = await Promise.all(
      opportunities.map(async (o) => {
        const referenceEventId = o.referenceEventId;
        if (!referenceEventId) {
          return {
            title: o.title,
            description: o.description,
            date: o.startTime.toDate().toISOString().split("T")[0],
            otherOpPerformers: [],
          };
        }

        const bookingsSnap = await bookingsRef
          .where("referenceEventId", "==", referenceEventId)
          .get();

        const otherOpPerformers = await Promise.all(
          bookingsSnap.docs.map(async (doc) => {
            const booking = doc.data() as Booking;
            const requesteeId = booking.requesteeId;
            const requesteeDoc = await usersRef.doc(requesteeId).get();
            const requestee = requesteeDoc.data() as UserModel;

            return requestee.artistName ?? requestee.username;
          }),
        );

        return {
          title: o.title,
          description: o.description,
          date: o.startTime.toDate().toISOString().split("T")[0],
          otherOpPerformers: otherOpPerformers,
        };
      }),
    );

    const opportunitySnippet = shortenedOps.map((o) => {
      return `${o.title} on ${o.date} with these other performers ${o.otherOpPerformers.join(",")}. `;
    }).join("\n");
    // write op reply
    const res = await chatGpt(`
  Venue Name: ${venueName}
  Performer Name: ${displayName}
  ${genres !== "" ? `Perfomers Genres: ${genres}` : ""}

  ${note !== "" ? `Note: ${note}` : ""}

  --------------------------
  Given the information above, write an paragraph to send that you're open to performing with this:
  ${opportunitySnippet}
  

  The paragraph should be friendly, professional, and a little dry (i.e. straight to the point).
  Be sure to mention that you were recommended to reach out be Tapped Ai.
  Your response should ONLY use the information provider and assume that's all the information that's available.
  Don't include any intro like "dear venue owner" or signature like "sincerly" or "thanks".
  Be concise, to the point and keep it short.
      `);
    return {
      subject,
      body: res,
    };
  }

  const res = await chatGpt(`
  Venue Name: ${venueName}
  Performer Name: ${displayName}
  ${genres !== "" ? `Perfomers Genres: ${genres}` : ""}

  ${note !== "" ? `Note: ${note}` : ""}

  Given the information above, write an paragraph to send to venues to request a booking in the style
  of a musicians looking to perform there.
  The paragraph should be friendly, professional, and a little dry (i.e. straight to the point).
  Be sure to mention that you were recommended to reach out be Tapped Ai.
  Your response should ONLY use the information provider and assume that's all the information that's available.
  Don't include any intro like "dear venue owner" or signature like "sincerly" or "thanks".
  Be concise, to the point and keep it short.
  `);

  return {
    subject,
    body: res,
  };
}

export async function writeAiEmailReply({
  opportunities,
  note,
  userData,
  contactVenueData,
  emailsSent,
}: {
  opportunities: Opportunity[];
  note: string;
  userData: UserModel;
  contactVenueData: VenueContactRequest;
  emailsSent: postmark.Message[];
}): Promise<string> {
  const username = userData.username;
  const displayName = userData.artistName || username;
  const genres = userData.performerInfo?.genres?.join(", ") ?? "";

  const venueName = contactVenueData.venue.artistName;
  const emailsTextContent = emailsSent.map((e) => e.TextBody).join("\n--------------");

  if (opportunities.length > 0) {
    const shortenedOps = await Promise.all(
      opportunities.map(async (o) => {
        const referenceEventId = o.referenceEventId;
        if (!referenceEventId) {
          return {
            title: o.title,
            description: o.description,
            date: o.startTime.toDate().toISOString().split("T")[0],
            otherOpPerformers: [],
          };
        }

        const bookingsSnap = await bookingsRef
          .where("referenceEventId", "==", referenceEventId)
          .get();

        const otherOpPerformers = await Promise.all(
          bookingsSnap.docs.map(async (doc) => {
            const booking = doc.data() as Booking;
            const requesteeId = booking.requesteeId;
            const requesteeDoc = await usersRef.doc(requesteeId).get();
            const requestee = requesteeDoc.data() as UserModel;

            return requestee.artistName ?? requestee.username;
          }),
        );

        return {
          title: o.title,
          description: o.description,
          date: o.startTime.toDate().toISOString().split("T")[0],
          otherOpPerformers: otherOpPerformers,
        };
      }),
    );



    const opportunitySnippet = shortenedOps.map((o) => {
      return `${o.title} on ${o.date} with these other performers ${o.otherOpPerformers.join(",")}. `;
    }).join("\n");

    // write op reply
    const res = chatGpt(`
  Venue Name: ${venueName}
  Performer Name: ${displayName}
  ${genres !== "" ? `Perfomers Genres: ${genres}` : ""}

  ${note !== "" ? `Note: ${note}` : ""}

  Previous Conversations/Email Thread: 
  ###
  ${emailsTextContent}
  ###

  --------------------------
  Given the information above, write an paragraph to send that you're open to performing with this:
  ${opportunitySnippet}
  

  The paragraph should be friendly, professional, and a little dry (i.e. straight to the point).
  Be sure to mention that you were recommended to reach out be Tapped Ai.
  Your response should ONLY use the information provider and assume that's all the information that's available.
  Don't include any intro like "dear venue owner" or signature like "sincerly" or "thanks".
  Be concise, to the point and keep it short.
      `);
    return res;
  }


  const res = chatGpt(`
  Venue Name: ${venueName}
  Performer Name: ${displayName}
  ${genres !== "" ? `Perfomers Genres: ${genres}` : ""}

  ${note !== "" ? `Note: ${note}` : ""}

  Previous Conversations/Email Thread: 
  ###
  ${emailsTextContent}
  ###

  --------------------------
  Given the information above, write an paragraph to send to venues to request a booking in the style
  of a musicians looking to perform there.
  The paragraph should be friendly, professional, and a little dry (i.e. straight to the point).
  Be sure to mention that you were recommended to reach out be Tapped Ai.
  Your response should ONLY use the information provider and assume that's all the information that's available.
  Don't include any intro like "dear venue owner" or signature like "sincerly" or "thanks".
  Be concise, to the point and keep it short.
    `);

  return res;
}


