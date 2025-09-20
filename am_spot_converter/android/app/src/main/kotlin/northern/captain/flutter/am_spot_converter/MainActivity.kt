package northern.captain.flutter.am_spot_converter

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "am_spot_converter/url_launcher"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        android.util.Log.d("AMSpotConverter", "Configuring Flutter engine and setting up method channel")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            android.util.Log.d("AMSpotConverter", "Received method call: ${call.method}")

            when (call.method) {
                "launchUrlWithChooser" -> {
                    val url = call.argument<String>("url")
                    val title = call.argument<String>("title") ?: "Open with"

                    android.util.Log.d("AMSpotConverter", "Launching URL with chooser: $url")

                    if (url != null) {
                        val success = launchUrlWithChooser(url, title)
                        android.util.Log.d("AMSpotConverter", "Launch result: $success")
                        result.success(success)
                    } else {
                        android.util.Log.e("AMSpotConverter", "URL is null")
                        result.error("INVALID_ARGUMENT", "URL is required", null)
                    }
                }
                else -> {
                    android.util.Log.d("AMSpotConverter", "Method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }

    private fun launchUrlWithChooser(url: String, title: String): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))

            // Create a chooser intent to let user pick which app to use
            val chooserIntent = Intent.createChooser(intent, title)

            // Make sure there's at least one app that can handle this intent
            if (intent.resolveActivity(packageManager) != null || chooserIntent.resolveActivity(packageManager) != null) {
                startActivity(chooserIntent)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            android.util.Log.e("URLLauncher", "Failed to launch URL: $url", e)
            false
        }
    }
}
