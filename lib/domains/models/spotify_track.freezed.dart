// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotify_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpotifyTrack _$SpotifyTrackFromJson(Map<String, dynamic> json) {
  return _SpotifyTrack.fromJson(json);
}

/// @nodoc
mixin _$SpotifyTrack {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get artist => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get previewUrl => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyTrackCopyWith<SpotifyTrack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyTrackCopyWith<$Res> {
  factory $SpotifyTrackCopyWith(
          SpotifyTrack value, $Res Function(SpotifyTrack) then) =
      _$SpotifyTrackCopyWithImpl<$Res, SpotifyTrack>;
  @useResult
  $Res call(
      {String id,
      String name,
      String artist,
      String imageUrl,
      String previewUrl,
      String uri});
}

/// @nodoc
class _$SpotifyTrackCopyWithImpl<$Res, $Val extends SpotifyTrack>
    implements $SpotifyTrackCopyWith<$Res> {
  _$SpotifyTrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? artist = null,
    Object? imageUrl = null,
    Object? previewUrl = null,
    Object? uri = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      previewUrl: null == previewUrl
          ? _value.previewUrl
          : previewUrl // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifyTrackImplCopyWith<$Res>
    implements $SpotifyTrackCopyWith<$Res> {
  factory _$$SpotifyTrackImplCopyWith(
          _$SpotifyTrackImpl value, $Res Function(_$SpotifyTrackImpl) then) =
      __$$SpotifyTrackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String artist,
      String imageUrl,
      String previewUrl,
      String uri});
}

/// @nodoc
class __$$SpotifyTrackImplCopyWithImpl<$Res>
    extends _$SpotifyTrackCopyWithImpl<$Res, _$SpotifyTrackImpl>
    implements _$$SpotifyTrackImplCopyWith<$Res> {
  __$$SpotifyTrackImplCopyWithImpl(
      _$SpotifyTrackImpl _value, $Res Function(_$SpotifyTrackImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? artist = null,
    Object? imageUrl = null,
    Object? previewUrl = null,
    Object? uri = null,
  }) {
    return _then(_$SpotifyTrackImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      previewUrl: null == previewUrl
          ? _value.previewUrl
          : previewUrl // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyTrackImpl implements _SpotifyTrack {
  const _$SpotifyTrackImpl(
      {required this.id,
      required this.name,
      required this.artist,
      required this.imageUrl,
      required this.previewUrl,
      required this.uri});

  factory _$SpotifyTrackImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyTrackImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String artist;
  @override
  final String imageUrl;
  @override
  final String previewUrl;
  @override
  final String uri;

  @override
  String toString() {
    return 'SpotifyTrack(id: $id, name: $name, artist: $artist, imageUrl: $imageUrl, previewUrl: $previewUrl, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyTrackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.previewUrl, previewUrl) ||
                other.previewUrl == previewUrl) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, artist, imageUrl, previewUrl, uri);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyTrackImplCopyWith<_$SpotifyTrackImpl> get copyWith =>
      __$$SpotifyTrackImplCopyWithImpl<_$SpotifyTrackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyTrackImplToJson(
      this,
    );
  }
}

abstract class _SpotifyTrack implements SpotifyTrack {
  const factory _SpotifyTrack(
      {required final String id,
      required final String name,
      required final String artist,
      required final String imageUrl,
      required final String previewUrl,
      required final String uri}) = _$SpotifyTrackImpl;

  factory _SpotifyTrack.fromJson(Map<String, dynamic> json) =
      _$SpotifyTrackImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get artist;
  @override
  String get imageUrl;
  @override
  String get previewUrl;
  @override
  String get uri;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyTrackImplCopyWith<_$SpotifyTrackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
