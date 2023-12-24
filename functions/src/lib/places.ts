/* eslint-disable import/no-unresolved */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { encodeBase32 } from "geohashing";
import { LRUCache } from "lru-cache";
import {
  GOOGLE_PLACES_API_KEY,
  googlePlacesCacheRef,
} from "./firebase";
import { debug, error } from "firebase-functions/logger";

type PlaceData = {
  placeId: string;
  shortFormattedAddress: string;
  addressComponents: {
    longName: string;
    shortName: string;
    types: string[];
  }[];
  photoMetadata: {
    height: number;
    width: number;
    htmlAttributions: string[];
    photoReference: string;
  } | null;
  geohash: string;
  lat: number;
  lng: number;
};

const fields = [
  "id",
  "location",
  "shortFormattedAddress",
  "addressComponents",
  "photos",
];

const placeDetailsCache = new LRUCache({
  max: 500,
});
const placePhotosCache = new LRUCache({
  max: 500,
});

const _geohashForLocation = ([ lat, lng ]: [number, number]) => {
  const hash = encodeBase32(lat, lng);
  return hash;
}

const _getPlaceDetails = async (placeId: string): Promise<PlaceData> => {
  try {
    debug(`getting place details for placeId: ${placeId}`);

    if (placeDetailsCache.has(placeId)) {
      return placeDetailsCache.get(placeId) as PlaceData;
    }

    const res = await fetch(
      `https://places.googleapis.com/v1/places/${placeId}?languageCode=en`, {
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
    placeDetailsCache.set(placeId, value);
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

    if (data.placeId.length === 0) {
      throw new HttpsError(
        "invalid-argument",
        "The function argument 'placeId' cannot be empty"
      );
    }

    const { placeId } = data;

    const placeSnapshot = await googlePlacesCacheRef.doc(placeId).get();
    if (placeSnapshot.exists) {
      return placeSnapshot.data();
    }

    const place = await _getPlaceDetails(placeId);
    await googlePlacesCacheRef.doc(placeId).set(place);

    return place;
  });

const _getPlacePhotoUrlFromName = async (photoName: string, photoId: string): Promise<{
  name: string;
  photoUri: string;
}> => {
  if (placePhotosCache.has(photoId)) {
    return placePhotosCache.get(photoName) as {
      name: string;
      photoUri: string;
    };
  }

  const res = await fetch(
    `https://places.googleapis.com/v1/${
      photoName
    }/media?maxWidthPx=${
      400
    }&skipHttpRedirect=true&key=${
      GOOGLE_PLACES_API_KEY.value()
    }`);


  const json = await res.json() as {
    name: string;
    photoUri: string;
    error?: {
      code: number;
      message: string;
      status: string;
    };
  };

  if (json.error !== undefined) {
    error(`error getting place photo for photoName: ${photoName}`, json.error.message);
    throw new HttpsError("internal", json.error.message);
  }

  placePhotosCache.set(photoId, json);

  return json;
};

export const getPlacePhotoUrlFromName = onCall(
  { secrets: [ GOOGLE_PLACES_API_KEY ] },
  async (request) => {
    const { placeId, photoName }: {
      placeId: string;
      photoName: string;
    } = request.data;


    if (photoName.length === 0) {
      throw new HttpsError(
        "invalid-argument",
        "The function argument 'photoName' cannot be empty"
      );
    }

    if (placeId.length === 0) {
      throw new HttpsError(
        "invalid-argument",
        "The function argument 'placeId' cannot be empty"
      );
    }

    const photoId = photoName.split("/").pop();
    if (photoId === undefined) {
      throw new HttpsError(
        "invalid-argument",
        "The function argument 'photoReference' is invalid"
      );
    }

    const placeSnapshot = await googlePlacesCacheRef
      .doc(placeId)
      .collection("photos")
      .doc(photoId)
      .get();
    if (placeSnapshot.exists) {
      return placeSnapshot.data();
    }

    const res = await _getPlacePhotoUrlFromName(photoName, photoId);
    await googlePlacesCacheRef
      .doc(placeId)
      .collection("photos")
      .doc(photoId)
      .set(res);

    return res;
  });