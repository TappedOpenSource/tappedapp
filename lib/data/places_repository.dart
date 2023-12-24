import 'package:flutter/widgets.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/domains/models/option.dart';

abstract class PlacesRepository {
  Future<List<AutocompletePrediction>> searchPlace(String query);
  Future<PlaceData?> getPlaceById(String placeId);
  Future<Option<Image>> getPhotoUrlFromReference(
    String placeId,
    PhotoMetadata metadata,
  );
}

class PlaceData {
  PlaceData({
    required this.placeId,
    required this.shortFormattedAddress,
    required this.addressComponents,
    required this.geohash,
    required this.lat,
    required this.lng,
    this.photoMetadata = const None(),
  });

  final String placeId;
  final String shortFormattedAddress;
  final List<AddressComponent> addressComponents;
  final Option<PhotoMetadata> photoMetadata;
  final String geohash;
  final double lat;
  final double lng;
}
