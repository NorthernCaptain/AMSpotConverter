import '../models/song.dart';
import 'base_music_service.dart';

class MockAppleMusicService implements AppleMusicServiceInterface {

  final String teamId;
  final String keyId;
  final String privateKeyPath;

  MockAppleMusicService({
    required this.teamId,
    required this.keyId,
    required this.privateKeyPath,
  });

  @override
  Future<Song?> getTrackById(String trackId) async {
    return await getSongById(trackId);
  }

  @override
  Future<Song?> getSongById(String songId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Return mock data based on songId
    if (songId == '1677770551') {
      return Song(
        id: songId,
        name: 'Flowers',
        artist: 'Miley Cyrus',
        album: 'Endless Summer Vacation',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/sample/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/sample.m4a',
        externalUrl: 'https://music.apple.com/us/song/flowers/1677770551',
        platform: 'apple_music',
      );
    } else if (songId == '1440929778') {
      return Song(
        id: songId,
        name: 'Cruel Summer',
        artist: 'Taylor Swift',
        album: 'Lover',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/lover/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/lover.m4a',
        externalUrl: 'https://music.apple.com/us/song/cruel-summer/1440929778',
        platform: 'apple_music',
      );
    }

    // Default song for unknown IDs
    return Song(
      id: songId,
      name: 'Sample Song',
      artist: 'Sample Artist',
      album: 'Sample Album',
      imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music/v4/sample/640x640bb.jpg',
      previewUrl: null,
      externalUrl: 'https://music.apple.com/us/song/sample/$songId',
      platform: 'apple_music',
    );
  }

  @override
  Future<Song?> getAlbumById(String albumId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return Song(
      id: albumId,
      name: 'Sample Album',
      artist: 'Sample Artist',
      album: 'Sample Album',
      imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music/v4/sample_album/640x640bb.jpg',
      previewUrl: null,
      externalUrl: 'https://music.apple.com/us/album/sample/$albumId',
      platform: 'apple_music',
    );
  }

  @override
  Future<List<Song>> searchTracks(String query, {int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 900));

    // Return mock search results
    return [
      Song(
        id: 'am_search_1',
        name: 'Flowers',
        artist: 'Miley Cyrus',
        album: 'Endless Summer Vacation',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/flowers/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/flowers.m4a',
        externalUrl: 'https://music.apple.com/us/song/flowers/1677770551',
        platform: 'apple_music',
      ),
      Song(
        id: 'am_search_2',
        name: 'Flowers (Piano Version)',
        artist: 'Miley Cyrus',
        album: 'Endless Summer Vacation (Piano Sessions)',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/piano/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/flowers_piano.m4a',
        externalUrl: 'https://music.apple.com/us/song/flowers-piano/1677770552',
        platform: 'apple_music',
      ),
      Song(
        id: 'am_search_3',
        name: 'Used to Be Young',
        artist: 'Miley Cyrus',
        album: 'Used to Be Young - Single',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/young/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/young.m4a',
        externalUrl: 'https://music.apple.com/us/song/used-to-be-young/1677770553',
        platform: 'apple_music',
      ),
      Song(
        id: 'am_search_4',
        name: 'River',
        artist: 'Miley Cyrus ft. Dolly Parton',
        album: 'Endless Summer Vacation',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/river/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/river.m4a',
        externalUrl: 'https://music.apple.com/us/song/river/1677770554',
        platform: 'apple_music',
      ),
      Song(
        id: 'am_search_5',
        name: 'Jaded',
        artist: 'Miley Cyrus',
        album: 'Endless Summer Vacation',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/jaded/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/jaded.m4a',
        externalUrl: 'https://music.apple.com/us/song/jaded/1677770555',
        platform: 'apple_music',
      ),
      Song(
        id: 'am_search_6',
        name: 'Angels Like You',
        artist: 'Miley Cyrus',
        album: 'Plastic Hearts',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/angels/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/angels.m4a',
        externalUrl: 'https://music.apple.com/us/song/angels-like-you/1677770556',
        platform: 'apple_music',
      ),
      Song(
        id: 'am_search_7',
        name: 'Midnight Sky',
        artist: 'Miley Cyrus',
        album: 'Plastic Hearts',
        imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/midnight/640x640bb.jpg',
        previewUrl: 'https://audio-ssl.itunes.apple.com/midnight.m4a',
        externalUrl: 'https://music.apple.com/us/song/midnight-sky/1677770557',
        platform: 'apple_music',
      ),
    ];
  }

  @override
  String? extractTrackIdFromUrl(String url) {
    return extractSongIdFromUrl(url);
  }

  @override
  String? extractSongIdFromUrl(String url) {
    final RegExp songRegex = RegExp(r'music\.apple\.com/[^/]+/song/[^/]+/(\d+)');
    final match = songRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  String? extractAlbumIdFromUrl(String url) {
    final RegExp albumRegex = RegExp(r'music\.apple\.com/[^/]+/album/[^/]+/(\d+)');
    final match = albumRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  bool isValidUrl(String url) {
    return url.contains('music.apple.com/');
  }

  @override
  String get platformName => 'apple_music';
}