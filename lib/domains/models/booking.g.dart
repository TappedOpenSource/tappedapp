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
      flierUrl: json['flierUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['flierUrl'], (value) => value as String),
      eventUrl: json['eventUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['eventUrl'], (value) => value as String),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] == null
          ? const None()
          : Option<Location>.fromJson(json['location'],
              (value) => Location.fromJson(value as Map<String, dynamic>)),
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
      'flierUrl': instance.flierUrl.toJson(
        (value) => value,
      ),
      'eventUrl': instance.eventUrl.toJson(
        (value) => value,
      ),
      'genres': instance.genres,
      'location': instance.location.toJson(
        (value) => value,
      ),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.canceled: 'canceled',
};
