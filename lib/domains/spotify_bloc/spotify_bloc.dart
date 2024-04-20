import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/domains/models/spotify_credentials.dart';
import 'package:meta/meta.dart';

part 'spotify_event.dart';

part 'spotify_state.dart';

class SpotifyBloc extends Bloc<SpotifyEvent, SpotifyState> {
  SpotifyBloc({
    required this.spotify,
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
        Some(:final value) =>
          spotify.setAccessToken(event.currentUserId, value).then((_) {
            emit(SpotifyAuthenticated(credentials: value));
          }),
      };
    });
  }

  final SpotifyRepository spotify;
}
