/* eslint-disable import/no-unresolved */
import { HttpsError, onCall, onRequest } from "firebase-functions/v2/https";
import { SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET } from "./firebase";
import { info } from "firebase-functions/logger";
import SpotifyWebApi from "spotify-web-api-node";
import cookieParser from "cookie-parser";
import * as crypto from "crypto";

// Scopes to request.
const OAUTH_SCOPES = [ "user-read-email" ];

/**
 * Redirects the User to the Spotify authentication consent screen. Also the 'state' cookie is set for later state
 * verification.
 */
export const spotifyRedirect = onRequest(
  { secrets: [ SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET ] },
  (req, res) => {
    const spotifyClient = new SpotifyWebApi({
      clientId: SPOTIFY_CLIENT_ID.value(),
      clientSecret: SPOTIFY_CLIENT_SECRET.value(),
      redirectUri: "https://tapped.ai/spotify",
    });


    cookieParser()(req, res, () => {
      const state = req.cookies.state || crypto.randomBytes(20).toString("hex");
      info("Setting verification state:", state);
      res.cookie("state", state.toString(), { maxAge: 3600000, secure: true, httpOnly: true });
      const authorizeURL = spotifyClient.createAuthorizeURL(OAUTH_SCOPES, state.toString());
      res.redirect(authorizeURL);
    });
  });

/**
 * Exchanges a given Spotify auth code passed in the 'code' URL query parameter for a Firebase auth token.
 * The request also needs to specify a 'state' query parameter which will be checked against the 'state' cookie.
 * The Firebase custom auth token is sent back in a JSONP callback function with function name defined by the
 * 'callback' query parameter.
 */
export const spotifyAuthorizeCodeGrant = onCall(
  { secrets: [ SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET ] },
  async (request) => {
    // Checking that the user is authenticated.
    if (!request.auth) {
      // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError(
        "failed-precondition",
        "The function must be " + "called while authenticated."
      );
    }


    const spotifyClient = new SpotifyWebApi({
      clientId: SPOTIFY_CLIENT_ID.value(),
      clientSecret: SPOTIFY_CLIENT_SECRET.value(),
      redirectUri: "https://tapped.ai/spotify",
    });

    const { code } = request.data as { code: string };
    info("received auth code:", code);

    if (typeof code !== "string") {
      throw new Error("No auth code");
    }

    const res = await spotifyClient.authorizationCodeGrant(code);
    const body = res.body;

    const accessToken = body["access_token"];
    const refreshToken = body["refresh_token"];

    info(
      "received access token:",
      accessToken,
    );
    spotifyClient.setAccessToken(accessToken);

    return {
      accessToken: accessToken,
      refreshToken: refreshToken,
    };
  });
