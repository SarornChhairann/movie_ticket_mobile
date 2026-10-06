import 'package:freezed_annotation/freezed_annotation.dart';

import 'couple_pairing.dart';
import 'dto/seat_dtos.dart';

part 'seat_map.freezed.dart';

@freezed
abstract class SeatView with _$SeatView {
  const factory SeatView({
    /// `showtime_seats.id`.
    required int id,
    required String code,
    required int row,
    required int number,
    required bool couple,
    required bool booked,
  }) = _SeatView;

  factory SeatView.fromDto(SeatDto dto) {
    final parsed = SeatCode.tryParse(dto.seatCode);
    return SeatView(
      id: dto.id,
      code: dto.seatCode,
      row: dto.rowNumber ?? 0,
      number: parsed?.number ?? 0,
      couple: dto.seatType == 'COUPLE',
      booked: dto.status == 'BOOKED',
    );
  }
}

@freezed
abstract class SeatMapData with _$SeatMapData {
  const factory SeatMapData({
    required int showtimeId,
    required String movieTitle,
    required String hallName,
    String? showDate,
    String? showTime,
    required List<SeatView> seats,
    required Set<int> heldByOthers,
    required int holdMinutes,

    /// Most seats one booking may have; 0 means the server did not say, so no
    /// client guard. The server enforces it either way (`SEAT_LIMIT`).
    @Default(0) int maxSeats,
  }) = _SeatMapData;

  factory SeatMapData.fromDto(SeatMapResponseDto dto) => SeatMapData(
        showtimeId: dto.showtimeId,
        movieTitle: dto.showtime.movieTitle ?? '',
        hallName: dto.showtime.hallName ?? '',
        showDate: dto.showtime.showDate,
        showTime: dto.showtime.showTime,
        seats: dto.seats.map(SeatView.fromDto).toList(),
        heldByOthers: dto.heldByOthers.toSet(),
        holdMinutes: dto.holdMinutes,
        maxSeats: dto.maxSeats,
      );
}

/// Seats this client holds on the server, until [expiresAt].
@freezed
abstract class Hold with _$Hold {
  const factory Hold({
    required int showtimeId,
    required Set<int> seatIds,
    required DateTime expiresAt,

    /// The one extend for this hold was used (sprint 14).
    @Default(false) bool extended,
  }) = _Hold;
}

enum SeatEventType { held, released, booked }

@freezed
sealed class SeatEvent with _$SeatEvent {
  /// A push from the seat topic.
  const factory SeatEvent.change({
    required SeatEventType type,
    required Set<int> seatIds,
    String? sessionId,
  }) = SeatChange;

  /// Polling fallback: the full set of seats other sessions hold.
  const factory SeatEvent.snapshot({required Set<int> heldByOthers}) = SeatSnapshot;

  static SeatEvent? fromDto(SeatEventDto dto) {
    final type = switch (dto.type) {
      'HELD' => SeatEventType.held,
      'RELEASED' => SeatEventType.released,
      'BOOKED' => SeatEventType.booked,
      _ => null,
    };
    return type == null
        ? null
        : SeatEvent.change(type: type, seatIds: dto.seatIds.toSet(), sessionId: dto.sessionId);
  }
}
