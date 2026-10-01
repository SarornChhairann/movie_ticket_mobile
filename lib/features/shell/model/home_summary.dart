import 'package:freezed_annotation/freezed_annotation.dart';

import 'home_response_dto.dart';

part 'home_summary.freezed.dart';

@freezed
abstract class HomeSummary with _$HomeSummary {
  const factory HomeSummary({
    required int nowShowingCount,
    required int comingSoonCount,
    required int cinemaCount,
  }) = _HomeSummary;

  factory HomeSummary.fromDto(HomeResponseDto dto) => HomeSummary(
        nowShowingCount: dto.nowShowing.length,
        comingSoonCount: dto.comingSoon.length,
        cinemaCount: dto.cinemas.length,
      );
}
