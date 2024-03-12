// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueInfoImpl _$$VenueInfoImplFromJson(Map<String, dynamic> json) =>
    _$VenueInfoImpl(
      bookingEmail: json['bookingEmail'] == null
          ? const None()
          : Option<String>.fromJson(
              json['bookingEmail'], (value) => value as String),
      autoReply: json['autoReply'] == null
          ? const None()
          : Option<String>.fromJson(
              json['autoReply'], (value) => value as String),
      capacity: json['capacity'] == null
          ? const None()
          : Option<int>.fromJson(json['capacity'], (value) => value as int),
      idealPerformerProfile: json['idealPerformerProfile'] == null
          ? const None()
          : Option<String>.fromJson(
              json['idealPerformerProfile'], (value) => value as String),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      venuePhotos: (json['venuePhotos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
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
      averageTicketPrice: json['averageTicketPrice'] == null
          ? const None()
          : Option<int>.fromJson(
              json['averageTicketPrice'], (value) => value as int),
    );

Map<String, dynamic> _$$VenueInfoImplToJson(_$VenueInfoImpl instance) =>
    <String, dynamic>{
      'bookingEmail': instance.bookingEmail.toJson(
        (value) => value,
      ),
      'autoReply': instance.autoReply.toJson(
        (value) => value,
      ),
      'capacity': instance.capacity.toJson(
        (value) => value,
      ),
      'idealPerformerProfile': instance.idealPerformerProfile.toJson(
        (value) => value,
      ),
      'genres': instance.genres,
      'venuePhotos': instance.venuePhotos,
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
      'averageTicketPrice': instance.averageTicketPrice.toJson(
        (value) => value,
      ),
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
  VenueType.brewery: 'brewery',
  VenueType.hotel: 'hotel',
  VenueType.other: 'other',
};
