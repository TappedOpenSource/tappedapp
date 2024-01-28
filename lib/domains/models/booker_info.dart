
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/utils/deserialize.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booker_info.freezed.dart';
part 'booker_info.g.dart';

@freezed
class BookerInfo with _$BookerInfo {
  const factory BookerInfo({
    @Default(None()) Option<double> rating,
    @Default(0) int reviewCount,
  }) = _BookerInfo;

  static const empty = BookerInfo();

  // fromJson
  factory BookerInfo.fromJson(Map<String, dynamic> json) =>
      _$BookerInfoFromJson(json);
}
