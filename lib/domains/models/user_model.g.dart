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
      profilePicture: const OptionalStringConverter()
          .fromJson(json['profilePicture'] as String?),
      bio: json['bio'] as String,
      occupations: (json['occupations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: const OptionalLocationConverter()
          .fromJson(json['location'] as Location?),
      badgesCount: json['badgesCount'] as int,
      performerInfo: const OptionalPerformerInfoConverter()
          .fromJson(json['performerInfo'] as PerformerInfo?),
      bookerInfo: const OptionalBookerInfoConverter()
          .fromJson(json['bookerInfo'] as BookerInfo?),
      venueInfo: const OptionalVenueInfoConverter()
          .fromJson(json['venueInfo'] as VenueInfo?),
      socialFollowing: SocialFollowing.fromJson(
          json['socialFollowing'] as Map<String, dynamic>),
      emailNotifications: EmailNotifications.fromJson(
          json['emailNotifications'] as Map<String, dynamic>),
      pushNotifications: PushNotifications.fromJson(
          json['pushNotifications'] as Map<String, dynamic>),
      deleted: json['deleted'] as bool,
      stripeConnectedAccountId: const OptionalStringConverter()
          .fromJson(json['stripeConnectedAccountId'] as String?),
      stripeCustomerId: const OptionalStringConverter()
          .fromJson(json['stripeCustomerId'] as String?),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'timestamp': instance.timestamp.toIso8601String(),
      'username': Username.usernameToString(instance.username),
      'artistName': instance.artistName,
      'bio': instance.bio,
      'occupations': instance.occupations,
      'profilePicture':
          const OptionalStringConverter().toJson(instance.profilePicture),
      'location': const OptionalLocationConverter().toJson(instance.location),
      'badgesCount': instance.badgesCount,
      'performerInfo':
          const OptionalPerformerInfoConverter().toJson(instance.performerInfo),
      'venueInfo':
          const OptionalVenueInfoConverter().toJson(instance.venueInfo),
      'bookerInfo':
          const OptionalBookerInfoConverter().toJson(instance.bookerInfo),
      'emailNotifications': instance.emailNotifications,
      'pushNotifications': instance.pushNotifications,
      'deleted': instance.deleted,
      'socialFollowing': instance.socialFollowing,
      'stripeConnectedAccountId': const OptionalStringConverter()
          .toJson(instance.stripeConnectedAccountId),
      'stripeCustomerId':
          const OptionalStringConverter().toJson(instance.stripeCustomerId),
    };
