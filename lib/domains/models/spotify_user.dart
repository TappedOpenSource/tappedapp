import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_user.freezed.dart';
part 'spotify_user.g.dart';

@freezed
class SpotifyUser with _$SpotifyUser {
  @JsonSerializable(explicitToJson: true)
  const factory SpotifyUser({
    required String? country,
    required String? display_name,
    required String? email,
    required ExplicitContent? explicit_content,
    required ExternalUrls? external_urls,
    required Followers? followers,
    required String? href,
    required String? id,
    required List<Image> images,
    required String? product,
    required String? type,
    required String uri,
  }) = _SpotifyUser;

  factory SpotifyUser.fromJson(Map<String, dynamic> json) =>
      _$SpotifyUserFromJson(json);
}

@freezed
class ExplicitContent with _$ExplicitContent {
  const factory ExplicitContent({
    required bool filter_enabled,
    required bool filter_locked,
  }) = _ExplicitContent;

  factory ExplicitContent.fromJson(Map<String, dynamic> json) =>
      _$ExplicitContentFromJson(json);
}

@freezed
class ExternalUrls with _$ExternalUrls {
  const factory ExternalUrls({
    required String? spotify,
  }) = _ExternalUrls;

  factory ExternalUrls.fromJson(Map<String, dynamic> json) =>
      _$ExternalUrlsFromJson(json);
}

@freezed
abstract class Followers with _$Followers {
  const factory Followers({
    required String? href,
    required int? total,
  }) = _Followers;

  factory Followers.fromJson(Map<String, dynamic> json) =>
      _$FollowersFromJson(json);
}

@freezed
abstract class Image with _$Image {
  const factory Image({
    required String? url,
    required int? height,
    required int? width,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}