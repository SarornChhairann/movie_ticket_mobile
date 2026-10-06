import 'package:json_annotation/json_annotation.dart';

part 'hall_dtos.g.dart';

/// One row of `GET /api/halls` (also `hall` in the schedule).
@JsonSerializable(createToJson: false)
class HallDto {
  const HallDto({
    required this.id,
    required this.name,
    this.type,
    this.city,
    this.address,
    this.totalSeats,
    this.hasDolbyAtmos = false,
    this.hasScreenX = false,
    this.amenities,
    this.cinemaId,
    this.cinemaName,
    this.openingHours,
  });

  factory HallDto.fromJson(Map<String, dynamic> json) => _$HallDtoFromJson(json);

  final int id;
  final String name;
  final String? type;
  final String? city;
  final String? address;
  final int? totalSeats;
  final bool hasDolbyAtmos;
  final bool hasScreenX;
  final String? amenities;
  final String? cinemaId;
  final String? cinemaName;
  final String? openingHours;
}

/// `GET /api/halls/{id}/showtimes`.
@JsonSerializable(createToJson: false)
class HallScheduleDto {
  const HallScheduleDto({
    required this.hall,
    this.availableDates = const [],
    this.selectedDate,
    this.showtimes = const [],
  });

  factory HallScheduleDto.fromJson(Map<String, dynamic> json) => _$HallScheduleDtoFromJson(json);

  final HallDto hall;
  final List<String> availableDates;
  final String? selectedDate;
  final List<HallShowtimeDto> showtimes;
}

@JsonSerializable(createToJson: false)
class HallShowtimeDto {
  const HallShowtimeDto({
    required this.id,
    required this.showDate,
    this.showTime,
    required this.movieId,
    required this.movieTitle,
    this.imagePath,
    this.normalPrice,
    this.couplePrice,
    this.blocked = false,
  });

  factory HallShowtimeDto.fromJson(Map<String, dynamic> json) => _$HallShowtimeDtoFromJson(json);

  final int id;
  final String showDate;
  final String? showTime;
  final int movieId;
  final String movieTitle;

  /// Relative upload path (`/uploads/movies/...`).
  final String? imagePath;
  final num? normalPrice;
  final num? couplePrice;

  /// Not sent today; a blocked row is dropped if a server ever includes one.
  final bool blocked;
}
