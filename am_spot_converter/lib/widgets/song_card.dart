import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/song.dart';
import '../services/native_url_launcher.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final bool isOriginal;

  const SongCard({
    super.key,
    required this.song,
    this.isOriginal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isOriginal ? 4 : 2,
      child: InkWell(
        onTap: () => _launchUrl(context, song.externalUrl),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: song.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: song.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.music_note, color: Colors.grey),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.music_note, color: Colors.grey),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.music_note, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isOriginal ? FontWeight.bold : FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.album,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Icon(
                    song.platform == 'spotify' ? Icons.music_note : Icons.music_video,
                    color: song.platform == 'spotify' ? Colors.green : Colors.red,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.platform == 'spotify' ? 'Spotify' : 'Apple Music',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: song.platform == 'spotify' ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      debugPrint('Attempting to launch URL: $url');

      // First, try our native URL launcher with intent chooser
      bool launched = await NativeUrlLauncher.launchUrlWithChooser(
        url,
        title: 'Open ${song.name}',
      );

      debugPrint('Native launcher result: $launched');

      // If native launcher failed, fallback to Flutter's url_launcher
      if (!launched) {
        debugPrint('Native launcher failed, trying Flutter url_launcher');

        final uri = Uri.parse(url);

        // Try different launch modes as fallback
        try {
          launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          debugPrint('Flutter url_launcher result: $launched');
        } catch (e) {
          debugPrint('Flutter url_launcher failed: $e');

          // Last resort: try platform default
          try {
            launched = await launchUrl(
              uri,
              mode: LaunchMode.platformDefault,
            );
            debugPrint('Platform default result: $launched');
          } catch (e2) {
            debugPrint('Platform default failed: $e2');
          }
        }
      }

      if (!launched) {
        _showErrorSnackBar(scaffoldMessenger, 'Could not open this link');
      }
    } catch (e) {
      debugPrint('Launch URL failed with error: $e');
      _showErrorSnackBar(scaffoldMessenger, 'Failed to open link');
    }
  }

  void _showErrorSnackBar(ScaffoldMessengerState scaffoldMessenger, String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}