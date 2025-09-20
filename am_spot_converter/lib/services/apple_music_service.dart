import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../models/song.dart';
import 'base_music_service.dart';

class AppleMusicService implements AppleMusicServiceInterface {
  static const String _baseUrl = 'https://api.music.apple.com/v1';

  final String teamId;
  final String keyId;
  final String privateKeyPath;
  String? _token;
  DateTime? _tokenExpiry;

  AppleMusicService({
    required this.teamId,
    required this.keyId,
    required this.privateKeyPath,
  });

  Future<void> _generateToken() async {
    if (_token != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      print('🔍 Using existing token (expires: $_tokenExpiry)');
      return;
    }

    try {
      print('🔍 Generating new Apple Music JWT token...');
      print('🔍 Team ID: $teamId');
      print('🔍 Key ID: $keyId');
      print('🔍 Private Key Path: $privateKeyPath');

      // Read private key as an asset
      final privateKeyContent = await rootBundle.loadString(privateKeyPath);
      print('🔍 Private key loaded successfully (${privateKeyContent.length} characters)');

      final now = DateTime.now();
      final iat = now.millisecondsSinceEpoch ~/ 1000;
      final exp = now.add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;

      final payload = {
        'iss': teamId,
        'iat': iat,
        'exp': exp,
      };

      print('🔍 JWT Payload: $payload');

      final jwt = JWT(
        payload,
        header: {
          'kid': keyId,  // Add the Key ID to the header
        },
      );

      _token = jwt.sign(
        ECPrivateKey(privateKeyContent),
        algorithm: JWTAlgorithm.ES256,
      );

      print('🔍 JWT Token generated successfully');
      print('🔍 Token length: ${_token!.length}');
      print('🔍 Token preview: ${_token!.substring(0, 50)}...');

      _tokenExpiry = DateTime.now().add(Duration(minutes: 50));
    } catch (e, stackTrace) {
      print('❌ Failed to generate Apple Music token: $e');
      print('❌ Stack trace: $stackTrace');
      throw Exception('Failed to generate Apple Music token: $e');
    }
  }

  @override
  Future<Song?> getTrackById(String trackId) async {
    return await getSongById(trackId);
  }

  @override
  Future<Song?> getSongById(String songId) async {
    await _generateToken();

    final url = '$_baseUrl/catalog/us/songs/$songId';
    print('🔍 Apple Music API Request: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    print('🔍 API Response Status: ${response.statusCode}');
    print('🔍 API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final songs = data['data'] as List;
      if (songs.isNotEmpty) {
        return _createSongFromAppleMusicTrack(songs[0]);
      } else {
        print('❌ No songs found in API response');
      }
    } else {
      print('❌ API request failed with status ${response.statusCode}: ${response.body}');
    }
    return null;
  }

  @override
  Future<Song?> getAlbumById(String albumId) async {
    await _generateToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/catalog/us/albums/$albumId'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final albums = data['data'] as List;
      if (albums.isNotEmpty) {
        return _createSongFromAppleMusicAlbum(albums[0]);
      }
    }
    return null;
  }

  @override
  Future<List<Song>> searchTracks(String query, {int limit = 10}) async {
    await _generateToken();

    final encodedQuery = Uri.encodeComponent(query);
    final response = await http.get(
      Uri.parse('$_baseUrl/catalog/us/search?term=$encodedQuery&types=songs&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      if (results != null && results['songs'] != null) {
        final songs = results['songs']['data'] as List;
        return songs.map((song) => _createSongFromAppleMusicTrack(song)).toList();
      }
    }
    return [];
  }

  Song _createSongFromAppleMusicTrack(Map<String, dynamic> track) {
    final attributes = track['attributes'];
    final artwork = attributes['artwork'];
    String? imageUrl;
    if (artwork != null && artwork['url'] != null) {
      imageUrl = artwork['url']
          .toString()
          .replaceAll('{w}', '640')
          .replaceAll('{h}', '640');
    }

    return Song(
      id: track['id'],
      name: attributes['name'],
      artist: attributes['artistName'],
      album: attributes['albumName'],
      imageUrl: imageUrl,
      previewUrl: attributes['previews']?.isNotEmpty == true
          ? attributes['previews'][0]['url']
          : null,
      externalUrl: attributes['url'] ?? 'https://music.apple.com/song/${track['id']}',
      platform: 'apple_music',
    );
  }

  Song _createSongFromAppleMusicAlbum(Map<String, dynamic> album) {
    final attributes = album['attributes'];
    final artwork = attributes['artwork'];
    String? imageUrl;
    if (artwork != null && artwork['url'] != null) {
      imageUrl = artwork['url']
          .toString()
          .replaceAll('{w}', '640')
          .replaceAll('{h}', '640');
    }

    return Song(
      id: album['id'],
      name: attributes['name'],
      artist: attributes['artistName'],
      album: attributes['name'],
      imageUrl: imageUrl,
      previewUrl: null,
      externalUrl: attributes['url'] ?? 'https://music.apple.com/album/${album['id']}',
      platform: 'apple_music',
    );
  }

  @override
  String? extractTrackIdFromUrl(String url) {
    return extractSongIdFromUrl(url);
  }

  @override
  String? extractSongIdFromUrl(String url) {
    // Handle direct song URLs: music.apple.com/us/song/song-name/123456
    final RegExp songRegex = RegExp(r'music\.apple\.com/[^/]+/song/[^/]+/(\d+)');
    final songMatch = songRegex.firstMatch(url);
    if (songMatch != null) {
      return songMatch.group(1);
    }

    // Handle album URLs with track parameter: music.apple.com/us/album/album-name/123?i=456
    final RegExp albumTrackRegex = RegExp(r'music\.apple\.com/[^/]+/album/[^/]+/\d+\?i=(\d+)');
    final albumTrackMatch = albumTrackRegex.firstMatch(url);
    if (albumTrackMatch != null) {
      return albumTrackMatch.group(1);
    }

    return null;
  }

  @override
  String? extractAlbumIdFromUrl(String url) {
    final RegExp albumRegex = RegExp(r'music\.apple\.com/[^/]+/album/[^/]+/(\d+)');
    final match = albumRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  bool isValidUrl(String url) {
    return url.contains('music.apple.com/');
  }

  @override
  String get platformName => 'apple_music';
}