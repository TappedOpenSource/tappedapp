// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_venue_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactVenueRequest _$ContactVenueRequestFromJson(Map<String, dynamic> json) {
  return _ContactVenueRequest.fromJson(json);
}

/// @nodoc
mixin _$ContactVenueRequest {
  UserModel get venue => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;
  String get bookingEmail => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;
  Option<String> get originalMessageId => throw _privateConstructorUsedError;
  Option<String> get latestMessageId => throw _privateConstructorUsedError;
  Option<String> get subject => throw _privateConstructorUsedError;
  List<String> get allEmails => throw _privateConstructorUsedError;
  List<UserModel> get collaborators => throw _privateConstructorUsedError;
  Option<String> get opportunityId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactVenueRequestCopyWith<ContactVenueRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactVenueRequestCopyWith<$Res> {
  factory $ContactVenueRequestCopyWith(
          ContactVenueRequest value, $Res Function(ContactVenueRequest) then) =
      _$ContactVenueRequestCopyWithImpl<$Res, ContactVenueRequest>;
  @useResult
  $Res call(
      {UserModel venue,
      UserModel user,
      String bookingEmail,
      String note,
      @DateTimeConverter() DateTime timestamp,
      Option<String> originalMessageId,
      Option<String> latestMessageId,
      Option<String> subject,
      List<String> allEmails,
      List<UserModel> collaborators,
      Option<String> opportunityId});

  $UserModelCopyWith<$Res> get venue;
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$ContactVenueRequestCopyWithImpl<$Res, $Val extends ContactVenueRequest>
    implements $ContactVenueRequestCopyWith<$Res> {
  _$ContactVenueRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venue = null,
    Object? user = null,
    Object? bookingEmail = null,
    Object? note = null,
    Object? timestamp = null,
    Object? originalMessageId = null,
    Object? latestMessageId = null,
    Object? subject = null,
    Object? allEmails = null,
    Object? collaborators = null,
    Object? opportunityId = null,
  }) {
    return _then(_value.copyWith(
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as UserModel,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      bookingEmail: null == bookingEmail
          ? _value.bookingEmail
          : bookingEmail // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      originalMessageId: null == originalMessageId
          ? _value.originalMessageId
          : originalMessageId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      latestMessageId: null == latestMessageId
          ? _value.latestMessageId
          : latestMessageId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      allEmails: null == allEmails
          ? _value.allEmails
          : allEmails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      collaborators: null == collaborators
          ? _value.collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      opportunityId: null == opportunityId
          ? _value.opportunityId
          : opportunityId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get venue {
    return $UserModelCopyWith<$Res>(_value.venue, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContactVenueRequestImplCopyWith<$Res>
    implements $ContactVenueRequestCopyWith<$Res> {
  factory _$$ContactVenueRequestImplCopyWith(_$ContactVenueRequestImpl value,
          $Res Function(_$ContactVenueRequestImpl) then) =
      __$$ContactVenueRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserModel venue,
      UserModel user,
      String bookingEmail,
      String note,
      @DateTimeConverter() DateTime timestamp,
      Option<String> originalMessageId,
      Option<String> latestMessageId,
      Option<String> subject,
      List<String> allEmails,
      List<UserModel> collaborators,
      Option<String> opportunityId});

  @override
  $UserModelCopyWith<$Res> get venue;
  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$ContactVenueRequestImplCopyWithImpl<$Res>
    extends _$ContactVenueRequestCopyWithImpl<$Res, _$ContactVenueRequestImpl>
    implements _$$ContactVenueRequestImplCopyWith<$Res> {
  __$$ContactVenueRequestImplCopyWithImpl(_$ContactVenueRequestImpl _value,
      $Res Function(_$ContactVenueRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venue = null,
    Object? user = null,
    Object? bookingEmail = null,
    Object? note = null,
    Object? timestamp = null,
    Object? originalMessageId = null,
    Object? latestMessageId = null,
    Object? subject = null,
    Object? allEmails = null,
    Object? collaborators = null,
    Object? opportunityId = null,
  }) {
    return _then(_$ContactVenueRequestImpl(
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as UserModel,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      bookingEmail: null == bookingEmail
          ? _value.bookingEmail
          : bookingEmail // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      originalMessageId: null == originalMessageId
          ? _value.originalMessageId
          : originalMessageId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      latestMessageId: null == latestMessageId
          ? _value.latestMessageId
          : latestMessageId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      allEmails: null == allEmails
          ? _value._allEmails
          : allEmails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      collaborators: null == collaborators
          ? _value._collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      opportunityId: null == opportunityId
          ? _value.opportunityId
          : opportunityId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ContactVenueRequestImpl implements _ContactVenueRequest {
  const _$ContactVenueRequestImpl(
      {required this.venue,
      required this.user,
      required this.bookingEmail,
      required this.note,
      @DateTimeConverter() required this.timestamp,
      this.originalMessageId = const None(),
      this.latestMessageId = const None(),
      this.subject = const None(),
      final List<String> allEmails = const [],
      final List<UserModel> collaborators = const [],
      this.opportunityId = const None()})
      : _allEmails = allEmails,
        _collaborators = collaborators;

  factory _$ContactVenueRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactVenueRequestImplFromJson(json);

  @override
  final UserModel venue;
  @override
  final UserModel user;
  @override
  final String bookingEmail;
  @override
  final String note;
  @override
  @DateTimeConverter()
  final DateTime timestamp;
  @override
  @JsonKey()
  final Option<String> originalMessageId;
  @override
  @JsonKey()
  final Option<String> latestMessageId;
  @override
  @JsonKey()
  final Option<String> subject;
  final List<String> _allEmails;
  @override
  @JsonKey()
  List<String> get allEmails {
    if (_allEmails is EqualUnmodifiableListView) return _allEmails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allEmails);
  }

  final List<UserModel> _collaborators;
  @override
  @JsonKey()
  List<UserModel> get collaborators {
    if (_collaborators is EqualUnmodifiableListView) return _collaborators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collaborators);
  }

  @override
  @JsonKey()
  final Option<String> opportunityId;

  @override
  String toString() {
    return 'ContactVenueRequest(venue: $venue, user: $user, bookingEmail: $bookingEmail, note: $note, timestamp: $timestamp, originalMessageId: $originalMessageId, latestMessageId: $latestMessageId, subject: $subject, allEmails: $allEmails, collaborators: $collaborators, opportunityId: $opportunityId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactVenueRequestImpl &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.bookingEmail, bookingEmail) ||
                other.bookingEmail == bookingEmail) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.originalMessageId, originalMessageId) ||
                other.originalMessageId == originalMessageId) &&
            (identical(other.latestMessageId, latestMessageId) ||
                other.latestMessageId == latestMessageId) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            const DeepCollectionEquality()
                .equals(other._allEmails, _allEmails) &&
            const DeepCollectionEquality()
                .equals(other._collaborators, _collaborators) &&
            (identical(other.opportunityId, opportunityId) ||
                other.opportunityId == opportunityId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      venue,
      user,
      bookingEmail,
      note,
      timestamp,
      originalMessageId,
      latestMessageId,
      subject,
      const DeepCollectionEquality().hash(_allEmails),
      const DeepCollectionEquality().hash(_collaborators),
      opportunityId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactVenueRequestImplCopyWith<_$ContactVenueRequestImpl> get copyWith =>
      __$$ContactVenueRequestImplCopyWithImpl<_$ContactVenueRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactVenueRequestImplToJson(
      this,
    );
  }
}

abstract class _ContactVenueRequest implements ContactVenueRequest {
  const factory _ContactVenueRequest(
      {required final UserModel venue,
      required final UserModel user,
      required final String bookingEmail,
      required final String note,
      @DateTimeConverter() required final DateTime timestamp,
      final Option<String> originalMessageId,
      final Option<String> latestMessageId,
      final Option<String> subject,
      final List<String> allEmails,
      final List<UserModel> collaborators,
      final Option<String> opportunityId}) = _$ContactVenueRequestImpl;

  factory _ContactVenueRequest.fromJson(Map<String, dynamic> json) =
      _$ContactVenueRequestImpl.fromJson;

  @override
  UserModel get venue;
  @override
  UserModel get user;
  @override
  String get bookingEmail;
  @override
  String get note;
  @override
  @DateTimeConverter()
  DateTime get timestamp;
  @override
  Option<String> get originalMessageId;
  @override
  Option<String> get latestMessageId;
  @override
  Option<String> get subject;
  @override
  List<String> get allEmails;
  @override
  List<UserModel> get collaborators;
  @override
  Option<String> get opportunityId;
  @override
  @JsonKey(ignore: true)
  _$$ContactVenueRequestImplCopyWith<_$ContactVenueRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
