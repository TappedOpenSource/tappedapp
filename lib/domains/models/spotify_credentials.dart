
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_credentials.freezed.dart';
part 'spotify_credentials.g.dart';

@freezed
class SpotifyCredentials with _$SpotifyCredentials {
  const factory SpotifyCredentials({
    required String accessToken,
    required String refreshToken,
  }) = _SpotifyCredentials;

  factory SpotifyCredentials.fromJson(Map<String, dynamic> json) => _$SpotifyCredentialsFromJson(json);

  factory SpotifyCredentials.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist');
    }

    return SpotifyCredentials.fromJson(data);
  }
}
