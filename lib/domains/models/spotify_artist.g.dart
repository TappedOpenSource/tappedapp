// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifyArtistImpl _$$SpotifyArtistImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyArtistImpl(
      id: json['id'] as String,
      uri: json['uri'] as String,
      type: json['type'] == null
          ? const None()
          : Option<String>.fromJson(json['type'], (value) => value as String),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      href: json['href'] == null
          ? const None()
          : Option<String>.fromJson(json['href'], (value) => value as String),
      name: json['name'] == null
          ? const None()
          : Option<String>.fromJson(json['name'], (value) => value as String),
      popularity: json['popularity'] == null
          ? const None()
          : Option<int>.fromJson(
              json['popularity'], (value) => (value as num).toInt()),
      external_urls: json['external_urls'] == null
          ? const None()
          : Option<ExternalUrls>.fromJson(json['external_urls'],
              (value) => ExternalUrls.fromJson(value as Map<String, dynamic>)),
      followers: json['followers'] == null
          ? const None()
          : Option<Followers>.fromJson(json['followers'],
              (value) => Followers.fromJson(value as Map<String, dynamic>)),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ArtistImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SpotifyArtistImplToJson(_$SpotifyArtistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uri': instance.uri,
      'type': instance.type.toJson(
        (value) => value,
      ),
      'genres': instance.genres,
      'href': instance.href.toJson(
        (value) => value,
      ),
      'name': instance.name.toJson(
        (value) => value,
      ),
      'popularity': instance.popularity.toJson(
        (value) => value,
      ),
      'external_urls': instance.external_urls.toJson(
        (value) => value.toJson(),
      ),
      'followers': instance.followers.toJson(
        (value) => value.toJson(),
      ),
      'images': instance.images.map((e) => e.toJson()).toList(),
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
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FollowersImplToJson(_$FollowersImpl instance) =>
    <String, dynamic>{
      'href': instance.href,
      'total': instance.total,
    };

_$ArtistImageImpl _$$ArtistImageImplFromJson(Map<String, dynamic> json) =>
    _$ArtistImageImpl(
      url: json['url'] as String,
      height: (json['height'] as num).toInt(),
      width: (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$$ArtistImageImplToJson(_$ArtistImageImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'height': instance.height,
      'width': instance.width,
    };
