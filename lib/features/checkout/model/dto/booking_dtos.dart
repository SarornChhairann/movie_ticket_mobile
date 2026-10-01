import 'package:json_annotation/json_annotation.dart';

import 'quote_dtos.dart';

part 'booking_dtos.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class ConfirmRequestDto {
  const ConfirmRequestDto({
    required this.seatIds,
    this.guestName,
    this.guestPhone,
    this.guestEmail,
    this.promoCode,
    required this.paymentMethod,
    this.foodItems,
  });

  final List<int> seatIds;
  final String? guestName;
  final String? guestPhone;
  final String? guestEmail;
  final String? promoCode;
  final String paymentMethod;

  /// `{ "<foodItemId>": quantity }`. No total is ever sent: the server recomputes it.
  final Map<String, int>? foodItems;

  Map<String, dynamic> toJson() => _$ConfirmRequestDtoToJson(this);
}

/// `BookingDetailResponse` — returned by confirm and `GET /bookings/confirmation/{id}`.
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
  final QuoteShowtimeDto showtime;
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
