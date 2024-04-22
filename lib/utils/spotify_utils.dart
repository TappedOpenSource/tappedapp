
bool isValidSpotifyUrl(String url) {
  // Regular expression to match Spotify URLs
  RegExp regExp = RegExp(
      r'^https:\/\/open\.spotify\.com\/(artist)\/[a-zA-Z0-9]+([?/].*)?$');

  return regExp.hasMatch(url);
}

class InvalidSpotifyUrlException implements Exception {
  final String message;

  const InvalidSpotifyUrlException(this.message);
}
