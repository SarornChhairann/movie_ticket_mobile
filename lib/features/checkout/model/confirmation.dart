import 'package:freezed_annotation/freezed_annotation.dart';

import 'dto/booking_dtos.dart';

part 'confirmation.freezed.dart';

@freezed
abstract class TicketPass with _$TicketPass {
  const factory TicketPass({required String code, required String seatCode, required String status}) = _TicketPass;
}

/// A paid booking, as the server confirmed it.
@freezed
abstract class Confirmation with _$Confirmation {
  const factory Confirmation({
    required int bookingId,
    required String status,
    required String movieTitle,
    required String hallName,
    String? showDate,
    String? showTime,
    required num totalAmount,
    required List<TicketPass> tickets,
  }) = _Confirmation;

  factory Confirmation.fromDto(BookingDetailDto dto) => Confirmation(
        bookingId: dto.id,
        status: dto.status,
        movieTitle: dto.showtime.movieTitle ?? '',
        hallName: dto.showtime.hallName ?? '',
        showDate: dto.showtime.showDate,
        showTime: dto.showtime.showTime,
        totalAmount: dto.totalAmount,
        tickets: [
          for (final t in dto.tickets) TicketPass(code: t.ticketCode, seatCode: t.seatCode ?? '', status: t.status),
        ]..sort((a, b) => a.seatCode.compareTo(b.seatCode)),
      );
}
