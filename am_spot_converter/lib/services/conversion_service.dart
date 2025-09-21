import '../models/song.dart';
import '../models/conversion_result.dart';
import 'base_music_service.dart';

class ConversionService {
  final BaseMusicService spotifyService;
  final BaseMusicService appleMusicService;

  ConversionService({
    required this.spotifyService,
    required this.appleMusicService,
  });

  Future<ConversionResult> convertUrl(String url) async {
    try {
      Song? originalSong;
      List<Song> searchResults = [];

      if (spotifyService.isValidUrl(url)) {
        originalSong = await _getSpotifySong(url);
        if (originalSong != null) {
          searchResults = await _searchAppleMusic(originalSong);
        }
      } else if (appleMusicService.isValidUrl(url)) {
        originalSong = await _getAppleMusicSong(url);
        if (originalSong != null) {
          searchResults = await _searchSpotify(originalSong);
        }
      } else {
        return ConversionResult(error: 'Unsupported URL format');
      }

      if (originalSong == null) {
        return ConversionResult(error: 'Could not retrieve song information');
      }

      return ConversionResult(
        originalSong: originalSong,
        searchResults: searchResults,
      );
    } catch (e) {
      return ConversionResult(error: 'Conversion failed: ${e.toString()}');
    }
  }

  Future<Song?> _getSpotifySong(String url) async {
    final trackId = spotifyService.extractTrackIdFromUrl(url);
    if (trackId != null) {
      return await spotifyService.getTrackById(trackId);
    }

    final albumId = spotifyService.extractAlbumIdFromUrl(url);
    if (albumId != null) {
      return await spotifyService.getAlbumById(albumId);
    }

    return null;
  }

  Future<Song?> _getAppleMusicSong(String url) async {
    final trackId = appleMusicService.extractTrackIdFromUrl(url);
    if (trackId != null) {
      return await appleMusicService.getTrackById(trackId);
    }

    final albumId = appleMusicService.extractAlbumIdFromUrl(url);
    if (albumId != null) {
      return await appleMusicService.getAlbumById(albumId);
    }

    return null;
  }

  Future<List<Song>> _searchAppleMusic(Song spotifySong) async {
    final query = '${spotifySong.name} ${spotifySong.artist}';
    return await appleMusicService.searchTracks(query);
  }

  Future<List<Song>> _searchSpotify(Song appleMusicSong) async {
    final query = '${appleMusicSong.name} ${appleMusicSong.artist}';
    return await spotifyService.searchTracks(query);
  }

  bool isValidMusicUrl(String url) {
    return spotifyService.isValidUrl(url) || appleMusicService.isValidUrl(url);
  }

  String getUrlPlatform(String url) {
    if (spotifyService.isValidUrl(url)) return spotifyService.platformName;
    if (appleMusicService.isValidUrl(url)) return appleMusicService.platformName;
    return 'unknown';
  }
}