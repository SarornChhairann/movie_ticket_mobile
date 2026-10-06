// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatMapResponseDto _$SeatMapResponseDtoFromJson(Map<String, dynamic> json) =>
    SeatMapResponseDto(
      showtimeId: (json['showtimeId'] as num).toInt(),
      showtime: ShowtimeInfoDto.fromJson(
        json['showtime'] as Map<String, dynamic>,
      ),
      seats:
          (json['seats'] as List<dynamic>?)
              ?.map((e) => SeatDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      heldByOthers:
          (json['heldByOthers'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      heldByMe:
          (json['heldByMe'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      holdMinutes: (json['holdMinutes'] as num?)?.toInt() ?? 0,
      maxSeats: (json['maxSeats'] as num?)?.toInt() ?? 0,
    );

ShowtimeInfoDto _$ShowtimeInfoDtoFromJson(Map<String, dynamic> json) =>
    ShowtimeInfoDto(
      id: (json['id'] as num).toInt(),
      showDate: json['showDate'] as String?,
      showTime: json['showTime'] as String?,
      movieTitle: json['movieTitle'] as String?,
      hallName: json['hallName'] as String?,
      hallCity: json['hallCity'] as String?,
    );

SeatDto _$SeatDtoFromJson(Map<String, dynamic> json) => SeatDto(
  id: (json['id'] as num).toInt(),
  seatCode: json['seatCode'] as String,
  seatType: json['seatType'] as String,
  rowNumber: (json['rowNumber'] as num?)?.toInt(),
  status: json['status'] as String,
);

HoldResponseDto _$HoldResponseDtoFromJson(Map<String, dynamic> json) =>
    HoldResponseDto(
      showtimeId: (json['showtimeId'] as num).toInt(),
      expiresAtEpochMs: (json['expiresAtEpochMs'] as num).toInt(),
      holdMinutes: (json['holdMinutes'] as num?)?.toInt() ?? 0,
      extended: json['extended'] as bool? ?? false,
    );

HoldStateDto _$HoldStateDtoFromJson(Map<String, dynamic> json) => HoldStateDto(
  heldByOthers:
      (json['heldByOthers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  heldByMe:
      (json['heldByMe'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

SeatEventDto _$SeatEventDtoFromJson(Map<String, dynamic> json) => SeatEventDto(
  type: json['type'] as String,
  showtimeId: (json['showtimeId'] as num?)?.toInt(),
  seatIds:
      (json['seatIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  sessionId: json['sessionId'] as String?,
  expiresAtEpochMs: (json['expiresAtEpochMs'] as num?)?.toInt(),
);

Map<String, dynamic> _$SeatIdsRequestDtoToJson(SeatIdsRequestDto instance) =>
    <String, dynamic>{
      'showtimeId': instance.showtimeId,
      'seatIds': instance.seatIds,
    };
