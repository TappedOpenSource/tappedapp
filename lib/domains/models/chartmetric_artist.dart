import 'package:freezed_annotation/freezed_annotation.dart';

part 'chartmetric_artist.freezed.dart';

part 'chartmetric_artist.g.dart';

@freezed
class ChartmetricArtist with _$ChartmetricArtist {
  const factory ChartmetricArtist({
    @JsonKey(name: 'chartmetric_id') required String id,
  }) = _ChartmetricArtist;

  factory ChartmetricArtist.fromJson(Map<String, dynamic> json) =>
      _$ChartmetricArtistFromJson(json);
}
