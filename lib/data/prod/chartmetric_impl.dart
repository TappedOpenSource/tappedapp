import 'package:cloud_functions/cloud_functions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/chartmetric_repository.dart';
import 'package:intheloopapp/domains/models/chartmetric_artist.dart';

final _functions = FirebaseFunctions.instance;

class ChartmetricImpl extends ChartmetricRepository {
  @override
  Future<Option<ChartmetricArtist>> getArtistBySpotifyId(
    String spotifyId,
  ) async {
    final callable = _functions.httpsCallable('getArtistBySpotifyId');
    final res = await callable.call<Map<String, dynamic>>({
      'spotifyId': spotifyId,
    });

    final data = res.data;
    final artist = ChartmetricArtist.fromJson(res.data);

    return Option.of(artist);
  }
}
