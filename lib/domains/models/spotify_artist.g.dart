// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifyArtistImpl _$$SpotifyArtistImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyArtistImpl(
      externalUrls: json['externalUrls'] == null
          ? null
          : ExternalUrls.fromJson(json['externalUrls'] as Map<String, dynamic>),
      followers: json['followers'] == null
          ? null
          : Followers.fromJson(json['followers'] as Map<String, dynamic>),
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      href: json['href'] as String?,
      id: json['id'] as String?,
      images: (json['images'] as List<dynamic>)
          .map((e) => ArtistImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      popularity: json['popularity'] as int?,
      type: json['type'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$$SpotifyArtistImplToJson(_$SpotifyArtistImpl instance) =>
    <String, dynamic>{
      'externalUrls': instance.externalUrls?.toJson(),
      'followers': instance.followers?.toJson(),
      'genres': instance.genres,
      'href': instance.href,
      'id': instance.id,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'popularity': instance.popularity,
      'type': instance.type,
      'uri': instance.uri,
    };

_$ExternalUrlsImpl _$$ExternalUrlsImplFromJson(Map<String, dynamic> json) =>
    _$ExternalUrlsImpl(
      spotify: json['spotify'] as String,
    );

Map<String, dynamic> _$$ExternalUrlsImplToJson(_$ExternalUrlsImpl instance) =>
    <String, dynamic>{
      'spotify': instance.spotify,
    };

_$FollowersImpl _$$FollowersImplFromJson(Map<String, dynamic> json) =>
    _$FollowersImpl(
      href: json['href'] as String?,
      total: json['total'] as int?,
    );

Map<String, dynamic> _$$FollowersImplToJson(_$FollowersImpl instance) =>
    <String, dynamic>{
      'href': instance.href,
      'total': instance.total,
    };

_$ArtistImageImpl _$$ArtistImageImplFromJson(Map<String, dynamic> json) =>
    _$ArtistImageImpl(
      url: json['url'] as String,
      height: json['height'] as int,
      width: json['width'] as int,
    );

Map<String, dynamic> _$$ArtistImageImplToJson(_$ArtistImageImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'height': instance.height,
      'width': instance.width,
    };
