import 'package:json_annotation/json_annotation.dart';

part 'booking_detail_dto.g.dart';

/// Backend `ShowtimeInfo`, nested in quote and booking responses.
@JsonSerializable(createToJson: false)
class ShowtimeInfoDto {
  const ShowtimeInfoDto({required this.id, this.showDate, this.showTime, this.movieTitle, this.hallName});

  factory ShowtimeInfoDto.fromJson(Map<String, dynamic> json) => _$ShowtimeInfoDtoFromJson(json);

  final int id;
  final String? showDate;
  final String? showTime;
  final String? movieTitle;
  final String? hallName;
}

/// `BookingDetailResponse` — returned by confirm, `GET /bookings/confirmation/{id}`,
/// and each row of `GET /bookings/my-bookings`. Shared by checkout and tickets.
@JsonSerializable(createToJson: false)
class BookingDetailDto {
  const BookingDetailDto({
    required this.id,
    required this.showtime,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    required this.totalAmount,
    this.promoCode,
    this.paymentMethod,
    required this.status,
    this.bookedAt,
    this.tickets = const [],
  });

  factory BookingDetailDto.fromJson(Map<String, dynamic> json) => _$BookingDetailDtoFromJson(json);

  final int id;
  final ShowtimeInfoDto showtime;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final num totalAmount;
  final String? promoCode;
  final String? paymentMethod;
  final String status;
  final String? bookedAt;
  final List<TicketSummaryDto> tickets;
}

@JsonSerializable(createToJson: false)
class TicketSummaryDto {
  const TicketSummaryDto({required this.id, required this.ticketCode, required this.status, this.seatCode, this.seatType});

  factory TicketSummaryDto.fromJson(Map<String, dynamic> json) => _$TicketSummaryDtoFromJson(json);

  final int id;
  final String ticketCode;
  final String status;
  final String? seatCode;
  final String? seatType;
}
