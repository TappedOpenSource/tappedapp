
import { OpenAI } from "langchain/llms/openai";
import { PromptTemplate } from "langchain/prompts";
import { LLMChain } from "langchain/chains";
import { ChainValues } from "langchain/dist/schema";

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
const ALBUM_NAME_TEMPLATE = `Create an album name for {ARTIST_NAME}
who makes {ARTIST_GENRES} music 
and has {IG_FOLLOWER_COUNT} followers.`;

export const llm = {
  generateAlbumName: async ({
    artistName,
    artistGenres,
    igFollowerCount,
    apiKey,
  }: {
    artistName: string;
    artistGenres: string;
    igFollowerCount: number;
    apiKey: string;
}): Promise<ChainValues> => {
    process.env.OPENAI_API_KEY = apiKey;

    const model = new OpenAI({ temperature: 0 });
    const prompt = new PromptTemplate({
      inputVariables: [
        "ARTIST_NAME",
        "ARTIST_GENRES",
        "IG_FOLLOWER_COUNT",
      ],
      template: ALBUM_NAME_TEMPLATE,
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

    return res;
  },
};
