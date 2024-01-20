// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rate: json['rate'] as int? ?? 0,
      rateType: $enumDecodeNullable(_$RateTypeEnumMap, json['rateType']) ??
          RateType.hourly,
      count: json['count'] as int? ?? 0,
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
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
