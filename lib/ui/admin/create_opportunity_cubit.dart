import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/create_booking/components/end_time.dart';
import 'package:intheloopapp/ui/create_booking/components/start_time.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'create_opportunity_state.dart';

class CreateOpportunityCubit extends Cubit<CreateOpportunityState> {
  CreateOpportunityCubit({
    required this.database,
    required this.storage,
    required this.currentUserId,
  }) : super(CreateOpportunityState());

  final DatabaseRepository database;
  final StorageRepository storage;
  final String currentUserId;

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
        endTime: EndTime.dirty(startTime.add(state.duration)),
      ),
    );

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

  Future<void> submit() async {
    logger.debug('creating new opportunity');
    emit(
      state.copyWith(
        loading: true,
      ),
    );

    try {
      final thePlaceData = state.placeData;
      final thePlaceId = state.placeId;

      // validate inputs
      if (state.title.isEmpty) {
        // toast with missing title
        throw Exception('missing title');
      }

      if (state.description.isEmpty) {
        throw Exception('missing description');
      }

      if (thePlaceData == null || thePlaceId == null) {
        throw Exception('missing location');
      }

      final uuid = const Uuid().v4();
      final flierUrl = await switch (state.pickedPhoto) {
        None() => Future.value(),
        Some(:final value) => () async {
            final url = await storage.uploadOpportunityFlier(
              opportunityId: uuid,
              imageFile: value,
            );

            return url;
          }(),
      };

      final placeId = thePlaceId;
      final lat = thePlaceData.lat;
      final lng = thePlaceData.lng;
      final geohash = thePlaceData.geohash;

      final op = Opportunity(
        id: uuid,
        userId: currentUserId,
        flierUrl: Option.fromNullable(flierUrl),
        placeId: placeId,
        geohash: geohash,
        lat: lat,
        lng: lng,
        timestamp: DateTime.now(),
        touched: const None<OpportunityInteration>(),
        title: state.title,
        description: state.description,
        isPaid: state.isPaid,
        startTime: state.startTime.value,
        endTime: state.endTime.value,
      );

      logger.debug('op: $op');
      await database.createOpportunity(op);
      await database.copyOpportunityToFeeds(op);
    } catch (e, s) {
      logger.error('error creating opportunity', error: e, stackTrace: s);
    } finally {
      emit(
        state.copyWith(
          loading: false,
        ),
      );
    }
  }
}
