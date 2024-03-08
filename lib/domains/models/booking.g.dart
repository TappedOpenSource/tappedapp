// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      requesteeId: json['requesteeId'] as String,
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as Timestamp),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as Timestamp),
      timestamp:
          const DateTimeConverter().fromJson(json['timestamp'] as Timestamp),
      requesterId: json['requesterId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['requesterId'], (value) => value as String),
      name: json['name'] == null
          ? const None()
          : Option<String>.fromJson(json['name'], (value) => value as String),
      note: json['note'] as String? ?? '',
      rate: json['rate'] as int? ?? 0,
      serviceId: json['serviceId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['serviceId'], (value) => value as String),
      addedByUser: json['addedByUser'] as bool? ?? false,
      placeId: json['placeId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['placeId'], (value) => value as String),
      geohash: json['geohash'] == null
          ? const None()
          : Option<String>.fromJson(
              json['geohash'], (value) => value as String),
      lat: json['lat'] == null
          ? const None()
          : Option<double>.fromJson(
              json['lat'], (value) => (value as num).toDouble()),
      lng: json['lng'] == null
          ? const None()
          : Option<double>.fromJson(
              json['lng'], (value) => (value as num).toDouble()),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$GenreEnumMap, e))
              .toList() ??
          const [],
      flierUrl: json['flierUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['flierUrl'], (value) => value as String),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesteeId': instance.requesteeId,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
      'requesterId': instance.requesterId.toJson(
        (value) => value,
      ),
      'name': instance.name.toJson(
        (value) => value,
      ),
      'note': instance.note,
      'rate': instance.rate,
      'serviceId': instance.serviceId.toJson(
        (value) => value,
      ),
      'addedByUser': instance.addedByUser,
      'placeId': instance.placeId.toJson(
        (value) => value,
      ),
      'geohash': instance.geohash.toJson(
        (value) => value,
      ),
      'lat': instance.lat.toJson(
        (value) => value,
      ),
      'lng': instance.lng.toJson(
        (value) => value,
      ),
      'genres': instance.genres.map((e) => _$GenreEnumMap[e]!).toList(),
      'flierUrl': instance.flierUrl.toJson(
        (value) => value,
      ),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.canceled: 'canceled',
};

const _$GenreEnumMap = {
  Genre.pop: 'pop',
  Genre.rock: 'rock',
  Genre.hiphop: 'hiphop',
  Genre.rap: 'rap',
  Genre.rnb: 'rnb',
  Genre.country: 'country',
  Genre.edm: 'edm',
  Genre.electronic: 'electronic',
  Genre.dance: 'dance',
  Genre.jazz: 'jazz',
  Genre.latin: 'latin',
  Genre.classical: 'classical',
  Genre.reggae: 'reggae',
  Genre.blues: 'blues',
  Genre.soul: 'soul',
  Genre.funk: 'funk',
  Genre.metal: 'metal',
  Genre.punk: 'punk',
  Genre.indie: 'indie',
  Genre.folk: 'folk',
  Genre.alternative: 'alternative',
  Genre.bluegrass: 'bluegrass',
  Genre.gospel: 'gospel',
  Genre.orchestra: 'orchestra',
  Genre.theater: 'theater',
  Genre.opera: 'opera',
  Genre.other: 'other',
};
