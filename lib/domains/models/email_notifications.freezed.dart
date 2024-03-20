// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_notifications.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmailNotifications _$EmailNotificationsFromJson(Map<String, dynamic> json) {
  return _EmailNotifications.fromJson(json);
}

/// @nodoc
mixin _$EmailNotifications {
  bool get appReleases => throw _privateConstructorUsedError;
  bool get tappedUpdates => throw _privateConstructorUsedError;
  bool get bookingRequests => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmailNotificationsCopyWith<EmailNotifications> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailNotificationsCopyWith<$Res> {
  factory $EmailNotificationsCopyWith(
          EmailNotifications value, $Res Function(EmailNotifications) then) =
      _$EmailNotificationsCopyWithImpl<$Res, EmailNotifications>;
  @useResult
  $Res call({bool appReleases, bool tappedUpdates, bool bookingRequests});
}

/// @nodoc
class _$EmailNotificationsCopyWithImpl<$Res, $Val extends EmailNotifications>
    implements $EmailNotificationsCopyWith<$Res> {
  _$EmailNotificationsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appReleases = null,
    Object? tappedUpdates = null,
    Object? bookingRequests = null,
  }) {
    return _then(_value.copyWith(
      appReleases: null == appReleases
          ? _value.appReleases
          : appReleases // ignore: cast_nullable_to_non_nullable
              as bool,
      tappedUpdates: null == tappedUpdates
          ? _value.tappedUpdates
          : tappedUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
      bookingRequests: null == bookingRequests
          ? _value.bookingRequests
          : bookingRequests // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailNotificationsImplCopyWith<$Res>
    implements $EmailNotificationsCopyWith<$Res> {
  factory _$$EmailNotificationsImplCopyWith(_$EmailNotificationsImpl value,
          $Res Function(_$EmailNotificationsImpl) then) =
      __$$EmailNotificationsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool appReleases, bool tappedUpdates, bool bookingRequests});
}

/// @nodoc
class __$$EmailNotificationsImplCopyWithImpl<$Res>
    extends _$EmailNotificationsCopyWithImpl<$Res, _$EmailNotificationsImpl>
    implements _$$EmailNotificationsImplCopyWith<$Res> {
  __$$EmailNotificationsImplCopyWithImpl(_$EmailNotificationsImpl _value,
      $Res Function(_$EmailNotificationsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appReleases = null,
    Object? tappedUpdates = null,
    Object? bookingRequests = null,
  }) {
    return _then(_$EmailNotificationsImpl(
      appReleases: null == appReleases
          ? _value.appReleases
          : appReleases // ignore: cast_nullable_to_non_nullable
              as bool,
      tappedUpdates: null == tappedUpdates
          ? _value.tappedUpdates
          : tappedUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
      bookingRequests: null == bookingRequests
          ? _value.bookingRequests
          : bookingRequests // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmailNotificationsImpl implements _EmailNotifications {
  const _$EmailNotificationsImpl(
      {this.appReleases = true,
      this.tappedUpdates = true,
      this.bookingRequests = true});

  factory _$EmailNotificationsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmailNotificationsImplFromJson(json);

  @override
  @JsonKey()
  final bool appReleases;
  @override
  @JsonKey()
  final bool tappedUpdates;
  @override
  @JsonKey()
  final bool bookingRequests;

  @override
  String toString() {
    return 'EmailNotifications(appReleases: $appReleases, tappedUpdates: $tappedUpdates, bookingRequests: $bookingRequests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailNotificationsImpl &&
            (identical(other.appReleases, appReleases) ||
                other.appReleases == appReleases) &&
            (identical(other.tappedUpdates, tappedUpdates) ||
                other.tappedUpdates == tappedUpdates) &&
            (identical(other.bookingRequests, bookingRequests) ||
                other.bookingRequests == bookingRequests));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, appReleases, tappedUpdates, bookingRequests);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailNotificationsImplCopyWith<_$EmailNotificationsImpl> get copyWith =>
      __$$EmailNotificationsImplCopyWithImpl<_$EmailNotificationsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailNotificationsImplToJson(
      this,
    );
  }
}

abstract class _EmailNotifications implements EmailNotifications {
  const factory _EmailNotifications(
      {final bool appReleases,
      final bool tappedUpdates,
      final bool bookingRequests}) = _$EmailNotificationsImpl;

  factory _EmailNotifications.fromJson(Map<String, dynamic> json) =
      _$EmailNotificationsImpl.fromJson;

  @override
  bool get appReleases;
  @override
  bool get tappedUpdates;
  @override
  bool get bookingRequests;
  @override
  @JsonKey(ignore: true)
  _$$EmailNotificationsImplCopyWith<_$EmailNotificationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
