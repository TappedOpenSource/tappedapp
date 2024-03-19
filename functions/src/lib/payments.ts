/* eslint-disable import/no-unresolved */
import Stripe from "stripe";
import * as functions from "firebase-functions";
import { remote, stripeKey, stripePublishableKey, stripeTestKey } from "./firebase";
import { info } from "firebase-functions/logger";
import { authenticated } from "./utils";
import { HttpsError, onCall } from "firebase-functions/v2/https";

export const _createStripeCustomer = async (email?: string): Promise<string> => {
  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const customer = await stripe.customers.create({ email: email });

  return customer.id;
}

export const _createPaymentIntent = async (data: {
  destination?: string;
  amount?: number,
  customerId?: string,
  receiptEmail?: string,
}): Promise<{
    paymentIntent: string | null;
    ephemeralKey?: string;
    customer: string;
    publishableKey: string;
  } | null> => {
  if (data.destination === undefined || data.destination === null || data.destination === "") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'destination' cannot be empty"
    );
  }

  if (data.amount === undefined || data.amount === null || data.amount < 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'amount' cannot be empty or negative"
    );
  }

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });


  const customerId = (data.customerId === undefined || data.customerId === null || data.customerId === "")
    ? (await _createStripeCustomer(data.receiptEmail))
    : data.customerId

  // Use an existing Customer ID if this is a returning customer.
  const ephemeralKey = await stripe.ephemeralKeys.create(
    { customer: customerId },
    { apiVersion: "2022-11-15" }
  );

  const remoteTemplate = await remote.getTemplate()
  const bookingFeeValue = remoteTemplate.parameters.booking_fee?.defaultValue;
  // const bookingFee = await getValue(remote, "booking_fee").asNumber();

  if (bookingFeeValue === undefined || bookingFeeValue === null) return null;

  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  const weirdTSError = bookingFeeValue.value;

  const bookingFee = parseFloat(weirdTSError);

  info(`booking fee is ${bookingFee}`);

  const application_fee = data.amount * bookingFee;

  const paymentIntent = await stripe.paymentIntents.create({
    amount: Math.floor(data.amount),
    currency: "usd",
    customer: customerId,
    application_fee_amount: Math.floor(application_fee),
    automatic_payment_methods: {
      enabled: true,
    },
    transfer_data: {
      destination: data.destination,
    },
    receipt_email: data.receiptEmail,
  });

  return {
    paymentIntent: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customerId,
    publishableKey: stripePublishableKey.value(),
  };
};

export const _createStripeAccount = async ({ countryCode }: {
  countryCode?: string;
}): Promise<string> => {
  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const country = countryCode || "US";
  const account = await stripe.accounts.create({
    type: "express",
    settings: {
      payouts: {
        schedule: {
          interval: "manual",
        },
      },
    },
    // cross border payments only work with
    // recipient accounts
    // tos_acceptance: {
    //   service_agreement: "recipient", 
    // },
    country: country,
  });

  info(`created Stripe account ${account.id} for ${country}`);

  return account.id;
}

export const _createConnectedAccount = async ({ accountId, country }: {
  accountId?: string | null;
  country?: string;
}): Promise<{
    success: boolean;
    url: string;
    accountId: string;
}> => {

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const account = (accountId === undefined || accountId === null || accountId === "")
    ? (await _createStripeAccount({
      countryCode: country,
    }))
    : accountId

  const subdomain = "tappednetwork";
  const deepLink = "https://tappednetwork.page.link/connect_payment";
  const appInfo = "&apn=com.intheloopstudio&isi=1574937614&ibi=com.intheloopstudio";

  const refreshUrl = `https://${subdomain}.page.link/?link=${deepLink}?account_id=${accountId}&refresh=true${appInfo}`;
  const returnUrl = `https://${subdomain}.page.link/?link=${deepLink}?account_id=${accountId}`;

  const accountLinks = await stripe.accountLinks.create({
    account: account,
    refresh_url: refreshUrl,
    return_url: returnUrl,
    type: "account_onboarding",
  })

  info(`created Stripe account link ${accountLinks.url} for ${account}`)

  return { success: true, url: accountLinks.url, accountId: account };
}

export const _getAccountById = async (data: { accountId: string }): Promise<Stripe.Response<Stripe.Account>> => {
  if (data.accountId === undefined || data.accountId === null || data.accountId === "") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'accountId' cannot be empty"
    );
  }

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const account = await stripe.accounts.retrieve(data.accountId);

  return account;
}

export const createPaymentIntent = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    authenticated(context);
    return _createPaymentIntent(data);
  });

export const createConnectedAccount = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    authenticated(context);
    return _createConnectedAccount(data);
  })

export const getAccountById = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    authenticated(context);
    return _getAccountById(data);
  });

export const checkoutSessionToClientReferenceId = onCall(
  { secrets: [ stripeTestKey ] },
  async (request) => {
    const stripe = new Stripe(stripeTestKey.value(), {
      apiVersion: "2022-11-15",
    });

    const { checkoutSessionId }: {
      checkoutSessionId: string;
    } = request.data;
    if (typeof checkoutSessionId !== "string" || checkoutSessionId.length === 0) {
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"checkoutSessionId\".");
    }

    const session = await stripe.checkout.sessions.retrieve(checkoutSessionId);
    info({ session });

    return {
      clientReferenceId: session.client_reference_id,
    };
  });


