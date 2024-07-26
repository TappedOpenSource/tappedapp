// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpportunityImpl _$$OpportunityImplFromJson(Map<String, dynamic> json) =>
    _$OpportunityImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      timestamp:
          const DateTimeConverter().fromJson(json['timestamp'] as Timestamp),
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as Timestamp),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as Timestamp),
      deadline: json['deadline'] == null
          ? const None()
          : const OptionalDateTimeConverter()
              .fromJson(json['deadline'] as Timestamp?),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      flierUrl: json['flierUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['flierUrl'], (value) => value as String),
      isPaid: json['isPaid'] as bool? ?? false,
      touched: json['touched'] == null
          ? const None()
          : Option<OpportunityInteraction>.fromJson(json['touched'],
              (value) => $enumDecode(_$OpportunityInteractionEnumMap, value)),
      deleted: json['deleted'] as bool? ?? false,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      venueId: json['venueId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['venueId'], (value) => value as String),
      referenceEventId: json['referenceEventId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['referenceEventId'], (value) => value as String),
    );

Map<String, dynamic> _$$OpportunityImplToJson(_$OpportunityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'location': instance.location.toJson(),
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
      'deadline': const OptionalDateTimeConverter().toJson(instance.deadline),
      'title': instance.title,
      'description': instance.description,
      'flierUrl': instance.flierUrl.toJson(
        (value) => value,
      ),
      'isPaid': instance.isPaid,
      'touched': instance.touched.toJson(
        (value) => _$OpportunityInteractionEnumMap[value]!,
      ),
      'deleted': instance.deleted,
      'genres': instance.genres,
      'venueId': instance.venueId.toJson(
        (value) => value,
      ),
      'referenceEventId': instance.referenceEventId.toJson(
        (value) => value,
      ),
    };

const _$OpportunityInteractionEnumMap = {
  OpportunityInteraction.like: 'like',
  OpportunityInteraction.dislike: 'dislike',
};
