// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialFollowing _$SocialFollowingFromJson(Map<String, dynamic> json) =>
    SocialFollowing(
      youtubeChannelId: const OptionalStringConverter()
          .fromJson(json['youtubeChannelId'] as String?),
      tiktokHandle: const OptionalStringConverter()
          .fromJson(json['tiktokHandle'] as String?),
      tiktokFollowers: json['tiktokFollowers'] as int,
      instagramHandle: const OptionalStringConverter()
          .fromJson(json['instagramHandle'] as String?),
      instagramFollowers: json['instagramFollowers'] as int,
      twitterHandle: const OptionalStringConverter()
          .fromJson(json['twitterHandle'] as String?),
      twitterFollowers: json['twitterFollowers'] as int,
    );

Map<String, dynamic> _$SocialFollowingToJson(SocialFollowing instance) =>
    <String, dynamic>{
      'youtubeChannelId':
          const OptionalStringConverter().toJson(instance.youtubeChannelId),
      'tiktokHandle':
          const OptionalStringConverter().toJson(instance.tiktokHandle),
      'tiktokFollowers': instance.tiktokFollowers,
      'instagramHandle':
          const OptionalStringConverter().toJson(instance.instagramHandle),
      'instagramFollowers': instance.instagramFollowers,
      'twitterHandle':
          const OptionalStringConverter().toJson(instance.twitterHandle),
      'twitterFollowers': instance.twitterFollowers,
    };
