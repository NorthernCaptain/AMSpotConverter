// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:am_spot_converter/providers/conversion_provider.dart';
import 'package:am_spot_converter/services/music_service_factory.dart';
import 'package:am_spot_converter/services/conversion_service.dart';
import 'package:am_spot_converter/screens/home_screen.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Create mock services for testing using factory
    final spotifyService = MusicServiceFactory.createMockSpotifyService();
    final appleMusicService = MusicServiceFactory.createMockAppleMusicService();

    final conversionService = ConversionService(
      spotifyService: spotifyService,
      appleMusicService: appleMusicService,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => ConversionProvider(conversionService),
          child: const HomeScreen(),
        ),
      ),
    );

    // Verify that the welcome message is displayed.
    expect(find.text('Welcome to AMSpotConverter!'), findsOneWidget);

    // Verify that the input field hint is displayed.
    expect(find.text('Paste Spotify or Apple Music link here...'), findsOneWidget);
  });
}
