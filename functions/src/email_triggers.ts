
/* eslint-disable import/no-unresolved */
import type { UserRecord } from "firebase-admin/auth";
import * as functions from "firebase-functions";
import { 
  debug, 
  info, 
  error,
} from "firebase-functions/logger";
import { 
  RESEND_API_KEY, 
  guestMarketingPlansRef, 
  mailRef, 
  queuedWritesRef, 
  stripeTestEndpointSecret, 
  stripeTestKey,
  usersRef,
} from "./firebase";
import { 
  onRequest, 
} from "firebase-functions/v2/https";
import {
  onDocumentCreated,
  onDocumentUpdated,
} from "firebase-functions/v2/firestore";
import Stripe from "stripe";
import { Resend } from "resend";
import { Booking, MarketingPlan } from "./models";
import { marked } from "marked";
import { Timestamp } from "firebase-admin/firestore";
import { labelApplied } from "./email_templates/label_applied";
import { labelApproved } from "./email_templates/label_approved";

export const sendWelcomeEmailOnUserCreated = functions.auth
  .user()
  .onCreate(async (user: UserRecord) => {
    const email = user.email;

    if (email === undefined || email === null || email === "") {
      throw new Error("user email is undefined, null or empty: " + JSON.stringify(user));
    }

    debug(`sending welcome email to ${email}`);
    await mailRef.add({
      to: [ email ],
      template: {
        name: "welcome",
      },
    })
  });

export const sendEmailOnLabelApplication = onDocumentCreated({
  document: "label_applications/{applicationId}",
  secrets: [ RESEND_API_KEY ],
}, async (event) => {
  const snapshot = event.data;
  const application = snapshot?.data();
  const email = application?.email;
  if (email === undefined || email === null || email === "") {
    throw new Error(`application ${application?.id} does not have an email`);
  }

  const resend = new Resend(RESEND_API_KEY.value());
  await resend.emails.send({
    from: "no-reply@tapped.ai",
    to: [ email ],
    subject: "thank you for applying to Tapped Ai!",
    html: `<div style="white-space: pre;">${labelApplied}</div>`,
  });
});

export const sendEmailOnApproval = onDocumentUpdated({
  document: "label_applications/{applicationId}",
  secrets: [ RESEND_API_KEY ],
}, async (event) => {
  const {before, after} = event.data;
  const beforeData = before?.data();
  const afterData = after?.data();
  const approvedBefore = beforeData?.approved ?? false;
  const approvedAfter = afterData?.approved ?? false; 

  if (approvedBefore !== false && approvedAfter !== true) {
    debug(`before ${approvedBefore}, after ${approvedAfter}`);
    return;
  }

  if (beforeData?.approved === false && afterData?.approved === true){
    const email = afterData?.email;
    if (email === undefined || email === null || email === "") {
      throw new Error(`application ${afterData?.id} does not have an email`);
    }
    const resend = new Resend(RESEND_API_KEY.value());
    await resend.emails.send({
      from: "no-reply@tapped.ai",
      to: [ email ],
      subject: "you've been approved for Tapped Ai!",
      html: `<div style="white-space: pre;">${labelApproved}</div>`,
    });
  }
});

export const emailMarketingPlanStripeWebhook = onRequest(
  { secrets: [ 
    stripeTestKey, 
    stripeTestEndpointSecret, 
    RESEND_API_KEY, 
  ] },
  async (req, res) => {
    const stripe = new Stripe(stripeTestKey.value(), {
      apiVersion: "2022-11-15",
    });
  
    const resend = new Resend(RESEND_API_KEY.value());
    const productIds = [
      "prod_Ojv2uMqEt5n60E", // test AI plan product
      "prod_OjsPZixnuZ86el", // prod AI plan product
    ];
  
    info("marketingPlanStripeWebhook", req.body);
    const sig = req.headers["stripe-signature"];
    if (!sig) {
      res.status(400).send("No signature");
      return;
    }
  
    try {
      const event = stripe.webhooks.constructEvent(
        req.rawBody, 
        sig, 
        stripeTestEndpointSecret.value(),
      );
  
      // Handle the event
      switch (event.type) {
      case "checkout.session.completed":
        // eslint-disable-next-line no-case-declarations
        const checkoutSessionCompleted = event.data.object as unknown as { 
            id: string;
            customer_email: string | null;
            customer_details: {
              email: string;
            }
          };
  
        // create firestore document for marketing plan set to 'processing' keyed at session_id
        info({ checkoutSessionCompleted });
        info({ sessionId: checkoutSessionCompleted.id });
  
        // get form data from firestore
        // eslint-disable-next-line no-case-declarations
        const checkoutSession = await stripe.checkout.sessions.retrieve(checkoutSessionCompleted.id, {
          expand: [ "line_items" ]
        });
        info({ checkoutSession });
        info({ lineItems: checkoutSession.line_items })
        // eslint-disable-next-line no-case-declarations
        const products = checkoutSession.line_items?.data?.map((item) => item.price?.product);
        // eslint-disable-next-line no-case-declarations
        const filteredArray = products?.filter(value => productIds.includes(value?.toString() ?? "")) ?? [];
        if (filteredArray.length === 0) {
          debug(`incorrect product: ${products}`);
          return;
        }
  
        // eslint-disable-next-line no-case-declarations
        const { client_reference_id: clientReferenceId } = checkoutSession;
        if (clientReferenceId === null) {
          debug(`no client reference id: ${clientReferenceId}`)
          res.sendStatus(200);
          return;
        }
        info({ clientReferenceId });
  
        // save marketing plan to firestore and update status to 'complete'
        await guestMarketingPlansRef.doc(clientReferenceId).update({
          checkoutSessionId: checkoutSessionCompleted.id,
        });

        // eslint-disable-next-line no-case-declarations
        const marketingPlanRef = await guestMarketingPlansRef.doc(clientReferenceId).get();
        // eslint-disable-next-line no-case-declarations
        const marketingPlan = marketingPlanRef.data() as MarketingPlan;
  
        // email marketing plan to user
        // eslint-disable-next-line no-case-declarations
        const customerEmail = checkoutSessionCompleted.customer_email ?? checkoutSessionCompleted.customer_details.email;
        if (customerEmail !== null) {
          await resend.emails.send({
            from: "no-reply@tapped.ai",
            to: [
              checkoutSessionCompleted.customer_email ?? checkoutSessionCompleted.customer_details.email
            ],
            subject: "Your Marketing Plan | Tapped Ai",
            html: `<div>${marked.parse(marketingPlan.content)}</div>`,
          });
        }
  
        break;
        // ... handle other event types
      default:
        console.log(`Unhandled event type ${event.type}`);
      }
  
      // Return a 200 response to acknowledge receipt of the event
      res.sendStatus(200);
    } catch (err: any) {
      error(err);
      res.status(400).send(`Webhook Error: ${err.message}`);
      return;
    }
  });
  
export const sendBookingRequestSentEmailOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (data) => {
    const booking = data.data() as Booking;
    const requesterSnapshot = await usersRef.doc(booking.requesterId).get();
    const requester = requesterSnapshot.data();
    const email = requester?.email;

    if (email === undefined || email === null || email === "") {
      throw new Error(`requester ${requester?.id} does not have an email`);
    }

    await mailRef.add({
      to: [ email ],
      template: {
        name: "bookingRequestSent",
      },
    })
  });

export const sendBookingRequestReceivedEmailOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (data) => {
    const booking = data.data() as Booking;
    const requesteeSnapshot = await usersRef.doc(booking.requesteeId).get();
    const requestee = requesteeSnapshot.data();
    const email = requestee?.email;

    if (email === undefined || email === null || email === "") {
      throw new Error(`requestee ${requestee?.id} does not have an email`);
    }

    await mailRef.add({
      to: [ email ],
      template: {
        name: "bookingRequestReceived",
      },
    })
  });

export const sendBookingNotificationsOnBookingConfirmed = functions
  .firestore
  .document("bookings/{bookingId}")
  .onUpdate(async (data) => {
    const booking = data.after.data() as Booking;
    const bookingBefore = data.before.data() as Booking;

    if (booking.status !== "confirmed" || bookingBefore.status === "confirmed") {
      functions.logger.info(`booking ${booking.id} is not confirmed or was already confirmed`);
      return;
    }

    const requesteeSnapshot = await usersRef.doc(booking.requesteeId).get();
    const requestee = requesteeSnapshot.data();
    const requesteeEmail = requestee?.email;

    if (requesteeEmail === undefined || requesteeEmail === null || requesteeEmail === "") {
      throw new Error(`requestee ${requestee?.id} does not have an email`);
    }

    const requesterSnapshot = await usersRef.doc(booking.requesterId).get();
    const requester = requesterSnapshot.data();
    const requesterEmail = requester?.email;

    if (requesterEmail === undefined || requesterEmail === null || requesterEmail === "") {
      throw new Error(`requester ${requester?.id} does not have an email`);
    }


    const ONE_HOUR_MS = 60 * 60 * 1000;
    const ONE_DAY_MS = 24 * ONE_HOUR_MS;
    const ONE_WEEK_MS = 7 * ONE_DAY_MS;
    const reminders = [
      {
        userId: booking.requesteeId,
        email: requesteeEmail,
        offset: ONE_HOUR_MS,
        type: "bookingReminderRequestee",
      },
      {
        userId: booking.requesteeId,
        email: requesteeEmail,
        offset: ONE_DAY_MS,
        type: "bookingReminderRequestee",
      },
      {
        userId: booking.requesteeId,
        email: requesteeEmail,
        offset: ONE_WEEK_MS,
        type: "bookingReminderRequestee",
      },
      {
        userId: booking.requesterId,
        email: requesterEmail,
        offset: ONE_HOUR_MS,
        type: "bookingReminderRequester",
      },
      {
        userId: booking.requesterId,
        email: requesterEmail,
        offset: ONE_DAY_MS,
        type: "bookingReminderRequester",
      },
      {
        userId: booking.requesterId,
        email: requesterEmail,
        offset: ONE_WEEK_MS,
        type: "bookingReminderRequester",
      },
    ]

    const startTime = booking.startTime.toDate().getTime();

    // Create schedule write for push notification
    // 1 week, 1 day, and 1 hour before booking start time
    for (const reminder of reminders) {

      if ((startTime - reminder.offset) < Date.now()) {
        functions.logger.info("too late to send reminder, skipping reminder");
        continue;
      }

      await Promise.all([
        queuedWritesRef.add({
          state: "PENDING",
          data: {
            toUserId: reminder.userId,
            type: "bookingReminder",
            bookingId: booking.id,
            timestamp: Timestamp.now(),
            markedRead: false,
          },
          collection: "activities",
          deliverTime: Timestamp.fromMillis(
            startTime - reminder.offset,
          ),
        }),
        // queuedWritesRef.add({
        //   state: "PENDING",
        //   data: {
        //     to: [ reminder.email ],
        //     template: {
        //       // e.g. bookingReminderRequestee-3600000
        //       name: `${reminder.type}-${reminder.offset}`,
        //     },
        //   },
        //   collection: "mail",
        //   deliverTime: Timestamp.fromMillis(
        //     startTime - reminder.offset,
        //   ),
        // }),
      ]);
    }
  });