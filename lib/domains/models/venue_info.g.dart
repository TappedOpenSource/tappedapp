// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueInfo _$VenueInfoFromJson(Map<String, dynamic> json) => VenueInfo(
      capacity: const OptionalIntConverter().fromJson(json['capacity'] as int?),
      idealArtistProfile: const OptionalStringConverter()
          .fromJson(json['idealArtistProfile'] as String?),
      productionInfo: const OptionalStringConverter()
          .fromJson(json['productionInfo'] as String?),
      frontOfHouse: const OptionalStringConverter()
          .fromJson(json['frontOfHouse'] as String?),
      monitors:
          const OptionalStringConverter().fromJson(json['monitors'] as String?),
      microphones: const OptionalStringConverter()
          .fromJson(json['microphones'] as String?),
      lights:
          const OptionalStringConverter().fromJson(json['lights'] as String?),
    );

Map<String, dynamic> _$VenueInfoToJson(VenueInfo instance) => <String, dynamic>{
      'capacity': const OptionalIntConverter().toJson(instance.capacity),
      'idealArtistProfile':
          const OptionalStringConverter().toJson(instance.idealArtistProfile),
      'productionInfo':
          const OptionalStringConverter().toJson(instance.productionInfo),
      'frontOfHouse':
          const OptionalStringConverter().toJson(instance.frontOfHouse),
      'monitors': const OptionalStringConverter().toJson(instance.monitors),
      'microphones':
          const OptionalStringConverter().toJson(instance.microphones),
      'lights': const OptionalStringConverter().toJson(instance.lights),
    };
