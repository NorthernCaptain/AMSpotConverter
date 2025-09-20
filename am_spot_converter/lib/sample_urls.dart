// Sample URLs for testing the UI with mock services

class SampleUrls {
  // Spotify URLs (real working URLs for testing)
  static const String spotifyFlowers = 'https://open.spotify.com/track/4iV5W9uYEdYUVa79Axb7Rh';
  static const String spotifyCruelSummer = 'https://open.spotify.com/track/1BxfuPKGuaTgP7aM0Bbdwr';
  static const String spotifyAlbum = 'https://open.spotify.com/album/2plbrEY59IikOBgBGLjaoe';

  // Alternative test URLs
  static const String googleUrl = 'https://www.google.com';
  static const String youtubeTestUrl = 'https://www.youtube.com';

  // Apple Music URLs
  static const String appleMusicFlowers = 'https://music.apple.com/us/song/flowers/1677770551';
  static const String appleMusicCruelSummer = 'https://music.apple.com/us/song/cruel-summer/1440929778';
  static const String appleMusicAlbum = 'https://music.apple.com/us/album/endless-summer-vacation/1677770547';

  // Invalid URLs for testing error handling
  static const String invalidUrl = 'https://example.com/not-a-music-link';
  static const String youtubeUrl = 'https://youtube.com/watch?v=123';

  static List<String> get allSampleUrls => [
    spotifyFlowers,
    spotifyCruelSummer,
    spotifyAlbum,
    appleMusicFlowers,
    appleMusicCruelSummer,
    appleMusicAlbum,
    invalidUrl,
    youtubeUrl,
  ];

  static Map<String, String> get urlDescriptions => {
    spotifyFlowers: 'Spotify: Flowers by Miley Cyrus',
    spotifyCruelSummer: 'Spotify: Cruel Summer by Taylor Swift',
    spotifyAlbum: 'Spotify: Sample Album',
    appleMusicFlowers: 'Apple Music: Flowers by Miley Cyrus',
    appleMusicCruelSummer: 'Apple Music: Cruel Summer by Taylor Swift',
    appleMusicAlbum: 'Apple Music: Sample Album',
    invalidUrl: 'Invalid URL (should show error)',
    youtubeUrl: 'YouTube URL (should show error)',
  };
}