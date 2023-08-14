
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall, onRequest } from "firebase-functions/v2/https";
import {
  onDocumentCreated,
} from "firebase-functions/v2/firestore";

import { defineSecret } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";

import { Leap, ModelSubjectTypesEnum } from "@leap-ai/sdk";

import llm from "./utils/openai";
import sd from "./utils/leapai";


const app = initializeApp();
const db = getFirestore(app);

// const avatarsRef = db.collection('avatars');
const generatorsRef = db.collection("generators");

const WEBHOOK_URL = "https://us-central1-in-the-loop-306520.cloudfunctions.net/onTrainingJobCompletedWebhook";

const OPEN_AI_KEY = defineSecret("OPEN_AI_KEY");
const LEAP_API_KEY = defineSecret("LEAP_API_KEY");

// const AVATAR_PROMPT = '';
// const STAGE_PHOTOS_PROMPT = '';
// const ALBUM_ART_PROMPT = '';

// const MARKETING_PLAN_TEMPLATE = `
// You will now assume the role of a manager at a
// record label and create branding for an artist
// that we want to become more well known.
// Your role is to create branding, marketing strategy,
// and social media direction.
// In this specific example you will be working
// for an artist named {ARTIST_NAME}.
// Her biggest genres are {ARTIST_GENRES}.
// She's currently has {IG_FOLLOWER_COUNT} followers on social media,
// and mainly posts content about her lifestyle, time touring,
// snippets, and about her personality. Her main advantage
// and selling point is that she's great at live performances
// and has lots of energy.
// Create a detailed report that will essentially
// be a blue print for her career.
// `;

// const BRANDING_GUIDANCE_TEMPLATE = '';
// const SOCIAL_BIO_TEMPLATE = '';
const ALBUM_NAME_TEMPLATE = "";

export const onGeneratorCreated = onDocumentCreated(
  {
    document: "/generators/{generatorId}",
    secrets: [ LEAP_API_KEY ],
  },
  async (event) => {
    const { generatorId } = event.params;
    const data = event.data?.data();
    if (data == null) {
      return;
    }

    const { userId, referenceImages } = data;

    // create LeapAI job
    const leapApiKey = LEAP_API_KEY.value();
    const leap = new Leap(leapApiKey);
    const { data: modelSchema, error: error1 } = await leap
      .fineTune
      .createModel({
        title: `sd/${userId}/${generatorId}`,
        subjectKeyword: "@subject",
        subjectType: ModelSubjectTypesEnum.PERSON,
      });
    if (modelSchema == null) {
      logger.error(error1);
      await generatorsRef
        .doc(generatorId)
        .update({ sdModelStatus: "errored" });
      return;
    }

    // Save model id to firestore
    const model = await modelSchema;
    const modelId = model.id;
    await generatorsRef
      .doc(generatorId)
      .update({ sdModelId: modelId });

    // upload images to leapai
    const { data: sampleSchema, error: error2 } = await leap
      .fineTune
      .uploadImageSamples({
        modelId,
        images: referenceImages,
      });
    if (sampleSchema == null) {
      logger.error(error2);
      await generatorsRef
        .doc(generatorId)
        .update({ sdModelStatus: "errored" });
      return;
    }

    // queue training job
    const samples = await sampleSchema;
    logger.debug(`samples: ${JSON.stringify(samples)}`);
    const { data: versionSchema, error: error3 } = await leap
      .fineTune
      .queueTrainingJob({
        modelId,
        webhookUrl: WEBHOOK_URL,
      });
    if (versionSchema == null) {
      logger.error(error3);
      await generatorsRef
        .doc(generatorId)
        .update({ sdModelStatus: "errored" });
      return;
    }
    const version = await versionSchema;
    logger.debug(`version: ${JSON.stringify(version)}`);

    // change generator sfModel to "training"
    await generatorsRef
      .doc(generatorId)
      .update({ sdModelStatus: "training" });
  });

export const onTrainingJobCompletedWebhook = onRequest(
  async (req) => {
    // get model id from request
    const { id, state } = req.body;

    // update firestore if error
    if (state !== "finished") {
      logger.error(`training job ${id} failed with state ${state}`);
      return;
    }

    // update firestore if success
    logger.debug(`training job ${id} finished with state ${state}`);
    const generatorSnapshot = await generatorsRef.where("sdModelId", "==", id).get();
    if (generatorSnapshot.docs.length <= 0) {
      logger.error(`no generator found with sdModelId ${id}`);
      return;
    }

    const generator = generatorSnapshot.docs[0];
    await generator.ref.update({ sdModelStatus: "ready" });
  });

export const generateAlbumName = onCall(
  { secrets: [ OPEN_AI_KEY ] },
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

    const res = await llm.generateAlbumName({
      artistName,
      artistGenres: genres,
      igFollowerCount,
      apiKey: oak,
      template: ALBUM_NAME_TEMPLATE,
    });

    return res;
  });

export const createAvatarInferenceJob = onCall(
  { secrets: [ LEAP_API_KEY ] },
  async (request) => {
    // Checking that the user is authenticated.
    if (!request.auth) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("failed-precondition", "The function must be " +
        "called while authenticated.");
    }

    const leapApiKey = LEAP_API_KEY.value();
    const { modelId, avatarStyle } = request.data;

    if (!(typeof modelId === "string") || modelId.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"modelId\".");
    }

    if (!(typeof avatarStyle === "string") || avatarStyle.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"avatarStyle\".");
    }

    const prompt = `@subject is a ${avatarStyle} avatar.`;

    const { inferenceId } = await sd.createInferenceJob({
      leapApiKey,
      modelId,
      prompt,
    });

    return { inferenceId, prompt };
  });

export const getAvatarInferenceJob = onCall(
  { secrets: [ LEAP_API_KEY ] },
  async (request) => {
    // Checking that the user is authenticated.
    if (!request.auth) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("failed-precondition", "The function must be " +
        "called while authenticated.");
    }

    const leapApiKey = LEAP_API_KEY.value();
    const { inferenceId } = request.data;

    if (!(typeof inferenceId === "string") || inferenceId.length === 0) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("invalid-argument", "The function must be called " +
        "with argument \"inferenceId\".");
    }

    const { imageUrls } = await sd.getInferenceJob({
      leapApiKey,
      inferenceId,
    });

    return { imageUrls };
  });

export const deleteInferenceJob = onCall(
  { secrets: [ LEAP_API_KEY ] },
  async (request) => {
    // Checking that the user is authenticated.
    if (!request.auth) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError("failed-precondition", "The function must be " +
        "called while authenticated.");
    }

    const leapApiKey = LEAP_API_KEY.value();
    const { inferenceId } = request.data;

    await sd.deleteInferenceJob({
      leapApiKey,
      inferenceId,
    });
  });
