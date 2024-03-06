// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performer_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PerformerInfo _$PerformerInfoFromJson(Map<String, dynamic> json) {
  return _PerformerInfo.fromJson(json);
}

/// @nodoc
mixin _$PerformerInfo {
  Option<String> get pressKitUrl => throw _privateConstructorUsedError;
  List<Genre> get genres => throw _privateConstructorUsedError;
  Option<double> get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  PerformerCategory get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PerformerInfoCopyWith<PerformerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformerInfoCopyWith<$Res> {
  factory $PerformerInfoCopyWith(
          PerformerInfo value, $Res Function(PerformerInfo) then) =
      _$PerformerInfoCopyWithImpl<$Res, PerformerInfo>;
  @useResult
  $Res call(
      {Option<String> pressKitUrl,
      List<Genre> genres,
      Option<double> rating,
      int reviewCount,
      String label,
      PerformerCategory category});
}

/// @nodoc
class _$PerformerInfoCopyWithImpl<$Res, $Val extends PerformerInfo>
    implements $PerformerInfoCopyWith<$Res> {
  _$PerformerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pressKitUrl = null,
    Object? genres = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? label = null,
    Object? category = null,
  }) {
    return _then(_value.copyWith(
      pressKitUrl: null == pressKitUrl
          ? _value.pressKitUrl
          : pressKitUrl // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      genres: null == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<Genre>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as Option<double>,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as PerformerCategory,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerformerInfoImplCopyWith<$Res>
    implements $PerformerInfoCopyWith<$Res> {
  factory _$$PerformerInfoImplCopyWith(
          _$PerformerInfoImpl value, $Res Function(_$PerformerInfoImpl) then) =
      __$$PerformerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Option<String> pressKitUrl,
      List<Genre> genres,
      Option<double> rating,
      int reviewCount,
      String label,
      PerformerCategory category});
}

/// @nodoc
class __$$PerformerInfoImplCopyWithImpl<$Res>
    extends _$PerformerInfoCopyWithImpl<$Res, _$PerformerInfoImpl>
    implements _$$PerformerInfoImplCopyWith<$Res> {
  __$$PerformerInfoImplCopyWithImpl(
      _$PerformerInfoImpl _value, $Res Function(_$PerformerInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pressKitUrl = null,
    Object? genres = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? label = null,
    Object? category = null,
  }) {
    return _then(_$PerformerInfoImpl(
      pressKitUrl: null == pressKitUrl
          ? _value.pressKitUrl
          : pressKitUrl // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      genres: null == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<Genre>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as Option<double>,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as PerformerCategory,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformerInfoImpl implements _PerformerInfo {
  const _$PerformerInfoImpl(
      {this.pressKitUrl = const None(),
      final List<Genre> genres = const [],
      this.rating = const None(),
      this.reviewCount = 0,
      this.label = 'Independent',
      this.category = PerformerCategory.undiscovered})
      : _genres = genres;

  factory _$PerformerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformerInfoImplFromJson(json);

  @override
  @JsonKey()
  final Option<String> pressKitUrl;
  final List<Genre> _genres;
  @override
  @JsonKey()
  List<Genre> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  @JsonKey()
  final Option<double> rating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final String label;
  @override
  @JsonKey()
  final PerformerCategory category;

  @override
  String toString() {
    return 'PerformerInfo(pressKitUrl: $pressKitUrl, genres: $genres, rating: $rating, reviewCount: $reviewCount, label: $label, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformerInfoImpl &&
            (identical(other.pressKitUrl, pressKitUrl) ||
                other.pressKitUrl == pressKitUrl) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      pressKitUrl,
      const DeepCollectionEquality().hash(_genres),
      rating,
      reviewCount,
      label,
      category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformerInfoImplCopyWith<_$PerformerInfoImpl> get copyWith =>
      __$$PerformerInfoImplCopyWithImpl<_$PerformerInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformerInfoImplToJson(
      this,
    );
  }
}

abstract class _PerformerInfo implements PerformerInfo {
  const factory _PerformerInfo(
      {final Option<String> pressKitUrl,
      final List<Genre> genres,
      final Option<double> rating,
      final int reviewCount,
      final String label,
      final PerformerCategory category}) = _$PerformerInfoImpl;

  factory _PerformerInfo.fromJson(Map<String, dynamic> json) =
      _$PerformerInfoImpl.fromJson;

  @override
  Option<String> get pressKitUrl;
  @override
  List<Genre> get genres;
  @override
  Option<double> get rating;
  @override
  int get reviewCount;
  @override
  String get label;
  @override
  PerformerCategory get category;
  @override
  @JsonKey(ignore: true)
  _$$PerformerInfoImplCopyWith<_$PerformerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
