// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponseDto _$HomeResponseDtoFromJson(Map<String, dynamic> json) =>
    HomeResponseDto(
      nowShowing: json['nowShowing'] as List<dynamic>? ?? const [],
      comingSoon: json['comingSoon'] as List<dynamic>? ?? const [],
      cinemas: json['cinemas'] as List<dynamic>? ?? const [],
      heroMovies:
          (json['heroMovies'] as List<dynamic>?)
              ?.map((e) => MovieDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      featuredMovie: json['featuredMovie'] == null
          ? null
          : MovieDto.fromJson(json['featuredMovie'] as Map<String, dynamic>),
    );
