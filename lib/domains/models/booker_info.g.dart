// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booker_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookerInfo _$BookerInfoFromJson(Map<String, dynamic> json) => BookerInfo(
      rating: optionalDoubleFromJson(json['rating']),
      reviewCount: json['reviewCount'] as int,
    );

Map<String, dynamic> _$BookerInfoToJson(BookerInfo instance) =>
    <String, dynamic>{
      'rating': optionalDoubleToJson(instance.rating),
      'reviewCount': instance.reviewCount,
    };
