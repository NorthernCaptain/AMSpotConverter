# Platform Channel Troubleshooting

## MissingPluginException Error

If you see this error:
```
MissingPluginException(No implementation found for method launchUrlWithChooser on channel am_spot_converter/url_launcher)
```

### Solution 1: Hot Restart (Most Common Fix)

**Platform channels require a full app restart, not just hot reload:**

1. **Stop the app completely** (Ctrl+C in terminal or stop in IDE)
2. **Run again**: `flutter run`
3. **Or use hot restart**: Press `R` (capital R) in the Flutter console

### Solution 2: Clean Build

If hot restart doesn't work:

```bash
flutter clean
flutter pub get
flutter run
```

### Solution 3: Check Android Logs

Look for these log messages to verify the channel is registered:

```
D/AMSpotConverter: Configuring Flutter engine and setting up method channel
D/AMSpotConverter: Received method call: launchUrlWithChooser
D/AMSpotConverter: Launching URL with chooser: [URL]
```

### Solution 4: Verify File Changes

Make sure these files were updated correctly:

1. **Android**: `android/app/src/main/kotlin/.../MainActivity.kt`
2. **iOS**: `ios/Runner/AppDelegate.swift`
3. **Flutter**: `lib/services/native_url_launcher.dart`

### Fallback Behavior

The app is designed to fall back to Flutter's `url_launcher` if the native implementation fails, so URL launching should still work even if the platform channel isn't working.

## Testing the Fix

1. **Stop the app**
2. **Run**: `flutter run`
3. **Test URL launching** by tapping song cards
4. **Check logs** for debug messages

### Expected Behavior After Fix

- **Android**: Should show native "Open with" dialog
- **Logs**: Should show native launcher debug messages
- **No more**: MissingPluginException errors