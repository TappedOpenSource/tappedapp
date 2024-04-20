import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/deep_link_repository.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/domains/spotify_bloc/spotify_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'deep_link_event.dart';

part 'deep_link_state.dart';

class DeepLinkBloc extends Bloc<DeepLinkEvent, DeepLinkState> {
  DeepLinkBloc({
    required this.onboardingBloc,
    required this.nav,
    required this.deepLinks,
    required this.database,
    required this.spotify,
    required this.spotifyBloc,
  }) : super(DeepLinkInitial()) {
    on<MonitorDeepLinks>((event, emit) {
      logger.debug('monitoring deep links');
      streamSub ??= deepLinks.getDeepLinks().listen(
            (event) async => await _linkHandler(event, emit),
          );
    });
  }

  Future<void> _linkHandler(
    DeepLinkRedirect event,
    Emitter<DeepLinkState> emit,
  ) async {
    try {
      logger.debug('new deep link ${event.type}');
      switch (event) {
        case ShareProfileDeepLink(
            :final userId,
            :final user,
          ):
          nav.push(
            ProfilePage(
              userId: userId,
              user: user,
            ),
          );
        case ShareOpportunityDeepLink(
            :final opportunityId,
            :final opportunity,
          ):
          nav.push(
            OpportunityPage(
              opportunityId: opportunityId,
              opportunity: opportunity,
              onDislike: nav.pop,
              onDismiss: nav.pop,
              onApply: nav.pop,
            ),
          );
        case SettingsDeepLink():
          nav.push(SettingsPage());
          break;
        case ConnectStripeRedirectDeepLink(:final id):
          // add accountId to the users data
          if (onboardingBloc.state is! Onboarded) {
            break;
          }

          final currentUser =
              (onboardingBloc.state as Onboarded).currentUser.copyWith(
                    stripeConnectedAccountId: Option.of(id),
                  );

          onboardingBloc.add(
            UpdateOnboardedUser(
              user: currentUser,
            ),
          );

          nav.push(SettingsPage());
        // case DeepLinkType.connectStripeRefresh:
        //   if (event.id != null) {
        //     // resend the create account request?
        //   }
        case SpotifyRedirectDeepLink():
          if (onboardingBloc.state is! Onboarded) {
            break;
          }

          final code = event.code;
          final currentUser = (onboardingBloc.state as Onboarded).currentUser;
          final userId = currentUser.id;

          final credentials = await spotify.authorizeCodeGrant(code);
          spotifyBloc.add(
            UpdateCredentials(
              currentUserId: userId,
              credentials: credentials,
            ),
          );
      }
    } catch (e, s) {
      logger.error('deep link error', error: e, stackTrace: s);
    }

    emit(DeepLinkInitial());
  }

  @override
  Future<void> close() async {
    await streamSub?.cancel();
    await super.close();
  }

  final NavigationBloc nav;
  final OnboardingBloc onboardingBloc;
  final DeepLinkRepository deepLinks;
  final DatabaseRepository database;
  final SpotifyRepository spotify;
  final SpotifyBloc spotifyBloc;
  StreamSubscription<DeepLinkRedirect>? streamSub;
}
