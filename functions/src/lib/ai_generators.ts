/* eslint-disable import/no-unresolved */
import * as functions from "firebase-functions";
import { marked } from "marked";
import { LEAP_API_KEY, LEAP_WEBHOOK_SECRET, OPEN_AI_KEY, RESEND_API_KEY, aiModelsRef, auth, avatarsRef, creditsPerPriceId, creditsPerTestPriceId, creditsRef, fcm, guestMarketingPlansRef, mainBucket, marketingFormsRef, marketingPlansRef, projectId, stripeCoverArtTestWebhookSecret, stripeCoverArtWebhookSecret, stripeKey, stripeTestEndpointSecret, stripeTestKey, trainingImagesRef, usersRef } from "./firebase";
import { Resend } from "resend";
import { error, info } from "firebase-functions/logger";
import { basicEnhancedBio, generateBasicAlbumName, generateBasicMarketingPlan, generateSingleBasicMarketingPlan } from "./openai";
import { HttpsError, onCall, onRequest } from "firebase-functions/v2/https";
import { authenticatedRequest, getFoundersDeviceTokens } from "./utils";
import { sd } from "./leapai";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { MarketingPlan, UserModel } from "../types/models";
import Stripe from "stripe";
import { v4 as uuidv4 } from "uuid";

const WEBHOOK_URL = `https://us-central1-${projectId}.cloudfunctions.net/trainWebhook`;
const IMAGE_WEBHOOK_URL = `https://us-central1-${projectId}.cloudfunctions.net/imageWebhook`;

const prompts = [
  "8k portrait of @subject in the style of jackson pollock's 'abstract expressionism,' featuring drips, splatters, and energetic brushwork.",

  "8k portrait of @subject in the style of salvador dalí's 'surrealism,' featuring unexpected juxtapositions, melting objects, and a dreamlike atmosphere.",

  "8k portrait of @subject in the style of Retro comic style artwork, highly detailed spiderman, comic book cover, symmetrical, vibrant",

  "8k close up linkedin profile picture of @subject, professional jack suite, professional headshots, photo-realistic, 4k, high-resolution image, workplace settings, upper body, modern outfit, professional suit, businessman, blurred background, glass building, office window",
];

const _incrementCoverArtTestCredits = async (stripe: Stripe, checkoutSessionCompleted: {
  id: string;
  client_reference_id: string | null;
  customer_email: string | null;
  customer_details: {
    email: string;
  }
}) => {
  const userId = checkoutSessionCompleted.client_reference_id;

  if (userId === null) {
    throw new HttpsError("failed-precondition", "client reference id not set");
  }

  // create firestore document for marketing plan set to 'processing' keyed at session_id
  info({ checkoutSessionCompleted });
  info({ sessionId: checkoutSessionCompleted.id });

  // get form data from firestore
  const checkoutSession = await stripe.checkout.sessions.retrieve(checkoutSessionCompleted.id);
  info({ checkoutSession });

  // const customerEmail = checkoutSessionCompleted.customer_email ?? checkoutSessionCompleted.customer_details.email;

  const lineItems = await stripe.checkout.sessions.listLineItems(
    checkoutSessionCompleted.id
  );
  const quantity = lineItems.data[0].quantity;
  const priceId = lineItems.data[0].price!.id;
  const creditsPerUnit = creditsPerTestPriceId[priceId];
  const totalCreditsPurchased = quantity! * creditsPerUnit;

  console.log({ lineItems });
  console.log({ quantity });
  console.log({ priceId });
  console.log({ creditsPerUnit });

  console.log("totalCreditsPurchased: " + totalCreditsPurchased);

  await creditsRef.doc(userId).update({
    coverArtCredits: FieldValue.increment(totalCreditsPurchased),
  });
};

const _incrementCoverArtCredits = async (stripe: Stripe, checkoutSessionCompleted: {
  id: string;
  client_reference_id: string | null;
  customer_email: string | null;
  customer_details: {
    email: string;
  }
}) => {
  const userId = checkoutSessionCompleted.client_reference_id;

  if (userId === null) {
    throw new HttpsError("failed-precondition", "client reference id not set");
  }

  // create firestore document for marketing plan set to 'processing' keyed at session_id
  info({ checkoutSessionCompleted });
  info({ sessionId: checkoutSessionCompleted.id });

  // get form data from firestore
  const checkoutSession = await stripe.checkout.sessions.retrieve(checkoutSessionCompleted.id);
  info({ checkoutSession });

  // const customerEmail = checkoutSessionCompleted.customer_email ?? checkoutSessionCompleted.customer_details.email;

  const lineItems = await stripe.checkout.sessions.listLineItems(
    checkoutSessionCompleted.id
  );
  const quantity = lineItems.data[0].quantity;
  const priceId = lineItems.data[0].price!.id;
  const creditsPerUnit = creditsPerPriceId[priceId];
  const totalCreditsPurchased = quantity! * creditsPerUnit;

  console.log({ lineItems });
  console.log({ quantity });
  console.log({ priceId });
  console.log({ creditsPerUnit });

  console.log("totalCreditsPurchased: " + totalCreditsPurchased);

  await creditsRef.doc(userId).update({
    coverArtCredits: FieldValue.increment(totalCreditsPurchased),
  });
};

const _giveUserCoverArtCredits = async (userId: string, amount: number) => {
  await creditsRef.doc(userId).set({
    coverArtCredits: FieldValue.increment(amount),
  });
}

const _emailMarketingPlan = async ({
  checkoutSessionCompleteId,
  checkoutSession,
  customerEmail,
  resendApiKey,
}: {
  checkoutSessionCompleteId: string;
  checkoutSession: Stripe.Response<Stripe.Checkout.Session>;
  customerEmail: string | null;
  resendApiKey: string;
}) => {
  const resend = new Resend(resendApiKey);

  const { client_reference_id: clientReferenceId } = checkoutSession;
  if (clientReferenceId === null) {
    throw new Error("no client reference id");
  }
  info({ clientReferenceId });

  await guestMarketingPlansRef.doc(clientReferenceId).update({
    status: "processing",
  });

  const formDataRef = await marketingFormsRef.doc(clientReferenceId).get()


  const formData = formDataRef.data();
  if (!formData || !formDataRef.exists) {
    throw new Error("no form data");
  }

  info({ formData })

  // TODO: get use follower count
  // TODO: switch case for if it's a single, EP, or album
  const { content, prompt } = await generateBasicMarketingPlan({
    releaseType: formData["marketingType"],
    artistName: formData["artistName"],
    // artistGenres: formData.genre,
    // igFollowerCount,
    singleName: formData["productName"],
    aesthetic: formData["aesthetic"],
    targetAudience: formData["audience"],
    moreToCome: formData["moreToCome"] ?? "nothing",
    releaseTimeline: formData["timeline"],
    apiKey: OPEN_AI_KEY.value(),
  });

  // save marketing plan to firestore and update status to 'complete'
  await guestMarketingPlansRef.doc(clientReferenceId).update({
    status: "completed",
    checkoutSessionCompleteId,
    content,
    prompt,
  });

  // email marketing plan to user
  if (customerEmail !== null) {
    await resend.emails.send({
      from: "no-reply@tapped.ai",
      to: [
        customerEmail
      ],
      subject: "Your Marketing Plan",
      html: `<div>${marked.parse(content)}</div>`,
    });
  }
};

export const onDeleteAvatar = functions
  .firestore
  .document("avatars/{userId}/userAvatars/{avatarId}")
  .onDelete(async (data) => {
    const avatar = data.data();
    const url = avatar?.url;
    const userId = avatar?.userId;

    if (url === undefined) {
      return;
    }

    if (userId === undefined) {
      return;
    }

    await mainBucket.deleteFiles({ prefix: `images/${userId}/avatar_${data.id}.png` });
  });

export const generateAlbumName = onCall(
  {
    secrets: [ OPEN_AI_KEY ],
  },
  async (request) => {
    const oak = OPEN_AI_KEY.value();
    const {
      artistName,
      artistGenres,
      igFollowerCount,
    } = request.data;

    if (!(typeof artistName === "string") || artistName.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"artistName\".");
    }

    if (!Array.isArray(artistGenres) || artistGenres.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"artistGenres\".");
    }

    if (!(typeof igFollowerCount === "number") || artistName.length <= 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"igFollowerCount\".");
    }

    // Checking that the user is authenticated.
    if (!request.auth) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("failed-precondition", "The function must be " +
        "called while authenticated.");
    }

    const genres = artistGenres.join(", ");

    const res = await generateBasicAlbumName({
      artistName,
      artistGenres: genres,
      igFollowerCount,
      apiKey: oak,
    });
    functions.logger.log({ res });

    return res;
  });

export const createAvatarInferenceJob = onCall(
  {
    secrets: [ LEAP_API_KEY, LEAP_WEBHOOK_SECRET ]
  },
  async (request) => {
    // // Checking that the user is authenticated.
    authenticatedRequest(request);

    const leapApiKey = LEAP_API_KEY.value();
    const { modelId, prompt } = request.data;

    if (!(typeof modelId === "string") || modelId.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"modelId\".");
    }

    if (!(typeof prompt === "string") || prompt.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"avatarStyle\".");
    }

    const userId = request.auth?.uid;

    // const prompt = `8k portrait of @subject in the style of ${avatarStyle}`;
    const negativePrompt = "(deformed iris, deformed pupils, semi-realistic, cgi, 3d, render, sketch, cartoon, drawing, anime:1.4), text, close up, cropped, out of frame, worst quality, low quality, jpeg artifacts, ugly, duplicate, morbid, mutilated, extra fingers, mutated hands, poorly drawn hands, poorly drawn face, mutation, deformed, blurry, dehydrated, bad anatomy, bad proportions, extra limbs, cloned face, disfigured, gross proportions, malformed limbs, missing arms, missing legs, extra arms, extra legs, fused fingers, too many fingers, long neck";

    const { inferenceId } = await sd.createInferenceJob({
      leapApiKey,
      modelId,
      prompt,
      negativePrompt,
      numberOfImages: 4,
      webhookUrl: `${IMAGE_WEBHOOK_URL}?user_id=${userId}&model_id=${modelId}&webhook_secret=${LEAP_WEBHOOK_SECRET.value()}`,
    });
    info({ inferenceId });

    return { inferenceId };
  });

export const getAvatarInferenceJob = onCall(
  {
    secrets: [ LEAP_API_KEY ],
  },
  async (request) => {
    // Checking that the user is authenticated.
    authenticatedRequest(request);

    const leapApiKey = LEAP_API_KEY.value();
    const { inferenceId } = request.data;

    if (!(typeof inferenceId === "string") || inferenceId.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"inferenceId\".");
    }

    const { inferenceJob } = await sd.getInferenceJob({
      leapApiKey,
      inferenceId,
    });

    return { inferenceJob };
  });

export const deleteInferenceJob = functions
  .runWith({ secrets: [ LEAP_API_KEY ] })
  .https
  .onCall(
    async (request) => {
      // Checking that the user is authenticated.
      if (!request.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new HttpsError("failed-precondition", "The function must be " +
          "called while authenticated.");
      }

      const leapApiKey = LEAP_API_KEY.value();
      const { inferenceId } = request.data;

      await sd.deleteInferenceJob({ inferenceId, leapApiKey });
    });

export const imageWebhook = onRequest(
  { secrets: [ LEAP_API_KEY, LEAP_WEBHOOK_SECRET ] },
  async (request, response): Promise<void> => {
    const {
      id: inferenceId,
      state: status,
      result,
    } = request.body;

    const userId = request.query.user_id as string;
    const modelId = request.query.model_id as string;
    const webhookSecret = request.query.webhook_secret as string;

    info({ userId, status, inferenceId });

    if (!webhookSecret) {
      response.status(500).json(
        "Malformed URL, no webhook_secret detected!",
      );
      return;
    }

    if (
      webhookSecret.toLowerCase() !== LEAP_WEBHOOK_SECRET.value().toLowerCase()
    ) {
      response.status(401).json("Unauthorized!");
      return;
    }

    if (!userId) {
      response.status(500).json(
        "Malformed URL, no user_id detected!",
      );
      return;
    }

    if (!modelId) {
      response.status(500).json(
        "Malformed URL, no model_id detected!",
      );
      return;
    }

    try {
      info({ images: result.images });
      await Promise.all(
        result.images.map(async (image: any) => {
          avatarsRef.doc(userId).collection("userAvatars").add({
            modelId: modelId,
            url: image.uri,
          });
        })
      );
      response.status(200).json("Success");
    } catch (e) {
      info(e);
      response.status(500).json(
        "Something went wrong!",
      );
    }
  });

export const trainModel = onCall(
  { secrets: [ LEAP_API_KEY, LEAP_WEBHOOK_SECRET ] },
  async (request) => {
    // Checking that the user is authenticated.
    if (!request.auth) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError(
        "failed-precondition",
        "The function must be called while authenticated."
      );
    }

    const userId = request.auth.uid;
    info({ userId });
    const { imageUrls, type, name }: {
      imageUrls: string[];
      type: string;
      name: string;
    } = request.data;

    if (imageUrls?.length < 4) {
      throw new HttpsError(
        "failed-precondition",
        "Upload at least 4 sample images",
      );
    }
    info({ imageUrls, type, name });

    // eslint-disable-next-line max-len
    const fullWebhook = `${WEBHOOK_URL.valueOf()}?user_id=${userId}&webhook_secret=${LEAP_WEBHOOK_SECRET.value()}&model_type=${type}`;

    const modelId = await sd.createTrainingJob({
      leapApiKey: LEAP_API_KEY.value(),
      imageUrls,
      name,
      type,
      userId,
      webhookUrl: fullWebhook,
    });

    // add model to DB
    await aiModelsRef
      .doc(userId)
      .collection("imageModels")
      .doc(modelId)
      .set({
        id: modelId,
        user_id: userId,
        name,
        type,
        timestamp: Timestamp.now(),
        status: "training",
      });

    await Promise.all(
      imageUrls.map(async (imageUrl) => {
        // get image from url
        const imagesSnap = await trainingImagesRef
          .doc(userId)
          .collection("userSamples")
          .where("url", "==", imageUrl)
          .get();

        if (imagesSnap.empty) return;

        // update image with modelId
        await Promise.all(
          imagesSnap.docs.map(async (doc) => {
            await doc.ref.update({
              modelId: modelId,
            });
          }),
        );
      }),
    );

    return {
      success: true,
    };
  });

export const trainWebhook = onRequest(
  { secrets: [ LEAP_API_KEY, LEAP_WEBHOOK_SECRET ] },
  async (request, response): Promise<void> => {

    const { id, state: status }: {
      id: string;
      state: string;
    } = await request.body;
    const userId = request.query.user_id as string;
    const webhookSecret = request.query.webhook_secret as string;
    const modelType = request.query.model_type as string;

    info({ status, id });

    if (!webhookSecret) {
      response.status(500).json(
        "Malformed URL, no webhook_secret detected!",
      );
      return;
    }

    if (
      webhookSecret.toLowerCase() !== LEAP_WEBHOOK_SECRET.value().toLowerCase()
    ) {
      response.status(401).json("Unauthorized!");
      return;
    }

    if (!userId) {
      response.status(500).json(
        "Malformed URL, no user_id detected!",
      );
      return;
    }

    const user = await auth.getUser(userId);
    if (!user) {
      response.status(401).json(
        "User not found!",
      );
      return;
    }

    try {
      if (status === "finished") {
        await aiModelsRef
          .doc(userId)
          .collection("imageModels")
          .doc(id)
          .update({
            status: "ready",
          });


        for (let index = 0; index < prompts.length; index++) {
          const { inferenceId } = await sd.createInferenceJob({
            leapApiKey: LEAP_API_KEY.value(),
            modelId: id,
            prompt: prompts[index].replace(
              "{model_type}",
              modelType ?? ""
            ),
            negativePrompt: "(deformed iris, deformed pupils, semi-realistic, cgi, 3d, render, sketch, cartoon, drawing, anime:1.4), text, close up, cropped, out of frame, worst quality, low quality, jpeg artifacts, ugly, duplicate, morbid, mutilated, extra fingers, mutated hands, poorly drawn hands, poorly drawn face, mutation, deformed, blurry, dehydrated, bad anatomy, bad proportions, extra limbs, cloned face, disfigured, gross proportions, malformed limbs, missing arms, missing legs, extra arms, extra legs, fused fingers, too many fingers, long neck",
            numberOfImages: 0,
            webhookUrl: `${IMAGE_WEBHOOK_URL}?user_id=${userId}&model_id=${id}&webhook_secret=${LEAP_WEBHOOK_SECRET.value()}`,
          });
          info({ inferenceId });
        }
      } else {
        await aiModelsRef
          .doc(userId)
          .collection("imageModels")
          .doc(id)
          .update({
            status: "errored",
          });
      }

      response.status(200).json(
        "Success",
      );
    } catch (e) {
      info(e);
      response.status(500).json(
        "Something went wrong!",
      );
    }
  });

export const createSingleMarketingPlan = onCall(
  { secrets: [ OPEN_AI_KEY ] },
  async (request) => {
    const openAiKey = OPEN_AI_KEY.value();
    const {
      userId,
      name,
      aesthetic,
      targetAudience,
      moreToCome,
      releaseTimeline,
    } = request.data;

    info({ userId, name, aesthetic, targetAudience, moreToCome, releaseTimeline });

    const userSnapshot = await usersRef.doc(userId).get();
    if (!userSnapshot.exists) {
      throw new HttpsError("failed-precondition", `user ${userId} does not exist`);
    }

    const artistName = userSnapshot.data()?.username;
    const artistGenres = userSnapshot.data()?.genres;

    // const labelApplicationsQuery = await labelApplicationsRef.where("id", "==", userId).get();
    // if (labelApplicationsQuery.empty) {
    //   throw new HttpsError("failed-precondition", `user ${userId} does not have a label application`);
    // }

    // const igFollowerCount = labelApplicationsQuery.docs[0].data().igFollowerCount;

    const { content, prompt } = await generateSingleBasicMarketingPlan({
      artistName,
      artistGenres,
      // igFollowerCount,
      singleName: name,
      aesthetic,
      targetAudience,
      moreToCome,
      releaseTimeline,
      apiKey: openAiKey,
    });

    const uuid = uuidv4();
    const marketingPlan: MarketingPlan = {
      id: uuid,
      userId: userId,
      name: name,
      type: "single",
      content: content,
      prompt: prompt,
      timestamp: Timestamp.now(),

    };
    await marketingPlansRef
      .doc(userId)
      .collection("userMarketingPlans")
      .doc(uuid)
      .set(marketingPlan);

    return {
      content,
      prompt,
    };
  });

export const marketingPlanStripeWebhook = onRequest(
  {
    secrets: [
      stripeTestKey,
      stripeTestEndpointSecret,
      RESEND_API_KEY,
      OPEN_AI_KEY,
    ]
  },
  async (req, res) => {
    const stripe = new Stripe(stripeTestKey.value(), {
      apiVersion: "2022-11-15",
    });

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
        const checkoutSession = await stripe.checkout.sessions.retrieve(checkoutSessionCompleted.id);
        info({ checkoutSession });

        // eslint-disable-next-line no-case-declarations
        const customerEmail = checkoutSessionCompleted.customer_email ?? checkoutSessionCompleted.customer_details.email;
        await _emailMarketingPlan({
          checkoutSessionCompleteId: checkoutSessionCompleted.id,
          checkoutSession,
          customerEmail,
          resendApiKey: RESEND_API_KEY.value(),
        });
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

export const generateMarketingPlan = functions
  .runWith({
    secrets: [
      RESEND_API_KEY,
      OPEN_AI_KEY,
    ]
  })
  .firestore
  .document("marketingForms/{clientReferenceId}")
  .onCreate(
    async (request, context) => {
      const clientReferenceId = context.params.clientReferenceId;
      if (clientReferenceId === null) {
        throw new HttpsError("invalid-argument", "no client reference id");
      }
      info({ clientReferenceId });

      await guestMarketingPlansRef.doc(clientReferenceId).update({
        status: "processing",
      });

      const formDataRef = await marketingFormsRef.doc(clientReferenceId).get()


      const formData = formDataRef.data();
      if (!formData || !formDataRef.exists) {
        throw new HttpsError("failed-precondition", "no form data");
      }

      info({ formData })

      // TODO: get use follower count
      const { content, prompt } = await generateBasicMarketingPlan({
        releaseType: formData["marketingType"],
        artistName: formData["artistName"],
        // artistGenres: formData.genre,
        // igFollowerCount,
        singleName: formData["productName"],
        aesthetic: formData["aesthetic"],
        targetAudience: formData["audience"],
        moreToCome: formData["moreToCome"] ?? "nothing",
        releaseTimeline: formData["timeline"],
        apiKey: OPEN_AI_KEY.value(),
      });

      // save marketing plan to firestore and update status to 'complete'
      await guestMarketingPlansRef.doc(clientReferenceId).update({
        status: "completed",
        // checkoutSessionId: checkoutSessionCompleted.id,
        content,
        prompt,
      });
    });

export const coverArtStripeTestWebhook = onRequest(
  {
    secrets: [
      stripeTestKey,
      stripeCoverArtTestWebhookSecret,
    ]
  },
  async (req, res) => {
    const stripe = new Stripe(stripeTestKey.value(), {
      apiVersion: "2022-11-15",
    });

    info("coverArtStripeTestWebhook", req.body);
    const sig = req.headers["stripe-signature"];
    if (!sig) {
      res.status(400).send("No signature");
      return;
    }

    try {
      const event = stripe.webhooks.constructEvent(
        req.rawBody,
        sig,
        stripeCoverArtTestWebhookSecret.value(),
      );

      // Handle the event
      switch (event.type) {
      case "checkout.session.completed":
        // eslint-disable-next-line no-case-declarations
        const checkoutSessionCompleted = event.data.object as unknown as {
            id: string;
            client_reference_id: string | null;
            customer_email: string | null;
            customer_details: {
              email: string;
            }
          };

        await _incrementCoverArtTestCredits(stripe, checkoutSessionCompleted);
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

export const coverArtStripeWebhook = onRequest(
  {
    secrets: [
      stripeKey,
      stripeCoverArtWebhookSecret,
    ]
  },
  async (req, res) => {
    const stripe = new Stripe(stripeKey.value(), {
      apiVersion: "2022-11-15",
    });

    info("coverArtStripeWebhook", req.body);
    const sig = req.headers["stripe-signature"];
    if (!sig) {
      res.status(400).send("No signature");
      return;
    }

    try {
      const event = stripe.webhooks.constructEvent(
        req.rawBody,
        sig,
        stripeCoverArtWebhookSecret.value(),
      );

      // Handle the event
      switch (event.type) {
      case "checkout.session.completed":
        // eslint-disable-next-line no-case-declarations
        const checkoutSessionCompleted = event.data.object as unknown as {
            id: string;
            client_reference_id: string | null;
            customer_email: string | null;
            customer_details: {
              email: string;
            }
          };
        await _incrementCoverArtCredits(stripe, checkoutSessionCompleted);
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

export const generateEnhancedBio = onCall(
  { secrets: [ OPEN_AI_KEY ] },
  async (request) => {
    authenticatedRequest(request);
    // pull artist data
    const userId = request.auth?.uid;
    if (userId === undefined) {
      throw new HttpsError("unauthenticated", "user is not authenticated");
    }

    const userSnapshot = await usersRef.doc(userId).get();
    const userData = userSnapshot.data() as UserModel;

    const displayName = userData?.artistName ?? userData?.username ?? "";
    const twitterHandle = userData?.twitterHandle ?? "";
    const tiktokHandle = userData?.tiktokHandle ?? "";
    const instagramHandle = userData?.instagramHandle ?? "";
    const artistGenres = userData?.genres ?? [];

    const openAiKey = OPEN_AI_KEY.value();
    const { content } = await basicEnhancedBio({
      apiKey: openAiKey,
      artistName: displayName,
      twitterHandle,
      tiktokHandle,
      instagramHandle,
      artistGenres,
    });

    return {
      enhancedBio: content,
    };
  });

export const giveUserCoverArtCreditsOnCreate = functions
  .auth
  .user()
  .onCreate(async (user) => {
    await _giveUserCoverArtCredits(user.uid, 15);
  });

export const notifyFoundersOnMarketingForm = functions
  .firestore
  .document("marketingForm/{formId}")
  .onCreate(async (snapshot) => {
    const form = snapshot.data();

    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: "New Marketing Form \uD83D\uDE43",
        body: `${form.artistName} just created a marketing plan`,
      }
    };

    fcm.sendToDevice(devices, payload);
  });

export const notifyFoundersOnGuestMarketingPlan = functions
  .firestore
  .document("guestMarketingPlans/{planId}")
  .onCreate(async () => {
    const devices = await getFoundersDeviceTokens();
    const payload = {
      notification: {
        title: "New Marketing Plan \uD83D\uDE43",
        body: "Someone just created a marketing plan",
      }
    };

    fcm.sendToDevice(devices, payload);
  });
