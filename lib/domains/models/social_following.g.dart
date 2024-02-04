// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialFollowingImpl _$$SocialFollowingImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialFollowingImpl(
      youtubeChannelId: json['youtubeChannelId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['youtubeChannelId'], (value) => value as String),
      tiktokHandle: json['tiktokHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['tiktokHandle'], (value) => value as String),
      tiktokFollowers: json['tiktokFollowers'] as int? ?? 0,
      instagramHandle: json['instagramHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['instagramHandle'], (value) => value as String),
      instagramFollowers: json['instagramFollowers'] as int? ?? 0,
      twitterHandle: json['twitterHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['twitterHandle'], (value) => value as String),
      twitterFollowers: json['twitterFollowers'] as int? ?? 0,
      facebookHandle: json['facebookHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['facebookHandle'], (value) => value as String),
      facebookFollowers: json['facebookFollowers'] as int? ?? 0,
    );

Map<String, dynamic> _$$SocialFollowingImplToJson(
        _$SocialFollowingImpl instance) =>
    <String, dynamic>{
      'youtubeChannelId': instance.youtubeChannelId.toJson(
        (value) => value,
      ),
      'tiktokHandle': instance.tiktokHandle.toJson(
        (value) => value,
      ),
      'tiktokFollowers': instance.tiktokFollowers,
      'instagramHandle': instance.instagramHandle.toJson(
        (value) => value,
      ),
      'instagramFollowers': instance.instagramFollowers,
      'twitterHandle': instance.twitterHandle.toJson(
        (value) => value,
      ),
      'twitterFollowers': instance.twitterFollowers,
      'facebookHandle': instance.facebookHandle.toJson(
        (value) => value,
      ),
      'facebookFollowers': instance.facebookFollowers,
    };
