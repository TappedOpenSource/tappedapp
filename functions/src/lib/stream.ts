
import { StreamChat } from "stream-chat";
import * as functions from "firebase-functions";
import { streamKey, streamSecret } from "./firebase";

const _introMessage = async (
  streamClient: StreamChat,
  newUserId: string,
) => {
  const johannesId = "8yYVxpQ7cURSzNfBsaBGF7A7kkv2";
  const token = await streamClient.createToken(johannesId);
  await streamClient.connectUser({
    id: johannesId,
  }, token);

  // join channel
  const channel = streamClient.channel("messaging", {
    members: [ johannesId, newUserId ],
  });
  await channel.create();

  // post msg
  await channel.sendMessage({ 
    text: "welcome to tapped!",
  });
  await channel.sendMessage({ 
    text: "I work with the engineering team so if you have any ideas on how to make the app better lemme know and I can send it to them",
  });

  // disconnectUser
  await streamClient.disconnectUser();
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

    const user = snapshot.data();
    await streamClient.upsertUser({
      id: user.id,
      name: user.artistName,
      username: user.username,
      email: user.email,
      image: user.profilePicture,
    });

    // intro msg from me
    await _introMessage(streamClient, userId);
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