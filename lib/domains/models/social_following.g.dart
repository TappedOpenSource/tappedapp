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
      youtubeHandle: json['youtubeHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['youtubeHandle'], (value) => value as String),
      tiktokHandle: json['tiktokHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['tiktokHandle'], (value) => value as String),
      tiktokFollowers: (json['tiktokFollowers'] as num?)?.toInt() ?? 0,
      instagramHandle: json['instagramHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['instagramHandle'], (value) => value as String),
      instagramFollowers: (json['instagramFollowers'] as num?)?.toInt() ?? 0,
      twitterHandle: json['twitterHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['twitterHandle'], (value) => value as String),
      twitterFollowers: (json['twitterFollowers'] as num?)?.toInt() ?? 0,
      facebookHandle: json['facebookHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['facebookHandle'], (value) => value as String),
      facebookFollowers: (json['facebookFollowers'] as num?)?.toInt() ?? 0,
      spotifyId: json['spotifyId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['spotifyId'], (value) => value as String),
      spotifyMonthlyListeners:
          (json['spotifyMonthlyListeners'] as num?)?.toInt() ?? 0,
      soundcloudHandle: json['soundcloudHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['soundcloudHandle'], (value) => value as String),
      soundcloudFollowers: (json['soundcloudFollowers'] as num?)?.toInt() ?? 0,
      audiusHandle: json['audiusHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['audiusHandle'], (value) => value as String),
      audiusFollowers: (json['audiusFollowers'] as num?)?.toInt() ?? 0,
      twitchHandle: json['twitchHandle'] == null
          ? const None()
          : Option<String>.fromJson(
              json['twitchHandle'], (value) => value as String),
      twitchFollowers: (json['twitchFollowers'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SocialFollowingImplToJson(
        _$SocialFollowingImpl instance) =>
    <String, dynamic>{
      'youtubeChannelId': instance.youtubeChannelId.toJson(
        (value) => value,
      ),
      'youtubeHandle': instance.youtubeHandle.toJson(
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
      'spotifyId': instance.spotifyId.toJson(
        (value) => value,
      ),
      'spotifyMonthlyListeners': instance.spotifyMonthlyListeners,
      'soundcloudHandle': instance.soundcloudHandle.toJson(
        (value) => value,
      ),
      'soundcloudFollowers': instance.soundcloudFollowers,
      'audiusHandle': instance.audiusHandle.toJson(
        (value) => value,
      ),
      'audiusFollowers': instance.audiusFollowers,
      'twitchHandle': instance.twitchHandle.toJson(
        (value) => value,
      ),
      'twitchFollowers': instance.twitchFollowers,
    };
