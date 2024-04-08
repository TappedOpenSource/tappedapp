// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookingHistoryState {
  bool get loadingBookings => throw _privateConstructorUsedError;
  bool get gridView => throw _privateConstructorUsedError;
  bool get showFlierMarkers => throw _privateConstructorUsedError;
  List<Booking> get bookings => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingHistoryStateCopyWith<BookingHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingHistoryStateCopyWith<$Res> {
  factory $BookingHistoryStateCopyWith(
          BookingHistoryState value, $Res Function(BookingHistoryState) then) =
      _$BookingHistoryStateCopyWithImpl<$Res, BookingHistoryState>;
  @useResult
  $Res call(
      {bool loadingBookings,
      bool gridView,
      bool showFlierMarkers,
      List<Booking> bookings});
}

/// @nodoc
class _$BookingHistoryStateCopyWithImpl<$Res, $Val extends BookingHistoryState>
    implements $BookingHistoryStateCopyWith<$Res> {
  _$BookingHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingBookings = null,
    Object? gridView = null,
    Object? showFlierMarkers = null,
    Object? bookings = null,
  }) {
    return _then(_value.copyWith(
      loadingBookings: null == loadingBookings
          ? _value.loadingBookings
          : loadingBookings // ignore: cast_nullable_to_non_nullable
              as bool,
      gridView: null == gridView
          ? _value.gridView
          : gridView // ignore: cast_nullable_to_non_nullable
              as bool,
      showFlierMarkers: null == showFlierMarkers
          ? _value.showFlierMarkers
          : showFlierMarkers // ignore: cast_nullable_to_non_nullable
              as bool,
      bookings: null == bookings
          ? _value.bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<Booking>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingHistoryStateImplCopyWith<$Res>
    implements $BookingHistoryStateCopyWith<$Res> {
  factory _$$BookingHistoryStateImplCopyWith(_$BookingHistoryStateImpl value,
          $Res Function(_$BookingHistoryStateImpl) then) =
      __$$BookingHistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loadingBookings,
      bool gridView,
      bool showFlierMarkers,
      List<Booking> bookings});
}

/// @nodoc
class __$$BookingHistoryStateImplCopyWithImpl<$Res>
    extends _$BookingHistoryStateCopyWithImpl<$Res, _$BookingHistoryStateImpl>
    implements _$$BookingHistoryStateImplCopyWith<$Res> {
  __$$BookingHistoryStateImplCopyWithImpl(_$BookingHistoryStateImpl _value,
      $Res Function(_$BookingHistoryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingBookings = null,
    Object? gridView = null,
    Object? showFlierMarkers = null,
    Object? bookings = null,
  }) {
    return _then(_$BookingHistoryStateImpl(
      loadingBookings: null == loadingBookings
          ? _value.loadingBookings
          : loadingBookings // ignore: cast_nullable_to_non_nullable
              as bool,
      gridView: null == gridView
          ? _value.gridView
          : gridView // ignore: cast_nullable_to_non_nullable
              as bool,
      showFlierMarkers: null == showFlierMarkers
          ? _value.showFlierMarkers
          : showFlierMarkers // ignore: cast_nullable_to_non_nullable
              as bool,
      bookings: null == bookings
          ? _value._bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<Booking>,
    ));
  }
}

/// @nodoc

class _$BookingHistoryStateImpl implements _BookingHistoryState {
  const _$BookingHistoryStateImpl(
      {this.loadingBookings = false,
      this.gridView = true,
      this.showFlierMarkers = true,
      final List<Booking> bookings = const <Booking>[]})
      : _bookings = bookings;

  @override
  @JsonKey()
  final bool loadingBookings;
  @override
  @JsonKey()
  final bool gridView;
  @override
  @JsonKey()
  final bool showFlierMarkers;
  final List<Booking> _bookings;
  @override
  @JsonKey()
  List<Booking> get bookings {
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookings);
  }

  @override
  String toString() {
    return 'BookingHistoryState(loadingBookings: $loadingBookings, gridView: $gridView, showFlierMarkers: $showFlierMarkers, bookings: $bookings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingHistoryStateImpl &&
            (identical(other.loadingBookings, loadingBookings) ||
                other.loadingBookings == loadingBookings) &&
            (identical(other.gridView, gridView) ||
                other.gridView == gridView) &&
            (identical(other.showFlierMarkers, showFlierMarkers) ||
                other.showFlierMarkers == showFlierMarkers) &&
            const DeepCollectionEquality().equals(other._bookings, _bookings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loadingBookings, gridView,
      showFlierMarkers, const DeepCollectionEquality().hash(_bookings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingHistoryStateImplCopyWith<_$BookingHistoryStateImpl> get copyWith =>
      __$$BookingHistoryStateImplCopyWithImpl<_$BookingHistoryStateImpl>(
          this, _$identity);
}

abstract class _BookingHistoryState implements BookingHistoryState {
  const factory _BookingHistoryState(
      {final bool loadingBookings,
      final bool gridView,
      final bool showFlierMarkers,
      final List<Booking> bookings}) = _$BookingHistoryStateImpl;

  @override
  bool get loadingBookings;
  @override
  bool get gridView;
  @override
  bool get showFlierMarkers;
  @override
  List<Booking> get bookings;
  @override
  @JsonKey(ignore: true)
  _$$BookingHistoryStateImplCopyWith<_$BookingHistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
