import 'package:freezed_annotation/freezed_annotation.dart';

import '../../catalog/model/catalog_mapper.dart';
import '../../catalog/model/movie.dart';
import 'home_response_dto.dart';

part 'home_summary.freezed.dart';

@freezed
abstract class HomeSummary with _$HomeSummary {
  const factory HomeSummary({
    required int nowShowingCount,
    required int comingSoonCount,
    required int cinemaCount,

    /// Home's hero: the admin's featured movie, else the first hero movie.
    Movie? featured,
  }) = _HomeSummary;

  /// [baseUrl] makes the relative image paths absolute.
  factory HomeSummary.fromDto(HomeResponseDto dto, {String baseUrl = ''}) {
    final featured = dto.featuredMovie ?? (dto.heroMovies.isEmpty ? null : dto.heroMovies.first);
    return HomeSummary(
      nowShowingCount: dto.nowShowing.length,
      comingSoonCount: dto.comingSoon.length,
      cinemaCount: dto.cinemas.length,
      featured: featured == null ? null : CatalogMapper.movie(featured, baseUrl),
    );
  }
}
