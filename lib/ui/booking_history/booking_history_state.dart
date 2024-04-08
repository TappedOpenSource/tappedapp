part of 'booking_history_cubit.dart';

@freezed
class BookingHistoryState with _$BookingHistoryState {
  const factory BookingHistoryState({
    @Default(false) bool loadingBookings,
    @Default(true) bool gridView,
    @Default(true) bool showFlierMarkers,
    @Default(<Booking>[]) List<Booking> bookings,
  }) = _BookingHistoryState;
}

