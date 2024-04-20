// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotify_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpotifyCredentials _$SpotifyCredentialsFromJson(Map<String, dynamic> json) {
  return _SpotifyCredentials.fromJson(json);
}

/// @nodoc
mixin _$SpotifyCredentials {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  String get scope => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyCredentialsCopyWith<SpotifyCredentials> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyCredentialsCopyWith<$Res> {
  factory $SpotifyCredentialsCopyWith(
          SpotifyCredentials value, $Res Function(SpotifyCredentials) then) =
      _$SpotifyCredentialsCopyWithImpl<$Res, SpotifyCredentials>;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      int expiresIn,
      String tokenType,
      String scope});
}

/// @nodoc
class _$SpotifyCredentialsCopyWithImpl<$Res, $Val extends SpotifyCredentials>
    implements $SpotifyCredentialsCopyWith<$Res> {
  _$SpotifyCredentialsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? tokenType = null,
    Object? scope = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifyCredentialsImplCopyWith<$Res>
    implements $SpotifyCredentialsCopyWith<$Res> {
  factory _$$SpotifyCredentialsImplCopyWith(_$SpotifyCredentialsImpl value,
          $Res Function(_$SpotifyCredentialsImpl) then) =
      __$$SpotifyCredentialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      int expiresIn,
      String tokenType,
      String scope});
}

/// @nodoc
class __$$SpotifyCredentialsImplCopyWithImpl<$Res>
    extends _$SpotifyCredentialsCopyWithImpl<$Res, _$SpotifyCredentialsImpl>
    implements _$$SpotifyCredentialsImplCopyWith<$Res> {
  __$$SpotifyCredentialsImplCopyWithImpl(_$SpotifyCredentialsImpl _value,
      $Res Function(_$SpotifyCredentialsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? tokenType = null,
    Object? scope = null,
  }) {
    return _then(_$SpotifyCredentialsImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyCredentialsImpl implements _SpotifyCredentials {
  const _$SpotifyCredentialsImpl(
      {required this.accessToken,
      required this.refreshToken,
      required this.expiresIn,
      required this.tokenType,
      required this.scope});

  factory _$SpotifyCredentialsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyCredentialsImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final int expiresIn;
  @override
  final String tokenType;
  @override
  final String scope;

  @override
  String toString() {
    return 'SpotifyCredentials(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, tokenType: $tokenType, scope: $scope)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyCredentialsImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.scope, scope) || other.scope == scope));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, refreshToken, expiresIn, tokenType, scope);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyCredentialsImplCopyWith<_$SpotifyCredentialsImpl> get copyWith =>
      __$$SpotifyCredentialsImplCopyWithImpl<_$SpotifyCredentialsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyCredentialsImplToJson(
      this,
    );
  }
}

abstract class _SpotifyCredentials implements SpotifyCredentials {
  const factory _SpotifyCredentials(
      {required final String accessToken,
      required final String refreshToken,
      required final int expiresIn,
      required final String tokenType,
      required final String scope}) = _$SpotifyCredentialsImpl;

  factory _SpotifyCredentials.fromJson(Map<String, dynamic> json) =
      _$SpotifyCredentialsImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  int get expiresIn;
  @override
  String get tokenType;
  @override
  String get scope;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyCredentialsImplCopyWith<_$SpotifyCredentialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
