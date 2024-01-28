// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeImpl _$$BadgeImplFromJson(Map<String, dynamic> json) => _$BadgeImpl(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      timestamp:
          const DateTimeConverter().fromJson(json['timestamp'] as Timestamp),
    );

Map<String, dynamic> _$$BadgeImplToJson(_$BadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'description': instance.description,
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
    };
