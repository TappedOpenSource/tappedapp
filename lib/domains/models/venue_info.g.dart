// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueInfoImpl _$$VenueInfoImplFromJson(Map<String, dynamic> json) =>
    _$VenueInfoImpl(
      capacity: json['capacity'] == null
          ? const None()
          : Option<int>.fromJson(json['capacity'], (value) => value as int),
      idealArtistProfile: json['idealArtistProfile'] == null
          ? const None()
          : Option<String>.fromJson(
              json['idealArtistProfile'], (value) => value as String),
      productionInfo: json['productionInfo'] == null
          ? const None()
          : Option<String>.fromJson(
              json['productionInfo'], (value) => value as String),
      frontOfHouse: json['frontOfHouse'] == null
          ? const None()
          : Option<String>.fromJson(
              json['frontOfHouse'], (value) => value as String),
      monitors: json['monitors'] == null
          ? const None()
          : Option<String>.fromJson(
              json['monitors'], (value) => value as String),
      microphones: json['microphones'] == null
          ? const None()
          : Option<String>.fromJson(
              json['microphones'], (value) => value as String),
      lights: json['lights'] == null
          ? const None()
          : Option<String>.fromJson(json['lights'], (value) => value as String),
      type: $enumDecodeNullable(_$VenueTypeEnumMap, json['type']) ??
          VenueType.other,
    );

Map<String, dynamic> _$$VenueInfoImplToJson(_$VenueInfoImpl instance) =>
    <String, dynamic>{
      'capacity': instance.capacity.toJson(
        (value) => value,
      ),
      'idealArtistProfile': instance.idealArtistProfile.toJson(
        (value) => value,
      ),
      'productionInfo': instance.productionInfo.toJson(
        (value) => value,
      ),
      'frontOfHouse': instance.frontOfHouse.toJson(
        (value) => value,
      ),
      'monitors': instance.monitors.toJson(
        (value) => value,
      ),
      'microphones': instance.microphones.toJson(
        (value) => value,
      ),
      'lights': instance.lights.toJson(
        (value) => value,
      ),
      'type': _$VenueTypeEnumMap[instance.type]!,
    };

const _$VenueTypeEnumMap = {
  VenueType.concertHall: 'concertHall',
  VenueType.bar: 'bar',
  VenueType.club: 'club',
  VenueType.restaurant: 'restaurant',
  VenueType.theater: 'theater',
  VenueType.arena: 'arena',
  VenueType.stadium: 'stadium',
  VenueType.festival: 'festival',
  VenueType.artGallery: 'artGallery',
  VenueType.studio: 'studio',
  VenueType.other: 'other',
};
