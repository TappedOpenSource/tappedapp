// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifyUserImpl _$$SpotifyUserImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyUserImpl(
      country: json['country'] as String?,
      display_name: json['display_name'] as String?,
      email: json['email'] as String?,
      explicit_content: json['explicit_content'] == null
          ? null
          : ExplicitContent.fromJson(
              json['explicit_content'] as Map<String, dynamic>),
      external_urls: json['external_urls'] == null
          ? null
          : ExternalUrls.fromJson(
              json['external_urls'] as Map<String, dynamic>),
      followers: json['followers'] == null
          ? null
          : Followers.fromJson(json['followers'] as Map<String, dynamic>),
      href: json['href'] as String?,
      id: json['id'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => Image.fromJson(e as Map<String, dynamic>))
          .toList(),
      product: json['product'] as String?,
      type: json['type'] as String?,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$$SpotifyUserImplToJson(_$SpotifyUserImpl instance) =>
    <String, dynamic>{
      'country': instance.country,
      'display_name': instance.display_name,
      'email': instance.email,
      'explicit_content': instance.explicit_content?.toJson(),
      'external_urls': instance.external_urls?.toJson(),
      'followers': instance.followers?.toJson(),
      'href': instance.href,
      'id': instance.id,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'product': instance.product,
      'type': instance.type,
      'uri': instance.uri,
    };

_$ExplicitContentImpl _$$ExplicitContentImplFromJson(
        Map<String, dynamic> json) =>
    _$ExplicitContentImpl(
      filter_enabled: json['filter_enabled'] as bool,
      filter_locked: json['filter_locked'] as bool,
    );

Map<String, dynamic> _$$ExplicitContentImplToJson(
        _$ExplicitContentImpl instance) =>
    <String, dynamic>{
      'filter_enabled': instance.filter_enabled,
      'filter_locked': instance.filter_locked,
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

_$ImageImpl _$$ImageImplFromJson(Map<String, dynamic> json) => _$ImageImpl(
      url: json['url'] as String,
      height: json['height'] as int,
      width: json['width'] as int,
    );

Map<String, dynamic> _$$ImageImplToJson(_$ImageImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'height': instance.height,
      'width': instance.width,
    };
