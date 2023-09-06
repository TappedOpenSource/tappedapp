
import { Leap } from "@leap-ai/sdk";
import { LeapInferenceSchema } from "@leap-ai/sdk/dist/types/schemas/Inference";

export const sd = {
  createInferenceJob: async ({
    leapApiKey,
    modelId,
    prompt,
    negativePrompt,
  }: {
    leapApiKey: string;
    modelId: string;
    prompt: string;
    negativePrompt: string;
}): Promise<{ inferenceId: string }> => {
    const leap = new Leap(leapApiKey);

    const { data, error } = await leap.generate.createInferenceJob({
      modelId,
      prompt,
      negativePrompt,
      width: 512,
      height: 512,
      numberOfImages: 4,
    });

    if (data === null) {
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
}): Promise<{ inferenceJob: LeapInferenceSchema }> => {
    const leap = new Leap(leapApiKey);
    const { data, error } = await leap.generate.getInferenceJob({
      inferenceId: inferenceId,
    });

    if (data === null) {
      throw new Error(error);
    }

    return { inferenceJob: data };
  },

  deleteInferenceJob: async ({
    leapApiKey,
    inferenceId,
  }: {
    leapApiKey: string;
    inferenceId: string;
}): Promise<void> => {
    const leap = new Leap(leapApiKey);
    const { data, error } = await leap.generate.deleteInference({
      inferenceId: inferenceId,
    });

    if (data === null) {
      throw new Error(error);
    }
  },
};
