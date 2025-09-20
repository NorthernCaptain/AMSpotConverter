# UI Testing Guide with Mock Services

The app is now configured to use mock services instead of real API calls, allowing you to test the UI without needing API keys.

## ✅ What's Ready for Testing

### Mock Services
- **MockSpotifyService**: Returns sample Spotify track data
- **MockAppleMusicService**: Returns sample Apple Music track data
- **MockConversionService**: Handles URL parsing and platform switching

### Sample Data Available
- Realistic song metadata (title, artist, album, images)
- Multiple search results (5-7 results per conversion)
- Loading states with simulated network delays
- Error handling for invalid URLs

## 🧪 How to Test the UI

### 1. Run the App
```bash
flutter run
```

### 2. Test Sample URLs

Copy and paste these URLs into the app to test different scenarios:

**Spotify URLs:**
- `https://open.spotify.com/track/4iV5W9uYEdYUVa79Axb7Rh` (Flowers - Miley Cyrus)
- `https://open.spotify.com/track/1BxfuPKGuaTgP7aM0Bbdwr` (Cruel Summer - Taylor Swift)
- `https://open.spotify.com/album/2plbrEY59IikOBgBGLjaoe` (Sample Album)

**Apple Music URLs:**
- `https://music.apple.com/us/song/flowers/1677770551` (Flowers - Miley Cyrus)
- `https://music.apple.com/us/song/cruel-summer/1440929778` (Cruel Summer - Taylor Swift)
- `https://music.apple.com/us/album/endless-summer-vacation/1677770547` (Sample Album)

**Error Testing:**
- `https://example.com/not-a-music-link` (Invalid URL)
- `https://youtube.com/watch?v=123` (Unsupported platform)

### 3. UI Features to Test

**Input Field:**
- ✅ Paste button functionality
- ✅ Clear button when text is entered
- ✅ Search button activation
- ✅ Enter key submission

**Loading States:**
- ✅ Loading spinner during conversion
- ✅ "Converting your link..." message

**Results Display:**
- ✅ Original song card (highlighted)
- ✅ Search results list (scrollable)
- ✅ Platform icons (Spotify green, Apple Music red)
- ✅ Song artwork, titles, artists, albums
- ✅ **Tap to open external links:**
  - **Android**: Shows app selection dialog (Spotify, Apple Music, browser)
  - **iOS**: Opens in native apps or browser
  - **Visual cue**: Small "open in new" icon on each card
  - **Error handling**: Shows error messages if no apps can handle the link

**Error Handling:**
- ✅ Error messages for invalid URLs
- ✅ "No matches found" when appropriate
- ✅ Network error simulation

**Deep Linking (Android):**
- ✅ Click Apple Music links in other apps
- ✅ Auto-populate and convert

## 🎨 UI Components Being Tested

- **SongCard**: Displays song info with artwork and metadata
- **HomeScreen**: Main conversion interface
- **ConversionProvider**: State management and loading states
- **Input handling**: Paste, clear, search functionality
- **Responsive design**: Portrait mode layout
- **Material Design 3**: Modern styling and animations

## 🔄 Switching to Real Services

When ready to use real APIs, update `lib/main.dart`:

```dart
// Replace mock services with real ones
import 'services/spotify_service.dart';
import 'services/apple_music_service.dart';
import 'services/conversion_service.dart';

// Update service initialization
final spotifyService = SpotifyService(
  clientId: dotenv.env['SPOTIFY_CLIENT_ID'] ?? '',
  clientSecret: dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '',
);
```

The mock services have identical interfaces to the real services, so the UI code requires no changes.

## 📱 What You'll See

1. **Welcome Screen**: Clean interface with input field
2. **Loading**: Smooth loading animation during conversion
3. **Results**: Original song at top, search results below
4. **Platform Visual Cues**: Clear Spotify/Apple Music branding
5. **Error States**: Helpful error messages
6. **Interactive Elements**: Tap cards to open in external apps

All mock data includes realistic song titles, artists, and album artwork URLs for a complete UI testing experience!