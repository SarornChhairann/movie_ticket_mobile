import 'package:json_annotation/json_annotation.dart';

part 'movie_dto.g.dart';

/// The `Movie` entity as the API serializes it.
@JsonSerializable(createToJson: false)
class MovieDto {
  const MovieDto({
    required this.id,
    required this.title,
    this.description,
    this.genre,
    this.director,
    this.language,
    this.format,
    this.cast,
    this.trailerUrl,
    this.rating,
    this.releaseDate,
    this.durationMinutes,
    this.status,
    this.imagePath,
    this.bannerPath,
  });

  factory MovieDto.fromJson(Map<String, dynamic> json) => _$MovieDtoFromJson(json);

  final int id;
  final String title;
  final String? description;
  final String? genre;
  final String? director;
  final String? language;
  final String? format;
  final String? cast;
  final String? trailerUrl;
  final String? rating;
  final String? releaseDate;
  final int? durationMinutes;
  final String? status;
  final String? imagePath;
  final String? bannerPath;
}
