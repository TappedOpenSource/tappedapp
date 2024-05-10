String sanitizeUsername(String artistName) {
  // Convert name to lowercase
  final trimmed = artistName.trim().toLowerCase();

  // Replace spaces with a hyphen
  final underscores = trimmed.replaceAll(RegExp(r'\s+'), '_');

  // Remove disallowed characters (only keep letters, numbers, hyphens, and underscores)
  final username = underscores.replaceAll(RegExp('[^a-z0-9_]'), '');

  return username;
}