import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/create_booking/components/booking_end_time.dart';
import 'package:intheloopapp/ui/create_booking/components/booking_name.dart';
import 'package:intheloopapp/ui/create_booking/components/booking_note.dart';
import 'package:intheloopapp/ui/create_booking/components/booking_start_time.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  CreateBookingCubit({
    required this.currentUser,
    required this.service,
    required this.requesteeStripeConnectedAccountId,
    required this.navigationBloc,
    required this.onboardingBloc,
    required this.database,
    required this.streamRepo,
    required this.payments,
    required this.bookingFee,
  }) : super(
          CreateBookingState(
            currentUserId: currentUser.id,
            service: service,
            bookingFee: bookingFee,
          ),
        );

  final UserModel currentUser;
  final Service service;
  final Option<String> requesteeStripeConnectedAccountId;
  final double bookingFee;
  final NavigationBloc navigationBloc;
  final OnboardingBloc onboardingBloc;
  final DatabaseRepository database;
  final StreamRepository streamRepo;
  final PaymentRepository payments;

  void updateStartTime(DateTime value) => emit(
        state.copyWith(
          startTime: BookingStartTime.dirty(value),
          endTime: value.isAfter(state.endTime.value)
              ? BookingEndTime.dirty(value)
              : state.endTime,
        ),
      );

  void updateEndTime(DateTime value) => emit(
        state.copyWith(
          endTime: BookingEndTime.dirty(value),
        ),
      );

  void updateName(String value) => emit(
        state.copyWith(
          name: BookingName.dirty(value),
        ),
      );

  void updateNote(String value) => emit(
        state.copyWith(
          note: BookingNote.dirty(value),
        ),
      );

  void updatePlace({
    required Option<PlaceData> place,
    required Option<String> placeId,
  }) =>
      emit(
        state.copyWith(
          place: place,
          placeId: placeId,
        ),
      );

  Future<Booking> createBooking() async {
    if (!state.isValid) {
      throw Exception('Form is not valid');
    }

    final nullablePlace = state.place.asNullable();

    final lat = nullablePlace?.lat;
    final lng = nullablePlace?.lng;
    final geohash = nullablePlace?.geohash;

    final booking = Booking(
      name: state.name.value,
      note: state.note.value,
      serviceId: Some(state.service.id),
      requesterId: state.currentUserId,
      requesteeId: state.service.userId,
      rate: state.service.rate,
      status: BookingStatus.pending,
      placeId: state.placeId,
      geohash: Option.fromNullable(geohash),
      lat: Option.fromNullable(lat),
      lng: Option.fromNullable(lng),
      startTime: state.startTime.value,
      endTime: state.endTime.value,
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final total = state.totalCost;

    logger.debug('creating booking: $booking');
    try {
      if (total > 0) {
        if (requesteeStripeConnectedAccountId is None) {
          throw Exception('requesteeStripeConnectedAccountId is None');
        }

        final stripeAccountId = requesteeStripeConnectedAccountId.unwrap;
        final intent = await payments.initPaymentSheet(
          payerCustomerId: currentUser.stripeCustomerId,
          customerEmail: currentUser.email,
          payeeConnectedAccountId: stripeAccountId,
          amount: total,
        );

        if (intent.customer != currentUser.stripeCustomerId) {
          onboardingBloc.add(
            UpdateOnboardedUser(
              user: currentUser.copyWith(
                stripeCustomerId: intent.customer,
              ),
            ),
          );
        }

        await payments.presentPaymentSheet();

        await payments.confirmPaymentSheetPayment();
      }

      final channel = await streamRepo.createSimpleChat(state.service.userId);
      await channel.sendMessage(
        Message(
          text: state.note.value,
        ),
      );
      await database.createBooking(booking);
      emit(state.copyWith(status: FormzSubmissionStatus.success));

      return booking;
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      rethrow;
    }
  }
}
