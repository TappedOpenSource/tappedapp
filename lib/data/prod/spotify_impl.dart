import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/domains/models/spotify_artist.dart';

final _functions = FirebaseFunctions.instance;

class SpotifyImpl extends SpotifyRepository {
  @override
  Future<Option<SpotifyArtist>> getArtistById(
    String artistId,
  ) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'getArtistById',
      parameters: {
        'artistId': artistId,
      },
    );

    final callable = _functions.httpsCallable('getArtistById');
    final result = await callable<Map<String, dynamic>>({
      'artistId': artistId,
    });

    final spotifyArtist = SpotifyArtist.fromJson(result.data);
    return some(spotifyArtist);
  }
}
