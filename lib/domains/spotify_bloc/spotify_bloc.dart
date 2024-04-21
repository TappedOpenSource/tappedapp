import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/chartmetric_repository.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/spotify_credentials.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:meta/meta.dart';

part 'spotify_event.dart';

part 'spotify_state.dart';

class SpotifyBloc extends Bloc<SpotifyEvent, SpotifyState> {
  SpotifyBloc({
    required this.chartmetric,
    required this.spotify,
    required this.onboarding,
  }) : super(SpotifyInitial()) {
    on<InitSpotify>((event, emit) async {
      final currentUserId = event.currentUserId;

      // check spotify access token
      final creds = await spotify.getAccessToken(currentUserId);

      // set it if it exists or unauthed
      return switch (creds) {
        None() => emit(SpotifyUnauthenticated()),
        Some(:final value) => emit(SpotifyAuthenticated(credentials: value)),
      };
    });
    on<UpdateCredentials>((event, emit) async {
      // set spotify access token
      await switch (event.credentials) {
        None() => spotify.clearAccessToken(event.currentUserId).then((_) {
            emit(SpotifyUnauthenticated());
          }),
        Some(:final value) => _setSpotifyUser(emit, event.currentUserId, value),
      };
    });
    on<RefreshConnection>((event, emit) async {
      final currentUserId = event.currentUserId;
      return switch (state) {
        SpotifyAuthenticated(:final credentials) =>
          _setSpotifyUser(emit, currentUserId, credentials),
        _ => null,
      };
    });
  }

  Future<void> _setSpotifyUser(
    Emitter<SpotifyState> emit,
    String userId,
    SpotifyCredentials credentials,
  ) async {
    emit(SpotifyAuthenticated(credentials: credentials));
    await spotify.setAccessToken(
      userId,
      credentials,
    );

    final onboardingState = onboarding.state;
    if (onboardingState is! Onboarded) {
      logger.error('onboarding state is not Onboarded');
      emit(SpotifyUnauthenticated());
      return;
    }

    final spotifyUser = (await spotify.getMe(userId, credentials)).toNullable();
    if (spotifyUser == null) {
      logger.error('spotify user is null');
      emit(SpotifyUnauthenticated());
      return;
    }

    final spotifyId = spotifyUser.id;
    final artistData = await chartmetric.getArtistBySpotifyId(spotifyId);

    final withSpotifyUser = onboardingState.currentUser.copyWith(
      socialFollowing: onboardingState.currentUser.socialFollowing.copyWith(
        spotifyUser: Option.of(spotifyUser),
      ),
    );

    final currentUser = switch (artistData) {
      None() => withSpotifyUser,
      Some(:final value) => withSpotifyUser.copyWith(
          performerInfo: Option.of(
            withSpotifyUser.performerInfo.fold(
              () => PerformerInfo(
                chartmetricId: Option.of(value.id),
              ),
              (performerInfo) => performerInfo.copyWith(
                chartmetricId: Option.of(value.id),
              ),
            ),
          ),
        ),
    };

    onboarding.add(UpdateOnboardedUser(user: currentUser));
  }

  final OnboardingBloc onboarding;
  final SpotifyRepository spotify;
  final ChartmetricRepository chartmetric;
}
