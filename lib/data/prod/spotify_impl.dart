import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/domains/models/spotify_credentials.dart';
import 'package:intheloopapp/domains/models/spotify_user.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

final dio = Dio();
final _firestore = FirebaseFirestore.instance;
final _spotifyAccessTokensRef = _firestore.collection('spotifyAccessTokens');
const clientId = '3d6a0acb461948e5ad9a133720103445';

class SpotifyImpl extends SpotifyRepository {
  @override
  Future<void> signInWithSpotify() async {
    final spotifyRedirectUri = Uri.parse(
        'https://us-central1-in-the-loop-306520.cloudfunctions.net/spotifyRedirect');
    await launchUrl(
      spotifyRedirectUri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Future<Option<SpotifyCredentials>> authorizeCodeGrant(String code) async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'spotifyAuthorizeCodeGrant',
    );

    try {
      logger.debug('spotifyAuthorizeCodeGrant called with code: $code');
      final res = await callable.call<Map<String, dynamic>>({
        'code': code,
      });

      final creds = SpotifyCredentials.fromJson(res.data);
      return Option.of(creds);
    } catch (e, s) {
      logger.error('spotifyAuthorizeCodeGrant error', error: e, stackTrace: s);
      return const None();
    }
  }

  @override
  Future<Option<SpotifyCredentials>> refreshAccessToken(
    String userId,
    String refreshToken,
  ) async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'spotifyRefreshToken',
    );

    final res = await callable.call<Map<String, dynamic>>({
      'refreshToken': refreshToken,
    });

    final body = res.data;
    logger.info('refreshAccessToken body: $body');
    final creds = SpotifyCredentials.fromJson(body);
    await setAccessToken(userId, creds);

    return Option.of(creds);
  }

  @override
  Future<Option<SpotifyCredentials>> getAccessToken(String userId) async {
    // check if code is in local storage

    final tokenSnap = await _spotifyAccessTokensRef.doc(userId).get();
    if (!tokenSnap.exists) {
      return const None();
    }

    final credentials = SpotifyCredentials.fromDoc(tokenSnap);

    return Option.of(credentials);
  }

  @override
  Future<void> setAccessToken(String userId, SpotifyCredentials creds) async {
    // save token to local storage

    // save token to firestore
    await _spotifyAccessTokensRef.doc(userId).set(creds.toJson());
  }

  @override
  Future<void> clearAccessToken(String userId) async {
    // clear token from local storage
  }

  ///
  /// Spotify API
  ///
  /// cURL
  /// curl --request GET \
  ///   --url https://api.spotify.com/v1/me \
  ///   --header 'Authorization: Bearer 1POdFZRZbvb...qqillRxMr2z'
  @override
  Future<Option<SpotifyUser>> getMe(
    String userId,
    SpotifyCredentials credentials,
  ) async {
    // refresh token if expired

    // get user info from spotify api with access token
    final res = await dio.get<Map<String, dynamic>>(
      'https://api.spotify.com/v1/me',
      options: Options(
        validateStatus: (status) => status == 200 || status == 401,
        headers: {
          'Authorization': ' Bearer ${credentials.accessToken}',
        },
      ),
    );

    if (res.statusCode == 401) {
      logger.error('getMe error: 401');
      // refresh token
      final newCreds = await refreshAccessToken(
        userId,
        credentials.refreshToken,
      );

      return switch (newCreds) {
        None() => Future.value(const None()),
        Some(:final value) => getMe(userId, value),
      };
    }

    final body = res.data;
    if (res.statusCode != 200 || body == null) {
      logger.error('getMe error');
      return const None();
    }

    final t = SpotifyUser.fromJson(body);

    return Option.of(t);
  }
}
