import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/spotify_artist.dart';

abstract class SpotifyRepository {
  Future<Option<SpotifyArtist>> getArtistById(String artistId);
}
