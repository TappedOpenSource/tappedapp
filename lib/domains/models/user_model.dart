import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/models/booker_info.dart';
import 'package:intheloopapp/domains/models/email_notifications.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/push_notifications.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/domains/models/venue_info.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.timestamp,
    required this.username,
    required this.artistName,
    required this.profilePicture,
    required this.bio,
    required this.occupations,
    required this.location,
    required this.badgesCount,
    required this.performerInfo,
    required this.bookerInfo,
    required this.venueInfo,
    required this.socialFollowing,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.deleted,
    required this.stripeConnectedAccountId,
    required this.stripeCustomerId,
    required this.latestAppVersion,
  });

  factory UserModel.empty() => UserModel(
        id: const Uuid().v4(),
        email: '',
        timestamp: DateTime.now(),
        username: Username.fromString('anonymous'),
        artistName: '',
        bio: '',
        occupations: const [],
        profilePicture: const None<String>(),
        location: const None<Location>(),
        badgesCount: 0,
        performerInfo: const None<PerformerInfo>(),
        bookerInfo: const None<BookerInfo>(),
        venueInfo: const None<VenueInfo>(),
        socialFollowing: SocialFollowing.empty(),
        emailNotifications: EmailNotifications.empty(),
        pushNotifications: PushNotifications.empty(),
        deleted: false,
        stripeConnectedAccountId: const None<String>(),
        stripeCustomerId: const None<String>(),
        latestAppVersion: const None<String>(),
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final userData = doc.data();
    if (userData == null) {
      throw Exception('user data is null');
    }

    userData['id'] = doc.id;

    return UserModel.fromJson(userData);
  }

  final String id;

  @JsonKey(defaultValue: '')
  final String email;

  @JsonKey(
    defaultValue: DateTime.now,
    fromJson: timestampToDateTime,
    toJson: dateTimeToTimestamp,
  )
  final DateTime timestamp;

  @UsernameConverter()
  final Username username;

  @JsonKey(defaultValue: '')
  final String artistName;

  @JsonKey(defaultValue: '')
  final String bio;

  @JsonKey(defaultValue: [])
  final List<String> occupations;

  final Option<String> profilePicture;

  final Option<Location> location;

  @JsonKey(defaultValue: 0)
  final int badgesCount;

  final Option<PerformerInfo> performerInfo;

  final Option<VenueInfo> venueInfo;

  final Option<BookerInfo> bookerInfo;

  @JsonKey(defaultValue: EmailNotifications.empty)
  final EmailNotifications emailNotifications;

  @JsonKey(defaultValue: PushNotifications.empty)
  final PushNotifications pushNotifications;

  @JsonKey(defaultValue: false)
  final bool deleted;

  @JsonKey(defaultValue: SocialFollowing.empty)
  final SocialFollowing socialFollowing;

  final Option<String> stripeConnectedAccountId;
  final Option<String> stripeCustomerId;

  final Option<String> latestAppVersion;

  Option<double> get overallRating {
    final performerRating = performerInfo.map((e) => e.rating).unwrapOr(const None());
    final bookerRating = bookerInfo.map((e) => e.rating).unwrapOr(const None());

    return switch ((performerRating, bookerRating)) {
      (None(), None()) => const None(),
      (Some(:final value), None()) => Some(value),
      (None(), Some(:final value)) => Some(value),
      (Some(), Some()) => () {
          final overallRating =
              (performerRating.unwrap + bookerRating.unwrap) / 2;

          return Some(overallRating);
        }()
    };
  }

  String get displayName => artistName.isEmpty ? username.username : artistName;

  @override
  List<Object?> get props => [
        id,
        email,
        timestamp,
        username,
        artistName,
        profilePicture,
        bio,
        occupations,
        location,
        badgesCount,
        performerInfo,
        bookerInfo,
        venueInfo,
        socialFollowing,
        deleted,
        emailNotifications,
        pushNotifications,
        stripeConnectedAccountId,
        stripeCustomerId,
        latestAppVersion,
      ];

  bool get isEmpty => this == UserModel.empty();
  bool get isNotEmpty => this != UserModel.empty();

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    DateTime? timestamp,
    Username? username,
    String? artistName,
    Option<String>? profilePicture,
    String? bio,
    List<String>? occupations,
    Option<Location>? location,
    int? badgesCount,
    Option<PerformerInfo>? performerInfo,
    Option<BookerInfo>? bookerInfo,
    Option<VenueInfo>? venueInfo,
    SocialFollowing? socialFollowing,
    bool? deleted,
    EmailNotifications? emailNotifications,
    PushNotifications? pushNotifications,
    Option<String>? stripeCustomerId,
    Option<String>? stripeConnectedAccountId,
    Option<String>? latestAppVersion,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      timestamp: timestamp ?? this.timestamp,
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      occupations: occupations ?? this.occupations,
      location: location ?? this.location,
      badgesCount: badgesCount ?? this.badgesCount,
      performerInfo: performerInfo ?? this.performerInfo,
      bookerInfo: bookerInfo ?? this.bookerInfo,
      venueInfo: venueInfo ?? this.venueInfo,
      socialFollowing: socialFollowing ?? this.socialFollowing,
      deleted: deleted ?? this.deleted,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      stripeConnectedAccountId:
          stripeConnectedAccountId ?? this.stripeConnectedAccountId,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      latestAppVersion: latestAppVersion ?? this.latestAppVersion,
    );
  }
}
