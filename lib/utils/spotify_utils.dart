
bool isValidSpotifyUrl(String url) {
  // Regular expression to match Spotify URLs
  final regExp = RegExp(
      r'^https:\/\/open\.spotify\.com\/(artist)\/[a-zA-Z0-9]+([?/].*)?$',);

  return regExp.hasMatch(url);
}

class InvalidSpotifyUrlException implements Exception {

  const InvalidSpotifyUrlException(this.message);
  final String message;
}
