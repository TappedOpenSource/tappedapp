import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_artist.freezed.dart';

part 'spotify_artist.g.dart';

@freezed
class SpotifyArtist with _$SpotifyArtist {
  @JsonSerializable(explicitToJson: true)
  const factory SpotifyArtist({
    required List<String>? genres,
    required String? href,
    required String id,
    required String? name,
    required int? popularity,
    required String? type,
    required String uri,
    @Default(None()) Option<ExternalUrls> external_urls,
    @Default(None()) Option<Followers> followers,
    @Default([]) List<ArtistImage> images,
  }) = _SpotifyArtist;

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) =>
      _$SpotifyArtistFromJson(json);
}

@freezed
class ExternalUrls with _$ExternalUrls {
  const factory ExternalUrls({
    required String spotify,
  }) = _ExternalUrls;

  factory ExternalUrls.fromJson(Map<String, dynamic> json) =>
      _$ExternalUrlsFromJson(json);
}

@freezed
class Followers with _$Followers {
  const factory Followers({
    required String? href,
    required int? total,
  }) = _Followers;

  factory Followers.fromJson(Map<String, dynamic> json) =>
      _$FollowersFromJson(json);
}

@freezed
class ArtistImage with _$ArtistImage {
  const factory ArtistImage({
    required String url,
    required int height,
    required int width,
  }) = _ArtistImage;

  factory ArtistImage.fromJson(Map<String, dynamic> json) =>
      _$ArtistImageFromJson(json);
}
