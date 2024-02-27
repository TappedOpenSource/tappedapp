import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intl/intl.dart';

part 'add_past_booking_state.dart';

class AddPastBookingCubit extends Cubit<AddPastBookingState> {
  AddPastBookingCubit() : super(AddPastBookingState());

  void eventNameChanged(String input) {
    final val = input.isEmpty ? const None() : Option.of(input);
    emit(
      state.copyWith(
        eventName: val,
      ),
    );
  }

  void amountPaidChanged(String input) {
    final val = int.tryParse(input) ?? 0;
    emit(
      state.copyWith(
        amountPaid: val,
      ),
    );
  }

  void placeChanged(Option<PlaceData> input) {
    emit(
      state.copyWith(
        place: input,
      ),
    );
  }

  void updateStartTime(DateTime value) {
    emit(
      state.copyWith(
        eventStart: value,
      ),
    );
  }

  void updateDuration(Duration value) {
    emit(
      state.copyWith(
        duration: value,
      ),
    );
  }
}
