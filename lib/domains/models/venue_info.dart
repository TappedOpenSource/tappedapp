import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'venue_info.freezed.dart';
part 'venue_info.g.dart';

@freezed
class VenueInfo with _$VenueInfo {
  const factory VenueInfo({
    @Default(None()) Option<int> capacity,
    @Default(None()) Option<String> idealArtistProfile,
    @Default(None()) Option<String> productionInfo,
    @Default(None()) Option<String> frontOfHouse,
    @Default(None()) Option<String> monitors,
    @Default(None()) Option<String> microphones,
    @Default(None()) Option<String> lights,
    @Default(Option.of(VenueType.other)) Option<VenueType> type,
  }) = _VenueInfo;

  // empty
  static const empty = VenueInfo();

  // fromJson
  factory VenueInfo.fromJson(Map<String, dynamic> json) =>
      _$VenueInfoFromJson(json);
}

@JsonEnum()
enum VenueType {
  concertHall,
  bar,
  club,
  restaurant,
  theater,
  arena,
  stadium,
  festival,
  artGallery,
  studio,
  other,
}

class OptionalVenueInfoConverter
    implements JsonConverter<Option<VenueInfo>, VenueInfo?> {
  const OptionalVenueInfoConverter();

  @override
  Option<VenueInfo> fromJson(VenueInfo? value) => Option.fromNullable(value);

  @override
  VenueInfo? toJson(Option<VenueInfo> value) => value.toNullable();
}
