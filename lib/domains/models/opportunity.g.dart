// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpportunityImpl _$$OpportunityImplFromJson(Map<String, dynamic> json) =>
    _$OpportunityImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      timestamp:
          const DateTimeConverter().fromJson(json['timestamp'] as Timestamp),
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as Timestamp),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as Timestamp),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      flierUrl: json['flierUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['flierUrl'], (value) => value as String),
      location: json['location'] == null
          ? Location.rva
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      isPaid: json['isPaid'] as bool? ?? false,
      touched: json['touched'] == null
          ? const None()
          : Option<OpportunityInteraction>.fromJson(json['touched'],
              (value) => $enumDecode(_$OpportunityInteractionEnumMap, value)),
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$OpportunityImplToJson(_$OpportunityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
      'title': instance.title,
      'description': instance.description,
      'flierUrl': instance.flierUrl.toJson(
        (value) => value,
      ),
      'location': instance.location,
      'isPaid': instance.isPaid,
      'touched': instance.touched.toJson(
        (value) => _$OpportunityInteractionEnumMap[value]!,
      ),
      'deleted': instance.deleted,
    };

const _$OpportunityInteractionEnumMap = {
  OpportunityInteraction.like: 'like',
  OpportunityInteraction.dislike: 'dislike',
};
