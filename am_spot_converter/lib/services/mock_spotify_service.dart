import '../models/song.dart';
import 'base_music_service.dart';

class MockSpotifyService implements SpotifyServiceInterface {

  final String clientId;
  final String clientSecret;

  MockSpotifyService({
    required this.clientId,
    required this.clientSecret,
  });

  @override
  Future<Song?> getTrackById(String trackId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data based on trackId
    if (trackId == '4iV5W9uYEdYUVa79Axb7Rh') {
      return Song(
        id: trackId,
        name: 'Flowers',
        artist: 'Miley Cyrus',
        album: 'Endless Summer Vacation',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273f46b9d202509a8f7384b90de',
        previewUrl: 'https://p.scdn.co/mp3-preview/sample',
        externalUrl: 'https://open.spotify.com/track/4iV5W9uYEdYUVa79Axb7Rh',
        platform: 'spotify',
      );
    } else if (trackId == '1BxfuPKGuaTgP7aM0Bbdwr') {
      return Song(
        id: trackId,
        name: 'Cruel Summer',
        artist: 'Taylor Swift',
        album: 'Lover',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647',
        previewUrl: 'https://p.scdn.co/mp3-preview/sample2',
        externalUrl: 'https://open.spotify.com/track/1BxfuPKGuaTgP7aM0Bbdwr',
        platform: 'spotify',
      );
    }

    // Default track for unknown IDs
    return Song(
      id: trackId,
      name: 'Sample Song',
      artist: 'Sample Artist',
      album: 'Sample Album',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273sample',
      previewUrl: null,
      externalUrl: 'https://open.spotify.com/track/$trackId',
      platform: 'spotify',
    );
  }

  @override
  Future<Song?> getAlbumById(String albumId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return Song(
      id: albumId,
      name: 'Sample Album',
      artist: 'Sample Artist',
      album: 'Sample Album',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273sample_album',
      previewUrl: null,
      externalUrl: 'https://open.spotify.com/album/$albumId',
      platform: 'spotify',
    );
  }

  @override
  Future<List<Song>> searchTracks(String query, {int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return mock search results
    return [
      Song(
        id: 'search_result_1',
        name: 'Flowers',
        artist: 'Miley Cyrus',
        album: 'Endless Summer Vacation',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273f46b9d202509a8f7384b90de',
        previewUrl: 'https://p.scdn.co/mp3-preview/sample1',
        externalUrl: 'https://open.spotify.com/track/4iV5W9uYEdYUVa79Axb7Rh',
        platform: 'spotify',
      ),
      Song(
        id: 'search_result_2',
        name: 'Flowers (Acoustic)',
        artist: 'Miley Cyrus',
        album: 'Endless Summer Vacation (Backyard Sessions)',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273acoustic_version',
        previewUrl: 'https://p.scdn.co/mp3-preview/sample2',
        externalUrl: 'https://open.spotify.com/track/acoustic_version',
        platform: 'spotify',
      ),
      Song(
        id: 'search_result_3',
        name: 'Flowers (Remix)',
        artist: 'Miley Cyrus ft. DJ Sample',
        album: 'Remixes Collection',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273remix_version',
        previewUrl: 'https://p.scdn.co/mp3-preview/sample3',
        externalUrl: 'https://open.spotify.com/track/remix_version',
        platform: 'spotify',
      ),
      Song(
        id: 'search_result_4',
        name: 'Party in the U.S.A.',
        artist: 'Miley Cyrus',
        album: 'The Time of Our Lives',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273party_usa',
        previewUrl: 'https://p.scdn.co/mp3-preview/sample4',
        externalUrl: 'https://open.spotify.com/track/party_usa',
        platform: 'spotify',
      ),
      Song(
        id: 'search_result_5',
        name: 'Wrecking Ball',
        artist: 'Miley Cyrus',
        album: 'Bangerz',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273wrecking_ball',
        previewUrl: 'https://p.scdn.co/mp3-preview/sample5',
        externalUrl: 'https://open.spotify.com/track/wrecking_ball',
        platform: 'spotify',
      ),
    ];
  }

  @override
  String? extractTrackIdFromUrl(String url) {
    final RegExp trackRegex = RegExp(r'spotify\.com/track/([a-zA-Z0-9]+)');
    final match = trackRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  String? extractAlbumIdFromUrl(String url) {
    final RegExp albumRegex = RegExp(r'spotify\.com/album/([a-zA-Z0-9]+)');
    final match = albumRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  bool isValidUrl(String url) {
    return url.contains('spotify.com/') || url.contains('open.spotify.com/');
  }

  @override
  String get platformName => 'spotify';
}