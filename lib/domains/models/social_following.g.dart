// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialFollowing _$SocialFollowingFromJson(Map<String, dynamic> json) =>
    SocialFollowing(
      youtubeChannelId: Option<String>.fromJson(
          json['youtubeChannelId'], (value) => value as String),
      tiktokHandle: Option<String>.fromJson(
          json['tiktokHandle'], (value) => value as String),
      tiktokFollowers: json['tiktokFollowers'] as int,
      instagramHandle: Option<String>.fromJson(
          json['instagramHandle'], (value) => value as String),
      instagramFollowers: json['instagramFollowers'] as int,
      twitterHandle: Option<String>.fromJson(
          json['twitterHandle'], (value) => value as String),
      twitterFollowers: json['twitterFollowers'] as int,
    );

Map<String, dynamic> _$SocialFollowingToJson(SocialFollowing instance) =>
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
    };
