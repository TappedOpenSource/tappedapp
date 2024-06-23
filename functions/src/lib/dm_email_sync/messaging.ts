import { Channel, StreamChat } from "stream-chat";

export async function dmAutoReply({
  streamClient,
  venueId,
  userId,
  autoReply,
}: {
  streamClient: StreamChat;
  venueId: string;
  userId: string;
  autoReply: string | null;
}): Promise<void> {
  const defaultReply = `
  Hey! Thanks for reaching out. We'll reach back out to you soon
`
  const text = autoReply ?? defaultReply;

  await sendStreamMessage({
    streamClient,
    receiverId: venueId,
    senderId: userId,
    message: text,
    freeze: true,
  });
}

export async function sendStreamMessage({
  streamClient,
  receiverId,
  senderId,
  message,
  freeze = false,
}: {
  streamClient: StreamChat;
  receiverId: string;
  senderId: string;
  message: string;
  freeze?: boolean;
}): Promise<Channel> {

  // join channel
  const channel = streamClient.channel("messaging", {
    members: [ receiverId, senderId ],
    created_by_id: senderId,
  });
  await channel.create();

  await channel.sendMessage({
    text: message,
    user_id: senderId,
  });

  if (freeze) {
    const channelSnap = await channel.query({});
    const isNew = channelSnap.channel.last_message_at === null;
    if (isNew) {
      await channel.updatePartial({
        set: { frozen: true },
      });
    }
  } else {
    await channel.updatePartial({
      set: { frozen: false },
    });
  }

  return channel;
}

