// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifyTrackImpl _$$SpotifyTrackImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyTrackImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      artist: json['artist'] as String,
      imageUrl: json['imageUrl'] as String,
      previewUrl: json['previewUrl'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$$SpotifyTrackImplToJson(_$SpotifyTrackImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artist': instance.artist,
      'imageUrl': instance.imageUrl,
      'previewUrl': instance.previewUrl,
      'uri': instance.uri,
    };
