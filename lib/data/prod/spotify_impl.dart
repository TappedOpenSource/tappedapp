import 'package:cached_annotation/cached_annotation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/domains/models/spotify_artist.dart';
import 'package:intheloopapp/domains/models/spotify_track.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/map_tools.dart';

final _functions = FirebaseFunctions.instance;

class SpotifyImpl extends SpotifyRepository {
  @override
  @cached
  Future<Option<SpotifyArtist>> getArtistById(
    String spotifyId,
  ) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'spotify:getArtistBySpotifyId',
      parameters: {
        'spotifyId': spotifyId,
      },
    );

    final callable = _functions.httpsCallable('getArtistBySpotifyId');
    final result = await callable<Map<String, dynamic>>({
      'spotifyId': spotifyId,
    });

    final converted = convertMap(result.data);

    final spotifyArtist = SpotifyArtist.fromJson(converted);
    return some(spotifyArtist);
  }

  @override
  // @cached
  Future<List<SpotifyTrack>> getTopTracks(String artistId) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'spotify:getTopTracksById',
      parameters: {
        'spotifyId': artistId,
      },
    );

    final callable = _functions.httpsCallable('getTopTracksByArtistId');
    final result = await callable<Map<String, dynamic>>({
      'spotifyId': artistId,
    });

    final converted = convertMap(result.data);
    final rawTracks = converted['tracks'] as List<dynamic>;
    final convertedTracks = rawTracks.map((e) => convertMap(e as Map<dynamic, dynamic>)).toList();
    final tracks = convertedTracks.map(SpotifyTrack.fromJson).toList();

    return tracks;
  }
}
