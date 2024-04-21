import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/chartmetric_artist.dart';

abstract class ChartmetricRepository {
  Future<Option<ChartmetricArtist>> getArtistBySpotifyId(
    String spotifyId,
  );
}
