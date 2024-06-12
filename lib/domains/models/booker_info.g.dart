// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booker_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookerInfoImpl _$$BookerInfoImplFromJson(Map<String, dynamic> json) =>
    _$BookerInfoImpl(
      rating: json['rating'] == null
          ? const None()
          : Option<double>.fromJson(
              json['rating'], (value) => (value as num).toDouble()),
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BookerInfoImplToJson(_$BookerInfoImpl instance) =>
    <String, dynamic>{
      'rating': instance.rating.toJson(
        (value) => value,
      ),
      'reviewCount': instance.reviewCount,
    };
