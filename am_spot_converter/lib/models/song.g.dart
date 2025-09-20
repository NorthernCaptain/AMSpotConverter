// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
  id: json['id'] as String,
  name: json['name'] as String,
  artist: json['artist'] as String,
  album: json['album'] as String,
  imageUrl: json['imageUrl'] as String?,
  previewUrl: json['previewUrl'] as String?,
  externalUrl: json['externalUrl'] as String,
  platform: json['platform'] as String,
);

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'artist': instance.artist,
  'album': instance.album,
  'imageUrl': instance.imageUrl,
  'previewUrl': instance.previewUrl,
  'externalUrl': instance.externalUrl,
  'platform': instance.platform,
};
