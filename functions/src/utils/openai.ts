
import * as functions from "firebase-functions";
import { OpenAI } from "langchain/llms/openai";
import { PromptTemplate } from "langchain/prompts";
import { LLMChain } from "langchain/chains";
import { ChainValues } from "langchain/dist/schema";


const llm = {
  generateAlbumName: async ({
    artistName,
    artistGenres,
    igFollowerCount,
    apiKey,
    template,
  }: {
    artistName: string;
    artistGenres: string;
    igFollowerCount: number;
    apiKey: string;
    template: string;
}): Promise<ChainValues> => {
    process.env.OPENAI_API_KEY = apiKey;

    const model = new OpenAI({ temperature: 0 });
    const prompt = new PromptTemplate({
      inputVariables: [
        "ARTIST_NAME",
        "ARTIST_GENRES",
        "IG_FOLLOWER_COUNT",
      ],
      template,
    });

    const chain = new LLMChain({
      llm: model,
      prompt: prompt,
    });

    const res = await chain.call({
      ARTIST_NAME: artistName,
      ARTIST_GENRES: artistGenres,
      IG_FOLLOWER_COUNT: igFollowerCount,
    });
    functions.logger.log({ res });

    return res;
  },
};

export default llm;
