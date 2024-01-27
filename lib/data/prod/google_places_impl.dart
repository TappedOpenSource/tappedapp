import 'dart:io';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/default_value.dart';

// ios only, restricted
const _placesIosKey = 'AIzaSyA5-IXbTej9XA-eV96fqf0gWuvmdnHrOnY';

// android only, restricted
const _placesAndroidKey = 'AIzaSyCD1NeNSfMRVOJz40P2v44aY-kj2pnHr14';

final _placesKey = Platform.isIOS ? _placesIosKey : _placesAndroidKey;
final _places = FlutterGooglePlacesSdk(_placesKey);
final _functions = FirebaseFunctions.instance;

class GooglePlacesImpl implements PlacesRepository {
  @override
  @cached
  Future<PlaceData?> getPlaceById(String placeId) async {
    if (placeId.isEmpty) return null;

    try {
      final callable = _functions.httpsCallable('getPlaceById');

      final results = await callable<Map<String, dynamic>>({
        'placeId': placeId,
      });
      final data = results.data;

      final place = PlaceData(
        placeId: data['placeId'] as String,
        shortFormattedAddress: data['shortFormattedAddress'] as String,
        addressComponents: (data['addressComponents'] as List<dynamic>)
            .map(
              (e) => AddressComponent(
                name: e['longText'] as String,
                shortName: e['shortText'] as String,
                types: (e['types'] as List<dynamic>?)?.cast<String>() ?? [],
              ),
            )
            .toList(),
        geohash: data['geohash'] as String,
        lat: data['lat'] as double,
        lng: data['lng'] as double,
        photoMetadata: data['photoMetadata'] == null
            ? const None()
            : Some(
                PhotoMetadata(
                  height: data['photoMetadata']['heightPx'] as int,
                  width: data['photoMetadata']['widthPx'] as int,
                  attributions: data['photoMetadata']['authorAttributions'][0]
                      ['uri'] as String,
                  photoReference: data['photoMetadata']['name'] as String,
                ),
              ),
      );

      return place;
    } catch (e, s) {
      logger.error(
        'Error fetching place by id: $placeId',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  @override
  @cached
  Future<List<AutocompletePrediction>> searchPlace(String query) async {
    try {
      final predictions = await _places.findAutocompletePredictions(query);
      return predictions.predictions;
    } catch (e, s) {
      logger.error(
        'Error searching place: $query',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  @override
  @cached
  Future<Option<Image>> getPhotoUrlFromReference(
    String placeId,
    PhotoMetadata metadata,
  ) async {
    try {
      final callable = _functions.httpsCallable('getPlacePhotoUrlFromName');

      final results = await callable<Map<String, dynamic>>({
        'placeId': placeId,
        'photoName': metadata.photoReference,
      });
      final data = results.data;
      final photoUri = data.getOrElse<String?>('photoUri', null);
      if (photoUri == null) return const None();

      return Some(
        Image(
          image: CachedNetworkImageProvider(
            photoUri,
          ),
        ),
      );
    } catch (e, s) {
      logger.error(
        'Error fetching photo from reference: $metadata',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
