import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/domains/models/spotify_user.dart';

part 'social_following.freezed.dart';
part 'social_following.g.dart';

@freezed
class SocialFollowing with _$SocialFollowing {
  @JsonSerializable(explicitToJson: true)
  const factory SocialFollowing({
    @Default(None()) Option<String> youtubeChannelId,
    @Default(None()) Option<String> youtubeHandle,
    @Default(None()) Option<String> tiktokHandle,
    @Default(0) int tiktokFollowers,
    @Default(None()) Option<String> instagramHandle,
    @Default(0) int instagramFollowers,
    @Default(None()) Option<String> twitterHandle,
    @Default(0) int twitterFollowers,
    @Default(None()) Option<String> facebookHandle,
    @Default(0) int facebookFollowers,
    @Default(None()) Option<String> spotifyId,
    @Default(0) int spotifyMonthlyListeners,
    @Default(None()) Option<String> soundcloudHandle,
    @Default(0) int soundcloudFollowers,
    @Default(None()) Option<String> audiusHandle,
    @Default(0) int audiusFollowers,
    @Default(None()) Option<String> twitchHandle,
    @Default(0) int twitchFollowers,
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
      tiktokFollowers + instagramFollowers + twitterFollowers + facebookFollowers;
}
