// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueInfo _$VenueInfoFromJson(Map<String, dynamic> json) => VenueInfo(
      capacity: Option<int>.fromJson(json['capacity'], (value) => value as int),
      idealArtistProfile: Option<String>.fromJson(
          json['idealArtistProfile'], (value) => value as String),
      productionInfo: Option<String>.fromJson(
          json['productionInfo'], (value) => value as String),
      frontOfHouse: Option<String>.fromJson(
          json['frontOfHouse'], (value) => value as String),
      monitors:
          Option<String>.fromJson(json['monitors'], (value) => value as String),
      microphones: Option<String>.fromJson(
          json['microphones'], (value) => value as String),
      lights:
          Option<String>.fromJson(json['lights'], (value) => value as String),
    );

Map<String, dynamic> _$VenueInfoToJson(VenueInfo instance) => <String, dynamic>{
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
    };