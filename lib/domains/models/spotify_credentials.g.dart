// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifyCredentialsImpl _$$SpotifyCredentialsImplFromJson(
        Map<String, dynamic> json) =>
    _$SpotifyCredentialsImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$SpotifyCredentialsImplToJson(
        _$SpotifyCredentialsImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
