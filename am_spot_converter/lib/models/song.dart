import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@JsonSerializable()
class Song {
  final String id;
  final String name;
  final String artist;
  final String album;
  final String? imageUrl;
  final String? previewUrl;
  final String externalUrl;
  final String platform; // 'spotify' or 'apple_music'

  Song({
    required this.id,
    required this.name,
    required this.artist,
    required this.album,
    this.imageUrl,
    this.previewUrl,
    required this.externalUrl,
    required this.platform,
  });

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
  Map<String, dynamic> toJson() => _$SongToJson(this);

  Song copyWith({
    String? id,
    String? name,
    String? artist,
    String? album,
    String? imageUrl,
    String? previewUrl,
    String? externalUrl,
    String? platform,
  }) {
    return Song(
      id: id ?? this.id,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      imageUrl: imageUrl ?? this.imageUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      externalUrl: externalUrl ?? this.externalUrl,
      platform: platform ?? this.platform,
    );
  }
}