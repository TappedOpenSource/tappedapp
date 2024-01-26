// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      unclaimed: json['unclaimed'] as bool? ?? false,
      timestamp: json['timestamp'] == null
          ? DateTime.now()
          : timestampToDateTime(json['timestamp'] as Timestamp),
      username: const UsernameConverter().fromJson(json['username'] as String),
      artistName: json['artistName'] as String? ?? '',
      profilePicture: Option<String>.fromJson(
          json['profilePicture'], (value) => value as String),
      bio: json['bio'] as String? ?? '',
      occupations: (json['occupations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      location: Option<Location>.fromJson(json['location'],
          (value) => Location.fromJson(value as Map<String, dynamic>)),
      badgesCount: json['badgesCount'] as int? ?? 0,
      performerInfo: Option<PerformerInfo>.fromJson(json['performerInfo'],
          (value) => PerformerInfo.fromJson(value as Map<String, dynamic>)),
      bookerInfo: Option<BookerInfo>.fromJson(json['bookerInfo'],
          (value) => BookerInfo.fromJson(value as Map<String, dynamic>)),
      venueInfo: Option<VenueInfo>.fromJson(json['venueInfo'],
          (value) => VenueInfo.fromJson(value as Map<String, dynamic>)),
      socialFollowing: json['socialFollowing'] == null
          ? SocialFollowing.empty()
          : SocialFollowing.fromJson(
              json['socialFollowing'] as Map<String, dynamic>),
      emailNotifications: json['emailNotifications'] == null
          ? EmailNotifications.empty()
          : EmailNotifications.fromJson(
              json['emailNotifications'] as Map<String, dynamic>),
      pushNotifications: json['pushNotifications'] == null
          ? PushNotifications.empty()
          : PushNotifications.fromJson(
              json['pushNotifications'] as Map<String, dynamic>),
      deleted: json['deleted'] as bool? ?? false,
      stripeConnectedAccountId: Option<String>.fromJson(
          json['stripeConnectedAccountId'], (value) => value as String),
      stripeCustomerId: Option<String>.fromJson(
          json['stripeCustomerId'], (value) => value as String),
      latestAppVersion: Option<String>.fromJson(
          json['latestAppVersion'], (value) => value as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'unclaimed': instance.unclaimed,
      'timestamp': dateTimeToTimestamp(instance.timestamp),
      'username': const UsernameConverter().toJson(instance.username),
      'artistName': instance.artistName,
      'bio': instance.bio,
      'occupations': instance.occupations,
      'profilePicture': instance.profilePicture.toJson(
        (value) => value,
      ),
      'location': instance.location.toJson(
        (value) => value,
      ),
      'badgesCount': instance.badgesCount,
      'performerInfo': instance.performerInfo.toJson(
        (value) => value,
      ),
      'venueInfo': instance.venueInfo.toJson(
        (value) => value,
      ),
      'bookerInfo': instance.bookerInfo.toJson(
        (value) => value,
      ),
      'emailNotifications': instance.emailNotifications,
      'pushNotifications': instance.pushNotifications,
      'deleted': instance.deleted,
      'socialFollowing': instance.socialFollowing,
      'stripeConnectedAccountId': instance.stripeConnectedAccountId.toJson(
        (value) => value,
      ),
      'stripeCustomerId': instance.stripeCustomerId.toJson(
        (value) => value,
      ),
      'latestAppVersion': instance.latestAppVersion.toJson(
        (value) => value,
      ),
    };
