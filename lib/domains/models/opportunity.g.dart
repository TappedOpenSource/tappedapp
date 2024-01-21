// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Opportunity _$OpportunityFromJson(Map<String, dynamic> json) => Opportunity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      flierUrl:
          Option<String>.fromJson(json['flierUrl'], (value) => value as String),
      location: json['location'] == null
          ? Location.rva()
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      timestamp: json['timestamp'] == null
          ? DateTime.now()
          : timestampToDateTime(json['timestamp'] as Timestamp),
      startTime: json['startTime'] == null
          ? DateTime.now()
          : timestampToDateTime(json['startTime'] as Timestamp),
      endTime: json['endTime'] == null
          ? DateTime.now()
          : timestampToDateTime(json['endTime'] as Timestamp),
      isPaid: json['isPaid'] as bool? ?? false,
      touched: Option<OpportunityInteraction>.fromJson(json['touched'],
          (value) => $enumDecode(_$OpportunityInteractionEnumMap, value)),
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$OpportunityToJson(Opportunity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'flierUrl': instance.flierUrl.toJson(
        (value) => value,
      ),
      'location': instance.location,
      'timestamp': dateTimeToTimestamp(instance.timestamp),
      'startTime': dateTimeToTimestamp(instance.startTime),
      'endTime': dateTimeToTimestamp(instance.endTime),
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
