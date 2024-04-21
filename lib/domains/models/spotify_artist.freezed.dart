// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotify_artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpotifyArtist _$SpotifyArtistFromJson(Map<String, dynamic> json) {
  return _SpotifyArtist.fromJson(json);
}

/// @nodoc
mixin _$SpotifyArtist {
  ExternalUrls? get externalUrls => throw _privateConstructorUsedError;
  Followers? get followers => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  String? get href => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  List<ArtistImage> get images => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get popularity => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyArtistCopyWith<SpotifyArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyArtistCopyWith<$Res> {
  factory $SpotifyArtistCopyWith(
          SpotifyArtist value, $Res Function(SpotifyArtist) then) =
      _$SpotifyArtistCopyWithImpl<$Res, SpotifyArtist>;
  @useResult
  $Res call(
      {ExternalUrls? externalUrls,
      Followers? followers,
      List<String> genres,
      String? href,
      String? id,
      List<ArtistImage> images,
      String? name,
      int? popularity,
      String type,
      String uri});

  $ExternalUrlsCopyWith<$Res>? get externalUrls;
  $FollowersCopyWith<$Res>? get followers;
}

/// @nodoc
class _$SpotifyArtistCopyWithImpl<$Res, $Val extends SpotifyArtist>
    implements $SpotifyArtistCopyWith<$Res> {
  _$SpotifyArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalUrls = freezed,
    Object? followers = freezed,
    Object? genres = null,
    Object? href = freezed,
    Object? id = freezed,
    Object? images = null,
    Object? name = freezed,
    Object? popularity = freezed,
    Object? type = null,
    Object? uri = null,
  }) {
    return _then(_value.copyWith(
      externalUrls: freezed == externalUrls
          ? _value.externalUrls
          : externalUrls // ignore: cast_nullable_to_non_nullable
              as ExternalUrls?,
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as Followers?,
      genres: null == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      href: freezed == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ArtistImage>,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      popularity: freezed == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExternalUrlsCopyWith<$Res>? get externalUrls {
    if (_value.externalUrls == null) {
      return null;
    }

    return $ExternalUrlsCopyWith<$Res>(_value.externalUrls!, (value) {
      return _then(_value.copyWith(externalUrls: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FollowersCopyWith<$Res>? get followers {
    if (_value.followers == null) {
      return null;
    }

    return $FollowersCopyWith<$Res>(_value.followers!, (value) {
      return _then(_value.copyWith(followers: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpotifyArtistImplCopyWith<$Res>
    implements $SpotifyArtistCopyWith<$Res> {
  factory _$$SpotifyArtistImplCopyWith(
          _$SpotifyArtistImpl value, $Res Function(_$SpotifyArtistImpl) then) =
      __$$SpotifyArtistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ExternalUrls? externalUrls,
      Followers? followers,
      List<String> genres,
      String? href,
      String? id,
      List<ArtistImage> images,
      String? name,
      int? popularity,
      String type,
      String uri});

  @override
  $ExternalUrlsCopyWith<$Res>? get externalUrls;
  @override
  $FollowersCopyWith<$Res>? get followers;
}

/// @nodoc
class __$$SpotifyArtistImplCopyWithImpl<$Res>
    extends _$SpotifyArtistCopyWithImpl<$Res, _$SpotifyArtistImpl>
    implements _$$SpotifyArtistImplCopyWith<$Res> {
  __$$SpotifyArtistImplCopyWithImpl(
      _$SpotifyArtistImpl _value, $Res Function(_$SpotifyArtistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalUrls = freezed,
    Object? followers = freezed,
    Object? genres = null,
    Object? href = freezed,
    Object? id = freezed,
    Object? images = null,
    Object? name = freezed,
    Object? popularity = freezed,
    Object? type = null,
    Object? uri = null,
  }) {
    return _then(_$SpotifyArtistImpl(
      externalUrls: freezed == externalUrls
          ? _value.externalUrls
          : externalUrls // ignore: cast_nullable_to_non_nullable
              as ExternalUrls?,
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as Followers?,
      genres: null == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      href: freezed == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ArtistImage>,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      popularity: freezed == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SpotifyArtistImpl implements _SpotifyArtist {
  const _$SpotifyArtistImpl(
      {required this.externalUrls,
      required this.followers,
      required final List<String> genres,
      required this.href,
      required this.id,
      required final List<ArtistImage> images,
      required this.name,
      required this.popularity,
      required this.type,
      required this.uri})
      : _genres = genres,
        _images = images;

  factory _$SpotifyArtistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyArtistImplFromJson(json);

  @override
  final ExternalUrls? externalUrls;
  @override
  final Followers? followers;
  final List<String> _genres;
  @override
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  final String? href;
  @override
  final String? id;
  final List<ArtistImage> _images;
  @override
  List<ArtistImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? name;
  @override
  final int? popularity;
  @override
  final String type;
  @override
  final String uri;

  @override
  String toString() {
    return 'SpotifyArtist(externalUrls: $externalUrls, followers: $followers, genres: $genres, href: $href, id: $id, images: $images, name: $name, popularity: $popularity, type: $type, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyArtistImpl &&
            (identical(other.externalUrls, externalUrls) ||
                other.externalUrls == externalUrls) &&
            (identical(other.followers, followers) ||
                other.followers == followers) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.href, href) || other.href == href) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      externalUrls,
      followers,
      const DeepCollectionEquality().hash(_genres),
      href,
      id,
      const DeepCollectionEquality().hash(_images),
      name,
      popularity,
      type,
      uri);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyArtistImplCopyWith<_$SpotifyArtistImpl> get copyWith =>
      __$$SpotifyArtistImplCopyWithImpl<_$SpotifyArtistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyArtistImplToJson(
      this,
    );
  }
}

abstract class _SpotifyArtist implements SpotifyArtist {
  const factory _SpotifyArtist(
      {required final ExternalUrls? externalUrls,
      required final Followers? followers,
      required final List<String> genres,
      required final String? href,
      required final String? id,
      required final List<ArtistImage> images,
      required final String? name,
      required final int? popularity,
      required final String type,
      required final String uri}) = _$SpotifyArtistImpl;

  factory _SpotifyArtist.fromJson(Map<String, dynamic> json) =
      _$SpotifyArtistImpl.fromJson;

  @override
  ExternalUrls? get externalUrls;
  @override
  Followers? get followers;
  @override
  List<String> get genres;
  @override
  String? get href;
  @override
  String? get id;
  @override
  List<ArtistImage> get images;
  @override
  String? get name;
  @override
  int? get popularity;
  @override
  String get type;
  @override
  String get uri;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyArtistImplCopyWith<_$SpotifyArtistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExternalUrls _$ExternalUrlsFromJson(Map<String, dynamic> json) {
  return _ExternalUrls.fromJson(json);
}

/// @nodoc
mixin _$ExternalUrls {
  String get spotify => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExternalUrlsCopyWith<ExternalUrls> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExternalUrlsCopyWith<$Res> {
  factory $ExternalUrlsCopyWith(
          ExternalUrls value, $Res Function(ExternalUrls) then) =
      _$ExternalUrlsCopyWithImpl<$Res, ExternalUrls>;
  @useResult
  $Res call({String spotify});
}

/// @nodoc
class _$ExternalUrlsCopyWithImpl<$Res, $Val extends ExternalUrls>
    implements $ExternalUrlsCopyWith<$Res> {
  _$ExternalUrlsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotify = null,
  }) {
    return _then(_value.copyWith(
      spotify: null == spotify
          ? _value.spotify
          : spotify // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExternalUrlsImplCopyWith<$Res>
    implements $ExternalUrlsCopyWith<$Res> {
  factory _$$ExternalUrlsImplCopyWith(
          _$ExternalUrlsImpl value, $Res Function(_$ExternalUrlsImpl) then) =
      __$$ExternalUrlsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String spotify});
}

/// @nodoc
class __$$ExternalUrlsImplCopyWithImpl<$Res>
    extends _$ExternalUrlsCopyWithImpl<$Res, _$ExternalUrlsImpl>
    implements _$$ExternalUrlsImplCopyWith<$Res> {
  __$$ExternalUrlsImplCopyWithImpl(
      _$ExternalUrlsImpl _value, $Res Function(_$ExternalUrlsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotify = null,
  }) {
    return _then(_$ExternalUrlsImpl(
      spotify: null == spotify
          ? _value.spotify
          : spotify // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExternalUrlsImpl implements _ExternalUrls {
  const _$ExternalUrlsImpl({required this.spotify});

  factory _$ExternalUrlsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExternalUrlsImplFromJson(json);

  @override
  final String spotify;

  @override
  String toString() {
    return 'ExternalUrls(spotify: $spotify)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalUrlsImpl &&
            (identical(other.spotify, spotify) || other.spotify == spotify));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, spotify);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalUrlsImplCopyWith<_$ExternalUrlsImpl> get copyWith =>
      __$$ExternalUrlsImplCopyWithImpl<_$ExternalUrlsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExternalUrlsImplToJson(
      this,
    );
  }
}

abstract class _ExternalUrls implements ExternalUrls {
  const factory _ExternalUrls({required final String spotify}) =
      _$ExternalUrlsImpl;

  factory _ExternalUrls.fromJson(Map<String, dynamic> json) =
      _$ExternalUrlsImpl.fromJson;

  @override
  String get spotify;
  @override
  @JsonKey(ignore: true)
  _$$ExternalUrlsImplCopyWith<_$ExternalUrlsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Followers _$FollowersFromJson(Map<String, dynamic> json) {
  return _Followers.fromJson(json);
}

/// @nodoc
mixin _$Followers {
  String? get href => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FollowersCopyWith<Followers> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowersCopyWith<$Res> {
  factory $FollowersCopyWith(Followers value, $Res Function(Followers) then) =
      _$FollowersCopyWithImpl<$Res, Followers>;
  @useResult
  $Res call({String? href, int? total});
}

/// @nodoc
class _$FollowersCopyWithImpl<$Res, $Val extends Followers>
    implements $FollowersCopyWith<$Res> {
  _$FollowersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? href = freezed,
    Object? total = freezed,
  }) {
    return _then(_value.copyWith(
      href: freezed == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as String?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowersImplCopyWith<$Res>
    implements $FollowersCopyWith<$Res> {
  factory _$$FollowersImplCopyWith(
          _$FollowersImpl value, $Res Function(_$FollowersImpl) then) =
      __$$FollowersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? href, int? total});
}

/// @nodoc
class __$$FollowersImplCopyWithImpl<$Res>
    extends _$FollowersCopyWithImpl<$Res, _$FollowersImpl>
    implements _$$FollowersImplCopyWith<$Res> {
  __$$FollowersImplCopyWithImpl(
      _$FollowersImpl _value, $Res Function(_$FollowersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? href = freezed,
    Object? total = freezed,
  }) {
    return _then(_$FollowersImpl(
      href: freezed == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as String?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FollowersImpl implements _Followers {
  const _$FollowersImpl({required this.href, required this.total});

  factory _$FollowersImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowersImplFromJson(json);

  @override
  final String? href;
  @override
  final int? total;

  @override
  String toString() {
    return 'Followers(href: $href, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowersImpl &&
            (identical(other.href, href) || other.href == href) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, href, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowersImplCopyWith<_$FollowersImpl> get copyWith =>
      __$$FollowersImplCopyWithImpl<_$FollowersImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowersImplToJson(
      this,
    );
  }
}

abstract class _Followers implements Followers {
  const factory _Followers(
      {required final String? href,
      required final int? total}) = _$FollowersImpl;

  factory _Followers.fromJson(Map<String, dynamic> json) =
      _$FollowersImpl.fromJson;

  @override
  String? get href;
  @override
  int? get total;
  @override
  @JsonKey(ignore: true)
  _$$FollowersImplCopyWith<_$FollowersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ArtistImage _$ArtistImageFromJson(Map<String, dynamic> json) {
  return _ArtistImage.fromJson(json);
}

/// @nodoc
mixin _$ArtistImage {
  String get url => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArtistImageCopyWith<ArtistImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArtistImageCopyWith<$Res> {
  factory $ArtistImageCopyWith(
          ArtistImage value, $Res Function(ArtistImage) then) =
      _$ArtistImageCopyWithImpl<$Res, ArtistImage>;
  @useResult
  $Res call({String url, int height, int width});
}

/// @nodoc
class _$ArtistImageCopyWithImpl<$Res, $Val extends ArtistImage>
    implements $ArtistImageCopyWith<$Res> {
  _$ArtistImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArtistImageImplCopyWith<$Res>
    implements $ArtistImageCopyWith<$Res> {
  factory _$$ArtistImageImplCopyWith(
          _$ArtistImageImpl value, $Res Function(_$ArtistImageImpl) then) =
      __$$ArtistImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, int height, int width});
}

/// @nodoc
class __$$ArtistImageImplCopyWithImpl<$Res>
    extends _$ArtistImageCopyWithImpl<$Res, _$ArtistImageImpl>
    implements _$$ArtistImageImplCopyWith<$Res> {
  __$$ArtistImageImplCopyWithImpl(
      _$ArtistImageImpl _value, $Res Function(_$ArtistImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(_$ArtistImageImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArtistImageImpl implements _ArtistImage {
  const _$ArtistImageImpl(
      {required this.url, required this.height, required this.width});

  factory _$ArtistImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArtistImageImplFromJson(json);

  @override
  final String url;
  @override
  final int height;
  @override
  final int width;

  @override
  String toString() {
    return 'ArtistImage(url: $url, height: $height, width: $width)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArtistImageImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, url, height, width);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArtistImageImplCopyWith<_$ArtistImageImpl> get copyWith =>
      __$$ArtistImageImplCopyWithImpl<_$ArtistImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArtistImageImplToJson(
      this,
    );
  }
}

abstract class _ArtistImage implements ArtistImage {
  const factory _ArtistImage(
      {required final String url,
      required final int height,
      required final int width}) = _$ArtistImageImpl;

  factory _ArtistImage.fromJson(Map<String, dynamic> json) =
      _$ArtistImageImpl.fromJson;

  @override
  String get url;
  @override
  int get height;
  @override
  int get width;
  @override
  @JsonKey(ignore: true)
  _$$ArtistImageImplCopyWith<_$ArtistImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
