// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      username: Username.fromJson(json['username'] as Map<String, dynamic>),
      artistName: json['artistName'] as String,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String,
      genres: (json['genres'] as List<dynamic>)
          .map((e) => $enumDecode(_$GenreEnumMap, e))
          .toList(),
      occupations: (json['occupations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      label: json['label'] as String,
      placeId: json['placeId'] as String?,
      geohash: json['geohash'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      loopsCount: json['loopsCount'] as int,
      badgesCount: json['badgesCount'] as int,
      reviewCount: json['reviewCount'] as int,
      followerCount: json['followerCount'] as int,
      followingCount: json['followingCount'] as int,
      overallRating: const OptionalDoubleConverter()
          .fromJson(json['overallRating'] as double?),
      deleted: json['deleted'] as bool,
      shadowBanned: json['shadowBanned'] as bool,
      epkUrl:
          const OptionalStringConverter().fromJson(json['epkUrl'] as String?),
      youtubeChannelId: json['youtubeChannelId'] as String?,
      tiktokHandle: json['tiktokHandle'] as String?,
      tiktokFollowers: json['tiktokFollowers'] as int?,
      instagramHandle: json['instagramHandle'] as String?,
      instagramFollowers: json['instagramFollowers'] as int?,
      twitterHandle: json['twitterHandle'] as String?,
      twitterFollowers: json['twitterFollowers'] as int?,
      spotifyId: json['spotifyId'] as String?,
      pushNotificationsLikes: json['pushNotificationsLikes'] as bool,
      pushNotificationsComments: json['pushNotificationsComments'] as bool,
      pushNotificationsFollows: json['pushNotificationsFollows'] as bool,
      pushNotificationsDirectMessages:
          json['pushNotificationsDirectMessages'] as bool,
      pushNotificationsITLUpdates: json['pushNotificationsITLUpdates'] as bool,
      emailNotificationsAppReleases:
          json['emailNotificationsAppReleases'] as bool,
      emailNotificationsITLUpdates:
          json['emailNotificationsITLUpdates'] as bool,
      stripeConnectedAccountId: json['stripeConnectedAccountId'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'timestamp': instance.timestamp.toIso8601String(),
      'username': Username.usernameToString(instance.username),
      'artistName': instance.artistName,
      'bio': instance.bio,
      'genres': instance.genres.map((e) => _$GenreEnumMap[e]!).toList(),
      'occupations': instance.occupations,
      'label': instance.label,
      'profilePicture': instance.profilePicture,
      'placeId': instance.placeId,
      'geohash': instance.geohash,
      'lat': instance.lat,
      'lng': instance.lng,
      'loopsCount': instance.loopsCount,
      'badgesCount': instance.badgesCount,
      'reviewCount': instance.reviewCount,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'overallRating':
          const OptionalDoubleConverter().toJson(instance.overallRating),
      'deleted': instance.deleted,
      'shadowBanned': instance.shadowBanned,
      'epkUrl': const OptionalStringConverter().toJson(instance.epkUrl),
      'youtubeChannelId': instance.youtubeChannelId,
      'tiktokHandle': instance.tiktokHandle,
      'tiktokFollowers': instance.tiktokFollowers,
      'instagramHandle': instance.instagramHandle,
      'instagramFollowers': instance.instagramFollowers,
      'twitterHandle': instance.twitterHandle,
      'twitterFollowers': instance.twitterFollowers,
      'spotifyId': instance.spotifyId,
      'pushNotificationsLikes': instance.pushNotificationsLikes,
      'pushNotificationsComments': instance.pushNotificationsComments,
      'pushNotificationsFollows': instance.pushNotificationsFollows,
      'pushNotificationsDirectMessages':
          instance.pushNotificationsDirectMessages,
      'pushNotificationsITLUpdates': instance.pushNotificationsITLUpdates,
      'emailNotificationsAppReleases': instance.emailNotificationsAppReleases,
      'emailNotificationsITLUpdates': instance.emailNotificationsITLUpdates,
      'stripeConnectedAccountId': instance.stripeConnectedAccountId,
      'stripeCustomerId': instance.stripeCustomerId,
    };

const _$GenreEnumMap = {
  Genre.pop: 'pop',
  Genre.rock: 'rock',
  Genre.hiphop: 'hiphop',
  Genre.rnb: 'rnb',
  Genre.country: 'country',
  Genre.edm: 'edm',
  Genre.jazz: 'jazz',
  Genre.latin: 'latin',
  Genre.classical: 'classical',
  Genre.reggae: 'reggae',
  Genre.blues: 'blues',
  Genre.soul: 'soul',
  Genre.funk: 'funk',
  Genre.metal: 'metal',
  Genre.punk: 'punk',
  Genre.indie: 'indie',
  Genre.folk: 'folk',
  Genre.other: 'other',
};
