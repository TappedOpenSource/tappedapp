/* eslint-disable import/no-unresolved */
import { Leap } from "@leap-ai/sdk";
import { LeapInferenceSchema } from "@leap-ai/sdk/dist/types/schemas/Inference";
import { info } from "firebase-functions/logger";
import { HttpsError } from "firebase-functions/v1/auth";

export const sd = {
  createTrainingJob: async ({
    leapApiKey,
    imageUrls,
    name,
    type,
    webhookUrl,
  }: {
    leapApiKey: string;
    imageUrls: string[];
    name: string;
    type: string;
    userId: string;
    webhookUrl: string;
  }): Promise<string> => {
    const formData = new FormData();
    imageUrls.forEach((image) => {
      formData.append("imageSampleUrls", image);
    });
    
    formData.append(
      "webhookUrl",
      webhookUrl,
    );
    
    formData.append("name", name);
    formData.append("subjectType", type);
    formData.append("subjectKeyword", "@subject");
    
    const options = {
      method: "POST",
      headers: {
        accept: "application/json",
        Authorization: `Bearer ${leapApiKey}`,
      },
      body: formData,
    };
    const resp = await fetch(
      "https://api.tryleap.ai/api/v2/images/models/new",
      options
    );
    
    const { status, statusText } = resp;
    const body = (await resp.json()) as {
          id: string;
          imageSamples: string[];
        };

    info({ status, statusText, body });
    
    if (body.id === undefined) {
      throw new HttpsError(
        "internal",
        "the model id is undefined",
      );
    }
    
    return body.id;
  },
  createInferenceJob: async ({
    leapApiKey,
    modelId,
    prompt,
    negativePrompt,
    numberOfImages,
    webhookUrl,
  }: {
    leapApiKey: string;
    modelId: string;
    prompt: string;
    negativePrompt: string;
    numberOfImages: number;
    webhookUrl?: string;
}): Promise<{ inferenceId: string }> => {
    const leap = new Leap(leapApiKey);

    const { data, error } = await leap.generate.createInferenceJob({
      modelId,
      prompt,
      negativePrompt,
      width: 512,
      height: 512,
      numberOfImages,
      webhookUrl,
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
