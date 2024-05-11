import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/spotify_artist.dart';
import 'package:intheloopapp/domains/models/spotify_track.dart';

abstract class SpotifyRepository {
  Future<Option<SpotifyArtist>> getArtistById(String artistId);
  Future<List<SpotifyTrack>> getTopTracks(String artistId);
}
