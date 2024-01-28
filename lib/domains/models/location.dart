import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location {
  const factory Location({
    required String placeId,
    required String geohash,
    required double lat,
    required double lng,
  }) = _Location;

  // fromJson
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  static const rva = Location(
    placeId: 'ChIJ7cmZVwkRsYkRxTxC4m0-2L8',
    geohash: 'dq8vtfhf9',
    lat: 37.5407246,
    lng: -77.4360481,
  );

  static const dc = Location(
    placeId: 'ChIJW-T2Wt7Gt4kRKl2I1CJFUsI',
    geohash: 'dqcjqfz6',
    lat: 38.907192,
    lng: -77.036873,
  );
}
