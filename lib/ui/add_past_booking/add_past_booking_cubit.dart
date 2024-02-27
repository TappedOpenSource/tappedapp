import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
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

  void amountPaidChanged(int input) {
    emit(
      state.copyWith(
        amountPaid: input,
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

  Future<void> handleImageFromGallery() async {
    try {
      final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (imageFile == null) {
        return;
      }
      emit(
        state.copyWith(
          flierFile: Option.of(
            File(imageFile.path),
          ),
        ),
      );
    } catch (e) {
      // print(error);
    }
  }

  void removeFlier() {
    emit(
      state.copyWith(
        flierFile: const None(),
      ),
    );
  }
}
