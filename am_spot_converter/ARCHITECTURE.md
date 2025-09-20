# AMSpotConverter Architecture

This document describes the refactored architecture using interfaces and factory patterns for better maintainability and testability.

## 🏗️ Architecture Overview

### Interface-Based Design
All music services now implement common interfaces, enabling:
- **Polymorphism**: Treat all services uniformly
- **Testability**: Easy switching between mock and real services
- **Maintainability**: Add new music platforms without changing existing code
- **Flexibility**: Runtime service selection via environment variables

### Factory Pattern
The `MusicServiceFactory` centralizes service creation logic:
- **Environment-driven**: Uses `USE_MOCK_SERVICES` env variable
- **Type Safety**: Returns concrete interface types
- **Testing Support**: Dedicated methods for forced mock/real services

## 📁 File Structure

```
lib/services/
├── base_music_service.dart          # Abstract interfaces
├── music_service_factory.dart       # Service factory
├── conversion_service.dart          # Platform conversion logic
├── spotify_service.dart             # Real Spotify API implementation
├── apple_music_service.dart         # Real Apple Music API implementation
├── mock_spotify_service.dart        # Mock Spotify implementation
└── mock_apple_music_service.dart    # Mock Apple Music implementation
```

## 🔌 Interface Hierarchy

```dart
abstract class BaseMusicService {
  String? extractTrackIdFromUrl(String url);
  String? extractAlbumIdFromUrl(String url);
  bool isValidUrl(String url);
  Future<Song?> getTrackById(String trackId);
  Future<Song?> getAlbumById(String albumId);
  Future<List<Song>> searchTracks(String query, {int limit = 10});
  String get platformName;
}

abstract class SpotifyServiceInterface extends BaseMusicService {
  String get platformName => 'spotify';
}

abstract class AppleMusicServiceInterface extends BaseMusicService {
  String get platformName => 'apple_music';
  // Apple Music specific methods
  Future<Song?> getSongById(String songId);
  String? extractSongIdFromUrl(String url);
}
```

## 🏭 Factory Implementation

### Environment-Based Service Creation

```dart
class MusicServiceFactory {
  static SpotifyServiceInterface createSpotifyService() {
    if (_useMockServices) {
      return MockSpotifyService(/* mock params */);
    } else {
      return SpotifyService(/* real API params */);
    }
  }

  static AppleMusicServiceInterface createAppleMusicService() {
    if (_useMockServices) {
      return MockAppleMusicService(/* mock params */);
    } else {
      return AppleMusicService(/* real API params */);
    }
  }
}
```

### Environment Variable Control

Set `USE_MOCK_SERVICES=1` in `.env` to use mock services:

```bash
# For UI testing with mock data
USE_MOCK_SERVICES=1

# For production with real APIs
USE_MOCK_SERVICES=0
```

## 🔄 Service Implementation Pattern

### Real Services
```dart
class SpotifyService implements SpotifyServiceInterface {
  @override
  Future<Song?> getTrackById(String trackId) async {
    // Real Spotify API calls
    await _authenticate();
    final response = await http.get(/* API endpoint */);
    return _parseSpotifyResponse(response);
  }
}
```

### Mock Services
```dart
class MockSpotifyService implements SpotifyServiceInterface {
  @override
  Future<Song?> getTrackById(String trackId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    // Return predefined mock data
    return Song(/* mock data */);
  }
}
```

## 📝 Usage Examples

### Main App (Automatic Service Selection)
```dart
void main() {
  // Factory automatically chooses based on USE_MOCK_SERVICES
  final spotifyService = MusicServiceFactory.createSpotifyService();
  final appleMusicService = MusicServiceFactory.createAppleMusicService();

  final conversionService = ConversionService(
    spotifyService: spotifyService,
    appleMusicService: appleMusicService,
  );
}
```

### Testing (Forced Mock Services)
```dart
testWidgets('Test with mocks', (tester) async {
  // Force mock services regardless of environment
  final spotifyService = MusicServiceFactory.createMockSpotifyService();
  final appleMusicService = MusicServiceFactory.createMockAppleMusicService();

  final conversionService = ConversionService(
    spotifyService: spotifyService,
    appleMusicService: appleMusicService,
  );
});
```

### Production (Forced Real Services)
```dart
final spotifyService = MusicServiceFactory.createRealSpotifyService(
  clientId: 'real_client_id',
  clientSecret: 'real_client_secret',
);
```

## 🔧 Switching Between Mock and Real Services

### For Development/UI Testing
1. Set `USE_MOCK_SERVICES=1` in `.env`
2. Run `flutter run`
3. Use sample URLs from `UI_TESTING_GUIDE.md`

### For Production
1. Set `USE_MOCK_SERVICES=0` in `.env`
2. Add real API credentials to `.env`:
   ```bash
   SPOTIFY_CLIENT_ID=your_real_client_id
   SPOTIFY_CLIENT_SECRET=your_real_client_secret
   APPLE_MUSIC_TEAM_ID=your_real_team_id
   APPLE_MUSIC_KEY_ID=your_real_key_id
   APPLE_MUSIC_PRIVATE_KEY_PATH=path/to/real/key.p8
   ```
3. Run `flutter run`

## ✅ Benefits of This Architecture

### 1. **Separation of Concerns**
- Interface defines contract
- Implementation handles specifics
- Factory manages creation logic

### 2. **Testability**
- Easy to inject mock services
- No network calls in tests
- Predictable mock data

### 3. **Maintainability**
- Add new platforms by implementing interfaces
- Change implementations without affecting consumers
- Centralized service creation logic

### 4. **Flexibility**
- Runtime service selection
- Environment-specific configurations
- Easy debugging and development

### 5. **Type Safety**
- Compile-time interface checking
- IDE autocomplete and refactoring support
- Reduced runtime errors

## 🚀 Adding New Music Platforms

To add a new platform (e.g., YouTube Music):

1. **Create Interface**:
   ```dart
   abstract class YouTubeMusicServiceInterface extends BaseMusicService {
     String get platformName => 'youtube_music';
   }
   ```

2. **Implement Real Service**:
   ```dart
   class YouTubeMusicService implements YouTubeMusicServiceInterface {
     // Implement all interface methods
   }
   ```

3. **Implement Mock Service**:
   ```dart
   class MockYouTubeMusicService implements YouTubeMusicServiceInterface {
     // Implement with mock data
   }
   ```

4. **Update Factory**:
   ```dart
   static YouTubeMusicServiceInterface createYouTubeMusicService() {
     return _useMockServices ? MockYouTubeMusicService() : YouTubeMusicService();
   }
   ```

5. **Update ConversionService** to handle the new platform.

The existing UI and core logic remain unchanged!

## 🧪 Testing Strategy

- **Unit Tests**: Test individual service implementations
- **Integration Tests**: Test factory service creation
- **Widget Tests**: Test UI with mock services
- **E2E Tests**: Test with real services (CI environment)

This architecture makes the codebase scalable, maintainable, and testable while providing a smooth development experience.