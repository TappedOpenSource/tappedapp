import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/create_booking/components/end_time.dart';
import 'package:intheloopapp/ui/create_booking/components/start_time.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intl/intl.dart';

part 'create_opportunity_state.dart';

class CreateOpportunityCubit extends Cubit<CreateOpportunityState> {
  CreateOpportunityCubit() : super(CreateOpportunityState());

  Future<void> handleImageFromGallery() async {
    try {
      final imageFile =
          await state.picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(
          state.copyWith(
            pickedPhoto: Some(File(imageFile.path)),
          ),
        );
      }
    } catch (e) {
      // print(error);
    }
  }



  void updateTitle(String title) {
    emit(
      state.copyWith(
        title: title,
      ),
    );
  }

  void updateDescription(String description) {
    emit(
      state.copyWith(
        description: description,
      ),
    );
  }

  void updatePaid({required bool isPaid}) {
    emit(
      state.copyWith(
        isPaid: isPaid,
      ),
    );
  }

  void updateStartTime(DateTime startTime) {
    emit(
      state.copyWith(
        startTime: StartTime.dirty(startTime),
      ),
    );
  }

  void updateEndTime(DateTime endTime) {
    emit(
      state.copyWith(
        endTime: EndTime.dirty(endTime),
      ),
    );
  }

  void onLocationChanged(
    PlaceData? placeData,
    String placeId,
  ) {
    emit(
      state.copyWith(
        placeData: placeData,
        placeId: placeId,
      ),
    );
  }

  void submit() {
    logger.info('submitting');
  }
}
