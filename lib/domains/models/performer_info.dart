import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:json_annotation/json_annotation.dart';

part 'performer_info.freezed.dart';
part 'performer_info.g.dart';

@freezed
class PerformerInfo with _$PerformerInfo {
  const factory PerformerInfo({
    @Default(None()) Option<String> pressKitUrl,
    @Default([]) List<Genre> genres,
    @Default(None()) Option<double> rating,
    @Default(0) int reviewCount,
    @Default('Independent') String label,
  }) = _PerformerInfo;

  // fromJson
  factory PerformerInfo.fromJson(Map<String, dynamic> json) =>
      _$PerformerInfoFromJson(json);
}

class OptionalPerformerInfoConverter implements JsonConverter<Option<PerformerInfo>, PerformerInfo?> {
  const OptionalPerformerInfoConverter();

  @override
  Option<PerformerInfo> fromJson(PerformerInfo? value) => Option.fromNullable(value);

  @override
  PerformerInfo? toJson(Option<PerformerInfo> option) => option.toNullable();
}