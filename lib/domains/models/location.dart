import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fpdart/fpdart.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends Equatable {
  const Location({
    required this.placeId,
    required this.geohash,
    required this.lat,
    required this.lng,
  });

  final String placeId;
  final String geohash;
  final double lat;
  final double lng;

  @override
  List<Object?> get props =>
      [
        placeId,
        geohash,
        lat,
        lng,
      ];

  factory Location.rva() =>
      const Location(
        placeId: 'ChIJ7cmZVwkRsYkRxTxC4m0-2L8',
        geohash: 'dq8vtfhf9',
        lat: 37.5407246,
        lng: -77.4360481,
      );

  factory Location.dc() => const Location(
    placeId: 'ChIJW-T2Wt7Gt4kRKl2I1CJFUsI',
    geohash: 'dqcjqfz6',
    lat: 38.907192,
    lng: -77.036873,
  );

  // fromJson
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  // toJson
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  // copyWith
  Location copyWith({
    String? placeId,
    String? geohash,
    double? lat,
    double? lng,
  }) {
    return Location(
      placeId: placeId ?? this.placeId,
      geohash: geohash ?? this.geohash,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

class OptionalLocationConverter
    extends JsonConverter<Option<Location>, Location?> {
  const OptionalLocationConverter();

  @override
  Option<Location> fromJson(Location? json) => Option.fromNullable(json);

  @override
  Location? toJson(Option<Location> object) => object.toNullable();
}