import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeUrlLauncher {
  static const MethodChannel _channel = MethodChannel('am_spot_converter/url_launcher');

  /// Launch URL using native Android intent chooser or iOS share sheet
  static Future<bool> launchUrlWithChooser(String url, {String? title}) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _launchWithAndroidChooser(url, title);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _launchWithIOSShare(url, title);
    } else {
      // Fallback for other platforms
      debugPrint('Platform not supported for native URL launcher');
      return false;
    }
  }

  static Future<bool> _launchWithAndroidChooser(String url, String? title) async {
    try {
      debugPrint('Calling Android method channel: launchUrlWithChooser');
      final bool result = await _channel.invokeMethod('launchUrlWithChooser', {
        'url': url,
        'title': title ?? 'Open with',
      });
      debugPrint('Android method channel result: $result');
      return result;
    } on PlatformException catch (e) {
      debugPrint('PlatformException in Android chooser: ${e.code} - ${e.message}');
      return false;
    } on MissingPluginException catch (e) {
      debugPrint('MissingPluginException: ${e.message}');
      debugPrint('This usually means you need to do a hot restart (not hot reload)');
      return false;
    } catch (e) {
      debugPrint('Unexpected error in Android chooser: $e');
      return false;
    }
  }

  static Future<bool> _launchWithIOSShare(String url, String? title) async {
    try {
      final bool result = await _channel.invokeMethod('shareUrl', {
        'url': url,
        'title': title ?? 'Open with',
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint('Failed to share URL: ${e.message}');
      return false;
    }
  }
}