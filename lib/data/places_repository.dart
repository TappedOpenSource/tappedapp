import 'package:flutter/widgets.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/domains/models/option.dart';

abstract class PlacesRepository {
  Future<List<AutocompletePrediction>> searchPlace(String query);
  Future<Place?> getPlaceById(String placeId);
  Future<Option<Image>> getPhotoUrlFromReference(PhotoMetadata metadata);
}
