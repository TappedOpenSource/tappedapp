
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_track.freezed.dart';
part 'spotify_track.g.dart';

@freezed
class SpotifyTrack with _$SpotifyTrack {
  const factory SpotifyTrack({
    required String id,
    required String name,
    required String uri,
    @Default(None()) Option<Album> album,
    @Default([]) List<Map<String, dynamic>> artists,

    @JsonKey(name: 'available_markets')
    @Default([]) List<String> availableMarkets,

    @JsonKey(name: 'disc_number')
    @Default(None()) Option<int> discNumber,

    @JsonKey(name: 'duration_ms')
    @Default(None()) Option<int> durationMs,
    @Default(false) bool explicit,

    @JsonKey(name: 'external_ids')
    @Default(None()) Option<Map<String, String>> externalIds,

    @JsonKey(name: 'external_urls')
    @Default(None()) Option<Map<String, dynamic>> externalUrls,
    @Default(None()) Option<String> href,

    @JsonKey(name: 'is_playable')
    @Default(false) bool isPlayable,

    @JsonKey(name: 'linked_from')
    @Default(None()) Option<Map<String, dynamic>> linkedFrom,
    @Default(None()) Option<Map<String, dynamic>> restrictions,
    @Default(None()) Option<int> popularity,

    @JsonKey(name: 'preview_url')
    @Default(None()) Option<String> previewUrl,

    @JsonKey(name: 'track_number')
    @Default(None()) Option<int> trackNumber,
    @Default(None()) Option<String> type,

    @JsonKey(name: 'is_local')
    @Default(false) bool isLocal,
  }) = _SpotifyTrack;

  factory SpotifyTrack.fromJson(Map<String, dynamic> json) =>
      _$SpotifyTrackFromJson(json);
}
@freezed
class Album with _$Album {
  const factory Album({
    required String id,
    required String name,
    required String uri,

    @JsonKey(name: 'album_type')
    @Default(None()) Option<String> albumType,

    @JsonKey(name: 'total_tracks')
    @Default(0) int totalTracks,

    @JsonKey(name: 'available_markets')
    @Default([]) List<String> availableMarkets,

    @JsonKey(name: 'external_urls')
    @Default(None()) Option<Map<String, dynamic>> externalUrls,

    @Default(None()) Option<String> href,
    @Default([]) List<AlbumImage> images,

    @JsonKey(name: 'release_date')
    @Default(None()) Option<String> releaseDate,

    @JsonKey(name: 'release_date_precision')
    @Default(None()) Option<String> releaseDatePrecision,
    @Default(None()) Option<Map<String, dynamic>> restrictions,
    @Default(None()) Option<String> type,
    @Default([]) List<Map<String, dynamic>> artists,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}

@freezed
class AlbumImage with _$AlbumImage {
  const factory AlbumImage({
    required String url,
    required int height,
    required int width,
  }) = _AlbumImage;

  factory AlbumImage.fromJson(Map<String, dynamic> json) =>
      _$AlbumImageFromJson(json);
}
