import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/default_value.dart';
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
  });

  // @OptionalIntConverter()
  final Option<int> capacity;
  // @OptionalStringConverter()
  final Option<String> idealArtistProfile;
  // @OptionalStringConverter()
  final Option<String> productionInfo;
  // @OptionalStringConverter()
  final Option<String> frontOfHouse;
  // @OptionalStringConverter()
  final Option<String> monitors;
  // @OptionalStringConverter()
  final Option<String> microphones;
  // @OptionalStringConverter()
  final Option<String> lights;

  @override
  List<Object?> get props => [
    capacity,
    productionInfo,
    frontOfHouse,
    monitors,
    microphones,
    lights,
  ];

  // empty
  factory VenueInfo.empty() => const VenueInfo(
    capacity: None<int>(),
    idealArtistProfile: None<String>(),
    productionInfo: None<String>(),
    frontOfHouse: None<String>(),
    monitors: None<String>(),
    microphones: None<String>(),
    lights: None<String>(),
  );

  // fromJson
  factory VenueInfo.fromJson(Map<String, dynamic> json) =>
      _$VenueInfoFromJson(json);

  // fromDoc
  factory VenueInfo.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpCapacity = doc.getOrElse<int?>('capacity', null);
    final tmpIdealArtistProfile = doc.getOrElse<String?>('idealArtistProfile', null);
    final tmpProductionInfo = doc.getOrElse<String?>('productionInfo', null);
    final tmpFrontOfHouse = doc.getOrElse<String?>('frontOfHouse', null);
    final tmpMonitors = doc.getOrElse<String?>('monitors', null);
    final tmpMicrophones = doc.getOrElse<String?>('microphones', null);
    final tmpLights = doc.getOrElse<String?>('lights', null);

    // firestore can suck my nuts for this
    // firestore only stores "numbers" so I have to figure out if
    // it's an int or double
    final capacity = switch (tmpCapacity.runtimeType) {
      String => const None<int>(),
      int => Some<int>(tmpCapacity as int),
      double => Some<int>((tmpCapacity as double).toInt()),
      _ => const None<int>()
    };
    final idealArtistProfile = Option.fromNullable(tmpIdealArtistProfile);
    final productionInfo = Option.fromNullable(tmpProductionInfo);
    final frontOfHouse = Option.fromNullable(tmpFrontOfHouse);
    final monitors = Option.fromNullable(tmpMonitors);
    final microphones = Option.fromNullable(tmpMicrophones);
    final lights = Option.fromNullable(tmpLights);

    return VenueInfo(
      capacity: capacity,
      idealArtistProfile: idealArtistProfile,
      productionInfo: productionInfo,
      frontOfHouse: frontOfHouse,
      monitors: monitors,
      microphones: microphones,
      lights: lights,
    );
  }

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
  }) {
    return VenueInfo(
      capacity: capacity ?? this.capacity,
      idealArtistProfile: idealArtistProfile ?? this.idealArtistProfile,
      productionInfo: productionInfo ?? this.productionInfo,
      frontOfHouse: frontOfHouse ?? this.frontOfHouse,
      monitors: monitors ?? this.monitors,
      microphones: microphones ?? this.microphones,
      lights: lights ?? this.lights,
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'capacity': capacity.asNullable(),
      'idealArtistProfile': idealArtistProfile.asNullable(),
      'productionInfo': productionInfo.asNullable(),
      'frontOfHouse': frontOfHouse.asNullable(),
      'monitors': monitors.asNullable(),
      'microphones': microphones.asNullable(),
      'lights': lights.asNullable(),
    };
  }
}

class OptionalVenueInfoConverter implements JsonConverter<Option<VenueInfo>, VenueInfo?> {
  const OptionalVenueInfoConverter();

  @override
  Option<VenueInfo> fromJson(VenueInfo? value) => Option.fromNullable(value);

  @override
  VenueInfo? toJson(Option<VenueInfo> value) => value.asNullable();
}
