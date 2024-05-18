
import { StreamChat } from "stream-chat";
import * as functions from "firebase-functions";
import { streamKey, streamSecret } from "./firebase";
import type { UserModel } from "../types/models";

const _introMessage = async (
  streamClient: StreamChat,
  newUserId: string,
) => {
  const johannesId = "8yYVxpQ7cURSzNfBsaBGF7A7kkv2";
  const iliasId = "n4zIL6bOuPTqRC3dtsl6gyEBPQl1";

  const channel = streamClient.channel("messaging", {
    members: [ johannesId, newUserId ],
    created_by_id: johannesId,
  });
  await channel.create();

  // post msg
  await channel.sendMessage({ 
    text: "welcome to tapped!",
    user_id: johannesId,
  });
  await channel.sendMessage({ 
    text: "I work with the engineering team so if you have any ideas on how to make the app better lemme know and I can send it to them",
    user_id: johannesId,
  });

  const iliasChannel = streamClient.channel("messaging", {
    members: [ iliasId, newUserId ],
    created_by_id: iliasId,
  });

  await iliasChannel.create();
  await iliasChannel.sendMessage({ 
    text: "welcome to the app! how did you find out about us?",
    user_id: iliasId,
  });
}

export const createStreamUserOnUserCreated = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .firestore
  .document("users/{userId}")
  .onCreate(async (snapshot) => {
    const userId = snapshot.id;
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );

    const user = snapshot.data() as UserModel;
    if (!user.unclaimed) {
      await streamClient.upsertUser({
        id: user.id,
        name: user.artistName,
        username: user.username,
        email: user.email,
        image: user.profilePicture,
      });

      await _introMessage(streamClient, userId);
    }
  });

export const updateStreamUserOnUserUpdate = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .firestore
  .document("users/{userId}")
  .onUpdate(async (snapshot) => {
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );

    const user = snapshot.after.data();
    streamClient.partialUpdateUser({
      id: user.id,
      set: {
        name: user.artistName,
        username: user.username,
        email: user.email,
        image: user.profilePicture,
      },
    });
  });

export const deleteStreamUser = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .auth
  .user()
  .onDelete((user) => {
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );
    return streamClient.deleteUser(user.uid);
  });