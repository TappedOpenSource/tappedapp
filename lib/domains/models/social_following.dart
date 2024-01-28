import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_following.freezed.dart';

part 'social_following.g.dart';

@freezed
class SocialFollowing with _$SocialFollowing {
  const factory SocialFollowing({
    @Default(None()) Option<String> youtubeChannelId,
    @Default(None()) Option<String> tiktokHandle,
    @Default(0) int tiktokFollowers,
    @Default(None()) Option<String> instagramHandle,
    @Default(0) int instagramFollowers,
    @Default(None()) Option<String> twitterHandle,
    @Default(0) int twitterFollowers,
  }) = _SocialFollowing;

  // fromJson
  factory SocialFollowing.fromJson(Map<String, dynamic> json) =>
      _$SocialFollowingFromJson(json);

  // fromDoc
  factory SocialFollowing.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }

    data['id'] = doc.id;
    return SocialFollowing.fromJson(data);
  }

  // empty
  static const empty = SocialFollowing();
}

extension SocialFollowingHelper on SocialFollowing {
  int get audienceSize =>
      tiktokFollowers + instagramFollowers + twitterFollowers;
}
