/* eslint-disable import/no-unresolved */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { encodeBase32 } from "geohashing";
import { LRUCache } from "lru-cache";
import { 
  GOOGLE_PLACES_API_KEY, 
  googlePlacesCacheRef,
} from "./firebase";

const fields = [
  "id",
  "location",
  "shortFormattedAddress",
  "addressComponents",
  "photos",
];

const cache = new LRUCache({
  max: 500,
});

const _geohashForLocation = ([ lat, lng ]: [number, number]) => {
  const hash = encodeBase32(lat, lng);
  return hash;
}

const _getPlaceDetails = async (placeId: string): Promise<{
    placeId: string;
    shortFormattedAddress: string;
    addressComponents: string[];
    photoMetadata: string | null;
    geohash: string;
    lat: number;
    lng: number;
}> => {
  try {
    if (cache.has(placeId)) {
      return cache.get(placeId) as {
        placeId: string;
        shortFormattedAddress: string;
        addressComponents: string[];
        photoMetadata: string | null;
        geohash: string;
        lat: number;
        lng: number;
    };
    }

    const res = await fetch(
      `https://places.googleapis.com/v1/places/${placeId}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": GOOGLE_PLACES_API_KEY.value(),
          "X-Goog-FieldMask": fields.join(","),
        },
      });
    const json = await res.json() as any;

    if (json.error) {
      console.error(json.error);
      throw new Error(json.error.message);
    }

    const { 
      location,
      shortFormattedAddress,
      addressComponents,
      photos,
    } = json
    const { latitude: lat, longitude: lng } = location;
    const geohash = _geohashForLocation([ lat, lng ]);

    const photoMetadata = photos.length > 0 
      ? photos[0]
      : null;

    const value = { 
      placeId,
      shortFormattedAddress,
      addressComponents,
      photoMetadata,
      geohash, 
      lat, 
      lng,
    };
    cache.set(placeId, value);
    return value;
  } catch (e) {
    console.error(`error getting place details for placeId: ${placeId}`, e);
    throw e;
  }
}

export const getPlaceById = onCall(
  {
    secrets: [ GOOGLE_PLACES_API_KEY ],
  },
  async (request) => {
    const data = request.data;

    // Checking attribute.
    if (data.placeId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
      throw new HttpsError(
        "invalid-argument",
        "The function argument 'id' cannot be empty"
      );
    }
    
    const placeSnapshot = await googlePlacesCacheRef.doc(data.id).get();
    if (placeSnapshot.exists) {
      return placeSnapshot.data();
    }

    const place = await _getPlaceDetails(data.id);
    await googlePlacesCacheRef.doc(data.id).set(place);

    return place;
  });
