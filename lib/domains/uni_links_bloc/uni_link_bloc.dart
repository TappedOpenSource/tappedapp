import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'uni_link_event.dart';
part 'uni_link_state.dart';

class UniLinkBloc extends Bloc<UniLinkEvent, UniLinkState> {
  UniLinkBloc({
    required this.onboardingBloc,
    required this.navBloc,
    required this.dynamicLinkRepository,
    required this.databaseRepository,
  }) : super(UniLinkInitial()) {
    on<MonitorUniLinks>((event, emit) {
      logger.debug('monitoring dynamic links');
      dynamicLinkRepository.getDynamicLinks().listen((event) {
        try {
          logger.debug('new dynamic link');
          switch (event.type) {
            case UniLinkType.createPost:
              navBloc.push(
                CreateLoopPage(),
              );
            case UniLinkType.shareLoop:
              final loopId = event.id;
              if (loopId != null) {
                databaseRepository
                    .getLoopById(
                  loopId,
                )
                    .then((shareLoop) {
                  if (shareLoop.isSome) {
                    navBloc.push(
                      LoopPage(
                        loop: shareLoop.unwrap,
                        loopUser: const None(),
                      ),
                    );
                  }
                });
              }
            case UniLinkType.shareProfile:
              if (event.id != null) {
                navBloc.push(
                  ProfilePage(
                    userId: event.id!,
                    user: const None(),
                  ),
                );
              }
            case UniLinkType.connectStripeRedirect:
              if (event.id == null || event.id == '') {
                break;
              }
              // add accountId to the users data
              if (onboardingBloc.state is! Onboarded) {
                break;
              }

              final currentUser =
                  (onboardingBloc.state as Onboarded).currentUser.copyWith(
                        stripeConnectedAccountId: event.id,
                      );

              onboardingBloc.add(
                UpdateOnboardedUser(
                  user: currentUser,
                ),
              );

              navBloc.push(SettingsPage());
            case UniLinkType.connectStripeRefresh:
              if (event.id != null) {
                // resend the create account request?
              }
          }
        } catch (e, s) {
          logger.error('dynamic link error', error: e, stackTrace: s);
        }
      });

      emit(UniLinkInitial());
    });
  }

  final NavigationBloc navBloc;
  final OnboardingBloc onboardingBloc;
  final UniLinkRepository dynamicLinkRepository;
  final DatabaseRepository databaseRepository;
}
