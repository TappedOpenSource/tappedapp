// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DiscoverState {
  List<UserModel> get hits => throw _privateConstructorUsedError;
  double get userLat => throw _privateConstructorUsedError;
  double get userLng => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiscoverStateCopyWith<DiscoverState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoverStateCopyWith<$Res> {
  factory $DiscoverStateCopyWith(
          DiscoverState value, $Res Function(DiscoverState) then) =
      _$DiscoverStateCopyWithImpl<$Res, DiscoverState>;
  @useResult
  $Res call({List<UserModel> hits, double userLat, double userLng});
}

/// @nodoc
class _$DiscoverStateCopyWithImpl<$Res, $Val extends DiscoverState>
    implements $DiscoverStateCopyWith<$Res> {
  _$DiscoverStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hits = null,
    Object? userLat = null,
    Object? userLng = null,
  }) {
    return _then(_value.copyWith(
      hits: null == hits
          ? _value.hits
          : hits // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      userLat: null == userLat
          ? _value.userLat
          : userLat // ignore: cast_nullable_to_non_nullable
              as double,
      userLng: null == userLng
          ? _value.userLng
          : userLng // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DiscoverStateImplCopyWith<$Res>
    implements $DiscoverStateCopyWith<$Res> {
  factory _$$DiscoverStateImplCopyWith(
          _$DiscoverStateImpl value, $Res Function(_$DiscoverStateImpl) then) =
      __$$DiscoverStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserModel> hits, double userLat, double userLng});
}

/// @nodoc
class __$$DiscoverStateImplCopyWithImpl<$Res>
    extends _$DiscoverStateCopyWithImpl<$Res, _$DiscoverStateImpl>
    implements _$$DiscoverStateImplCopyWith<$Res> {
  __$$DiscoverStateImplCopyWithImpl(
      _$DiscoverStateImpl _value, $Res Function(_$DiscoverStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hits = null,
    Object? userLat = null,
    Object? userLng = null,
  }) {
    return _then(_$DiscoverStateImpl(
      hits: null == hits
          ? _value._hits
          : hits // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      userLat: null == userLat
          ? _value.userLat
          : userLat // ignore: cast_nullable_to_non_nullable
              as double,
      userLng: null == userLng
          ? _value.userLng
          : userLng // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$DiscoverStateImpl implements _DiscoverState {
  const _$DiscoverStateImpl(
      {final List<UserModel> hits = const [],
      this.userLat = 37.5407246,
      this.userLng = -77.4360481})
      : _hits = hits;

  final List<UserModel> _hits;
  @override
  @JsonKey()
  List<UserModel> get hits {
    if (_hits is EqualUnmodifiableListView) return _hits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hits);
  }

  @override
  @JsonKey()
  final double userLat;
  @override
  @JsonKey()
  final double userLng;

  @override
  String toString() {
    return 'DiscoverState(hits: $hits, userLat: $userLat, userLng: $userLng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoverStateImpl &&
            const DeepCollectionEquality().equals(other._hits, _hits) &&
            (identical(other.userLat, userLat) || other.userLat == userLat) &&
            (identical(other.userLng, userLng) || other.userLng == userLng));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_hits), userLat, userLng);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoverStateImplCopyWith<_$DiscoverStateImpl> get copyWith =>
      __$$DiscoverStateImplCopyWithImpl<_$DiscoverStateImpl>(this, _$identity);
}

abstract class _DiscoverState implements DiscoverState {
  const factory _DiscoverState(
      {final List<UserModel> hits,
      final double userLat,
      final double userLng}) = _$DiscoverStateImpl;

  @override
  List<UserModel> get hits;
  @override
  double get userLat;
  @override
  double get userLng;
  @override
  @JsonKey(ignore: true)
  _$$DiscoverStateImplCopyWith<_$DiscoverStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
