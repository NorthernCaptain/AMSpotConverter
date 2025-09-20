# AMSpotConverter

A Flutter app for converting music links between Apple Music and Spotify platforms.

## Overview

AMSpotConverter allows users to seamlessly convert music links between Apple Music and Spotify on both platforms. The app automatically detects the source platform and converts to the opposite provider.

## Features

### Link Input Methods
- **Manual Entry**: Paste or type any music link (Spotify or Apple Music) in the input field
  - App automatically detects source platform and converts to opposite provider
  - Works on both Android and iOS
- **Deep Linking (Android)**: Click Apple Music links in other apps to auto-open converter
- **Share Extension (iOS)**: Share any music link (Spotify or Apple Music) via native iOS share sheet

### Supported Platforms
- Android and iOS only
- No sign-in required - instant access to main screen

### API Integration
- **Spotify API**:
  - Retrieve song/album metadata from Spotify link IDs
  - Search for Apple Music song/album analogs
- **Apple Music API**:
  - Retrieve song/album metadata from Apple Music link IDs
  - Search for Spotify song/album analogs

### Conversion Flow
1. Parse the input link to extract song/album ID
2. Use source platform API to retrieve original metadata (song name, artist, album)
3. Use target platform API to search for matching content
4. Display results with metadata from target platform

## UI Design

### Main Screen (Portrait Mode)
1. **Link Input Field** (top)
2. **Source Card** (below input)
   - Shows original link information
   - Displays: Provider, Song name, Album name, Artist, Album image
   - Tap to open original link in external browser
3. **Results List** (scrollable bottom section)
   - Up to 10 search result cards from opposite provider
   - Same card design as source card
   - Tap to open converted link in target app or browser
   - Input field and source card remain visible while scrolling

## API Requirements

### Spotify Web API (Free)
- **Spotify for Developers Account**: Register at [developer.spotify.com](https://developer.spotify.com)
- **Client ID & Client Secret**: Create an app to get credentials
- **No paid subscription required**: Free tier allows up to 100 API calls per minute
- **Required endpoints**:
  - Get Track/Album by ID
  - Search for tracks/albums

### Apple Music API (Free)
- **Apple Developer Account**: Already have (required for iOS development)
- **MusicKit Identifier**: Create in Apple Developer portal
- **Private Key**: Generate .p8 key file for JWT authentication
- **Team ID**: From Apple Developer account
- **Key ID**: From generated private key
- **No Apple Music subscription required**: API access is separate from subscription
- **Required endpoints**:
  - Get Song/Album by ID
  - Search catalog

### Rate Limits
- **Spotify**: 100 requests/minute (free tier)
- **Apple Music**: 1000 requests/minute per key

## Environment Setup

### Required Environment Variables
Set these environment variables before building the app:

```bash
# Spotify API credentials
export SPOTIFY_CLIENT_ID="your_spotify_client_id"
export SPOTIFY_CLIENT_SECRET="your_spotify_client_secret"

# Apple Music API credentials
export APPLE_MUSIC_TEAM_ID="your_apple_team_id"
export APPLE_MUSIC_KEY_ID="your_apple_music_key_id"
export APPLE_MUSIC_PRIVATE_KEY_PATH="path/to/your/AuthKey_KeyID.p8"
```

### Build Integration
- Environment variables are injected into the Flutter app during build time
- API keys are embedded securely in the compiled app
- No runtime configuration required

## Technical Requirements
- Flutter framework
- Android and iOS platform support
- Spotify Web API integration
- Apple Music API integration
- Deep linking support (Android)
- Share extension support (iOS)