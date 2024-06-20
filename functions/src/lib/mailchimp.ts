/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import mailchimp from "@mailchimp/mailchimp_marketing"
import { MAILCHIMP_API_KEY, MAILCHIMP_SERVER_PREFIX } from "./firebase";
import { error } from "firebase-functions/logger";

export const addUserToMailchimpOnCreated = functions
  .runWith({ secrets: [ MAILCHIMP_API_KEY, MAILCHIMP_SERVER_PREFIX ] })
  .auth
  .user()
  .onCreate(async (user) => {

    const email = user.email;
    if (!email) {
      error(`user ${user.uid} has no email`)
      return;
    }

    if (email.includes("tapped.ai")) {
      return;
    }

    mailchimp.setConfig({
      apiKey: MAILCHIMP_API_KEY.value(),
      server: MAILCHIMP_SERVER_PREFIX.value(),
    });

    mailchimp.lists.addListMember("adc6feff36", {
      email_address: email,
      status: "subscribed",
    });
  });

// export const removeUserFromMailchimpOnDeleted  = functions
// .runWith({ secrets: [ MAILCHIMP_API_KEY, MAILCHIMP_SERVER_PREFIX ] })
// .auth
// .user()
// .onDelete(async (user) => {
//     const email = user.email;
//     if (!email) {
//         error(`user ${user.uid} has no email`)
//         return;
//     }

//     mailchimp.setConfig({
//         apiKey: MAILCHIMP_API_KEY.value(),
//         server: MAILCHIMP_SERVER_PREFIX.value(),
//       });

//       mailchimp.lists.deleteListMember("adc6feff36", {
//         email_address: email,
//       });
// });