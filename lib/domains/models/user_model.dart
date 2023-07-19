import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/username.dart';
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
    required this.genres,
    required this.occupations,
    required this.label,
    required this.placeId,
    required this.geohash,
    required this.lat,
    required this.lng,
    required this.loopsCount,
    required this.badgesCount,
    required this.reviewCount,
    required this.followerCount,
    required this.followingCount,
    required this.overallRating,
    required this.deleted,
    required this.shadowBanned,
    required this.accountType,
    required this.epkUrl,
    required this.youtubeChannelId,
    required this.tiktokHandle,
    required this.instagramHandle,
    required this.twitterHandle,
    required this.spotifyId,
    required this.pushNotificationsLikes,
    required this.pushNotificationsComments,
    required this.pushNotificationsFollows,
    required this.pushNotificationsDirectMessages,
    required this.pushNotificationsITLUpdates,
    required this.emailNotificationsAppReleases,
    required this.emailNotificationsITLUpdates,
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
        genres: const [],
        occupations: const [],
        label: 'None',
        profilePicture: null,
        placeId: null,
        geohash: null,
        lat: null,
        lng: null,
        loopsCount: 0,
        badgesCount: 0,
        reviewCount: 0,
        followerCount: 0,
        followingCount: 0,
        overallRating: const None<double>(),
        deleted: false,
        shadowBanned: false,
        accountType: AccountType.free,
        epkUrl: const None<String>(),
        youtubeChannelId: null,
        tiktokHandle: null,
        instagramHandle: null,
        twitterHandle: null,
        spotifyId: null,
        pushNotificationsLikes: true,
        pushNotificationsComments: true,
        pushNotificationsFollows: true,
        pushNotificationsDirectMessages: true,
        pushNotificationsITLUpdates: true,
        emailNotificationsAppReleases: true,
        emailNotificationsITLUpdates: true,
        stripeConnectedAccountId: null,
        stripeCustomerId: null,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    late final AccountType accountType;
    try {
      accountType = $enumDecode(
        _$AccountTypeEnumMap,
        doc.getOrElse('accountType', 'free'),
      );
    } catch (e) {
      accountType = AccountType.free;
    }

    final tmpTimestamp = doc.getOrElse(
      'timestamp',
      Timestamp.now(),
    );

    final tmpOverallRating = doc.getOrElse<int?>('overallRating', null);
    final overallRating = tmpOverallRating != null
        ? Some<double>(tmpOverallRating.toDouble())
        : const None<double>();

    return UserModel(
      id: doc.id,
      email: doc.getOrElse('email', ''),
      timestamp: tmpTimestamp.toDate(),
      username:
          Username.fromString(doc.getOrElse('username', 'anonymous')),
      artistName: doc.getOrElse('artistName', ''),
      profilePicture: doc.getOrElse<String?>('profilePicture', null),
      bio: doc.getOrElse<String>('bio', ''),
      genres: (doc.getOrElse<List<dynamic>>('genres', []))
          .map(
            (dynamic e) =>
                EnumToString.fromString<Genre>(Genre.values, e as String),
          )
          .where((element) => element != null)
          .whereType<Genre>()
          .toList(),
      occupations: (doc.getOrElse<List<dynamic>>('occupations', []))
          .whereType<String>()
          .toList(),
      label: doc.getOrElse<String>('label', 'None'),
      placeId: doc.getOrElse<String?>('placeId', null),
      geohash: doc.getOrElse<String?>('geohash', null),
      lat: doc.getOrElse<double?>('lat', null),
      lng: doc.getOrElse<double?>('lng', null),
      loopsCount: doc.getOrElse<int>('loopsCount', 0),
      badgesCount: doc.getOrElse<int>('badgesCount', 0),
      reviewCount: doc.getOrElse<int>('reviewCount', 0),
      followerCount: doc.getOrElse<int>('followerCount', 0),
      followingCount: doc.getOrElse<int>('followingCount', 0),
      overallRating: overallRating,
      deleted: doc.getOrElse<bool>('deleted', false),
      shadowBanned: doc.getOrElse<bool>('shadowBanned', false),
      accountType: accountType,
      epkUrl: Option.fromNullable(
        doc.getOrElse<String?>('epkUrl', null),
      ),
      youtubeChannelId: doc.getOrElse<String?>('youtubeChannelId', null),
      tiktokHandle: doc.getOrElse<String?>('tiktokHandle', null),
      instagramHandle: doc.getOrElse<String?>('instagramHandle', null),
      twitterHandle: doc.getOrElse<String?>('twitterHandle', null),
      spotifyId: doc.getOrElse<String?>('spotifyId', null),
      pushNotificationsLikes:
          doc.getOrElse('pushNotificationsLikes', true),
      pushNotificationsComments:
          doc.getOrElse('pushNotificationsComments', true),
      pushNotificationsFollows:
          doc.getOrElse('pushNotificationsFollows', true),
      pushNotificationsDirectMessages:
          doc.getOrElse('pushNotificationsDirectMessages', true),
      pushNotificationsITLUpdates:
          doc.getOrElse('pushNotificationsITLUpdates', true),
      emailNotificationsAppReleases:
          doc.getOrElse('emailNotificationsAppReleases', true),
      emailNotificationsITLUpdates:
          doc.getOrElse('emailNotificationsITLUpdates', true),
      stripeConnectedAccountId: doc.getOrElse<String?>(
        'stripeConnectedAccountId',
        null,
      ),
      stripeCustomerId: doc.getOrElse<String?>('stripeCustomerId', null),
    );
  }
  final String id;
  final String email;
  final DateTime timestamp;

  @JsonKey(fromJson: Username.fromJson, toJson: Username.usernameToString)
  final Username username;

  final String artistName;
  final String bio;
  final List<Genre> genres;
  final List<String> occupations;
  final String label;

  final String? profilePicture;

  final String? placeId;
  final String? geohash;
  final double? lat;
  final double? lng;

  final int loopsCount;
  final int badgesCount;
  final int reviewCount;
  final int followerCount;
  final int followingCount;

  @OptionalDoubleConverter()
  final Option<double> overallRating;

  final bool deleted;
  final bool shadowBanned;
  final AccountType accountType;

  @OptionalStringConverter()
  final Option<String> epkUrl;

  final String? youtubeChannelId;
  final String? tiktokHandle;
  final String? instagramHandle;
  final String? twitterHandle;
  final String? spotifyId;

  final bool pushNotificationsLikes;
  final bool pushNotificationsComments;
  final bool pushNotificationsFollows;
  final bool pushNotificationsDirectMessages;
  final bool pushNotificationsITLUpdates;

  final bool emailNotificationsAppReleases;
  final bool emailNotificationsITLUpdates;

  final String? stripeConnectedAccountId;
  final String? stripeCustomerId;

  @override
  List<Object?> get props => [
        id,
        email,
        timestamp,
        username,
        artistName,
        profilePicture,
        bio,
        genres,
        occupations,
        label,
        placeId,
        geohash,
        lat,
        lng,
        loopsCount,
        badgesCount,
        reviewCount,
        followerCount,
        followingCount,
        overallRating,
        deleted,
        shadowBanned,
        accountType,
        epkUrl,
        youtubeChannelId,
        tiktokHandle,
        instagramHandle,
        twitterHandle,
        spotifyId,
        pushNotificationsLikes,
        pushNotificationsComments,
        pushNotificationsFollows,
        pushNotificationsDirectMessages,
        pushNotificationsITLUpdates,
        emailNotificationsAppReleases,
        emailNotificationsITLUpdates,
        stripeConnectedAccountId,
        stripeCustomerId,
      ];
  bool get isEmpty => this == UserModel.empty();
  bool get isNotEmpty => this != UserModel.empty();
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  bool get isVenue => accountType == AccountType.venue;
  bool get isNotVenue => accountType != AccountType.venue;
  bool get isFree => accountType == AccountType.free;
  bool get isNotFree => accountType != AccountType.free;

  String get displayName => artistName.isEmpty ? username.username : artistName;

  UserModel copyWith({
    String? id,
    String? email,
    DateTime? timestamp,
    Username? username,
    String? artistName,
    String? profilePicture,
    String? bio,
    List<Genre>? genres,
    List<String>? occupations,
    String? label,
    Option<String>? placeId,
    Option<String>? geohash,
    Option<double>? lat,
    Option<double>? lng,
    int? loopsCount,
    int? badgesCount,
    int? reviewCount,
    int? followerCount,
    int? followingCount,
    Option<double>? overallRating,
    bool? deleted,
    bool? shadowBanned,
    AccountType? accountType,
    Option<String>? epkUrl,
    String? youtubeChannelId,
    String? tiktokHandle,
    String? instagramHandle,
    String? twitterHandle,
    String? spotifyId,
    bool? pushNotificationsLikes,
    bool? pushNotificationsComments,
    bool? pushNotificationsFollows,
    bool? pushNotificationsDirectMessages,
    bool? pushNotificationsITLUpdates,
    bool? emailNotificationsAppReleases,
    bool? emailNotificationsITLUpdates,
    String? stripeConnectedAccountId,
    String? stripeCustomerId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      timestamp: timestamp ?? this.timestamp,
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      genres: genres ?? this.genres,
      occupations: occupations ?? this.occupations,
      label: label ?? this.label,
      placeId: placeId != null ? placeId.asNullable() : this.placeId,
      geohash: geohash != null ? geohash.asNullable() : this.geohash,
      lat: lat != null ? lat.asNullable() : this.lat,
      lng: lng != null ? lng.asNullable() : this.lng,
      loopsCount: loopsCount ?? this.loopsCount,
      badgesCount: badgesCount ?? this.badgesCount,
      reviewCount: reviewCount ?? this.reviewCount,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      overallRating: overallRating ?? this.overallRating,
      deleted: deleted ?? this.deleted,
      shadowBanned: shadowBanned ?? this.shadowBanned,
      accountType: accountType ?? this.accountType,
      epkUrl: epkUrl ?? this.epkUrl,
      youtubeChannelId: youtubeChannelId ?? this.youtubeChannelId,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      spotifyId: spotifyId ?? this.spotifyId,
      pushNotificationsLikes:
          pushNotificationsLikes ?? this.pushNotificationsLikes,
      pushNotificationsComments:
          pushNotificationsComments ?? this.pushNotificationsComments,
      pushNotificationsFollows:
          pushNotificationsFollows ?? this.pushNotificationsFollows,
      pushNotificationsDirectMessages: pushNotificationsDirectMessages ??
          this.pushNotificationsDirectMessages,
      pushNotificationsITLUpdates:
          pushNotificationsITLUpdates ?? this.pushNotificationsITLUpdates,
      emailNotificationsAppReleases:
          emailNotificationsAppReleases ?? this.emailNotificationsAppReleases,
      emailNotificationsITLUpdates:
          emailNotificationsITLUpdates ?? this.emailNotificationsITLUpdates,
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
      'genres': genres.map((e) => e.name).toList(),
      'occupations': occupations,
      'label': label,
      'profilePicture': profilePicture,
      'placeId': placeId,
      'geohash': geohash,
      'lat': lat,
      'lng': lng,
      'loopsCount': loopsCount,
      'badgesCount': badgesCount,
      'reviewCount': reviewCount,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'overallRating': overallRating.asNullable(),
      'deleted': deleted,
      'shadowBanned': shadowBanned,
      'accountType': _$AccountTypeEnumMap[accountType],
      'epkUrl': epkUrl.asNullable(),
      'youtubeChannelId': youtubeChannelId,
      'tiktokHandle': tiktokHandle,
      'instagramHandle': instagramHandle,
      'spotifyId': spotifyId,
      'twitterHandle': twitterHandle,
      'pushNotificationsLikes': pushNotificationsLikes,
      'pushNotificationsComments': pushNotificationsComments,
      'pushNotificationsFollows': pushNotificationsFollows,
      'pushNotificationsDirectMessages': pushNotificationsDirectMessages,
      'pushNotificationsITLUpdates': pushNotificationsITLUpdates,
      'emailNotificationsAppReleases': emailNotificationsAppReleases,
      'emailNotificationsITLUpdates': emailNotificationsITLUpdates,
      'stripeConnectedAccountId': stripeConnectedAccountId,
      'stripeCustomerId': stripeCustomerId,
    };
  }
}

/// The different account types for a user
enum AccountType {
  /// Venue users
  @JsonValue('venue')
  venue,

  /// Users with free accounts
  @JsonValue('free')
  free,
}
