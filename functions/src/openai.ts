
import { OpenAI } from "langchain/llms/openai";
import { PromptTemplate } from "langchain/prompts";
import { LLMChain } from "langchain/chains";
import { ChainValues } from "langchain/dist/schema";

// const AVATAR_PROMPT = '';
// const STAGE_PHOTOS_PROMPT = '';
// const ALBUM_ART_PROMPT = '';

const SINGLE_MARKETING_PLAN_TEMPLATE = `
You will now assume the role of a manager at a
record label and create branding for an artist
that we want to become more well known.
Your role is to create branding, marketing strategy,
and social media direction for their new single called
{SINGLE_NAME} coming out {RELEASE_TIMELINE}.
In this specific example you will be working
for an artist named {ARTIST_NAME}.
Their biggest genres are {ARTIST_GENRES} and the aesthetic
of the single is {AESTHETIC}.
Finally, this single is leading to {MORE_TO_COME}.
`;

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
  generateSingleMarketingPlan: async ({
    singleName,
    aesthetic,
    releaseTimeline,
    moreToCome,
    targetAudience,
    artistName,
    artistGenres,
    // igFollowerCount,
    apiKey, 
  }: {
    singleName: string;
    aesthetic: string;
    releaseTimeline: string;
    moreToCome: string;
    targetAudience: string;
    artistName: string;
    artistGenres: string;
    // igFollowerCount: number;
    apiKey: string;
  }): Promise<{ content: string; prompt: string; }> => {
    process.env.OPENAI_API_KEY = apiKey;

    const model = new OpenAI({ temperature: 0 });
    const prompt = new PromptTemplate({
      inputVariables: [
        "SINGLE_NAME",
        "AESTHETIC",
        "RELEASE_TIMELINE",
        "MORE_TO_COME",
        "TARGET_AUDIENCE",
        "ARTIST_NAME",
        "ARTIST_GENRES",
        // "IG_FOLLOWER_COUNT",
      ],
      template: SINGLE_MARKETING_PLAN_TEMPLATE,
    });

    const chain = new LLMChain({
      llm: model,
      prompt: prompt,
    });

    const res = await chain.call({
      SINGLE_NAME: singleName,
      AESTHETIC: aesthetic,
      RELEASE_TIMELINE: releaseTimeline,
      MORE_TO_COME: moreToCome,
      TARGET_AUDIENCE: targetAudience, 
      ARTIST_NAME: artistName,
      ARTIST_GENRES: artistGenres,
      // IG_FOLLOWER_COUNT: igFollowerCount,
    });

    const formatted = await prompt.format({
      SINGLE_NAME: singleName,
      AESTHETIC: aesthetic,
      RELEASE_TIMELINE: releaseTimeline,
      MORE_TO_COME: moreToCome,
      TARGET_AUDIENCE: targetAudience, 
      ARTIST_NAME: artistName,
      ARTIST_GENRES: artistGenres,
      // IG_FOLLOWER_COUNT: igFollowerCount,
    });

    return {
      content: res.text,
      prompt: formatted,
    }
  },
};
