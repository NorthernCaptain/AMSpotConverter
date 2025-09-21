import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';
import 'base_music_service.dart';

class SpotifyService implements BaseMusicService {
  static const String _baseUrl = 'https://api.spotify.com/v1';
  static const String _authUrl = 'https://accounts.spotify.com/api/token';

  final String clientId;
  final String clientSecret;
  String? _accessToken;
  DateTime? _tokenExpiry;

  SpotifyService({
    required this.clientId,
    required this.clientSecret,
  });

  Future<void> _authenticate() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return;
    }

    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse(_authUrl),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _accessToken = data['access_token'];
      final expiresIn = data['expires_in'] as int;
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));
    } else {
      throw Exception('Failed to authenticate with Spotify API');
    }
  }

  @override
  Future<Song?> getTrackById(String trackId) async {
    await _authenticate();

    final response = await http.get(
      Uri.parse('$_baseUrl/tracks/$trackId'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _createSongFromSpotifyTrack(data);
    }
    return null;
  }

  @override
  Future<Song?> getAlbumById(String albumId) async {
    await _authenticate();

    final response = await http.get(
      Uri.parse('$_baseUrl/albums/$albumId'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _createSongFromSpotifyAlbum(data);
    }
    return null;
  }

  @override
  Future<List<Song>> searchTracks(String query, {int limit = 10}) async {
    await _authenticate();

    final encodedQuery = Uri.encodeComponent(query);
    final response = await http.get(
      Uri.parse('$_baseUrl/search?q=$encodedQuery&type=track&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['tracks']['items'] as List;
      return tracks.map((track) => _createSongFromSpotifyTrack(track)).toList();
    }
    return [];
  }

  Song _createSongFromSpotifyTrack(Map<String, dynamic> track) {
    final artists = track['artists'] as List;
    final artistName = artists.isNotEmpty ? artists[0]['name'] : 'Unknown Artist';
    final images = track['album']['images'] as List;
    final imageUrl = images.isNotEmpty ? images[0]['url'] : null;

    return Song(
      id: track['id'],
      name: track['name'],
      artist: artistName,
      album: track['album']['name'],
      imageUrl: imageUrl,
      previewUrl: track['preview_url'],
      externalUrl: track['external_urls']['spotify'],
      platform: 'spotify',
    );
  }

  Song _createSongFromSpotifyAlbum(Map<String, dynamic> album) {
    final artists = album['artists'] as List;
    final artistName = artists.isNotEmpty ? artists[0]['name'] : 'Unknown Artist';
    final images = album['images'] as List;
    final imageUrl = images.isNotEmpty ? images[0]['url'] : null;

    return Song(
      id: album['id'],
      name: album['name'],
      artist: artistName,
      album: album['name'],
      imageUrl: imageUrl,
      previewUrl: null,
      externalUrl: album['external_urls']['spotify'],
      platform: 'spotify',
    );
  }

  @override
  String? extractTrackIdFromUrl(String url) {
    final RegExp trackRegex = RegExp(r'spotify\.com/track/([a-zA-Z0-9]+)');
    final match = trackRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  String? extractAlbumIdFromUrl(String url) {
    final RegExp albumRegex = RegExp(r'spotify\.com/album/([a-zA-Z0-9]+)');
    final match = albumRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  bool isValidUrl(String url) {
    return url.contains('spotify.com/') || url.contains('open.spotify.com/');
  }

  @override
  String get platformName => 'spotify';
}