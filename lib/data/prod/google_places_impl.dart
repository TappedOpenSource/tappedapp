import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/app_logger.dart';

const _placesKey = 'AIzaSyAh3GEqDEv4lfnAgeT19-7sgyF7JxLF34g';
final _places = FlutterGooglePlacesSdk(_placesKey);

class GooglePlacesImpl implements PlacesRepository {
  @override
  Future<Place?> getPlaceById(String placeId) async {
    if (placeId.isEmpty) return null;

    try {
      final result = await _places.fetchPlace(
        placeId,
        fields: [
          PlaceField.Id,
          PlaceField.AddressComponents,
          PlaceField.Location,
          PlaceField.PhotoMetadatas,
        ],
      );

      return result.place;
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
  Future<Option<Image>> getPhotoUrlFromReference(PhotoMetadata metadata) async {
    try {
      final photo = await _places.fetchPlacePhoto(
        metadata,
        maxWidth: 400,
      );

      return photo.maybeWhen(
        image: Some.new,
        imageUrl: (imageUrl) => Some(
          Image(
            image: CachedNetworkImageProvider(
              imageUrl,
            ),
          ),
        ),
        orElse: None.new,
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
