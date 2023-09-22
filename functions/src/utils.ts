import type { CallableContext } from "firebase-functions/v1/https";
import type { CallableRequest } from "firebase-functions/v2/https";
import { HttpsError } from "firebase-functions/v2/https";
import { tokensRef } from "./firebase";

const founderIds = [
  "8yYVxpQ7cURSzNfBsaBGF7A7kkv2", // Johannes
  "n4zIL6bOuPTqRC3dtsl6gyEBPQl1", // Ilias
];

export const getFileFromURL = (fileURL: string): string => {
  const fSlashes = fileURL.split("/");
  const fQuery = fSlashes[fSlashes.length - 1].split("?");
  const segments = fQuery[0].split("%2F");
  const fileName = segments.join("/");

  return fileName;
};

export const getFoundersDeviceTokens = async (): Promise<string[]> => {
  const deviceTokens = (
    await Promise.all(
      founderIds.map(
        async (founderId) => {

          const querySnapshot = await tokensRef
            .doc(founderId)
            .collection("tokens")
            .get();

          const tokens: string[] = querySnapshot.docs.map((snap) => snap.id);

          return tokens;
        })
    )
  ).flat();

  return deviceTokens;
}

export const authenticated = (context: CallableContext): void => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new HttpsError(
      "failed-precondition",
      "The function must be called while authenticated."
    );
  }
};

export const authenticatedRequest = (request: CallableRequest): void => {
  // Checking that the user is authenticated.
  if (!request.auth) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new HttpsError(
      "failed-precondition",
      "The function must be called while authenticated."
    );
  }
};

