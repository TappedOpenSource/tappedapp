import { StreamChat } from "stream-chat";

const PREMIUM_CHAT_CHANNEL_ID = "tapped-promoter-chat";

export async function addUserToPremiumChat(userId: string, {
  streamKey, streamSecret
}: {
    streamKey: string;
    streamSecret: string;
}): Promise<void> {
  const streamClient = StreamChat.getInstance(streamKey, streamSecret);
  const channel = streamClient.channel("messaging", PREMIUM_CHAT_CHANNEL_ID);

  await channel.addMembers([ userId ]);
}

export async function removeUserFromPremiumChat(userId: string, {
  streamKey, streamSecret
}: {
      streamKey: string;
      streamSecret: string;
  }): Promise<void>  {
  const streamClient = StreamChat.getInstance(streamKey, streamSecret);
  const channel = streamClient.channel("messaging", PREMIUM_CHAT_CHANNEL_ID);

  await channel.removeMembers([ userId ]);
}