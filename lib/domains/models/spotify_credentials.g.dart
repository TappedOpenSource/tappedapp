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
      expiresIn: json['expiresIn'] as int,
      tokenType: json['tokenType'] as String,
      scope: json['scope'] as String,
    );

Map<String, dynamic> _$$SpotifyCredentialsImplToJson(
        _$SpotifyCredentialsImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'tokenType': instance.tokenType,
      'scope': instance.scope,
    };
