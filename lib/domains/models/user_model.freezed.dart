// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  @OptionalDateTimeConverter()
  Option<DateTime> get timestamp => throw _privateConstructorUsedError;
  @UsernameConverter()
  Username get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  Option<String> get phoneNumber => throw _privateConstructorUsedError;
  Option<String> get website => throw _privateConstructorUsedError;
  bool get unclaimed => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  Option<String> get profilePicture => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  List<String> get occupations => throw _privateConstructorUsedError;
  Option<Location> get location => throw _privateConstructorUsedError;
  int get badgesCount => throw _privateConstructorUsedError;
  Option<PerformerInfo> get performerInfo => throw _privateConstructorUsedError;
  Option<BookerInfo> get bookerInfo => throw _privateConstructorUsedError;
  Option<VenueInfo> get venueInfo => throw _privateConstructorUsedError;
  SocialFollowing get socialFollowing => throw _privateConstructorUsedError;
  EmailNotifications get emailNotifications =>
      throw _privateConstructorUsedError;
  PushNotifications get pushNotifications => throw _privateConstructorUsedError;
  bool get deleted => throw _privateConstructorUsedError;
  Option<String> get stripeConnectedAccountId =>
      throw _privateConstructorUsedError;
  Option<String> get stripeCustomerId => throw _privateConstructorUsedError;
  Option<String> get latestAppVersion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      @OptionalDateTimeConverter() Option<DateTime> timestamp,
      @UsernameConverter() Username username,
      String email,
      Option<String> phoneNumber,
      Option<String> website,
      bool unclaimed,
      String artistName,
      Option<String> profilePicture,
      String bio,
      List<String> occupations,
      Option<Location> location,
      int badgesCount,
      Option<PerformerInfo> performerInfo,
      Option<BookerInfo> bookerInfo,
      Option<VenueInfo> venueInfo,
      SocialFollowing socialFollowing,
      EmailNotifications emailNotifications,
      PushNotifications pushNotifications,
      bool deleted,
      Option<String> stripeConnectedAccountId,
      Option<String> stripeCustomerId,
      Option<String> latestAppVersion});

  $SocialFollowingCopyWith<$Res> get socialFollowing;
  $EmailNotificationsCopyWith<$Res> get emailNotifications;
  $PushNotificationsCopyWith<$Res> get pushNotifications;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? username = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? website = null,
    Object? unclaimed = null,
    Object? artistName = null,
    Object? profilePicture = null,
    Object? bio = null,
    Object? occupations = null,
    Object? location = null,
    Object? badgesCount = null,
    Object? performerInfo = null,
    Object? bookerInfo = null,
    Object? venueInfo = null,
    Object? socialFollowing = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? deleted = null,
    Object? stripeConnectedAccountId = null,
    Object? stripeCustomerId = null,
    Object? latestAppVersion = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as Option<DateTime>,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as Username,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      website: null == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      unclaimed: null == unclaimed
          ? _value.unclaimed
          : unclaimed // ignore: cast_nullable_to_non_nullable
              as bool,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      profilePicture: null == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      occupations: null == occupations
          ? _value.occupations
          : occupations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Option<Location>,
      badgesCount: null == badgesCount
          ? _value.badgesCount
          : badgesCount // ignore: cast_nullable_to_non_nullable
              as int,
      performerInfo: null == performerInfo
          ? _value.performerInfo
          : performerInfo // ignore: cast_nullable_to_non_nullable
              as Option<PerformerInfo>,
      bookerInfo: null == bookerInfo
          ? _value.bookerInfo
          : bookerInfo // ignore: cast_nullable_to_non_nullable
              as Option<BookerInfo>,
      venueInfo: null == venueInfo
          ? _value.venueInfo
          : venueInfo // ignore: cast_nullable_to_non_nullable
              as Option<VenueInfo>,
      socialFollowing: null == socialFollowing
          ? _value.socialFollowing
          : socialFollowing // ignore: cast_nullable_to_non_nullable
              as SocialFollowing,
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as EmailNotifications,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as PushNotifications,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
      stripeConnectedAccountId: null == stripeConnectedAccountId
          ? _value.stripeConnectedAccountId
          : stripeConnectedAccountId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      stripeCustomerId: null == stripeCustomerId
          ? _value.stripeCustomerId
          : stripeCustomerId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      latestAppVersion: null == latestAppVersion
          ? _value.latestAppVersion
          : latestAppVersion // ignore: cast_nullable_to_non_nullable
              as Option<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SocialFollowingCopyWith<$Res> get socialFollowing {
    return $SocialFollowingCopyWith<$Res>(_value.socialFollowing, (value) {
      return _then(_value.copyWith(socialFollowing: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EmailNotificationsCopyWith<$Res> get emailNotifications {
    return $EmailNotificationsCopyWith<$Res>(_value.emailNotifications,
        (value) {
      return _then(_value.copyWith(emailNotifications: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PushNotificationsCopyWith<$Res> get pushNotifications {
    return $PushNotificationsCopyWith<$Res>(_value.pushNotifications, (value) {
      return _then(_value.copyWith(pushNotifications: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @OptionalDateTimeConverter() Option<DateTime> timestamp,
      @UsernameConverter() Username username,
      String email,
      Option<String> phoneNumber,
      Option<String> website,
      bool unclaimed,
      String artistName,
      Option<String> profilePicture,
      String bio,
      List<String> occupations,
      Option<Location> location,
      int badgesCount,
      Option<PerformerInfo> performerInfo,
      Option<BookerInfo> bookerInfo,
      Option<VenueInfo> venueInfo,
      SocialFollowing socialFollowing,
      EmailNotifications emailNotifications,
      PushNotifications pushNotifications,
      bool deleted,
      Option<String> stripeConnectedAccountId,
      Option<String> stripeCustomerId,
      Option<String> latestAppVersion});

  @override
  $SocialFollowingCopyWith<$Res> get socialFollowing;
  @override
  $EmailNotificationsCopyWith<$Res> get emailNotifications;
  @override
  $PushNotificationsCopyWith<$Res> get pushNotifications;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? username = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? website = null,
    Object? unclaimed = null,
    Object? artistName = null,
    Object? profilePicture = null,
    Object? bio = null,
    Object? occupations = null,
    Object? location = null,
    Object? badgesCount = null,
    Object? performerInfo = null,
    Object? bookerInfo = null,
    Object? venueInfo = null,
    Object? socialFollowing = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? deleted = null,
    Object? stripeConnectedAccountId = null,
    Object? stripeCustomerId = null,
    Object? latestAppVersion = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as Option<DateTime>,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as Username,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      website: null == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      unclaimed: null == unclaimed
          ? _value.unclaimed
          : unclaimed // ignore: cast_nullable_to_non_nullable
              as bool,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      profilePicture: null == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      occupations: null == occupations
          ? _value._occupations
          : occupations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Option<Location>,
      badgesCount: null == badgesCount
          ? _value.badgesCount
          : badgesCount // ignore: cast_nullable_to_non_nullable
              as int,
      performerInfo: null == performerInfo
          ? _value.performerInfo
          : performerInfo // ignore: cast_nullable_to_non_nullable
              as Option<PerformerInfo>,
      bookerInfo: null == bookerInfo
          ? _value.bookerInfo
          : bookerInfo // ignore: cast_nullable_to_non_nullable
              as Option<BookerInfo>,
      venueInfo: null == venueInfo
          ? _value.venueInfo
          : venueInfo // ignore: cast_nullable_to_non_nullable
              as Option<VenueInfo>,
      socialFollowing: null == socialFollowing
          ? _value.socialFollowing
          : socialFollowing // ignore: cast_nullable_to_non_nullable
              as SocialFollowing,
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as EmailNotifications,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as PushNotifications,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
      stripeConnectedAccountId: null == stripeConnectedAccountId
          ? _value.stripeConnectedAccountId
          : stripeConnectedAccountId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      stripeCustomerId: null == stripeCustomerId
          ? _value.stripeCustomerId
          : stripeCustomerId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      latestAppVersion: null == latestAppVersion
          ? _value.latestAppVersion
          : latestAppVersion // ignore: cast_nullable_to_non_nullable
              as Option<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      @OptionalDateTimeConverter() required this.timestamp,
      @UsernameConverter() required this.username,
      this.email = '',
      this.phoneNumber = const None(),
      this.website = const None(),
      this.unclaimed = false,
      this.artistName = '',
      this.profilePicture = const None(),
      this.bio = '',
      final List<String> occupations = const [],
      this.location = const None(),
      this.badgesCount = 0,
      this.performerInfo = const None(),
      this.bookerInfo = const None(),
      this.venueInfo = const None(),
      this.socialFollowing = SocialFollowing.empty,
      this.emailNotifications = EmailNotifications.empty,
      this.pushNotifications = PushNotifications.empty,
      this.deleted = false,
      this.stripeConnectedAccountId = const None(),
      this.stripeCustomerId = const None(),
      this.latestAppVersion = const None()})
      : _occupations = occupations;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  @OptionalDateTimeConverter()
  final Option<DateTime> timestamp;
  @override
  @UsernameConverter()
  final Username username;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final Option<String> phoneNumber;
  @override
  @JsonKey()
  final Option<String> website;
  @override
  @JsonKey()
  final bool unclaimed;
  @override
  @JsonKey()
  final String artistName;
  @override
  @JsonKey()
  final Option<String> profilePicture;
  @override
  @JsonKey()
  final String bio;
  final List<String> _occupations;
  @override
  @JsonKey()
  List<String> get occupations {
    if (_occupations is EqualUnmodifiableListView) return _occupations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_occupations);
  }

  @override
  @JsonKey()
  final Option<Location> location;
  @override
  @JsonKey()
  final int badgesCount;
  @override
  @JsonKey()
  final Option<PerformerInfo> performerInfo;
  @override
  @JsonKey()
  final Option<BookerInfo> bookerInfo;
  @override
  @JsonKey()
  final Option<VenueInfo> venueInfo;
  @override
  @JsonKey()
  final SocialFollowing socialFollowing;
  @override
  @JsonKey()
  final EmailNotifications emailNotifications;
  @override
  @JsonKey()
  final PushNotifications pushNotifications;
  @override
  @JsonKey()
  final bool deleted;
  @override
  @JsonKey()
  final Option<String> stripeConnectedAccountId;
  @override
  @JsonKey()
  final Option<String> stripeCustomerId;
  @override
  @JsonKey()
  final Option<String> latestAppVersion;

  @override
  String toString() {
    return 'UserModel(id: $id, timestamp: $timestamp, username: $username, email: $email, phoneNumber: $phoneNumber, website: $website, unclaimed: $unclaimed, artistName: $artistName, profilePicture: $profilePicture, bio: $bio, occupations: $occupations, location: $location, badgesCount: $badgesCount, performerInfo: $performerInfo, bookerInfo: $bookerInfo, venueInfo: $venueInfo, socialFollowing: $socialFollowing, emailNotifications: $emailNotifications, pushNotifications: $pushNotifications, deleted: $deleted, stripeConnectedAccountId: $stripeConnectedAccountId, stripeCustomerId: $stripeCustomerId, latestAppVersion: $latestAppVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.unclaimed, unclaimed) ||
                other.unclaimed == unclaimed) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._occupations, _occupations) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.badgesCount, badgesCount) ||
                other.badgesCount == badgesCount) &&
            (identical(other.performerInfo, performerInfo) ||
                other.performerInfo == performerInfo) &&
            (identical(other.bookerInfo, bookerInfo) ||
                other.bookerInfo == bookerInfo) &&
            (identical(other.venueInfo, venueInfo) ||
                other.venueInfo == venueInfo) &&
            (identical(other.socialFollowing, socialFollowing) ||
                other.socialFollowing == socialFollowing) &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.pushNotifications, pushNotifications) ||
                other.pushNotifications == pushNotifications) &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(
                    other.stripeConnectedAccountId, stripeConnectedAccountId) ||
                other.stripeConnectedAccountId == stripeConnectedAccountId) &&
            (identical(other.stripeCustomerId, stripeCustomerId) ||
                other.stripeCustomerId == stripeCustomerId) &&
            (identical(other.latestAppVersion, latestAppVersion) ||
                other.latestAppVersion == latestAppVersion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        timestamp,
        username,
        email,
        phoneNumber,
        website,
        unclaimed,
        artistName,
        profilePicture,
        bio,
        const DeepCollectionEquality().hash(_occupations),
        location,
        badgesCount,
        performerInfo,
        bookerInfo,
        venueInfo,
        socialFollowing,
        emailNotifications,
        pushNotifications,
        deleted,
        stripeConnectedAccountId,
        stripeCustomerId,
        latestAppVersion
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String id,
      @OptionalDateTimeConverter() required final Option<DateTime> timestamp,
      @UsernameConverter() required final Username username,
      final String email,
      final Option<String> phoneNumber,
      final Option<String> website,
      final bool unclaimed,
      final String artistName,
      final Option<String> profilePicture,
      final String bio,
      final List<String> occupations,
      final Option<Location> location,
      final int badgesCount,
      final Option<PerformerInfo> performerInfo,
      final Option<BookerInfo> bookerInfo,
      final Option<VenueInfo> venueInfo,
      final SocialFollowing socialFollowing,
      final EmailNotifications emailNotifications,
      final PushNotifications pushNotifications,
      final bool deleted,
      final Option<String> stripeConnectedAccountId,
      final Option<String> stripeCustomerId,
      final Option<String> latestAppVersion}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  @OptionalDateTimeConverter()
  Option<DateTime> get timestamp;
  @override
  @UsernameConverter()
  Username get username;
  @override
  String get email;
  @override
  Option<String> get phoneNumber;
  @override
  Option<String> get website;
  @override
  bool get unclaimed;
  @override
  String get artistName;
  @override
  Option<String> get profilePicture;
  @override
  String get bio;
  @override
  List<String> get occupations;
  @override
  Option<Location> get location;
  @override
  int get badgesCount;
  @override
  Option<PerformerInfo> get performerInfo;
  @override
  Option<BookerInfo> get bookerInfo;
  @override
  Option<VenueInfo> get venueInfo;
  @override
  SocialFollowing get socialFollowing;
  @override
  EmailNotifications get emailNotifications;
  @override
  PushNotifications get pushNotifications;
  @override
  bool get deleted;
  @override
  Option<String> get stripeConnectedAccountId;
  @override
  Option<String> get stripeCustomerId;
  @override
  Option<String> get latestAppVersion;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
