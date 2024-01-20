
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intheloopapp/domains/models/option.dart';

part 'social_following.g.dart';

@JsonSerializable()
class SocialFollowing extends Equatable {
  const SocialFollowing({
    required this.youtubeChannelId,
    required this.tiktokHandle,
    required this.tiktokFollowers,
    required this.instagramHandle,
    required this.instagramFollowers,
    required this.twitterHandle,
    required this.twitterFollowers,
  });

  // @OptionalStringConverter()
  final Option<String> youtubeChannelId;

  // @OptionalStringConverter()
  final Option<String> tiktokHandle;
  final int tiktokFollowers;

  // @OptionalStringConverter()
  final Option<String> instagramHandle;
  final int instagramFollowers;

  // @OptionalStringConverter()
  final Option<String> twitterHandle;
  final int twitterFollowers;

  int get audienceSize =>
      tiktokFollowers +
          instagramFollowers +
          twitterFollowers;

  @override
  List<Object?> get props => [
    youtubeChannelId,
    tiktokHandle,
    tiktokFollowers,
    instagramHandle,
    instagramFollowers,
    twitterHandle,
    twitterFollowers,
  ];

  // empty
  factory SocialFollowing.empty() => const SocialFollowing(
    youtubeChannelId: None<String>(),
    tiktokHandle: None<String>(),
    tiktokFollowers: 0,
    instagramHandle: None<String>(),
    instagramFollowers: 0,
    twitterHandle: None<String>(),
    twitterFollowers: 0,
  );

  // fromJson
  factory SocialFollowing.fromJson(Map<String, dynamic> json) =>
      _$SocialFollowingFromJson(json);

  // fromDoc
  factory SocialFollowing.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpYoutubeChannelId = doc.getOrElse<String?>('youtubeChannelId', null);
    final tmpTiktokHandle = doc.getOrElse<String?>('tiktokHandle', null);
    final tmpInstagramHandle = doc.getOrElse<String?>('instagramHandle', null);
    final tmpTwitterHandle = doc.getOrElse<String?>('twitterHandle', null);

    return SocialFollowing(
      youtubeChannelId: Option.fromNullable(tmpYoutubeChannelId),
      tiktokHandle: Option.fromNullable(tmpTiktokHandle),
      tiktokFollowers: doc.getOrElse<int>('tiktokFollowers', 0),
      instagramHandle: Option.fromNullable(tmpInstagramHandle),
      instagramFollowers: doc.getOrElse<int>('instagramFollowers', 0),
      twitterHandle: Option.fromNullable(tmpTwitterHandle),
      twitterFollowers: doc.getOrElse<int>('twitterFollowers', 0),
    );
  }

  // toJson
  Map<String, dynamic> toJson() => _$SocialFollowingToJson(this);

  // copyWith
  SocialFollowing copyWith({
    Option<String>? youtubeChannelId,
    Option<String>? tiktokHandle,
    int? tiktokFollowers,
    Option<String>? instagramHandle,
    int? instagramFollowers,
    Option<String>? twitterHandle,
    int? twitterFollowers,
  }) {
    return SocialFollowing(
      youtubeChannelId: youtubeChannelId ?? this.youtubeChannelId,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      tiktokFollowers: tiktokFollowers ?? this.tiktokFollowers,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      instagramFollowers: instagramFollowers ?? this.instagramFollowers,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      twitterFollowers: twitterFollowers ?? this.twitterFollowers,
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'youtubeChannelId': youtubeChannelId.asNullable(),
      'tiktokHandle': tiktokHandle.asNullable(),
      'tiktokFollowers': tiktokFollowers,
      'instagramHandle': instagramHandle.asNullable(),
      'instagramFollowers': instagramFollowers,
      'twitterHandle': twitterHandle.asNullable(),
      'twitterFollowers': twitterFollowers,
    };
  }
}