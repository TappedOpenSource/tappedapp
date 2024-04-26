/* eslint-disable import/no-unresolved */
import { debug } from "firebase-functions/logger";
import { onCall } from "firebase-functions/v2/https";
import { CHARTMETRIC_REFRESH_TOKEN } from "./firebase";

async function getChartmetricAccessToken(refreshToken: string,): Promise<{
    accessToken: string;
}> {
  /// curl -d '{"refreshtoken":"REFRESH_TOKEN"}' -H "Content-Type: application/json" -X POST https://api.chartmetric.com/api/token
  const response = await fetch("https://api.chartmetric.com/api/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ refreshtoken: refreshToken }),
  });

  const data = await response.json();

  return { accessToken: data.token };
}

export const getChartmetricIdBySpotifyId = onCall(
  { secrets: [ CHARTMETRIC_REFRESH_TOKEN ] },
  async (request) => {
    const { spotifyId } = request.data as { spotifyId: string; };
    const { accessToken } = await getChartmetricAccessToken(CHARTMETRIC_REFRESH_TOKEN.value());
    debug({ spotifyId, accessToken });

    /// curl -H 'Authorization: Bearer [ACCESS KEY]' https://api.chartmetric.com/api/artist/chartmetric/4904/get-ids?aggregate=true
    const response = await fetch(`https://api.chartmetric.com/api/artist/spotify/${spotifyId}/get-ids?aggregate=true`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });

    const data = await response.json();
    return data;
  });

export const getTopArtistsByCity = onCall(
  { secrets: [ CHARTMETRIC_REFRESH_TOKEN ] },
  async (request) => {
    // blah 
  });