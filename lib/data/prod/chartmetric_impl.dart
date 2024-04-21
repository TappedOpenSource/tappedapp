import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/chartmetric_repository.dart';
import 'package:intheloopapp/domains/models/chartmetric_artist.dart';
import 'package:intheloopapp/utils/app_logger.dart';

final _functions = FirebaseFunctions.instance;

class ChartmetricImpl extends ChartmetricRepository {
  @override
  Future<Option<ChartmetricArtist>> getArtistBySpotifyId(
    String spotifyId,
  ) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: 'get_artist_by_spotify_id',
        parameters: {
          'spotify_id': spotifyId,
        },
      );

      final callable = _functions.httpsCallable('getArtistBySpotifyId');
      final res = await callable.call<Map<String, dynamic>>({
        'spotifyId': spotifyId,
      });

      final data = res.data;
      final artist = ChartmetricArtist.fromJson(res.data);

      return Option.of(artist);
    } catch (e, s) {
      logger.error(
        'error getting artist by spotify id',
        error: e,
        stackTrace: s,
      );
      return const None();
    }
  }
}
