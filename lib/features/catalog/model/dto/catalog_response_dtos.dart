import 'package:json_annotation/json_annotation.dart';

import 'movie_dto.dart';

part 'catalog_response_dtos.g.dart';

/// `GET /movies` body; only `movies` is used.
@JsonSerializable(createToJson: false)
class MovieListResponseDto {
  const MovieListResponseDto({this.movies = const []});

  factory MovieListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseDtoFromJson(json);

  final List<MovieDto> movies;
}

/// `GET /movies/{id}` body.
@JsonSerializable(createToJson: false)
class MovieDetailResponseDto {
  const MovieDetailResponseDto({
    required this.movie,
    this.availableDates = const [],
    this.selectedDate,
    this.showtimesByDate = const {},
  });

  factory MovieDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailResponseDtoFromJson(json);

  final MovieDto movie;
  final List<String> availableDates;
  final String? selectedDate;
  final Map<String, List<ShowtimeSummaryDto>> showtimesByDate;
}

@JsonSerializable(createToJson: false)
class ShowtimeSummaryDto {
  const ShowtimeSummaryDto({
    required this.id,
    this.showTime,
    this.hallId,
    this.hallName,
    this.normalPrice,
    this.couplePrice,
    this.blocked = false,
    this.cinemaName,
    this.hasDolbyAtmos = false,
    this.hasScreenX = false,
  });

  factory ShowtimeSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$ShowtimeSummaryDtoFromJson(json);

  final int id;
  final String? showTime;
  final int? hallId;
  final String? hallName;
  final num? normalPrice;
  final num? couplePrice;
  final bool blocked;
  final String? cinemaName;
  final bool hasDolbyAtmos;
  final bool hasScreenX;
}
