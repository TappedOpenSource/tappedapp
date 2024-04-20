// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotify_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpotifyUser _$SpotifyUserFromJson(Map<String, dynamic> json) {
  return _SpotifyUser.fromJson(json);
}

/// @nodoc
mixin _$SpotifyUser {
  String? get country => throw _privateConstructorUsedError;
  String? get display_name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  ExplicitContent? get explicit_content => throw _privateConstructorUsedError;
  ExternalUrls? get external_urls => throw _privateConstructorUsedError;
  Followers? get followers => throw _privateConstructorUsedError;
  String? get href => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  List<Image> get images => throw _privateConstructorUsedError;
  String? get product => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyUserCopyWith<SpotifyUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyUserCopyWith<$Res> {
  factory $SpotifyUserCopyWith(
          SpotifyUser value, $Res Function(SpotifyUser) then) =
      _$SpotifyUserCopyWithImpl<$Res, SpotifyUser>;
  @useResult
  $Res call(
      {String? country,
      String? display_name,
      String? email,
      ExplicitContent? explicit_content,
      ExternalUrls? external_urls,
      Followers? followers,
      String? href,
      String? id,
      List<Image> images,
      String? product,
      String? type,
      String uri});

  $ExplicitContentCopyWith<$Res>? get explicit_content;
  $ExternalUrlsCopyWith<$Res>? get external_urls;
  $FollowersCopyWith<$Res>? get followers;
}

/// @nodoc
class _$SpotifyUserCopyWithImpl<$Res, $Val extends SpotifyUser>
    implements $SpotifyUserCopyWith<$Res> {
  _$SpotifyUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = freezed,
    Object? display_name = freezed,
    Object? email = freezed,
    Object? explicit_content = freezed,
    Object? external_urls = freezed,
    Object? followers = freezed,
    Object? href = freezed,
    Object? id = freezed,
    Object? images = null,
    Object? product = freezed,
    Object? type = freezed,
    Object? uri = null,
  }) {
    return _then(_value.copyWith(
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      display_name: freezed == display_name
          ? _value.display_name
          : display_name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      explicit_content: freezed == explicit_content
          ? _value.explicit_content
          : explicit_content // ignore: cast_nullable_to_non_nullable
              as ExplicitContent?,
      external_urls: freezed == external_urls
          ? _value.external_urls
          : external_urls // ignore: cast_nullable_to_non_nullable
              as ExternalUrls?,
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as Followers?,
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
              as List<Image>,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExplicitContentCopyWith<$Res>? get explicit_content {
    if (_value.explicit_content == null) {
      return null;
    }

    return $ExplicitContentCopyWith<$Res>(_value.explicit_content!, (value) {
      return _then(_value.copyWith(explicit_content: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ExternalUrlsCopyWith<$Res>? get external_urls {
    if (_value.external_urls == null) {
      return null;
    }

    return $ExternalUrlsCopyWith<$Res>(_value.external_urls!, (value) {
      return _then(_value.copyWith(external_urls: value) as $Val);
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
abstract class _$$SpotifyUserImplCopyWith<$Res>
    implements $SpotifyUserCopyWith<$Res> {
  factory _$$SpotifyUserImplCopyWith(
          _$SpotifyUserImpl value, $Res Function(_$SpotifyUserImpl) then) =
      __$$SpotifyUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? country,
      String? display_name,
      String? email,
      ExplicitContent? explicit_content,
      ExternalUrls? external_urls,
      Followers? followers,
      String? href,
      String? id,
      List<Image> images,
      String? product,
      String? type,
      String uri});

  @override
  $ExplicitContentCopyWith<$Res>? get explicit_content;
  @override
  $ExternalUrlsCopyWith<$Res>? get external_urls;
  @override
  $FollowersCopyWith<$Res>? get followers;
}

/// @nodoc
class __$$SpotifyUserImplCopyWithImpl<$Res>
    extends _$SpotifyUserCopyWithImpl<$Res, _$SpotifyUserImpl>
    implements _$$SpotifyUserImplCopyWith<$Res> {
  __$$SpotifyUserImplCopyWithImpl(
      _$SpotifyUserImpl _value, $Res Function(_$SpotifyUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = freezed,
    Object? display_name = freezed,
    Object? email = freezed,
    Object? explicit_content = freezed,
    Object? external_urls = freezed,
    Object? followers = freezed,
    Object? href = freezed,
    Object? id = freezed,
    Object? images = null,
    Object? product = freezed,
    Object? type = freezed,
    Object? uri = null,
  }) {
    return _then(_$SpotifyUserImpl(
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      display_name: freezed == display_name
          ? _value.display_name
          : display_name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      explicit_content: freezed == explicit_content
          ? _value.explicit_content
          : explicit_content // ignore: cast_nullable_to_non_nullable
              as ExplicitContent?,
      external_urls: freezed == external_urls
          ? _value.external_urls
          : external_urls // ignore: cast_nullable_to_non_nullable
              as ExternalUrls?,
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as Followers?,
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
              as List<Image>,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SpotifyUserImpl implements _SpotifyUser {
  const _$SpotifyUserImpl(
      {required this.country,
      required this.display_name,
      required this.email,
      required this.explicit_content,
      required this.external_urls,
      required this.followers,
      required this.href,
      required this.id,
      required final List<Image> images,
      required this.product,
      required this.type,
      required this.uri})
      : _images = images;

  factory _$SpotifyUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyUserImplFromJson(json);

  @override
  final String? country;
  @override
  final String? display_name;
  @override
  final String? email;
  @override
  final ExplicitContent? explicit_content;
  @override
  final ExternalUrls? external_urls;
  @override
  final Followers? followers;
  @override
  final String? href;
  @override
  final String? id;
  final List<Image> _images;
  @override
  List<Image> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? product;
  @override
  final String? type;
  @override
  final String uri;

  @override
  String toString() {
    return 'SpotifyUser(country: $country, display_name: $display_name, email: $email, explicit_content: $explicit_content, external_urls: $external_urls, followers: $followers, href: $href, id: $id, images: $images, product: $product, type: $type, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyUserImpl &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.display_name, display_name) ||
                other.display_name == display_name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.explicit_content, explicit_content) ||
                other.explicit_content == explicit_content) &&
            (identical(other.external_urls, external_urls) ||
                other.external_urls == external_urls) &&
            (identical(other.followers, followers) ||
                other.followers == followers) &&
            (identical(other.href, href) || other.href == href) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      country,
      display_name,
      email,
      explicit_content,
      external_urls,
      followers,
      href,
      id,
      const DeepCollectionEquality().hash(_images),
      product,
      type,
      uri);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyUserImplCopyWith<_$SpotifyUserImpl> get copyWith =>
      __$$SpotifyUserImplCopyWithImpl<_$SpotifyUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyUserImplToJson(
      this,
    );
  }
}

abstract class _SpotifyUser implements SpotifyUser {
  const factory _SpotifyUser(
      {required final String? country,
      required final String? display_name,
      required final String? email,
      required final ExplicitContent? explicit_content,
      required final ExternalUrls? external_urls,
      required final Followers? followers,
      required final String? href,
      required final String? id,
      required final List<Image> images,
      required final String? product,
      required final String? type,
      required final String uri}) = _$SpotifyUserImpl;

  factory _SpotifyUser.fromJson(Map<String, dynamic> json) =
      _$SpotifyUserImpl.fromJson;

  @override
  String? get country;
  @override
  String? get display_name;
  @override
  String? get email;
  @override
  ExplicitContent? get explicit_content;
  @override
  ExternalUrls? get external_urls;
  @override
  Followers? get followers;
  @override
  String? get href;
  @override
  String? get id;
  @override
  List<Image> get images;
  @override
  String? get product;
  @override
  String? get type;
  @override
  String get uri;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyUserImplCopyWith<_$SpotifyUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExplicitContent _$ExplicitContentFromJson(Map<String, dynamic> json) {
  return _ExplicitContent.fromJson(json);
}

/// @nodoc
mixin _$ExplicitContent {
  bool get filter_enabled => throw _privateConstructorUsedError;
  bool get filter_locked => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExplicitContentCopyWith<ExplicitContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExplicitContentCopyWith<$Res> {
  factory $ExplicitContentCopyWith(
          ExplicitContent value, $Res Function(ExplicitContent) then) =
      _$ExplicitContentCopyWithImpl<$Res, ExplicitContent>;
  @useResult
  $Res call({bool filter_enabled, bool filter_locked});
}

/// @nodoc
class _$ExplicitContentCopyWithImpl<$Res, $Val extends ExplicitContent>
    implements $ExplicitContentCopyWith<$Res> {
  _$ExplicitContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter_enabled = null,
    Object? filter_locked = null,
  }) {
    return _then(_value.copyWith(
      filter_enabled: null == filter_enabled
          ? _value.filter_enabled
          : filter_enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      filter_locked: null == filter_locked
          ? _value.filter_locked
          : filter_locked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExplicitContentImplCopyWith<$Res>
    implements $ExplicitContentCopyWith<$Res> {
  factory _$$ExplicitContentImplCopyWith(_$ExplicitContentImpl value,
          $Res Function(_$ExplicitContentImpl) then) =
      __$$ExplicitContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool filter_enabled, bool filter_locked});
}

/// @nodoc
class __$$ExplicitContentImplCopyWithImpl<$Res>
    extends _$ExplicitContentCopyWithImpl<$Res, _$ExplicitContentImpl>
    implements _$$ExplicitContentImplCopyWith<$Res> {
  __$$ExplicitContentImplCopyWithImpl(
      _$ExplicitContentImpl _value, $Res Function(_$ExplicitContentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter_enabled = null,
    Object? filter_locked = null,
  }) {
    return _then(_$ExplicitContentImpl(
      filter_enabled: null == filter_enabled
          ? _value.filter_enabled
          : filter_enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      filter_locked: null == filter_locked
          ? _value.filter_locked
          : filter_locked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExplicitContentImpl implements _ExplicitContent {
  const _$ExplicitContentImpl(
      {required this.filter_enabled, required this.filter_locked});

  factory _$ExplicitContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExplicitContentImplFromJson(json);

  @override
  final bool filter_enabled;
  @override
  final bool filter_locked;

  @override
  String toString() {
    return 'ExplicitContent(filter_enabled: $filter_enabled, filter_locked: $filter_locked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExplicitContentImpl &&
            (identical(other.filter_enabled, filter_enabled) ||
                other.filter_enabled == filter_enabled) &&
            (identical(other.filter_locked, filter_locked) ||
                other.filter_locked == filter_locked));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, filter_enabled, filter_locked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExplicitContentImplCopyWith<_$ExplicitContentImpl> get copyWith =>
      __$$ExplicitContentImplCopyWithImpl<_$ExplicitContentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExplicitContentImplToJson(
      this,
    );
  }
}

abstract class _ExplicitContent implements ExplicitContent {
  const factory _ExplicitContent(
      {required final bool filter_enabled,
      required final bool filter_locked}) = _$ExplicitContentImpl;

  factory _ExplicitContent.fromJson(Map<String, dynamic> json) =
      _$ExplicitContentImpl.fromJson;

  @override
  bool get filter_enabled;
  @override
  bool get filter_locked;
  @override
  @JsonKey(ignore: true)
  _$$ExplicitContentImplCopyWith<_$ExplicitContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExternalUrls _$ExternalUrlsFromJson(Map<String, dynamic> json) {
  return _ExternalUrls.fromJson(json);
}

/// @nodoc
mixin _$ExternalUrls {
  String? get spotify => throw _privateConstructorUsedError;

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
  $Res call({String? spotify});
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
    Object? spotify = freezed,
  }) {
    return _then(_value.copyWith(
      spotify: freezed == spotify
          ? _value.spotify
          : spotify // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $Res call({String? spotify});
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
    Object? spotify = freezed,
  }) {
    return _then(_$ExternalUrlsImpl(
      spotify: freezed == spotify
          ? _value.spotify
          : spotify // ignore: cast_nullable_to_non_nullable
              as String?,
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
  final String? spotify;

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
  const factory _ExternalUrls({required final String? spotify}) =
      _$ExternalUrlsImpl;

  factory _ExternalUrls.fromJson(Map<String, dynamic> json) =
      _$ExternalUrlsImpl.fromJson;

  @override
  String? get spotify;
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

Image _$ImageFromJson(Map<String, dynamic> json) {
  return _Image.fromJson(json);
}

/// @nodoc
mixin _$Image {
  String? get url => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageCopyWith<Image> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageCopyWith<$Res> {
  factory $ImageCopyWith(Image value, $Res Function(Image) then) =
      _$ImageCopyWithImpl<$Res, Image>;
  @useResult
  $Res call({String? url, int? height, int? width});
}

/// @nodoc
class _$ImageCopyWithImpl<$Res, $Val extends Image>
    implements $ImageCopyWith<$Res> {
  _$ImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? height = freezed,
    Object? width = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageImplCopyWith<$Res> implements $ImageCopyWith<$Res> {
  factory _$$ImageImplCopyWith(
          _$ImageImpl value, $Res Function(_$ImageImpl) then) =
      __$$ImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, int? height, int? width});
}

/// @nodoc
class __$$ImageImplCopyWithImpl<$Res>
    extends _$ImageCopyWithImpl<$Res, _$ImageImpl>
    implements _$$ImageImplCopyWith<$Res> {
  __$$ImageImplCopyWithImpl(
      _$ImageImpl _value, $Res Function(_$ImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? height = freezed,
    Object? width = freezed,
  }) {
    return _then(_$ImageImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageImpl implements _Image {
  const _$ImageImpl(
      {required this.url, required this.height, required this.width});

  factory _$ImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageImplFromJson(json);

  @override
  final String? url;
  @override
  final int? height;
  @override
  final int? width;

  @override
  String toString() {
    return 'Image(url: $url, height: $height, width: $width)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageImpl &&
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
  _$$ImageImplCopyWith<_$ImageImpl> get copyWith =>
      __$$ImageImplCopyWithImpl<_$ImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageImplToJson(
      this,
    );
  }
}

abstract class _Image implements Image {
  const factory _Image(
      {required final String? url,
      required final int? height,
      required final int? width}) = _$ImageImpl;

  factory _Image.fromJson(Map<String, dynamic> json) = _$ImageImpl.fromJson;

  @override
  String? get url;
  @override
  int? get height;
  @override
  int? get width;
  @override
  @JsonKey(ignore: true)
  _$$ImageImplCopyWith<_$ImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
