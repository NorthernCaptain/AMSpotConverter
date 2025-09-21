import '../models/song.dart';

abstract class BaseMusicService {
  /// Extract track/song ID from a URL
  String? extractTrackIdFromUrl(String url);

  /// Extract album ID from a URL
  String? extractAlbumIdFromUrl(String url);

  /// Check if the URL belongs to this service
  bool isValidUrl(String url);

  /// Get track/song by ID
  Future<Song?> getTrackById(String trackId);

  /// Get album by ID
  Future<Song?> getAlbumById(String albumId);

  /// Search for tracks/songs
  Future<List<Song>> searchTracks(String query, {int limit = 10});

  /// Get the platform name
  String get platformName;
}

