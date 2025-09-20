import 'song.dart';

class ConversionResult {
  final Song? originalSong;
  final List<Song> searchResults;
  final bool isLoading;
  final String? error;

  ConversionResult({
    this.originalSong,
    this.searchResults = const [],
    this.isLoading = false,
    this.error,
  });

  ConversionResult copyWith({
    Song? originalSong,
    List<Song>? searchResults,
    bool? isLoading,
    String? error,
  }) {
    return ConversionResult(
      originalSong: originalSong ?? this.originalSong,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}