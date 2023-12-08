import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:georange/georange.dart';

final georange = GeoRange();

const latPerKm = 0.009090909090909; // degrees latitude per Km
const lngPerKm = 0.0089847259658580; // degrees longitude per Km

String geocodeEncode({
  required double lat,
  required double lng,
}) {
  return georange.encode(lat, lng);
}

LatLng geocodeDecode(String geohash) {
  final decoded = georange.decode(geohash);

  return LatLng(
    lng: decoded.longitude,
    lat: decoded.latitude,
  );
}

// Get the geohash upper & lower bounds
GeoHashRange getGeohashRange({
  required double latitude,
  required double longitude,
  int distance = 100, // Km
}) {
  final lowerLat = latitude - latPerKm * distance;
  final lowerLon = longitude - lngPerKm * distance;

  final upperLat = latitude + latPerKm * distance;
  final upperLon = longitude + lngPerKm * distance;

  final lower = georange.encode(lowerLat, lowerLon);
  final upper = georange.encode(upperLat, upperLon);

  return GeoHashRange(lower: lower, upper: upper);
}

double geoDistance(Point p1, Point p2) {
  return georange.distance(p1, p2);
}

class GeoHashRange {
  GeoHashRange({
    required this.upper,
    required this.lower,
  });

  final String upper;
  final String lower;
}

String getAddressComponent(
  List<AddressComponent>? addressComponents, {
  PlaceType type = PlaceType.LOCALITY,
  String defaultIdent = 'Unknown',
  bool longName = false,
}) {
  final typeString = EnumToString.convertToString(type).toLowerCase();

  final addressComponent =
      addressComponents?.where((element) => element.types.contains(typeString));
  // final political =
  //  shortNames?.where((element) => element.types.contains('political'));

  if (longName) {
    return addressComponent?.firstOrNull?.name ?? defaultIdent;
  }

  return addressComponent?.firstOrNull?.shortName ?? defaultIdent;
}

String formattedFullAddress(List<AddressComponent>? addressComponents) {
  final streetNumber = getAddressComponent(
    addressComponents,
    type: PlaceType.STREET_NUMBER,
    longName: true,
    defaultIdent: '',
  );

  final street = getAddressComponent(
    addressComponents,
    type: PlaceType.ROUTE,
    longName: true,
    defaultIdent: '',
  );

  final city = getAddressComponent(
    addressComponents,
    longName: true,
    defaultIdent: '',
  );

  final zipCode = getAddressComponent(
    addressComponents,
    type: PlaceType.POSTAL_CODE,
    longName: true,
    defaultIdent: '',
  );

  return '$streetNumber $street, $city $zipCode';
}
