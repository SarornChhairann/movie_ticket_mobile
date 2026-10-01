// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_response_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieListResponseDto _$MovieListResponseDtoFromJson(
  Map<String, dynamic> json,
) => MovieListResponseDto(
  movies:
      (json['movies'] as List<dynamic>?)
          ?.map((e) => MovieDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

MovieDetailResponseDto _$MovieDetailResponseDtoFromJson(
  Map<String, dynamic> json,
) => MovieDetailResponseDto(
  movie: MovieDto.fromJson(json['movie'] as Map<String, dynamic>),
  availableDates:
      (json['availableDates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  selectedDate: json['selectedDate'] as String?,
  showtimesByDate:
      (json['showtimesByDate'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map(
                (e) => ShowtimeSummaryDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      ) ??
      const {},
);

ShowtimeSummaryDto _$ShowtimeSummaryDtoFromJson(Map<String, dynamic> json) =>
    ShowtimeSummaryDto(
      id: (json['id'] as num).toInt(),
      showTime: json['showTime'] as String?,
      hallId: (json['hallId'] as num?)?.toInt(),
      hallName: json['hallName'] as String?,
      normalPrice: json['normalPrice'] as num?,
      couplePrice: json['couplePrice'] as num?,
      blocked: json['blocked'] as bool? ?? false,
      cinemaName: json['cinemaName'] as String?,
      hasDolbyAtmos: json['hasDolbyAtmos'] as bool? ?? false,
      hasScreenX: json['hasScreenX'] as bool? ?? false,
    );
