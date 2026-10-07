import 'package:json_annotation/json_annotation.dart';

import '../../catalog/model/dto/movie_dto.dart';

part 'home_response_dto.g.dart';

/// `GET /` body. The list sizes prove the API is up; `featuredMovie` and
/// `heroMovies` feed Home's featured hero (sprint 20).
@JsonSerializable(createToJson: false)
class HomeResponseDto {
  const HomeResponseDto({
    this.nowShowing = const [],
    this.comingSoon = const [],
    this.cinemas = const [],
    this.heroMovies = const [],
    this.featuredMovie,
  });

  factory HomeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseDtoFromJson(json);

  final List<Object?> nowShowing;
  final List<Object?> comingSoon;
  final List<Object?> cinemas;
  final List<MovieDto> heroMovies;
  final MovieDto? featuredMovie;
}
