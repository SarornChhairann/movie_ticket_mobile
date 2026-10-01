// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDto _$MovieDtoFromJson(Map<String, dynamic> json) => MovieDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  genre: json['genre'] as String?,
  director: json['director'] as String?,
  language: json['language'] as String?,
  format: json['format'] as String?,
  cast: json['cast'] as String?,
  trailerUrl: json['trailerUrl'] as String?,
  rating: json['rating'] as String?,
  releaseDate: json['releaseDate'] as String?,
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  status: json['status'] as String?,
  imagePath: json['imagePath'] as String?,
  bannerPath: json['bannerPath'] as String?,
);
