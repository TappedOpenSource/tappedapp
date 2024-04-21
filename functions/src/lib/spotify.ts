/* eslint-disable import/no-unresolved */
import { HttpsError, onCall, onRequest } from "firebase-functions/v2/https";
import { SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET } from "./firebase";
import { info } from "firebase-functions/logger";
import SpotifyWebApi from "spotify-web-api-node";
import cookieParser from "cookie-parser";
import * as crypto from "crypto";

// Scopes to request.
const OAUTH_SCOPES = [ "user-read-email" ];

async function getSpotifyAccessToken({ clientId, clientSecret }: {
  clientId: string;
  clientSecret: string;
}): Promise<{
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
  scope: string;
  tokenType: string;
}> {
  const res = await fetch(
    "https://accounts.spotify.com/api/token",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: "Basic " + Buffer.from(clientId + ":" + clientSecret).toString("base64"),
      },
      body: new URLSearchParams({
        grant_type: "client_credentials",
      }),
    }
  );

  const body = await res.json();
  return {
    accessToken: body["access_token"],
    refreshToken: body["refresh_token"],
    expiresIn: body["expires_in"],
    scope: body["scope"],
    tokenType: body["token_type"],
  };
}

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
    const expiresIn = body["expires_in"];
    const scope = body["scope"];
    const tokenType = body["token_type"];

    info(
      "received access token:",
      accessToken,
    );
    spotifyClient.setAccessToken(accessToken);

    return {
      accessToken,
      refreshToken,
      expiresIn,
      scope,
      tokenType,
    };
  });

export const spotifyRefreshToken = onCall(
  { secrets: [ SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET ] },
  async (request) => {
    const spotifyClient = new SpotifyWebApi({
      clientId: SPOTIFY_CLIENT_ID.value(),
      clientSecret: SPOTIFY_CLIENT_SECRET.value(),
      redirectUri: "https://tapped.ai/spotify",
    });

    const { refreshToken } = request.data as { refreshToken: string };

    const res = await fetch(
      "https://accounts.spotify.com/api/token",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          Authorization: "Basic " + Buffer.from(SPOTIFY_CLIENT_ID.value() + ":" + SPOTIFY_CLIENT_SECRET.value()).toString("base64"),
        },
        body: new URLSearchParams({
          grant_type: "refresh_token",
          refresh_token: refreshToken,
        }),
      }
    );

    const body = await res.json();
    info({ body });
    const accessToken = body["access_token"];
    const expiresIn = body["expires_in"];
    const tokenType = body["token_type"];
    const scope = body["scope"];

    info(
      "received access token:",
      accessToken,
    );
    spotifyClient.setAccessToken(accessToken);

    return {
      accessToken,
      expiresIn,
      tokenType,
      scope,
      refreshToken,
    };
  });


export const getArtistBySpotifyId = onCall(
  { secrets: [ SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET ] },
  async (request) => {
    const { spotifyId } = request.data as { spotifyId: string; };

    const { accessToken } = await getSpotifyAccessToken({
      clientId: SPOTIFY_CLIENT_ID.value(),
      clientSecret: SPOTIFY_CLIENT_SECRET.value(),
    });

    info({ spotifyId, accessToken });

    const res = await fetch(`https://api.spotify.com/v1/artists/${spotifyId}`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });

    const data = await res.json();

    return data;
  });