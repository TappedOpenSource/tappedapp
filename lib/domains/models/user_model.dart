import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/booker_info.dart';
import 'package:intheloopapp/domains/models/email_notifications.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/push_notifications.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/domains/models/venue_info.dart';
import 'package:intheloopapp/utils/default_value.dart';
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
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpTimestamp = doc.getOrElse(
      'timestamp',
      Timestamp.now(),
    );

    final performerInfoData = doc.getOrElse<Map<String, dynamic>?>(
      'performerInfo',
      null,
    );

    final performerInfo = performerInfoData != null
      ? Some<PerformerInfo>(
        PerformerInfo.fromJson(performerInfoData),
      )
      : const None<PerformerInfo>();

    final bookerInfoData = doc.getOrElse<Map<String, dynamic>?>(
      'bookerInfo',
      null,
    );

    final bookerInfo = bookerInfoData != null
      ? Some<BookerInfo>(
        BookerInfo.fromJson(bookerInfoData),
      )
      : const None<BookerInfo>();

    final venueInfoData = doc.getOrElse<Map<String, dynamic>?>(
      'venueInfo',
      null,
    );

    final venueInfo = venueInfoData != null
        ? Some<VenueInfo>(
      VenueInfo.fromJson(venueInfoData),
    )
        : const None<VenueInfo>();

    final socialFollowingData = doc.getOrElse<Map<String, dynamic>?>(
      'socialFollowing',
      null,
    );

    final socialFollowing = socialFollowingData != null
      ? SocialFollowing.fromJson(socialFollowingData)
      : SocialFollowing.empty();

    final emailNotificationsData = doc.getOrElse<Map<String, dynamic>?>(
      'emailNotifications',
      null,
    );

    final emailNotifications = emailNotificationsData != null
      ? EmailNotifications.fromJson(emailNotificationsData)
      : EmailNotifications.empty();

    final pushNotificationsData = doc.getOrElse<Map<String, dynamic>?>(
      'pushNotifications',
      null,
    );

    final pushNotifications = pushNotificationsData != null
      ? PushNotifications.fromJson(pushNotificationsData)
      : PushNotifications.empty();

    final tmpLocation = doc.getOrElse<Map<String, dynamic>?>(
      'location',
      null,
    );

    final location = tmpLocation != null
      ? Some<Location>(
        Location.fromJson(tmpLocation),
      )
      : const None<Location>();

    return UserModel(
      id: doc.id,
      email: doc.getOrElse('email', ''),
      timestamp: tmpTimestamp.toDate(),
      username: Username.fromString(doc.getOrElse('username', 'anonymous')),
      artistName: doc.getOrElse('artistName', ''),
      profilePicture: Option.fromNullable(doc.getOrElse<String?>('profilePicture', null),),
      bio: doc.getOrElse<String>('bio', ''),
      occupations: doc
          .getOrElse<List<dynamic>>('occupations', [])
          .whereType<String>()
          .toList(),
      location: location,
      badgesCount: doc.getOrElse<int>('badgesCount', 0),
      performerInfo: performerInfo,
      bookerInfo: bookerInfo,
      venueInfo: venueInfo,
      socialFollowing: socialFollowing,
      deleted: doc.getOrElse<bool>('deleted', false),
      emailNotifications: emailNotifications,
      pushNotifications: pushNotifications,
      stripeConnectedAccountId: Option.fromNullable(
    doc.getOrElse<String?>(
        'stripeConnectedAccountId',
        null,
      ),
      ),
      stripeCustomerId: Option.fromNullable(
    doc.getOrElse<String?>('stripeCustomerId', null),
      ),
    );
  }
  final String id;
  final String email;
  final DateTime timestamp;

  @JsonKey(fromJson: Username.fromJson, toJson: Username.usernameToString)
  final Username username;

  final String artistName;
  final String bio;
  final List<String> occupations;

  @OptionalStringConverter()
  final Option<String> profilePicture;

  @OptionalLocationConverter()
  final Option<Location> location;

  final int badgesCount;

  @OptionalPerformerInfoConverter()
  final Option<PerformerInfo> performerInfo;

  @OptionalVenueInfoConverter()
  final Option<VenueInfo> venueInfo;

  @OptionalBookerInfoConverter()
  final Option<BookerInfo> bookerInfo;

  final EmailNotifications emailNotifications;
  final PushNotifications pushNotifications;

  final bool deleted;

  final SocialFollowing socialFollowing;

  @OptionalStringConverter()
  final Option<String> stripeConnectedAccountId;

  @OptionalStringConverter()
  final Option<String> stripeCustomerId;

  Option<double> get overallRating {
    final performerRating = performerInfo.map((e) => e.rating).unwrapOr(None());
    final bookerRating = bookerInfo.map((e) => e.rating).unwrapOr(None());

    return switch ((performerRating, bookerRating)) {
      (None(), None()) => None(),
      (Some(:final value), None()) => Some(value),
      (None(), Some(:final value)) => Some(value),
      (Some(), Some()) => () {
        final overallRating = (performerRating.unwrap + bookerRating.unwrap) / 2;

        return Some(overallRating);
      }()
    };
  }

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
      ];
  bool get isEmpty => this == UserModel.empty();
  bool get isNotEmpty => this != UserModel.empty();
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get displayName => artistName.isEmpty ? username.username : artistName;

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'timestamp': timestamp,
      'username': username.toString(),
      'artistName': artistName,
      'bio': bio,
      'occupations': occupations,
      'profilePicture': profilePicture.asNullable(),
      'location': location.asNullable()?.toMap(),
      'performerInfo': performerInfo.asNullable()?.toMap(),
      'bookerInfo': bookerInfo.asNullable()?.toMap(),
      'venueInfo': venueInfo.asNullable()?.toMap(),
      'socialFollowing': socialFollowing.toMap(),
      'deleted': deleted,
      'emailNotifications': emailNotifications.toMap(),
      'pushNotifications': pushNotifications.toMap(),
      'stripeConnectedAccountId': stripeConnectedAccountId.asNullable(),
      'stripeCustomerId': stripeCustomerId.asNullable(),
    };
  }
}
