import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

part 'location.g.dart';

@freezed
class Location with _$Location {
  const factory Location({
    required String placeId,
    // required String geohash,
    required double lat,
    required double lng,
  }) = _Location;

  // fromJson
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  static const rva = Location(
    placeId: 'ChIJ7cmZVwkRsYkRxTxC4m0-2L8',
    // geohash: 'dq8vtfhf9',
    lat: 37.5407246,
    lng: -77.4360481,
  );

  static const dc = Location(
    placeId: 'ChIJW-T2Wt7Gt4kRKl2I1CJFUsI',
    // geohash: 'dqcjqfz6',
    lat: 38.907192,
    lng: -77.036873,
  );

  static const nyc = Location(
    placeId: 'ChIJOwg_06VPwokRYv534QaPC8g',
    // geohash: 'dr5regw3',
    lat: 40.712775,
    lng: -74.005973,
  );

  static const chicago = Location(
    placeId: 'ChIJ7cv00DwsDogRAMDACa2m4Ka8',
    // geohash: 'dp3wjztv',
    lat: 41.878114,
    lng: -87.629798,
  );
}
