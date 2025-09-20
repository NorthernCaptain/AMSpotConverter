import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'base_music_service.dart';
import 'spotify_service.dart';
import 'apple_music_service.dart';
import 'mock_spotify_service.dart';
import 'mock_apple_music_service.dart';

class MusicServiceFactory {
  static String get _mockServicesConfig {
    // Check environment variable USE_MOCK_SERVICES
    final useMockEnv = dotenv.env['USE_MOCK_SERVICES']?.toLowerCase();

    // Handle legacy boolean values
    if (useMockEnv == '1' || useMockEnv == 'true') {
      return 'all';
    } else if (useMockEnv == '0' || useMockEnv == 'false') {
      return 'none';
    }

    // Return the specific configuration (all/apple/spotify/none)
    return useMockEnv ?? 'all';
  }

  static bool _shouldUseMockForSpotify() {
    final config = _mockServicesConfig;
    return config == 'all' || config == 'spotify';
  }

  static bool _shouldUseMockForAppleMusic() {
    final config = _mockServicesConfig;
    return config == 'all' || config == 'apple';
  }

  static SpotifyServiceInterface createSpotifyService() {
    if (_shouldUseMockForSpotify()) {
      return MockSpotifyService(
        clientId: 'mock_spotify_client_id',
        clientSecret: 'mock_spotify_client_secret',
      );
    } else {
      return SpotifyService(
        clientId: dotenv.env['SPOTIFY_CLIENT_ID'] ?? '',
        clientSecret: dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '',
      );
    }
  }

  static AppleMusicServiceInterface createAppleMusicService() {
    if (_shouldUseMockForAppleMusic()) {
      return MockAppleMusicService(
        teamId: 'mock_apple_team_id',
        keyId: 'mock_apple_key_id',
        privateKeyPath: 'mock_path',
      );
    } else {
      return AppleMusicService(
        teamId: dotenv.env['APPLE_MUSIC_TEAM_ID'] ?? '',
        keyId: dotenv.env['APPLE_MUSIC_KEY_ID'] ?? '',
        privateKeyPath: dotenv.env['APPLE_MUSIC_PRIVATE_KEY_PATH'] ?? '',
      );
    }
  }

  static bool get isUsingMockServices => _mockServicesConfig != 'none';
  static String get mockServicesConfig => _mockServicesConfig;

  /// For testing purposes - force mock services regardless of environment
  static SpotifyServiceInterface createMockSpotifyService() {
    return MockSpotifyService(
      clientId: 'test_spotify_client_id',
      clientSecret: 'test_spotify_client_secret',
    );
  }

  /// For testing purposes - force mock Apple Music service regardless of environment
  static AppleMusicServiceInterface createMockAppleMusicService() {
    return MockAppleMusicService(
      teamId: 'test_apple_team_id',
      keyId: 'test_apple_key_id',
      privateKeyPath: 'test_path',
    );
  }

  /// For testing purposes - force real services regardless of environment
  static SpotifyServiceInterface createRealSpotifyService({
    required String clientId,
    required String clientSecret,
  }) {
    return SpotifyService(
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }

  /// For testing purposes - force real Apple Music service regardless of environment
  static AppleMusicServiceInterface createRealAppleMusicService({
    required String teamId,
    required String keyId,
    required String privateKeyPath,
  }) {
    return AppleMusicService(
      teamId: teamId,
      keyId: keyId,
      privateKeyPath: privateKeyPath,
    );
  }
}