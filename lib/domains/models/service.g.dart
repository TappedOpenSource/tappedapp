// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceImpl _$$ServiceImplFromJson(Map<String, dynamic> json) =>
    _$ServiceImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rate: (json['rate'] as num?)?.toInt() ?? 0,
      rateType: $enumDecodeNullable(_$RateTypeEnumMap, json['rateType']) ??
          RateType.fixed,
      count: (json['count'] as num?)?.toInt() ?? 0,
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$ServiceImplToJson(_$ServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'rate': instance.rate,
      'rateType': _$RateTypeEnumMap[instance.rateType]!,
      'count': instance.count,
      'deleted': instance.deleted,
    };

const _$RateTypeEnumMap = {
  RateType.hourly: 'hourly',
  RateType.fixed: 'fixed',
};
