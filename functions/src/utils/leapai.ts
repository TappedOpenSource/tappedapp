
import { Leap } from "@leap-ai/sdk";
import * as logger from "firebase-functions/logger";

const sd = {
  createInferenceJob: async ({
    leapApiKey,
    modelId,
    prompt,
  }: {
    leapApiKey: string;
    modelId: string;
    prompt: string;
}): Promise<{ inferenceId: string }> => {
    logger.log(`Generating text ${prompt}`);
    const leap = new Leap(leapApiKey);

    const { data, error } = await leap.generate.createInferenceJob({
      modelId: modelId,
      prompt: prompt,
    });

    if (data === null) {
      logger.error(`Error generating text: ${error}`);
      throw new Error(error);
    }

    return { inferenceId: data.id };
  },

  getInferenceJob: async ({
    leapApiKey,
    inferenceId,
  }: {
    leapApiKey: string;
        inferenceId: string;
}): Promise<{ imageUrls: string[] }> => {
    const leap = new Leap(leapApiKey);
    const { data, error } = await leap.generate.getInferenceJob({
      inferenceId: inferenceId,
    });

    if (data === null) {
      logger.error(`Error getting inference job: ${error}`);
      throw new Error(error);
    }

    const images = data.images;
    const imageUrls = images.map((image) => image.uri);

    return { imageUrls };
  },

  deleteInferenceJob: async ({
    leapApiKey,
    inferenceId,
  }: {
    leapApiKey: string;
    inferenceId: string;
}) => {
    const leap = new Leap(leapApiKey);
    const { data, error } = await leap.generate.deleteInference({
      inferenceId: inferenceId,
    });

    if (data === null) {
      logger.error(`Error deleting inference job: ${error}`);
      throw new Error(error);
    }
  },

};

export default sd;
