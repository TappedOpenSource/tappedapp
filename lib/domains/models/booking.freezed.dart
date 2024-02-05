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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get requesterId => throw _privateConstructorUsedError;
  String get requesteeId => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get startTime => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get endTime => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  int get rate => throw _privateConstructorUsedError;
  Option<String> get serviceId => throw _privateConstructorUsedError;
  Option<String> get placeId => throw _privateConstructorUsedError;
  Option<String> get geohash => throw _privateConstructorUsedError;
  Option<double> get lat => throw _privateConstructorUsedError;
  Option<double> get lng => throw _privateConstructorUsedError;

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
      String requesterId,
      String requesteeId,
      BookingStatus status,
      @DateTimeConverter() DateTime startTime,
      @DateTimeConverter() DateTime endTime,
      @DateTimeConverter() DateTime timestamp,
      String name,
      String note,
      int rate,
      Option<String> serviceId,
      Option<String> placeId,
      Option<String> geohash,
      Option<double> lat,
      Option<double> lng});
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
    Object? requesterId = null,
    Object? requesteeId = null,
    Object? status = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? timestamp = null,
    Object? name = null,
    Object? note = null,
    Object? rate = null,
    Object? serviceId = null,
    Object? placeId = null,
    Object? geohash = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
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
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      geohash: null == geohash
          ? _value.geohash
          : geohash // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as Option<double>,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as Option<double>,
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
      String requesterId,
      String requesteeId,
      BookingStatus status,
      @DateTimeConverter() DateTime startTime,
      @DateTimeConverter() DateTime endTime,
      @DateTimeConverter() DateTime timestamp,
      String name,
      String note,
      int rate,
      Option<String> serviceId,
      Option<String> placeId,
      Option<String> geohash,
      Option<double> lat,
      Option<double> lng});
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
    Object? requesterId = null,
    Object? requesteeId = null,
    Object? status = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? timestamp = null,
    Object? name = null,
    Object? note = null,
    Object? rate = null,
    Object? serviceId = null,
    Object? placeId = null,
    Object? geohash = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_$BookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
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
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      geohash: null == geohash
          ? _value.geohash
          : geohash // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as Option<double>,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as Option<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl implements _Booking {
  const _$BookingImpl(
      {required this.id,
      required this.requesterId,
      required this.requesteeId,
      required this.status,
      @DateTimeConverter() required this.startTime,
      @DateTimeConverter() required this.endTime,
      @DateTimeConverter() required this.timestamp,
      this.name = '',
      this.note = '',
      this.rate = 0,
      this.serviceId = const None(),
      this.placeId = const None(),
      this.geohash = const None(),
      this.lat = const None(),
      this.lng = const None()});

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String requesterId;
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
  final String name;
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
  final Option<String> placeId;
  @override
  @JsonKey()
  final Option<String> geohash;
  @override
  @JsonKey()
  final Option<double> lat;
  @override
  @JsonKey()
  final Option<double> lng;

  @override
  String toString() {
    return 'Booking(id: $id, requesterId: $requesterId, requesteeId: $requesteeId, status: $status, startTime: $startTime, endTime: $endTime, timestamp: $timestamp, name: $name, note: $note, rate: $rate, serviceId: $serviceId, placeId: $placeId, geohash: $geohash, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.requesteeId, requesteeId) ||
                other.requesteeId == requesteeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.geohash, geohash) || other.geohash == geohash) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requesterId,
      requesteeId,
      status,
      startTime,
      endTime,
      timestamp,
      name,
      note,
      rate,
      serviceId,
      placeId,
      geohash,
      lat,
      lng);

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
      required final String requesterId,
      required final String requesteeId,
      required final BookingStatus status,
      @DateTimeConverter() required final DateTime startTime,
      @DateTimeConverter() required final DateTime endTime,
      @DateTimeConverter() required final DateTime timestamp,
      final String name,
      final String note,
      final int rate,
      final Option<String> serviceId,
      final Option<String> placeId,
      final Option<String> geohash,
      final Option<double> lat,
      final Option<double> lng}) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get requesterId;
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
  String get name;
  @override
  String get note;
  @override
  int get rate;
  @override
  Option<String> get serviceId;
  @override
  Option<String> get placeId;
  @override
  Option<String> get geohash;
  @override
  Option<double> get lat;
  @override
  Option<double> get lng;
  @override
  @JsonKey(ignore: true)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
