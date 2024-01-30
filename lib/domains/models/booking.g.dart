// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      note: json['note'] as String,
      requesterId: json['requesterId'] as String,
      requesteeId: json['requesteeId'] as String,
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as Timestamp),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as Timestamp),
      timestamp:
          const DateTimeConverter().fromJson(json['timestamp'] as Timestamp),
      rate: json['rate'] as int? ?? 0,
      serviceId: json['serviceId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['serviceId'], (value) => value as String),
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
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'requesterId': instance.requesterId,
      'requesteeId': instance.requesteeId,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
      'rate': instance.rate,
      'serviceId': instance.serviceId.toJson(
        (value) => value,
      ),
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
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.canceled: 'canceled',
};
