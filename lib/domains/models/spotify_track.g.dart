// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifyTrackImpl _$$SpotifyTrackImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyTrackImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      uri: json['uri'] as String,
      album: json['album'] == null
          ? const None()
          : Option<Album>.fromJson(json['album'],
              (value) => Album.fromJson(value as Map<String, dynamic>)),
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      availableMarkets: (json['available_markets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      discNumber: json['disc_number'] == null
          ? const None()
          : Option<int>.fromJson(
              json['disc_number'], (value) => (value as num).toInt()),
      durationMs: json['duration_ms'] == null
          ? const None()
          : Option<int>.fromJson(
              json['duration_ms'], (value) => (value as num).toInt()),
      explicit: json['explicit'] as bool? ?? false,
      externalIds: json['external_ids'] == null
          ? const None()
          : Option<Map<String, String>>.fromJson(json['external_ids'],
              (value) => Map<String, String>.from(value as Map)),
      externalUrls: json['external_urls'] == null
          ? const None()
          : Option<Map<String, dynamic>>.fromJson(
              json['external_urls'], (value) => value as Map<String, dynamic>),
      href: json['href'] == null
          ? const None()
          : Option<String>.fromJson(json['href'], (value) => value as String),
      isPlayable: json['is_playable'] as bool? ?? false,
      linkedFrom: json['linked_from'] == null
          ? const None()
          : Option<Map<String, dynamic>>.fromJson(
              json['linked_from'], (value) => value as Map<String, dynamic>),
      restrictions: json['restrictions'] == null
          ? const None()
          : Option<Map<String, dynamic>>.fromJson(
              json['restrictions'], (value) => value as Map<String, dynamic>),
      popularity: json['popularity'] == null
          ? const None()
          : Option<int>.fromJson(
              json['popularity'], (value) => (value as num).toInt()),
      previewUrl: json['preview_url'] == null
          ? const None()
          : Option<String>.fromJson(
              json['preview_url'], (value) => value as String),
      trackNumber: json['track_number'] == null
          ? const None()
          : Option<int>.fromJson(
              json['track_number'], (value) => (value as num).toInt()),
      type: json['type'] == null
          ? const None()
          : Option<String>.fromJson(json['type'], (value) => value as String),
      isLocal: json['is_local'] as bool? ?? false,
    );

Map<String, dynamic> _$$SpotifyTrackImplToJson(_$SpotifyTrackImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'uri': instance.uri,
      'album': instance.album.toJson(
        (value) => value,
      ),
      'artists': instance.artists,
      'available_markets': instance.availableMarkets,
      'disc_number': instance.discNumber.toJson(
        (value) => value,
      ),
      'duration_ms': instance.durationMs.toJson(
        (value) => value,
      ),
      'explicit': instance.explicit,
      'external_ids': instance.externalIds.toJson(
        (value) => value,
      ),
      'external_urls': instance.externalUrls.toJson(
        (value) => value,
      ),
      'href': instance.href.toJson(
        (value) => value,
      ),
      'is_playable': instance.isPlayable,
      'linked_from': instance.linkedFrom.toJson(
        (value) => value,
      ),
      'restrictions': instance.restrictions.toJson(
        (value) => value,
      ),
      'popularity': instance.popularity.toJson(
        (value) => value,
      ),
      'preview_url': instance.previewUrl.toJson(
        (value) => value,
      ),
      'track_number': instance.trackNumber.toJson(
        (value) => value,
      ),
      'type': instance.type.toJson(
        (value) => value,
      ),
      'is_local': instance.isLocal,
    };

_$AlbumImpl _$$AlbumImplFromJson(Map<String, dynamic> json) => _$AlbumImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      uri: json['uri'] as String,
      albumType: json['album_type'] == null
          ? const None()
          : Option<String>.fromJson(
              json['album_type'], (value) => value as String),
      totalTracks: (json['total_tracks'] as num?)?.toInt() ?? 0,
      availableMarkets: (json['available_markets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      externalUrls: json['external_urls'] == null
          ? const None()
          : Option<Map<String, dynamic>>.fromJson(
              json['external_urls'], (value) => value as Map<String, dynamic>),
      href: json['href'] == null
          ? const None()
          : Option<String>.fromJson(json['href'], (value) => value as String),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => AlbumImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      releaseDate: json['release_date'] == null
          ? const None()
          : Option<String>.fromJson(
              json['release_date'], (value) => value as String),
      releaseDatePrecision: json['release_date_precision'] == null
          ? const None()
          : Option<String>.fromJson(
              json['release_date_precision'], (value) => value as String),
      restrictions: json['restrictions'] == null
          ? const None()
          : Option<Map<String, dynamic>>.fromJson(
              json['restrictions'], (value) => value as Map<String, dynamic>),
      type: json['type'] == null
          ? const None()
          : Option<String>.fromJson(json['type'], (value) => value as String),
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AlbumImplToJson(_$AlbumImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'uri': instance.uri,
      'album_type': instance.albumType.toJson(
        (value) => value,
      ),
      'total_tracks': instance.totalTracks,
      'available_markets': instance.availableMarkets,
      'external_urls': instance.externalUrls.toJson(
        (value) => value,
      ),
      'href': instance.href.toJson(
        (value) => value,
      ),
      'images': instance.images,
      'release_date': instance.releaseDate.toJson(
        (value) => value,
      ),
      'release_date_precision': instance.releaseDatePrecision.toJson(
        (value) => value,
      ),
      'restrictions': instance.restrictions.toJson(
        (value) => value,
      ),
      'type': instance.type.toJson(
        (value) => value,
      ),
      'artists': instance.artists,
    };

_$AlbumImageImpl _$$AlbumImageImplFromJson(Map<String, dynamic> json) =>
    _$AlbumImageImpl(
      url: json['url'] as String,
      height: (json['height'] as num).toInt(),
      width: (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$$AlbumImageImplToJson(_$AlbumImageImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'height': instance.height,
      'width': instance.width,
    };
