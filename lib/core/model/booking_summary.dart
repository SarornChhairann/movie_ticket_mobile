import 'package:freezed_annotation/freezed_annotation.dart';

import 'dto/booking_detail_dto.dart';

part 'booking_summary.freezed.dart';

/// Booking states of analytics §4. Anything else the server sends is [unknown].
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  unknown;

  static BookingStatus parse(String value) => switch (value) {
        'PENDING' => pending,
        'CONFIRMED' => confirmed,
        'CANCELLED' => cancelled,
        _ => unknown,
      };
}

/// Money owed back on a cancelled paid booking (sprint 12). An admin refunds by
/// hand, so the client only reports what the payment row says.
enum RefundState {
  none,
  pending,
  refunded;

  static RefundState parse(String? paymentStatus) => switch (paymentStatus) {
        'REFUND_PENDING' => pending,
        'REFUNDED' => refunded,
        _ => none,
      };
}

/// One issued ticket. [status] is the server's `ACTIVE | USED | CANCELLED`.
@freezed
abstract class TicketPass with _$TicketPass {
  const TicketPass._();

  const factory TicketPass({
    required String code,
    required String seatCode,
    required String status,

    /// The booking's reference, shown with the QR.
    @Default('') String bookingReference,
  }) = _TicketPass;

  bool get cancelled => status == 'CANCELLED';
}

/// A booking as the server reports it (`BookingDetailResponse`). Checkout shows it
/// as the confirmation; tickets lists and cancels it.
@freezed
abstract class BookingSummary with _$BookingSummary {
  const BookingSummary._();

  const factory BookingSummary({
    required int bookingId,

    /// Empty from a server older than sprint 13.
    @Default('') String reference,
    required BookingStatus status,
    required String movieTitle,
    required String hallName,

    /// ISO date and `HH:mm[:ss]` in the cinema's zone; never converted.
    String? showDate,
    String? showTime,
    required num totalAmount,
    required List<TicketPass> tickets,
    String? bookedAt,
    @Default(RefundState.none) RefundState refund,
  }) = _BookingSummary;

  factory BookingSummary.fromDto(BookingDetailDto dto) => BookingSummary(
        bookingId: dto.id,
        reference: dto.reference ?? '',
        status: BookingStatus.parse(dto.status),
        movieTitle: dto.showtime.movieTitle ?? '',
        hallName: dto.showtime.hallName ?? '',
        showDate: dto.showtime.showDate,
        showTime: dto.showtime.showTime,
        totalAmount: dto.totalAmount,
        bookedAt: dto.bookedAt,
        refund: RefundState.parse(dto.paymentStatus),
        tickets: [
          for (final t in dto.tickets)
            TicketPass(
              code: t.ticketCode,
              seatCode: t.seatCode ?? '',
              status: t.status,
              bookingReference: dto.reference ?? '',
            ),
        ]..sort((a, b) => a.seatCode.compareTo(b.seatCode)),
      );

  List<String> get seatCodes => [for (final t in tickets) t.seatCode];

  /// Show start as a wall-clock time in the cinema's zone, or null if unknown.
  DateTime? get showStart {
    if (showDate == null) return null;
    return DateTime.tryParse('${showDate}T${showTime ?? '00:00:00'}');
  }

  /// Whether to offer cancel. Only hides it for shows that already started; the
  /// cancellation window is not known to the client, so the server decides
  /// (`CANCEL_WINDOW`). The wall-clock comparison assumes the device is in the
  /// cinema's zone, which is fine for a view guard.
  bool canCancelAt(DateTime now) {
    if (status != BookingStatus.confirmed) return false;
    final start = showStart;
    return start == null || start.isAfter(now);
  }
}
