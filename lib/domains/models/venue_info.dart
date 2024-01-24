import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:json_annotation/json_annotation.dart';

part 'venue_info.g.dart';

@JsonSerializable()
class VenueInfo extends Equatable {
  const VenueInfo({
    required this.capacity,
    required this.idealArtistProfile,
    required this.productionInfo,
    required this.frontOfHouse,
    required this.monitors,
    required this.microphones,
    required this.lights,
    required this.type,
  });

  // empty
  factory VenueInfo.empty() => const VenueInfo(
        capacity: None<int>(),
        idealArtistProfile: None<String>(),
        productionInfo: None<String>(),
        frontOfHouse: None<String>(),
        monitors: None<String>(),
        microphones: None<String>(),
        lights: None<String>(),
        type: VenueType.other,
      );

  // fromJson
  factory VenueInfo.fromJson(Map<String, dynamic> json) =>
      _$VenueInfoFromJson(json);

  final Option<int> capacity;
  final Option<String> idealArtistProfile;
  final Option<String> productionInfo;
  final Option<String> frontOfHouse;
  final Option<String> monitors;
  final Option<String> microphones;
  final Option<String> lights;

  @JsonKey(defaultValue: VenueType.other)
  final VenueType type;

  @override
  List<Object?> get props => [
        capacity,
        productionInfo,
        frontOfHouse,
        monitors,
        microphones,
        lights,
        type,
      ];

  // toJson
  Map<String, dynamic> toJson() => _$VenueInfoToJson(this);

  // copyWith
  VenueInfo copyWith({
    Option<int>? capacity,
    Option<String>? idealArtistProfile,
    Option<String>? productionInfo,
    Option<String>? frontOfHouse,
    Option<String>? monitors,
    Option<String>? microphones,
    Option<String>? lights,
    VenueType? type,
  }) {
    return VenueInfo(
      capacity: capacity ?? this.capacity,
      idealArtistProfile: idealArtistProfile ?? this.idealArtistProfile,
      productionInfo: productionInfo ?? this.productionInfo,
      frontOfHouse: frontOfHouse ?? this.frontOfHouse,
      monitors: monitors ?? this.monitors,
      microphones: microphones ?? this.microphones,
      lights: lights ?? this.lights,
      type: type ?? this.type,
    );
  }
}

@JsonEnum()
enum VenueType {
  concertHall,
  bar,
  club,
  restaurant,
  theater,
  arena,
  stadium,
  festival,
  artGallery,
  studio,
  other,
}

class OptionalVenueInfoConverter
    implements JsonConverter<Option<VenueInfo>, VenueInfo?> {
  const OptionalVenueInfoConverter();

  @override
  Option<VenueInfo> fromJson(VenueInfo? value) => Option.fromNullable(value);

  @override
  VenueInfo? toJson(Option<VenueInfo> value) => value.asNullable();
}
