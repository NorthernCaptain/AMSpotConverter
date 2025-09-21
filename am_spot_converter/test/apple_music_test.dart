import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../lib/services/apple_music_service.dart';

void main() {
  group('Apple Music API Tests', () {
    late AppleMusicService service;

    setUpAll(() async {
      // Load environment variables
      await dotenv.load(fileName: '.env');

      service = AppleMusicService(
        teamId: dotenv.env['APPLE_MUSIC_TEAM_ID'] ?? '',
        keyId: dotenv.env['APPLE_MUSIC_KEY_ID'] ?? '',
        privateKeyPath: dotenv.env['APPLE_MUSIC_PRIVATE_KEY_PATH'] ?? '',
      );
    });

    test('Test URL parsing for album with track parameter', () {
      const testUrl = 'https://music.apple.com/us/album/run-run-run/1837020954?i=1837021188';
      final trackId = service.extractTrackIdFromUrl(testUrl);

      print('URL: $testUrl');
      print('Extracted Track ID: $trackId');

      expect(trackId, equals('1837021188'));
    });

    test('Test Apple Music API authentication and track fetch', () async {
      // Test with the track ID from your URL: https://music.apple.com/us/album/run-run-run/1837020954?i=1837021188
      const testTrackId = '1837021188';

      print('Testing Apple Music API with track ID: $testTrackId');
      print('Team ID: ${dotenv.env['APPLE_MUSIC_TEAM_ID']}');
      print('Key ID: ${dotenv.env['APPLE_MUSIC_KEY_ID']}');
      print('Private Key Path: ${dotenv.env['APPLE_MUSIC_PRIVATE_KEY_PATH']}');

      try {
        final song = await service.getTrackById(testTrackId);

        if (song != null) {
          print('✅ SUCCESS: Retrieved song information');
          print('Song: ${song.name}');
          print('Artist: ${song.artist}');
          print('Album: ${song.album}');
          print('Platform: ${song.platform}');
          print('External URL: ${song.externalUrl}');
        } else {
          print('❌ FAILED: getSongById returned null');
        }

        expect(song, isNotNull);
        expect(song!.name, isNotEmpty);
        expect(song.artist, isNotEmpty);

      } catch (e, stackTrace) {
        print('❌ ERROR: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });

    test('Test token generation details', () async {
      try {
        // Access private method through reflection would be complex,
        // so let's test by making a request that requires a token
        final song = await service.getTrackById('1677770551');
        print('✅ Token generation appears to work (request succeeded)');
      } catch (e) {
        print('❌ Token generation or API request failed: $e');

        // Check if it's a specific type of error
        if (e.toString().contains('401')) {
          print('🔍 This looks like an authentication error - check your Apple Music credentials');
        } else if (e.toString().contains('403')) {
          print('🔍 This looks like a permission error - check your MusicKit configuration');
        } else if (e.toString().contains('private key')) {
          print('🔍 This looks like a private key file issue');
        }

        rethrow;
      }
    });
  });
}