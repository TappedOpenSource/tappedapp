part of 'spotify_bloc.dart';

@immutable
sealed class SpotifyState {}

final class SpotifyInitial extends SpotifyState {}

final class SpotifyUnauthenticated extends SpotifyState {}

final class SpotifyAuthenticated extends SpotifyState {
  SpotifyAuthenticated({
    required this.credentials,
  });

  final SpotifyCredentials credentials;
}
