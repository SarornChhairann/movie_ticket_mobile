import 'package:json_annotation/json_annotation.dart';

part 'browse_dtos.g.dart';

/// One movie of `GET /api/movies?type=now_showing&date=` with its showtimes that
/// day (G34: started ones are already dropped, at most four).
@JsonSerializable(createToJson: false)
class MovieBrowseDto {
  const MovieBrowseDto({
    required this.id,
    required this.title,
    this.posterPath,
    this.bannerPath,
    this.trailerUrl,
    this.rating,
    this.language,
    this.format,
    this.status,
    this.releaseDate,
    this.genre,
    this.durationMinutes,
    this.showtimes = const [],
  });

  factory MovieBrowseDto.fromJson(Map<String, dynamic> json) => _$MovieBrowseDtoFromJson(json);

  final int id;
  final String title;
  final String? posterPath;
  final String? bannerPath;
  final String? trailerUrl;
  final String? rating;
  final String? language;
  final String? format;
  final String? status;
  final String? releaseDate;
  final String? genre;
  final int? durationMinutes;
  final List<ShowtimeChipDto> showtimes;
}

@JsonSerializable(createToJson: false)
class ShowtimeChipDto {
  const ShowtimeChipDto({
    required this.showtimeId,
    this.time,
    this.showDate,
    this.hallName,
    this.cinemaName,
    this.hasDolbyAtmos = false,
    this.hasScreenX = false,
  });

  factory ShowtimeChipDto.fromJson(Map<String, dynamic> json) => _$ShowtimeChipDtoFromJson(json);

  final int showtimeId;
  final String? time;
  final String? showDate;
  final String? hallName;
  final String? cinemaName;
  final bool hasDolbyAtmos;
  final bool hasScreenX;
}
