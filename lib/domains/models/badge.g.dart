// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badge _$BadgeFromJson(Map<String, dynamic> json) => Badge(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timestamp: json['timestamp'] == null
          ? DateTime.now()
          : timestampToDateTime(json['timestamp'] as Timestamp),
    );

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'description': instance.description,
      'timestamp': dateTimeToTimestamp(instance.timestamp),
    };
