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
  String get uri => throw _privateConstructorUsedError;
  Option<Album> get album => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get artists => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_markets')
  List<String> get availableMarkets => throw _privateConstructorUsedError;
  @JsonKey(name: 'disc_number')
  Option<int> get discNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_ms')
  Option<int> get durationMs => throw _privateConstructorUsedError;
  bool get explicit => throw _privateConstructorUsedError;
  @JsonKey(name: 'external_ids')
  Option<Map<String, String>> get externalIds =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'external_urls')
  Option<Map<String, dynamic>> get externalUrls =>
      throw _privateConstructorUsedError;
  Option<String> get href => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_playable')
  bool get isPlayable => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_from')
  Option<Map<String, dynamic>> get linkedFrom =>
      throw _privateConstructorUsedError;
  Option<Map<String, dynamic>> get restrictions =>
      throw _privateConstructorUsedError;
  Option<int> get popularity => throw _privateConstructorUsedError;
  @JsonKey(name: 'preview_url')
  Option<String> get previewUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'track_number')
  Option<int> get trackNumber => throw _privateConstructorUsedError;
  Option<String> get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_local')
  bool get isLocal => throw _privateConstructorUsedError;

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
      String uri,
      Option<Album> album,
      List<Map<String, dynamic>> artists,
      @JsonKey(name: 'available_markets') List<String> availableMarkets,
      @JsonKey(name: 'disc_number') Option<int> discNumber,
      @JsonKey(name: 'duration_ms') Option<int> durationMs,
      bool explicit,
      @JsonKey(name: 'external_ids') Option<Map<String, String>> externalIds,
      @JsonKey(name: 'external_urls') Option<Map<String, dynamic>> externalUrls,
      Option<String> href,
      @JsonKey(name: 'is_playable') bool isPlayable,
      @JsonKey(name: 'linked_from') Option<Map<String, dynamic>> linkedFrom,
      Option<Map<String, dynamic>> restrictions,
      Option<int> popularity,
      @JsonKey(name: 'preview_url') Option<String> previewUrl,
      @JsonKey(name: 'track_number') Option<int> trackNumber,
      Option<String> type,
      @JsonKey(name: 'is_local') bool isLocal});
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
    Object? uri = null,
    Object? album = null,
    Object? artists = null,
    Object? availableMarkets = null,
    Object? discNumber = null,
    Object? durationMs = null,
    Object? explicit = null,
    Object? externalIds = null,
    Object? externalUrls = null,
    Object? href = null,
    Object? isPlayable = null,
    Object? linkedFrom = null,
    Object? restrictions = null,
    Object? popularity = null,
    Object? previewUrl = null,
    Object? trackNumber = null,
    Object? type = null,
    Object? isLocal = null,
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
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as Option<Album>,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      availableMarkets: null == availableMarkets
          ? _value.availableMarkets
          : availableMarkets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discNumber: null == discNumber
          ? _value.discNumber
          : discNumber // ignore: cast_nullable_to_non_nullable
              as Option<int>,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as Option<int>,
      explicit: null == explicit
          ? _value.explicit
          : explicit // ignore: cast_nullable_to_non_nullable
              as bool,
      externalIds: null == externalIds
          ? _value.externalIds
          : externalIds // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, String>>,
      externalUrls: null == externalUrls
          ? _value.externalUrls
          : externalUrls // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      href: null == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      isPlayable: null == isPlayable
          ? _value.isPlayable
          : isPlayable // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedFrom: null == linkedFrom
          ? _value.linkedFrom
          : linkedFrom // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      restrictions: null == restrictions
          ? _value.restrictions
          : restrictions // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as Option<int>,
      previewUrl: null == previewUrl
          ? _value.previewUrl
          : previewUrl // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      trackNumber: null == trackNumber
          ? _value.trackNumber
          : trackNumber // ignore: cast_nullable_to_non_nullable
              as Option<int>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      isLocal: null == isLocal
          ? _value.isLocal
          : isLocal // ignore: cast_nullable_to_non_nullable
              as bool,
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
      String uri,
      Option<Album> album,
      List<Map<String, dynamic>> artists,
      @JsonKey(name: 'available_markets') List<String> availableMarkets,
      @JsonKey(name: 'disc_number') Option<int> discNumber,
      @JsonKey(name: 'duration_ms') Option<int> durationMs,
      bool explicit,
      @JsonKey(name: 'external_ids') Option<Map<String, String>> externalIds,
      @JsonKey(name: 'external_urls') Option<Map<String, dynamic>> externalUrls,
      Option<String> href,
      @JsonKey(name: 'is_playable') bool isPlayable,
      @JsonKey(name: 'linked_from') Option<Map<String, dynamic>> linkedFrom,
      Option<Map<String, dynamic>> restrictions,
      Option<int> popularity,
      @JsonKey(name: 'preview_url') Option<String> previewUrl,
      @JsonKey(name: 'track_number') Option<int> trackNumber,
      Option<String> type,
      @JsonKey(name: 'is_local') bool isLocal});
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
    Object? uri = null,
    Object? album = null,
    Object? artists = null,
    Object? availableMarkets = null,
    Object? discNumber = null,
    Object? durationMs = null,
    Object? explicit = null,
    Object? externalIds = null,
    Object? externalUrls = null,
    Object? href = null,
    Object? isPlayable = null,
    Object? linkedFrom = null,
    Object? restrictions = null,
    Object? popularity = null,
    Object? previewUrl = null,
    Object? trackNumber = null,
    Object? type = null,
    Object? isLocal = null,
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
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as Option<Album>,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      availableMarkets: null == availableMarkets
          ? _value._availableMarkets
          : availableMarkets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discNumber: null == discNumber
          ? _value.discNumber
          : discNumber // ignore: cast_nullable_to_non_nullable
              as Option<int>,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as Option<int>,
      explicit: null == explicit
          ? _value.explicit
          : explicit // ignore: cast_nullable_to_non_nullable
              as bool,
      externalIds: null == externalIds
          ? _value.externalIds
          : externalIds // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, String>>,
      externalUrls: null == externalUrls
          ? _value.externalUrls
          : externalUrls // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      href: null == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      isPlayable: null == isPlayable
          ? _value.isPlayable
          : isPlayable // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedFrom: null == linkedFrom
          ? _value.linkedFrom
          : linkedFrom // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      restrictions: null == restrictions
          ? _value.restrictions
          : restrictions // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as Option<int>,
      previewUrl: null == previewUrl
          ? _value.previewUrl
          : previewUrl // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      trackNumber: null == trackNumber
          ? _value.trackNumber
          : trackNumber // ignore: cast_nullable_to_non_nullable
              as Option<int>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      isLocal: null == isLocal
          ? _value.isLocal
          : isLocal // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyTrackImpl implements _SpotifyTrack {
  const _$SpotifyTrackImpl(
      {required this.id,
      required this.name,
      required this.uri,
      this.album = const None(),
      final List<Map<String, dynamic>> artists = const [],
      @JsonKey(name: 'available_markets')
      final List<String> availableMarkets = const [],
      @JsonKey(name: 'disc_number') this.discNumber = const None(),
      @JsonKey(name: 'duration_ms') this.durationMs = const None(),
      this.explicit = false,
      @JsonKey(name: 'external_ids') this.externalIds = const None(),
      @JsonKey(name: 'external_urls') this.externalUrls = const None(),
      this.href = const None(),
      @JsonKey(name: 'is_playable') this.isPlayable = false,
      @JsonKey(name: 'linked_from') this.linkedFrom = const None(),
      this.restrictions = const None(),
      this.popularity = const None(),
      @JsonKey(name: 'preview_url') this.previewUrl = const None(),
      @JsonKey(name: 'track_number') this.trackNumber = const None(),
      this.type = const None(),
      @JsonKey(name: 'is_local') this.isLocal = false})
      : _artists = artists,
        _availableMarkets = availableMarkets;

  factory _$SpotifyTrackImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyTrackImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String uri;
  @override
  @JsonKey()
  final Option<Album> album;
  final List<Map<String, dynamic>> _artists;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  final List<String> _availableMarkets;
  @override
  @JsonKey(name: 'available_markets')
  List<String> get availableMarkets {
    if (_availableMarkets is EqualUnmodifiableListView)
      return _availableMarkets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableMarkets);
  }

  @override
  @JsonKey(name: 'disc_number')
  final Option<int> discNumber;
  @override
  @JsonKey(name: 'duration_ms')
  final Option<int> durationMs;
  @override
  @JsonKey()
  final bool explicit;
  @override
  @JsonKey(name: 'external_ids')
  final Option<Map<String, String>> externalIds;
  @override
  @JsonKey(name: 'external_urls')
  final Option<Map<String, dynamic>> externalUrls;
  @override
  @JsonKey()
  final Option<String> href;
  @override
  @JsonKey(name: 'is_playable')
  final bool isPlayable;
  @override
  @JsonKey(name: 'linked_from')
  final Option<Map<String, dynamic>> linkedFrom;
  @override
  @JsonKey()
  final Option<Map<String, dynamic>> restrictions;
  @override
  @JsonKey()
  final Option<int> popularity;
  @override
  @JsonKey(name: 'preview_url')
  final Option<String> previewUrl;
  @override
  @JsonKey(name: 'track_number')
  final Option<int> trackNumber;
  @override
  @JsonKey()
  final Option<String> type;
  @override
  @JsonKey(name: 'is_local')
  final bool isLocal;

  @override
  String toString() {
    return 'SpotifyTrack(id: $id, name: $name, uri: $uri, album: $album, artists: $artists, availableMarkets: $availableMarkets, discNumber: $discNumber, durationMs: $durationMs, explicit: $explicit, externalIds: $externalIds, externalUrls: $externalUrls, href: $href, isPlayable: $isPlayable, linkedFrom: $linkedFrom, restrictions: $restrictions, popularity: $popularity, previewUrl: $previewUrl, trackNumber: $trackNumber, type: $type, isLocal: $isLocal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyTrackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.album, album) || other.album == album) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            const DeepCollectionEquality()
                .equals(other._availableMarkets, _availableMarkets) &&
            (identical(other.discNumber, discNumber) ||
                other.discNumber == discNumber) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.explicit, explicit) ||
                other.explicit == explicit) &&
            (identical(other.externalIds, externalIds) ||
                other.externalIds == externalIds) &&
            (identical(other.externalUrls, externalUrls) ||
                other.externalUrls == externalUrls) &&
            (identical(other.href, href) || other.href == href) &&
            (identical(other.isPlayable, isPlayable) ||
                other.isPlayable == isPlayable) &&
            (identical(other.linkedFrom, linkedFrom) ||
                other.linkedFrom == linkedFrom) &&
            (identical(other.restrictions, restrictions) ||
                other.restrictions == restrictions) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.previewUrl, previewUrl) ||
                other.previewUrl == previewUrl) &&
            (identical(other.trackNumber, trackNumber) ||
                other.trackNumber == trackNumber) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        uri,
        album,
        const DeepCollectionEquality().hash(_artists),
        const DeepCollectionEquality().hash(_availableMarkets),
        discNumber,
        durationMs,
        explicit,
        externalIds,
        externalUrls,
        href,
        isPlayable,
        linkedFrom,
        restrictions,
        popularity,
        previewUrl,
        trackNumber,
        type,
        isLocal
      ]);

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
      required final String uri,
      final Option<Album> album,
      final List<Map<String, dynamic>> artists,
      @JsonKey(name: 'available_markets') final List<String> availableMarkets,
      @JsonKey(name: 'disc_number') final Option<int> discNumber,
      @JsonKey(name: 'duration_ms') final Option<int> durationMs,
      final bool explicit,
      @JsonKey(name: 'external_ids')
      final Option<Map<String, String>> externalIds,
      @JsonKey(name: 'external_urls')
      final Option<Map<String, dynamic>> externalUrls,
      final Option<String> href,
      @JsonKey(name: 'is_playable') final bool isPlayable,
      @JsonKey(name: 'linked_from')
      final Option<Map<String, dynamic>> linkedFrom,
      final Option<Map<String, dynamic>> restrictions,
      final Option<int> popularity,
      @JsonKey(name: 'preview_url') final Option<String> previewUrl,
      @JsonKey(name: 'track_number') final Option<int> trackNumber,
      final Option<String> type,
      @JsonKey(name: 'is_local') final bool isLocal}) = _$SpotifyTrackImpl;

  factory _SpotifyTrack.fromJson(Map<String, dynamic> json) =
      _$SpotifyTrackImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get uri;
  @override
  Option<Album> get album;
  @override
  List<Map<String, dynamic>> get artists;
  @override
  @JsonKey(name: 'available_markets')
  List<String> get availableMarkets;
  @override
  @JsonKey(name: 'disc_number')
  Option<int> get discNumber;
  @override
  @JsonKey(name: 'duration_ms')
  Option<int> get durationMs;
  @override
  bool get explicit;
  @override
  @JsonKey(name: 'external_ids')
  Option<Map<String, String>> get externalIds;
  @override
  @JsonKey(name: 'external_urls')
  Option<Map<String, dynamic>> get externalUrls;
  @override
  Option<String> get href;
  @override
  @JsonKey(name: 'is_playable')
  bool get isPlayable;
  @override
  @JsonKey(name: 'linked_from')
  Option<Map<String, dynamic>> get linkedFrom;
  @override
  Option<Map<String, dynamic>> get restrictions;
  @override
  Option<int> get popularity;
  @override
  @JsonKey(name: 'preview_url')
  Option<String> get previewUrl;
  @override
  @JsonKey(name: 'track_number')
  Option<int> get trackNumber;
  @override
  Option<String> get type;
  @override
  @JsonKey(name: 'is_local')
  bool get isLocal;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyTrackImplCopyWith<_$SpotifyTrackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Album _$AlbumFromJson(Map<String, dynamic> json) {
  return _Album.fromJson(json);
}

/// @nodoc
mixin _$Album {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;
  @JsonKey(name: 'album_type')
  Option<String> get albumType => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_tracks')
  int get totalTracks => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_markets')
  List<String> get availableMarkets => throw _privateConstructorUsedError;
  @JsonKey(name: 'external_urls')
  Option<Map<String, dynamic>> get externalUrls =>
      throw _privateConstructorUsedError;
  Option<String> get href => throw _privateConstructorUsedError;
  List<AlbumImage> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'release_date')
  Option<String> get releaseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'release_date_precision')
  Option<String> get releaseDatePrecision => throw _privateConstructorUsedError;
  Option<Map<String, dynamic>> get restrictions =>
      throw _privateConstructorUsedError;
  Option<String> get type => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get artists => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlbumCopyWith<Album> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumCopyWith<$Res> {
  factory $AlbumCopyWith(Album value, $Res Function(Album) then) =
      _$AlbumCopyWithImpl<$Res, Album>;
  @useResult
  $Res call(
      {String id,
      String name,
      String uri,
      @JsonKey(name: 'album_type') Option<String> albumType,
      @JsonKey(name: 'total_tracks') int totalTracks,
      @JsonKey(name: 'available_markets') List<String> availableMarkets,
      @JsonKey(name: 'external_urls') Option<Map<String, dynamic>> externalUrls,
      Option<String> href,
      List<AlbumImage> images,
      @JsonKey(name: 'release_date') Option<String> releaseDate,
      @JsonKey(name: 'release_date_precision')
      Option<String> releaseDatePrecision,
      Option<Map<String, dynamic>> restrictions,
      Option<String> type,
      List<Map<String, dynamic>> artists});
}

/// @nodoc
class _$AlbumCopyWithImpl<$Res, $Val extends Album>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? uri = null,
    Object? albumType = null,
    Object? totalTracks = null,
    Object? availableMarkets = null,
    Object? externalUrls = null,
    Object? href = null,
    Object? images = null,
    Object? releaseDate = null,
    Object? releaseDatePrecision = null,
    Object? restrictions = null,
    Object? type = null,
    Object? artists = null,
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
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      albumType: null == albumType
          ? _value.albumType
          : albumType // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      totalTracks: null == totalTracks
          ? _value.totalTracks
          : totalTracks // ignore: cast_nullable_to_non_nullable
              as int,
      availableMarkets: null == availableMarkets
          ? _value.availableMarkets
          : availableMarkets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      externalUrls: null == externalUrls
          ? _value.externalUrls
          : externalUrls // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      href: null == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<AlbumImage>,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      releaseDatePrecision: null == releaseDatePrecision
          ? _value.releaseDatePrecision
          : releaseDatePrecision // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      restrictions: null == restrictions
          ? _value.restrictions
          : restrictions // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlbumImplCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$$AlbumImplCopyWith(
          _$AlbumImpl value, $Res Function(_$AlbumImpl) then) =
      __$$AlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String uri,
      @JsonKey(name: 'album_type') Option<String> albumType,
      @JsonKey(name: 'total_tracks') int totalTracks,
      @JsonKey(name: 'available_markets') List<String> availableMarkets,
      @JsonKey(name: 'external_urls') Option<Map<String, dynamic>> externalUrls,
      Option<String> href,
      List<AlbumImage> images,
      @JsonKey(name: 'release_date') Option<String> releaseDate,
      @JsonKey(name: 'release_date_precision')
      Option<String> releaseDatePrecision,
      Option<Map<String, dynamic>> restrictions,
      Option<String> type,
      List<Map<String, dynamic>> artists});
}

/// @nodoc
class __$$AlbumImplCopyWithImpl<$Res>
    extends _$AlbumCopyWithImpl<$Res, _$AlbumImpl>
    implements _$$AlbumImplCopyWith<$Res> {
  __$$AlbumImplCopyWithImpl(
      _$AlbumImpl _value, $Res Function(_$AlbumImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? uri = null,
    Object? albumType = null,
    Object? totalTracks = null,
    Object? availableMarkets = null,
    Object? externalUrls = null,
    Object? href = null,
    Object? images = null,
    Object? releaseDate = null,
    Object? releaseDatePrecision = null,
    Object? restrictions = null,
    Object? type = null,
    Object? artists = null,
  }) {
    return _then(_$AlbumImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      albumType: null == albumType
          ? _value.albumType
          : albumType // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      totalTracks: null == totalTracks
          ? _value.totalTracks
          : totalTracks // ignore: cast_nullable_to_non_nullable
              as int,
      availableMarkets: null == availableMarkets
          ? _value._availableMarkets
          : availableMarkets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      externalUrls: null == externalUrls
          ? _value.externalUrls
          : externalUrls // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      href: null == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<AlbumImage>,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      releaseDatePrecision: null == releaseDatePrecision
          ? _value.releaseDatePrecision
          : releaseDatePrecision // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      restrictions: null == restrictions
          ? _value.restrictions
          : restrictions // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, dynamic>>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlbumImpl implements _Album {
  const _$AlbumImpl(
      {required this.id,
      required this.name,
      required this.uri,
      @JsonKey(name: 'album_type') this.albumType = const None(),
      @JsonKey(name: 'total_tracks') this.totalTracks = 0,
      @JsonKey(name: 'available_markets')
      final List<String> availableMarkets = const [],
      @JsonKey(name: 'external_urls') this.externalUrls = const None(),
      this.href = const None(),
      final List<AlbumImage> images = const [],
      @JsonKey(name: 'release_date') this.releaseDate = const None(),
      @JsonKey(name: 'release_date_precision')
      this.releaseDatePrecision = const None(),
      this.restrictions = const None(),
      this.type = const None(),
      final List<Map<String, dynamic>> artists = const []})
      : _availableMarkets = availableMarkets,
        _images = images,
        _artists = artists;

  factory _$AlbumImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlbumImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String uri;
  @override
  @JsonKey(name: 'album_type')
  final Option<String> albumType;
  @override
  @JsonKey(name: 'total_tracks')
  final int totalTracks;
  final List<String> _availableMarkets;
  @override
  @JsonKey(name: 'available_markets')
  List<String> get availableMarkets {
    if (_availableMarkets is EqualUnmodifiableListView)
      return _availableMarkets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableMarkets);
  }

  @override
  @JsonKey(name: 'external_urls')
  final Option<Map<String, dynamic>> externalUrls;
  @override
  @JsonKey()
  final Option<String> href;
  final List<AlbumImage> _images;
  @override
  @JsonKey()
  List<AlbumImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'release_date')
  final Option<String> releaseDate;
  @override
  @JsonKey(name: 'release_date_precision')
  final Option<String> releaseDatePrecision;
  @override
  @JsonKey()
  final Option<Map<String, dynamic>> restrictions;
  @override
  @JsonKey()
  final Option<String> type;
  final List<Map<String, dynamic>> _artists;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  @override
  String toString() {
    return 'Album(id: $id, name: $name, uri: $uri, albumType: $albumType, totalTracks: $totalTracks, availableMarkets: $availableMarkets, externalUrls: $externalUrls, href: $href, images: $images, releaseDate: $releaseDate, releaseDatePrecision: $releaseDatePrecision, restrictions: $restrictions, type: $type, artists: $artists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.albumType, albumType) ||
                other.albumType == albumType) &&
            (identical(other.totalTracks, totalTracks) ||
                other.totalTracks == totalTracks) &&
            const DeepCollectionEquality()
                .equals(other._availableMarkets, _availableMarkets) &&
            (identical(other.externalUrls, externalUrls) ||
                other.externalUrls == externalUrls) &&
            (identical(other.href, href) || other.href == href) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.releaseDatePrecision, releaseDatePrecision) ||
                other.releaseDatePrecision == releaseDatePrecision) &&
            (identical(other.restrictions, restrictions) ||
                other.restrictions == restrictions) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._artists, _artists));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      uri,
      albumType,
      totalTracks,
      const DeepCollectionEquality().hash(_availableMarkets),
      externalUrls,
      href,
      const DeepCollectionEquality().hash(_images),
      releaseDate,
      releaseDatePrecision,
      restrictions,
      type,
      const DeepCollectionEquality().hash(_artists));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumImplCopyWith<_$AlbumImpl> get copyWith =>
      __$$AlbumImplCopyWithImpl<_$AlbumImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlbumImplToJson(
      this,
    );
  }
}

abstract class _Album implements Album {
  const factory _Album(
      {required final String id,
      required final String name,
      required final String uri,
      @JsonKey(name: 'album_type') final Option<String> albumType,
      @JsonKey(name: 'total_tracks') final int totalTracks,
      @JsonKey(name: 'available_markets') final List<String> availableMarkets,
      @JsonKey(name: 'external_urls')
      final Option<Map<String, dynamic>> externalUrls,
      final Option<String> href,
      final List<AlbumImage> images,
      @JsonKey(name: 'release_date') final Option<String> releaseDate,
      @JsonKey(name: 'release_date_precision')
      final Option<String> releaseDatePrecision,
      final Option<Map<String, dynamic>> restrictions,
      final Option<String> type,
      final List<Map<String, dynamic>> artists}) = _$AlbumImpl;

  factory _Album.fromJson(Map<String, dynamic> json) = _$AlbumImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get uri;
  @override
  @JsonKey(name: 'album_type')
  Option<String> get albumType;
  @override
  @JsonKey(name: 'total_tracks')
  int get totalTracks;
  @override
  @JsonKey(name: 'available_markets')
  List<String> get availableMarkets;
  @override
  @JsonKey(name: 'external_urls')
  Option<Map<String, dynamic>> get externalUrls;
  @override
  Option<String> get href;
  @override
  List<AlbumImage> get images;
  @override
  @JsonKey(name: 'release_date')
  Option<String> get releaseDate;
  @override
  @JsonKey(name: 'release_date_precision')
  Option<String> get releaseDatePrecision;
  @override
  Option<Map<String, dynamic>> get restrictions;
  @override
  Option<String> get type;
  @override
  List<Map<String, dynamic>> get artists;
  @override
  @JsonKey(ignore: true)
  _$$AlbumImplCopyWith<_$AlbumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlbumImage _$AlbumImageFromJson(Map<String, dynamic> json) {
  return _AlbumImage.fromJson(json);
}

/// @nodoc
mixin _$AlbumImage {
  String get url => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlbumImageCopyWith<AlbumImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumImageCopyWith<$Res> {
  factory $AlbumImageCopyWith(
          AlbumImage value, $Res Function(AlbumImage) then) =
      _$AlbumImageCopyWithImpl<$Res, AlbumImage>;
  @useResult
  $Res call({String url, int height, int width});
}

/// @nodoc
class _$AlbumImageCopyWithImpl<$Res, $Val extends AlbumImage>
    implements $AlbumImageCopyWith<$Res> {
  _$AlbumImageCopyWithImpl(this._value, this._then);

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
abstract class _$$AlbumImageImplCopyWith<$Res>
    implements $AlbumImageCopyWith<$Res> {
  factory _$$AlbumImageImplCopyWith(
          _$AlbumImageImpl value, $Res Function(_$AlbumImageImpl) then) =
      __$$AlbumImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, int height, int width});
}

/// @nodoc
class __$$AlbumImageImplCopyWithImpl<$Res>
    extends _$AlbumImageCopyWithImpl<$Res, _$AlbumImageImpl>
    implements _$$AlbumImageImplCopyWith<$Res> {
  __$$AlbumImageImplCopyWithImpl(
      _$AlbumImageImpl _value, $Res Function(_$AlbumImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(_$AlbumImageImpl(
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
class _$AlbumImageImpl implements _AlbumImage {
  const _$AlbumImageImpl(
      {required this.url, required this.height, required this.width});

  factory _$AlbumImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlbumImageImplFromJson(json);

  @override
  final String url;
  @override
  final int height;
  @override
  final int width;

  @override
  String toString() {
    return 'AlbumImage(url: $url, height: $height, width: $width)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumImageImpl &&
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
  _$$AlbumImageImplCopyWith<_$AlbumImageImpl> get copyWith =>
      __$$AlbumImageImplCopyWithImpl<_$AlbumImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlbumImageImplToJson(
      this,
    );
  }
}

abstract class _AlbumImage implements AlbumImage {
  const factory _AlbumImage(
      {required final String url,
      required final int height,
      required final int width}) = _$AlbumImageImpl;

  factory _AlbumImage.fromJson(Map<String, dynamic> json) =
      _$AlbumImageImpl.fromJson;

  @override
  String get url;
  @override
  int get height;
  @override
  int get width;
  @override
  @JsonKey(ignore: true)
  _$$AlbumImageImplCopyWith<_$AlbumImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
