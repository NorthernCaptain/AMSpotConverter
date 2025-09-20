import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_links/app_links.dart';

import 'providers/conversion_provider.dart';
import 'services/music_service_factory.dart';
import 'services/conversion_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _initialUrl;
  StreamSubscription<Uri>? _linkSubscription;
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initAppLinks();
  }

  Future<void> _initAppLinks() async {
    _appLinks = AppLinks();

    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        setState(() {
          _initialUrl = initialLink.toString();
        });
      }

      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(initialUrl: uri.toString()),
              ),
            );
          }
        },
        onError: (err) {
          if (mounted) {
            debugPrint('Deep link error: $err');
          }
        },
      );
    } catch (e) {
      debugPrint('App links initialization error: $e');
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use factory to create services based on environment
    final spotifyService = MusicServiceFactory.createSpotifyService();
    final appleMusicService = MusicServiceFactory.createAppleMusicService();

    final conversionService = ConversionService(
      spotifyService: spotifyService,
      appleMusicService: appleMusicService,
    );

    return ChangeNotifierProvider(
      create: (context) => ConversionProvider(conversionService),
      child: MaterialApp(
        title: 'Apple Music <> Spotify links',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: HomeScreen(initialUrl: _initialUrl),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
