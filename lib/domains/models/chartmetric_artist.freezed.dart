// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chartmetric_artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChartmetricArtist _$ChartmetricArtistFromJson(Map<String, dynamic> json) {
  return _ChartmetricArtist.fromJson(json);
}

/// @nodoc
mixin _$ChartmetricArtist {
  @JsonKey(name: 'chartmetric_id')
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChartmetricArtistCopyWith<ChartmetricArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartmetricArtistCopyWith<$Res> {
  factory $ChartmetricArtistCopyWith(
          ChartmetricArtist value, $Res Function(ChartmetricArtist) then) =
      _$ChartmetricArtistCopyWithImpl<$Res, ChartmetricArtist>;
  @useResult
  $Res call({@JsonKey(name: 'chartmetric_id') String id});
}

/// @nodoc
class _$ChartmetricArtistCopyWithImpl<$Res, $Val extends ChartmetricArtist>
    implements $ChartmetricArtistCopyWith<$Res> {
  _$ChartmetricArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartmetricArtistImplCopyWith<$Res>
    implements $ChartmetricArtistCopyWith<$Res> {
  factory _$$ChartmetricArtistImplCopyWith(_$ChartmetricArtistImpl value,
          $Res Function(_$ChartmetricArtistImpl) then) =
      __$$ChartmetricArtistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'chartmetric_id') String id});
}

/// @nodoc
class __$$ChartmetricArtistImplCopyWithImpl<$Res>
    extends _$ChartmetricArtistCopyWithImpl<$Res, _$ChartmetricArtistImpl>
    implements _$$ChartmetricArtistImplCopyWith<$Res> {
  __$$ChartmetricArtistImplCopyWithImpl(_$ChartmetricArtistImpl _value,
      $Res Function(_$ChartmetricArtistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$ChartmetricArtistImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartmetricArtistImpl implements _ChartmetricArtist {
  const _$ChartmetricArtistImpl(
      {@JsonKey(name: 'chartmetric_id') required this.id});

  factory _$ChartmetricArtistImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartmetricArtistImplFromJson(json);

  @override
  @JsonKey(name: 'chartmetric_id')
  final String id;

  @override
  String toString() {
    return 'ChartmetricArtist(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartmetricArtistImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartmetricArtistImplCopyWith<_$ChartmetricArtistImpl> get copyWith =>
      __$$ChartmetricArtistImplCopyWithImpl<_$ChartmetricArtistImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartmetricArtistImplToJson(
      this,
    );
  }
}

abstract class _ChartmetricArtist implements ChartmetricArtist {
  const factory _ChartmetricArtist(
          {@JsonKey(name: 'chartmetric_id') required final String id}) =
      _$ChartmetricArtistImpl;

  factory _ChartmetricArtist.fromJson(Map<String, dynamic> json) =
      _$ChartmetricArtistImpl.fromJson;

  @override
  @JsonKey(name: 'chartmetric_id')
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$ChartmetricArtistImplCopyWith<_$ChartmetricArtistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
