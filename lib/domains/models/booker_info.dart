
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booker_info.freezed.dart';
part 'booker_info.g.dart';

@freezed
class BookerInfo with _$BookerInfo {
  const factory BookerInfo({
    @Default(None()) Option<double> rating,
    @Default(0) int reviewCount,
  }) = _BookerInfo;

  // fromJson
  factory BookerInfo.fromJson(Map<String, dynamic> json) =>
      _$BookerInfoFromJson(json);

  static const empty = BookerInfo();
}
