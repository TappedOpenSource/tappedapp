// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booker_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookerInfo _$BookerInfoFromJson(Map<String, dynamic> json) {
  return _BookerInfo.fromJson(json);
}

/// @nodoc
mixin _$BookerInfo {
  Option<double> get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookerInfoCopyWith<BookerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookerInfoCopyWith<$Res> {
  factory $BookerInfoCopyWith(
          BookerInfo value, $Res Function(BookerInfo) then) =
      _$BookerInfoCopyWithImpl<$Res, BookerInfo>;
  @useResult
  $Res call({Option<double> rating, int reviewCount});
}

/// @nodoc
class _$BookerInfoCopyWithImpl<$Res, $Val extends BookerInfo>
    implements $BookerInfoCopyWith<$Res> {
  _$BookerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = null,
    Object? reviewCount = null,
  }) {
    return _then(_value.copyWith(
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as Option<double>,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookerInfoImplCopyWith<$Res>
    implements $BookerInfoCopyWith<$Res> {
  factory _$$BookerInfoImplCopyWith(
          _$BookerInfoImpl value, $Res Function(_$BookerInfoImpl) then) =
      __$$BookerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Option<double> rating, int reviewCount});
}

/// @nodoc
class __$$BookerInfoImplCopyWithImpl<$Res>
    extends _$BookerInfoCopyWithImpl<$Res, _$BookerInfoImpl>
    implements _$$BookerInfoImplCopyWith<$Res> {
  __$$BookerInfoImplCopyWithImpl(
      _$BookerInfoImpl _value, $Res Function(_$BookerInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = null,
    Object? reviewCount = null,
  }) {
    return _then(_$BookerInfoImpl(
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as Option<double>,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookerInfoImpl implements _BookerInfo {
  const _$BookerInfoImpl({this.rating = const None(), this.reviewCount = 0});

  factory _$BookerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookerInfoImplFromJson(json);

  @override
  @JsonKey()
  final Option<double> rating;
  @override
  @JsonKey()
  final int reviewCount;

  @override
  String toString() {
    return 'BookerInfo(rating: $rating, reviewCount: $reviewCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookerInfoImpl &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, rating, reviewCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookerInfoImplCopyWith<_$BookerInfoImpl> get copyWith =>
      __$$BookerInfoImplCopyWithImpl<_$BookerInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookerInfoImplToJson(
      this,
    );
  }
}

abstract class _BookerInfo implements BookerInfo {
  const factory _BookerInfo(
      {final Option<double> rating, final int reviewCount}) = _$BookerInfoImpl;

  factory _BookerInfo.fromJson(Map<String, dynamic> json) =
      _$BookerInfoImpl.fromJson;

  @override
  Option<double> get rating;
  @override
  int get reviewCount;
  @override
  @JsonKey(ignore: true)
  _$$BookerInfoImplCopyWith<_$BookerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
