import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:meta/meta.dart';

part 'booking_history_state.dart';

part 'booking_history_cubit.freezed.dart';

class BookingHistoryCubit extends Cubit<BookingHistoryState> {
  BookingHistoryCubit({
    required this.userId,
    required this.database,
  }) : super(const BookingHistoryState());

  final String userId;
  final DatabaseRepository database;

  Future<void> initBookings() async {
    emit(state.copyWith(loadingBookings: true));
    final bookings = await database.getBookingsByRequestee(
      userId,
      limit: 75,
    );
    emit(state.copyWith(bookings: bookings, loadingBookings: false));
  }

  void toggleFlierMarkers() {
    emit(state.copyWith(showFlierMarkers: !state.showFlierMarkers));
  }

  void toggleGridView() {
    emit(state.copyWith(gridView: !state.gridView));
  }
}
