// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get requesteeId => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get startTime => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get endTime => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;
  Option<String> get requesterId => throw _privateConstructorUsedError;
  Option<String> get name => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  int get rate => throw _privateConstructorUsedError;
  Option<String> get serviceId => throw _privateConstructorUsedError;
  bool get addedByUser => throw _privateConstructorUsedError;
  Option<String> get flierUrl => throw _privateConstructorUsedError;
  Option<String> get eventUrl => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  Option<Location> get location => throw _privateConstructorUsedError;
  List<String> get socialMediaLinks => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call(
      {String id,
      String requesteeId,
      BookingStatus status,
      @DateTimeConverter() DateTime startTime,
      @DateTimeConverter() DateTime endTime,
      @DateTimeConverter() DateTime timestamp,
      Option<String> requesterId,
      Option<String> name,
      String note,
      int rate,
      Option<String> serviceId,
      bool addedByUser,
      Option<String> flierUrl,
      Option<String> eventUrl,
      List<String> genres,
      Option<Location> location,
      List<String> socialMediaLinks});
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesteeId = null,
    Object? status = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? timestamp = null,
    Object? requesterId = null,
    Object? name = null,
    Object? note = null,
    Object? rate = null,
    Object? serviceId = null,
    Object? addedByUser = null,
    Object? flierUrl = null,
    Object? eventUrl = null,
    Object? genres = null,
    Object? location = null,
    Object? socialMediaLinks = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesteeId: null == requesteeId
          ? _value.requesteeId
          : requesteeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      addedByUser: null == addedByUser
          ? _value.addedByUser
          : addedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      flierUrl: null == flierUrl
          ? _value.flierUrl
          : flierUrl // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      eventUrl: null == eventUrl
          ? _value.eventUrl
          : eventUrl // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      genres: null == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Option<Location>,
      socialMediaLinks: null == socialMediaLinks
          ? _value.socialMediaLinks
          : socialMediaLinks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
          _$BookingImpl value, $Res Function(_$BookingImpl) then) =
      __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requesteeId,
      BookingStatus status,
      @DateTimeConverter() DateTime startTime,
      @DateTimeConverter() DateTime endTime,
      @DateTimeConverter() DateTime timestamp,
      Option<String> requesterId,
      Option<String> name,
      String note,
      int rate,
      Option<String> serviceId,
      bool addedByUser,
      Option<String> flierUrl,
      Option<String> eventUrl,
      List<String> genres,
      Option<Location> location,
      List<String> socialMediaLinks});
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
      _$BookingImpl _value, $Res Function(_$BookingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesteeId = null,
    Object? status = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? timestamp = null,
    Object? requesterId = null,
    Object? name = null,
    Object? note = null,
    Object? rate = null,
    Object? serviceId = null,
    Object? addedByUser = null,
    Object? flierUrl = null,
    Object? eventUrl = null,
    Object? genres = null,
    Object? location = null,
    Object? socialMediaLinks = null,
  }) {
    return _then(_$BookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesteeId: null == requesteeId
          ? _value.requesteeId
          : requesteeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      addedByUser: null == addedByUser
          ? _value.addedByUser
          : addedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      flierUrl: null == flierUrl
          ? _value.flierUrl
          : flierUrl // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      eventUrl: null == eventUrl
          ? _value.eventUrl
          : eventUrl // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      genres: null == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Option<Location>,
      socialMediaLinks: null == socialMediaLinks
          ? _value._socialMediaLinks
          : socialMediaLinks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$BookingImpl implements _Booking {
  const _$BookingImpl(
      {required this.id,
      required this.requesteeId,
      required this.status,
      @DateTimeConverter() required this.startTime,
      @DateTimeConverter() required this.endTime,
      @DateTimeConverter() required this.timestamp,
      this.requesterId = const None(),
      this.name = const None(),
      this.note = '',
      this.rate = 0,
      this.serviceId = const None(),
      this.addedByUser = false,
      this.flierUrl = const None(),
      this.eventUrl = const None(),
      final List<String> genres = const [],
      this.location = const None(),
      final List<String> socialMediaLinks = const []})
      : _genres = genres,
        _socialMediaLinks = socialMediaLinks;

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String requesteeId;
  @override
  final BookingStatus status;
  @override
  @DateTimeConverter()
  final DateTime startTime;
  @override
  @DateTimeConverter()
  final DateTime endTime;
  @override
  @DateTimeConverter()
  final DateTime timestamp;
  @override
  @JsonKey()
  final Option<String> requesterId;
  @override
  @JsonKey()
  final Option<String> name;
  @override
  @JsonKey()
  final String note;
  @override
  @JsonKey()
  final int rate;
  @override
  @JsonKey()
  final Option<String> serviceId;
  @override
  @JsonKey()
  final bool addedByUser;
  @override
  @JsonKey()
  final Option<String> flierUrl;
  @override
  @JsonKey()
  final Option<String> eventUrl;
  final List<String> _genres;
  @override
  @JsonKey()
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  @JsonKey()
  final Option<Location> location;
  final List<String> _socialMediaLinks;
  @override
  @JsonKey()
  List<String> get socialMediaLinks {
    if (_socialMediaLinks is EqualUnmodifiableListView)
      return _socialMediaLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_socialMediaLinks);
  }

  @override
  String toString() {
    return 'Booking(id: $id, requesteeId: $requesteeId, status: $status, startTime: $startTime, endTime: $endTime, timestamp: $timestamp, requesterId: $requesterId, name: $name, note: $note, rate: $rate, serviceId: $serviceId, addedByUser: $addedByUser, flierUrl: $flierUrl, eventUrl: $eventUrl, genres: $genres, location: $location, socialMediaLinks: $socialMediaLinks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesteeId, requesteeId) ||
                other.requesteeId == requesteeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.addedByUser, addedByUser) ||
                other.addedByUser == addedByUser) &&
            (identical(other.flierUrl, flierUrl) ||
                other.flierUrl == flierUrl) &&
            (identical(other.eventUrl, eventUrl) ||
                other.eventUrl == eventUrl) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._socialMediaLinks, _socialMediaLinks));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requesteeId,
      status,
      startTime,
      endTime,
      timestamp,
      requesterId,
      name,
      note,
      rate,
      serviceId,
      addedByUser,
      flierUrl,
      eventUrl,
      const DeepCollectionEquality().hash(_genres),
      location,
      const DeepCollectionEquality().hash(_socialMediaLinks));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(
      this,
    );
  }
}

abstract class _Booking implements Booking {
  const factory _Booking(
      {required final String id,
      required final String requesteeId,
      required final BookingStatus status,
      @DateTimeConverter() required final DateTime startTime,
      @DateTimeConverter() required final DateTime endTime,
      @DateTimeConverter() required final DateTime timestamp,
      final Option<String> requesterId,
      final Option<String> name,
      final String note,
      final int rate,
      final Option<String> serviceId,
      final bool addedByUser,
      final Option<String> flierUrl,
      final Option<String> eventUrl,
      final List<String> genres,
      final Option<Location> location,
      final List<String> socialMediaLinks}) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get requesteeId;
  @override
  BookingStatus get status;
  @override
  @DateTimeConverter()
  DateTime get startTime;
  @override
  @DateTimeConverter()
  DateTime get endTime;
  @override
  @DateTimeConverter()
  DateTime get timestamp;
  @override
  Option<String> get requesterId;
  @override
  Option<String> get name;
  @override
  String get note;
  @override
  int get rate;
  @override
  Option<String> get serviceId;
  @override
  bool get addedByUser;
  @override
  Option<String> get flierUrl;
  @override
  Option<String> get eventUrl;
  @override
  List<String> get genres;
  @override
  Option<Location> get location;
  @override
  List<String> get socialMediaLinks;
  @override
  @JsonKey(ignore: true)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
