import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'add_past_booking_state.dart';

class AddPastBookingCubit extends Cubit<AddPastBookingState> {
  AddPastBookingCubit({
    required this.database,
    required this.storage,
    required this.currentUserId,
  }) : super(AddPastBookingState());

  final String currentUserId;
  final DatabaseRepository database;
  final StorageRepository storage;

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

  void venueChanged(Option<UserModel> venue) {
    emit(
      state.copyWith(venue: venue),
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

  Future<void> submitBooking() async {
    final uuid = const Uuid().v4();
    final eventStart = state.eventStart;
    final eventEnd = eventStart.add(state.duration);
    final eventName = state.eventName;
    final amountPaid = state.amountPaid;
    final flierFile = state.flierFile;
    final place = state.place;
    final venue = state.venue;

    final requesterId = venue.map((user) => user.id);
    final flierUrl = await switch (flierFile) {
      None() => Future<None>.value(const None()),
      Some(:final value) => storage
          .uploadBookingFlier(
            bookingId: uuid,
            imageFile: value,
          )
          .then(Option.of),
    };

    final location = venue.map((t) => t.location).getOrElse(() {
      final placeData = place.getOrElse(() => throw 'No place or venue');
      return Option.of(
        Location(
          placeId: placeData.placeId,
          lat: placeData.lat,
          lng: placeData.lng,
          // geohash: placeData.geohash,
        ),
      );
    });

    final userData = await database.getUserById(currentUserId);
    final user = userData.getOrElse(() => throw 'user not found');
    final genres = user.performerInfo
        .map((t) => fromStrings(t.genres))
        .getOrElse(() => []);

    final booking = Booking(
      id: uuid,
      addedByUser: true,
      name: eventName,
      status: BookingStatus.confirmed,
      requesterId: requesterId,
      requesteeId: currentUserId,
      rate: amountPaid,
      timestamp: DateTime.now(),
      startTime: eventStart,
      endTime: eventEnd,
      flierUrl: flierUrl,
      genres: genres.map((e) => e.toString()).toList(),
      location: location,
      verified: true,
    );

    logger.i(booking.toString());

    await FirebaseAnalytics.instance.logEvent(
      name: 'add_past_booking',
      parameters: {
        'event_name': eventName.getOrElse(() => ''),
        'amount_paid': amountPaid,
        'genres': genres.map((e) => e.toString()).toList(),
      },
    );

    await database.createBooking(booking);
  }
}
