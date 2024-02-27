
import { OpenAI, ChatOpenAI } from "@langchain/openai";
import { PromptTemplate } from "@langchain/core/prompts";
import { LLMChain } from "langchain/chains";
import { HumanMessage } from "@langchain/core/messages";

// const AVATAR_PROMPT = '';
// const STAGE_PHOTOS_PROMPT = '';
// const ALBUM_ART_PROMPT = '';

const SINGLE_MARKETING_PLAN_TEMPLATE = `
Please provide a detailed marketing strategy report for promoting {ARTIST_NAME}'s 
new single. You are assuming the role of a marketing manager at a independent 
record label and your conversational tone will be in spartan you 
will not use corporate jargon. The goal is to achieve impressive 
traction and grow a loyal fanbase. Include creative and 
cost-effective strategies promotion report.Your goal is 
to create a hyper specific marketing report for an artist 
whos releasing is a single coming out on {RELEASE_TIMELINE}. 
In this specific example you will be working for an artist 
named {ARTIST_NAME}. Their biggest genres are {ARTIST_GENRES} 
and the aesthetic of the single is {AESTHETIC}.
Finally, this single is leading to {MORE_TO_COME}.'
`;

const MARKETING_PLAN_TEMPLATE = `
Please provide a detailed marketing strategy report for promoting {ARTIST_NAME}'s 
new {RELEASE_TYPE}. You are assuming the role of a marketing manager at a independent 
record label and your conversational tone will be in spartan you 
will not use corporate jargon. The goal is to achieve impressive 
traction and grow a loyal fanbase. Include creative and 
cost-effective strategies promotion report.Your goal is 
to create a hyper specific marketing report for an artist 
whos releasing is a {RELEASE_TYPE} coming out on {RELEASE_TIMELINE}. 
In this specific example you will be working for an artist 
named {ARTIST_NAME}. The aesthetic of the single is {AESTHETIC}.
Finally, this {RELEASE_TYPE} is leading to {MORE_TO_COME}.


Format the response to be in markdown format.
`;

// const BRANDING_GUIDANCE_TEMPLATE = '';
// const SOCIAL_BIO_TEMPLATE = '';

const ENHANCE_BIO_TEMPLATE = `Create a concise and engaging artist 
biography for {ARTIST_NAME}. 
Highlight their unique style, achievements, 
and what sets them apart in the music industry. 
Use the information provided, social media handles (if applicable
  twitter handle: {TWITTER_HANDLE},
  instagram handle: {INSTAGRAM_HANDLE},
  tiktok handle: {TIKTOK_HANDLE} 
), 
genre ({ARTIST_GENRES}), and any outstanding accomplishments, to craft a compelling two-paragraph 
artist introduction. Remember to keep it captivating and suitable for press and 
promotional materials. It should be no more than 100 words`


export const llm = async (template: string, apiKey: string, options?: {
    temperature?: number;
}): Promise<string> => {
  process.env.OPENAI_API_KEY = apiKey;

  const prompt = PromptTemplate.fromTemplate(template);
  const llm = new OpenAI(options)
  const llmChain = new LLMChain({
    llm,
    prompt,
  })

  const res = await llmChain.invoke({});

  return res.text;
}

export const chatGpt = async (
  prompt: string,
  options?: {
    model?: string;
    temperature?: number;
  },
): Promise<string> => {
  const modelName = options?.model ?? "gpt-4-1106-preview";
  const model = new ChatOpenAI({
    modelName,
    ...options,
  });

  const message = new HumanMessage({
    content: [
      {
        type: "text",
        text: prompt,
      },
    ],
  });

  const res = await model.invoke([ message ]);

  const result = res.content.toString();

  return result;
};

export async function generateBasicMarketingPlan({
  releaseType,
  singleName,
  aesthetic,
  releaseTimeline,
  moreToCome,
  targetAudience,
  artistName,
  // artistGenres,
  // igFollowerCount,
  apiKey, 
}: {
    releaseType: string;
    singleName: string;
    aesthetic: string;
    releaseTimeline: string;
    moreToCome: string;
    targetAudience: string;
    artistName: string;
    // artistGenres: string;
    // igFollowerCount: number;
    apiKey: string;
  }): Promise<{ content: string; prompt: string; }> {
  process.env.OPENAI_API_KEY = apiKey;

  const model = new ChatOpenAI({});
  const prompt = new PromptTemplate({
    inputVariables: [
      "SINGLE_NAME",
      "AESTHETIC",
      "RELEASE_TIMELINE",
      "MORE_TO_COME",
      "TARGET_AUDIENCE",
      "ARTIST_NAME",
      // "ARTIST_GENRES",
      "RELEASE_TYPE",
      // "IG_FOLLOWER_COUNT",
    ],
    template: MARKETING_PLAN_TEMPLATE,
  });

  const chain = prompt.pipe(model);

  const res = await chain.invoke({
    RELEASE_TYPE: releaseType,
    SINGLE_NAME: singleName,
    AESTHETIC: aesthetic,
    RELEASE_TIMELINE: releaseTimeline,
    MORE_TO_COME: moreToCome,
    TARGET_AUDIENCE: targetAudience,
    ARTIST_NAME: artistName,
    // ARTIST_GENRES: artistGenres,
    // IG_FOLLOWER_COUNT: igFollowerCount,
  });

  const formatted = await prompt.format({
    RELEASE_TYPE: releaseType,
    SINGLE_NAME: singleName,
    AESTHETIC: aesthetic,
    RELEASE_TIMELINE: releaseTimeline,
    MORE_TO_COME: moreToCome,
    TARGET_AUDIENCE: targetAudience,
    ARTIST_NAME: artistName,
    // ARTIST_GENRES: artistGenres,
    // IG_FOLLOWER_COUNT: igFollowerCount,
  });

  const content = res.content.toString();

  return {
    content: content,
    prompt: formatted,
  }
}

export async function generateSingleBasicMarketingPlan({
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
  }): Promise<{ content: string; prompt: string; }> {
  process.env.OPENAI_API_KEY = apiKey;

  const model = new ChatOpenAI({});
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

  const chain = prompt.pipe(model);

  const res = await chain.invoke({
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
}

export async function basicEnhancedBio({
  artistName,
  twitterHandle,
  instagramHandle,
  tiktokHandle,
  artistGenres,
  apiKey,
}: {
    artistName: string;
    twitterHandle: string;
    instagramHandle: string;
    tiktokHandle: string;
    artistGenres: Array<string>;
    apiKey: string;
  }): Promise<{ content: string; prompt: string; }> {
  process.env.OPENAI_API_KEY = apiKey;

  const model = new ChatOpenAI({});
  const prompt = new PromptTemplate({
    inputVariables: [
      "ARTIST_NAME",
      "TIKTOK_HANDLE",
      "TWITTER_HANDLE",
      "INSTAGRAM_HANDLE",
      "ARTIST_GENRES",
    ],
    template: ENHANCE_BIO_TEMPLATE,
  });

  const chain = prompt.pipe(model);

  const res = await chain.invoke({
    ARTIST_NAME: artistName,
    TWITTER_HANDLE: twitterHandle,
    INSTAGRAM_HANDLE: instagramHandle,
    TIKTOK_HANDLE: tiktokHandle,
    ARTIST_GENRES: artistGenres.join(", ")
  });

  const formatted = await prompt.format({
    ARTIST_NAME: artistName,
    TWITTER_HANDLE: twitterHandle,
    INSTAGRAM_HANDLE: instagramHandle,
    TIKTOK_HANDLE: tiktokHandle,
    ARTIST_GENRES: artistGenres.join(", ")
  });

  const content = res.content.toString();

  return {
    content,
    prompt: formatted,
  }
}
