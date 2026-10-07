// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieBrowseDto _$MovieBrowseDtoFromJson(Map<String, dynamic> json) =>
    MovieBrowseDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      posterPath: json['posterPath'] as String?,
      bannerPath: json['bannerPath'] as String?,
      trailerUrl: json['trailerUrl'] as String?,
      rating: json['rating'] as String?,
      language: json['language'] as String?,
      format: json['format'] as String?,
      status: json['status'] as String?,
      releaseDate: json['releaseDate'] as String?,
      genre: json['genre'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      showtimes:
          (json['showtimes'] as List<dynamic>?)
              ?.map((e) => ShowtimeChipDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

ShowtimeChipDto _$ShowtimeChipDtoFromJson(Map<String, dynamic> json) =>
    ShowtimeChipDto(
      showtimeId: (json['showtimeId'] as num).toInt(),
      time: json['time'] as String?,
      showDate: json['showDate'] as String?,
      hallName: json['hallName'] as String?,
      cinemaName: json['cinemaName'] as String?,
      hasDolbyAtmos: json['hasDolbyAtmos'] as bool? ?? false,
      hasScreenX: json['hasScreenX'] as bool? ?? false,
    );
