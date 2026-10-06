// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HallDto _$HallDtoFromJson(Map<String, dynamic> json) => HallDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String?,
  city: json['city'] as String?,
  address: json['address'] as String?,
  totalSeats: (json['totalSeats'] as num?)?.toInt(),
  hasDolbyAtmos: json['hasDolbyAtmos'] as bool? ?? false,
  hasScreenX: json['hasScreenX'] as bool? ?? false,
  amenities: json['amenities'] as String?,
  cinemaId: json['cinemaId'] as String?,
  cinemaName: json['cinemaName'] as String?,
  openingHours: json['openingHours'] as String?,
);

HallScheduleDto _$HallScheduleDtoFromJson(Map<String, dynamic> json) =>
    HallScheduleDto(
      hall: HallDto.fromJson(json['hall'] as Map<String, dynamic>),
      availableDates:
          (json['availableDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      selectedDate: json['selectedDate'] as String?,
      showtimes:
          (json['showtimes'] as List<dynamic>?)
              ?.map((e) => HallShowtimeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

HallShowtimeDto _$HallShowtimeDtoFromJson(Map<String, dynamic> json) =>
    HallShowtimeDto(
      id: (json['id'] as num).toInt(),
      showDate: json['showDate'] as String,
      showTime: json['showTime'] as String?,
      movieId: (json['movieId'] as num).toInt(),
      movieTitle: json['movieTitle'] as String,
      imagePath: json['imagePath'] as String?,
      normalPrice: json['normalPrice'] as num?,
      couplePrice: json['couplePrice'] as num?,
      blocked: json['blocked'] as bool? ?? false,
    );
