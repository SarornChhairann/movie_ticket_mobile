import 'package:movie_ticket_mobile/core/model/booking_summary.dart';

BookingSummary testBooking({
  int id = 99,
  BookingStatus status = BookingStatus.confirmed,
  String showDate = '2026-10-20',
  String ticketStatus = 'ACTIVE',
  String bookedAt = '2026-10-01T10:00:00',
  RefundState refund = RefundState.none,
}) =>
    BookingSummary(
      bookingId: id,
      status: status,
      movieTitle: 'Dune',
      hallName: 'Hall 1',
      showDate: showDate,
      showTime: '19:30:00',
      totalAmount: 12.5,
      bookedAt: bookedAt,
      refund: refund,
      tickets: [
        TicketPass(code: 'T-$id-1', seatCode: 'D1', status: ticketStatus),
        TicketPass(code: 'T-$id-2', seatCode: 'D2', status: ticketStatus),
      ],
    );

Map<String, dynamic> bookingJson({
  int id = 99,
  String status = 'CONFIRMED',
  String bookedAt = '2026-10-01T10:00:00',
  String? paymentStatus,
}) =>
    {
      'id': id,
      'showtime': {'id': 50, 'showDate': '2026-10-20', 'showTime': '19:30:00', 'movieTitle': 'Dune', 'hallName': 'Hall 1'},
      'customerName': 'Dara',
      'customerEmail': 'dara@example.com',
      'customerPhone': null,
      'totalAmount': 12.50,
      'serviceFee': 1.50,
      'taxAmount': 1.00,
      'discountAmount': 0,
      'promoCode': null,
      'paymentMethod': 'CARD',
      'status': status,
      'bookedAt': bookedAt,
      'tickets': [
        {'id': 2, 'ticketCode': 'T-$id-2', 'status': status == 'CANCELLED' ? 'CANCELLED' : 'ACTIVE', 'seatCode': 'D2', 'seatType': 'NORMAL'},
        {'id': 1, 'ticketCode': 'T-$id-1', 'status': status == 'CANCELLED' ? 'CANCELLED' : 'ACTIVE', 'seatCode': 'D1', 'seatType': 'NORMAL'},
      ],
      'firstTicketCode': 'T-$id-2',
      'paymentStatus': paymentStatus,
    };
