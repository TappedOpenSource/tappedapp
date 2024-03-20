// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notifications.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PushNotifications _$PushNotificationsFromJson(Map<String, dynamic> json) {
  return _PushNotifications.fromJson(json);
}

/// @nodoc
mixin _$PushNotifications {
  bool get appReleases => throw _privateConstructorUsedError;
  bool get tappedUpdates => throw _privateConstructorUsedError;
  bool get bookingRequests => throw _privateConstructorUsedError;
  bool get directMessages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PushNotificationsCopyWith<PushNotifications> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotificationsCopyWith<$Res> {
  factory $PushNotificationsCopyWith(
          PushNotifications value, $Res Function(PushNotifications) then) =
      _$PushNotificationsCopyWithImpl<$Res, PushNotifications>;
  @useResult
  $Res call(
      {bool appReleases,
      bool tappedUpdates,
      bool bookingRequests,
      bool directMessages});
}

/// @nodoc
class _$PushNotificationsCopyWithImpl<$Res, $Val extends PushNotifications>
    implements $PushNotificationsCopyWith<$Res> {
  _$PushNotificationsCopyWithImpl(this._value, this._then);

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
    Object? directMessages = null,
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
      directMessages: null == directMessages
          ? _value.directMessages
          : directMessages // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PushNotificationsImplCopyWith<$Res>
    implements $PushNotificationsCopyWith<$Res> {
  factory _$$PushNotificationsImplCopyWith(_$PushNotificationsImpl value,
          $Res Function(_$PushNotificationsImpl) then) =
      __$$PushNotificationsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool appReleases,
      bool tappedUpdates,
      bool bookingRequests,
      bool directMessages});
}

/// @nodoc
class __$$PushNotificationsImplCopyWithImpl<$Res>
    extends _$PushNotificationsCopyWithImpl<$Res, _$PushNotificationsImpl>
    implements _$$PushNotificationsImplCopyWith<$Res> {
  __$$PushNotificationsImplCopyWithImpl(_$PushNotificationsImpl _value,
      $Res Function(_$PushNotificationsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appReleases = null,
    Object? tappedUpdates = null,
    Object? bookingRequests = null,
    Object? directMessages = null,
  }) {
    return _then(_$PushNotificationsImpl(
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
      directMessages: null == directMessages
          ? _value.directMessages
          : directMessages // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PushNotificationsImpl implements _PushNotifications {
  const _$PushNotificationsImpl(
      {this.appReleases = true,
      this.tappedUpdates = true,
      this.bookingRequests = true,
      this.directMessages = true});

  factory _$PushNotificationsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PushNotificationsImplFromJson(json);

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
  @JsonKey()
  final bool directMessages;

  @override
  String toString() {
    return 'PushNotifications(appReleases: $appReleases, tappedUpdates: $tappedUpdates, bookingRequests: $bookingRequests, directMessages: $directMessages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PushNotificationsImpl &&
            (identical(other.appReleases, appReleases) ||
                other.appReleases == appReleases) &&
            (identical(other.tappedUpdates, tappedUpdates) ||
                other.tappedUpdates == tappedUpdates) &&
            (identical(other.bookingRequests, bookingRequests) ||
                other.bookingRequests == bookingRequests) &&
            (identical(other.directMessages, directMessages) ||
                other.directMessages == directMessages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, appReleases, tappedUpdates, bookingRequests, directMessages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PushNotificationsImplCopyWith<_$PushNotificationsImpl> get copyWith =>
      __$$PushNotificationsImplCopyWithImpl<_$PushNotificationsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PushNotificationsImplToJson(
      this,
    );
  }
}

abstract class _PushNotifications implements PushNotifications {
  const factory _PushNotifications(
      {final bool appReleases,
      final bool tappedUpdates,
      final bool bookingRequests,
      final bool directMessages}) = _$PushNotificationsImpl;

  factory _PushNotifications.fromJson(Map<String, dynamic> json) =
      _$PushNotificationsImpl.fromJson;

  @override
  bool get appReleases;
  @override
  bool get tappedUpdates;
  @override
  bool get bookingRequests;
  @override
  bool get directMessages;
  @override
  @JsonKey(ignore: true)
  _$$PushNotificationsImplCopyWith<_$PushNotificationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
