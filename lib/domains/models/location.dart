
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intheloopapp/domains/models/option.dart';

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
  List<Object?> get props => [
    placeId,
    geohash,
    lat,
    lng,
  ];

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

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'geohash': geohash,
      'lat': lat,
      'lng': lng,
    };
  }
}

class OptionalLocationConverter extends JsonConverter<Option<Location>, Location?> {
  const OptionalLocationConverter();

  @override
  Option<Location> fromJson(Location? value) => Option.fromNullable(value);

  @override
  Location? toJson(Option<Location> location) => location.asNullable();
}