import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required this.databaseRepository,
  }) : super(Unonboarded()) {
    on<OnboardingCheck>((event, emit) async {
      try {
        logger.debug('checking onboarding status');
        final userId = event.userId;
        final user = await databaseRepository.getUserById(userId);
        final _ = switch (user) {
          None() => () {
              emit(Onboarding());
            }(),
          Some(:final value) => () {
              logger.setUserIdentifier(value.id);
              emit(Onboarded(value));
            }(),
        };
        await logger.reportPreviousSessionErrors();
      } catch (e, s) {
        logger.error(
          'error checking onboarding status',
          error: e,
          stackTrace: s,
        );
        emit(Onboarding());
      }
    });
    on<FinishOnboarding>((event, emit) {
      logger
        ..debug('finishing onboarding')
        ..setUserIdentifier(event.user.id);
      emit(Onboarded(event.user));
    });
    on<UpdateOnboardedUser>((event, emit) async {
      logger.debug('updating onboarded user');
      emit(Onboarded(event.user));
      await databaseRepository.updateUserData(event.user);
    });
  }

  final DatabaseRepository databaseRepository;
}
