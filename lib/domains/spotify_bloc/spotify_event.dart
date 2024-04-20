part of 'spotify_bloc.dart';

@immutable
sealed class SpotifyEvent {}

final class InitSpotify extends SpotifyEvent {
  InitSpotify({
    required this.currentUserId,
  });

  final String currentUserId;
}

final class UpdateCredentials extends SpotifyEvent {
  UpdateCredentials({
    required this.currentUserId,
    required this.credentials,
  });

  final String currentUserId;
  final Option<SpotifyCredentials> credentials;
}

final class RefreshConnection extends SpotifyEvent {
  RefreshConnection({
    required this.currentUserId,
  });

  final String currentUserId;
}
