import 'package:json_annotation/json_annotation.dart';

part 'seat_dtos.g.dart';

/// `GET /bookings/seats/{showtimeId}` body.
@JsonSerializable(createToJson: false)
class SeatMapResponseDto {
  const SeatMapResponseDto({
    required this.showtimeId,
    required this.showtime,
    this.seats = const [],
    this.heldByOthers = const [],
    this.heldByMe = const [],
    this.holdMinutes = 0,
    this.maxSeats = 0,
  });

  factory SeatMapResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SeatMapResponseDtoFromJson(json);

  final int showtimeId;
  final ShowtimeInfoDto showtime;
  final List<SeatDto> seats;
  final List<int> heldByOthers;
  final List<int> heldByMe;
  final int holdMinutes;

  /// `max_seats_per_booking`; 0 from a server that does not send it yet.
  final int maxSeats;
}

@JsonSerializable(createToJson: false)
class ShowtimeInfoDto {
  const ShowtimeInfoDto({
    required this.id,
    this.showDate,
    this.showTime,
    this.movieTitle,
    this.hallName,
    this.hallCity,
  });

  factory ShowtimeInfoDto.fromJson(Map<String, dynamic> json) => _$ShowtimeInfoDtoFromJson(json);

  final int id;
  final String? showDate;
  final String? showTime;
  final String? movieTitle;
  final String? hallName;
  final String? hallCity;
}

/// A showtime seat; [id] is `showtime_seats.id`, the id hold/confirm expect.
@JsonSerializable(createToJson: false)
class SeatDto {
  const SeatDto({
    required this.id,
    required this.seatCode,
    required this.seatType,
    this.rowNumber,
    required this.status,
  });

  factory SeatDto.fromJson(Map<String, dynamic> json) => _$SeatDtoFromJson(json);

  final int id;
  final String seatCode;
  final String seatType;
  final int? rowNumber;
  final String status;
}

@JsonSerializable(createToJson: false)
class HoldResponseDto {
  const HoldResponseDto({
    required this.showtimeId,
    required this.expiresAtEpochMs,
    this.holdMinutes = 0,
    this.extended = false,
  });

  factory HoldResponseDto.fromJson(Map<String, dynamic> json) => _$HoldResponseDtoFromJson(json);

  final int showtimeId;
  final int expiresAtEpochMs;
  final int holdMinutes;

  /// The hold's one extend was used; false from a server older than sprint 14.
  final bool extended;
}

@JsonSerializable(createToJson: false)
class HoldStateDto {
  const HoldStateDto({this.heldByOthers = const [], this.heldByMe = const []});

  factory HoldStateDto.fromJson(Map<String, dynamic> json) => _$HoldStateDtoFromJson(json);

  final List<int> heldByOthers;
  final List<int> heldByMe;
}

/// Payload on `/topic/showtimes/{id}/seats`.
@JsonSerializable(createToJson: false)
class SeatEventDto {
  const SeatEventDto({
    required this.type,
    this.showtimeId,
    this.seatIds = const [],
    this.sessionId,
    this.expiresAtEpochMs,
  });

  factory SeatEventDto.fromJson(Map<String, dynamic> json) => _$SeatEventDtoFromJson(json);

  final String type;
  final int? showtimeId;
  final List<int> seatIds;
  final String? sessionId;
  final int? expiresAtEpochMs;
}

@JsonSerializable(createFactory: false)
class SeatIdsRequestDto {
  const SeatIdsRequestDto({required this.showtimeId, required this.seatIds});

  final int showtimeId;
  final List<int> seatIds;

  Map<String, dynamic> toJson() => _$SeatIdsRequestDtoToJson(this);
}
