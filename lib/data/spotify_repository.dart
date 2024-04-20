import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/spotify_credentials.dart';
import 'package:intheloopapp/domains/models/spotify_user.dart';

abstract class SpotifyRepository {
  Future<void> signInWithSpotify();

  Future<Option<SpotifyCredentials>> authorizeCodeGrant(String code);

  Future<Option<SpotifyCredentials>> refreshAccessToken(
    String userId,
    String refreshToken,
  );

  Future<Option<SpotifyCredentials>> getAccessToken(String userId);

  Future<void> setAccessToken(String userId, SpotifyCredentials token);

  Future<void> clearAccessToken(String userId);

  Future<Option<SpotifyUser>> getMe(
    String currentUserId,
    SpotifyCredentials credentials,
  );
}
