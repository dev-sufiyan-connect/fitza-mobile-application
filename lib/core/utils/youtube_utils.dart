/// Extracts a normalized YouTube video id from common URL formats.
///
/// Supports watch, `youtu.be`, `/shorts/`, `/embed/` and `/live/` URLs.
/// Returns `null` when [url] is empty, is not a YouTube URL, or does not
/// contain a valid (11 character) video id.
String? parseYoutubeVideoId(String url) {
  final uri = Uri.tryParse(url.trim());
  if (uri == null) return null;

  final host = uri.host.toLowerCase();
  String? rawId;

  if (host == 'youtu.be' || host.endsWith('.youtu.be')) {
    rawId = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
  } else if (host == 'youtube.com' ||
      host.endsWith('.youtube.com') ||
      host == 'youtube-nocookie.com' ||
      host.endsWith('.youtube-nocookie.com')) {
    rawId = uri.queryParameters['v'];

    if (rawId == null || rawId.isEmpty) {
      if (uri.pathSegments.length >= 2) {
        const prefixes = {'embed', 'shorts', 'live', 'v'};
        if (prefixes.contains(uri.pathSegments.first)) {
          rawId = uri.pathSegments[1];
        }
      }
    }
  }

  return _normalizeVideoId(rawId);
}

/// Normalizes a candidate id to the 11 character YouTube format.
///
/// Some exercise records contain a few stray characters after the real id
/// (for example `aYy3alWRDmk-4`), which makes YouTube reject the embed.
String? _normalizeVideoId(String? value) {
  final id = value?.trim();
  if (id == null || id.length < 11) return null;
  return id.substring(0, 11);
}
