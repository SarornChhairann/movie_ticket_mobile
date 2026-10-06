import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/format/cinema_clock.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/features/tickets/model/ticket_wallet.dart';

BookingSummary booking(int id, String date, String time,
        {BookingStatus status = BookingStatus.confirmed, RefundState refund = RefundState.none, String ticket = 'ACTIVE'}) =>
    BookingSummary(
      bookingId: id,
      status: status,
      movieTitle: 'M$id',
      hallName: 'Hall 1',
      showDate: date,
      showTime: time,
      totalAmount: 10,
      refund: refund,
      tickets: [TicketPass(code: 'T$id', seatCode: 'D1', status: ticket)],
    );

void main() {
  final now = DateTime(2026, 10, 7, 17, 20); // cinema wall clock

  group('nextBooking', () {
    test('none, or only past shows → null', () {
      expect(nextBooking(const [], now), isNull);
      expect(nextBooking([booking(1, '2026-10-07', '15:00:00')], now), isNull);
    });

    test('cancelled bookings and shows more than 7 days out are skipped', () {
      expect(nextBooking([booking(1, '2026-10-07', '19:30:00', status: BookingStatus.cancelled)], now), isNull);
      expect(nextBooking([booking(2, '2026-10-15', '19:30:00')], now), isNull);
    });

    test('the nearest upcoming show wins', () {
      final picked = nextBooking([
        booking(1, '2026-10-09', '10:00:00'),
        booking(2, '2026-10-07', '19:30:00'),
        booking(3, '2026-10-08', '09:00:00'),
      ], now);
      expect(picked!.bookingId, 2);
    });
  });

  test('cinema clock: UTC + 7 h wall clock, whatever the device zone', () {
    // 10:20 UTC is 17:20 in Phnom Penh, so a 17:00 show there has already started.
    final atCinema = CinemaClock.now(DateTime.utc(2026, 10, 7, 10, 20));
    expect(atCinema, DateTime(2026, 10, 7, 17, 20));
    expect(nextBooking([booking(1, '2026-10-07', '17:00:00')], atCinema), isNull);
    expect(nextBooking([booking(2, '2026-10-07', '17:30:00')], atCinema)!.bookingId, 2);
  });

  test('day words and countdown text', () {
    expect(upNextDay(DateTime(2026, 10, 7, 19, 30), now), UpNextDay.tonight);
    expect(upNextDay(DateTime(2026, 10, 8, 0, 15), now), UpNextDay.tomorrow);
    expect(upNextDay(DateTime(2026, 10, 10, 19, 30), now), UpNextDay.later);
    expect(untilText(DateTime(2026, 10, 7, 19, 30), now), '2h 10m');
    expect(untilText(DateTime(2026, 10, 7, 18, 20), now), '1h');
    expect(untilText(DateTime(2026, 10, 7, 17, 45), now), '25m');
    expect(untilText(DateTime(2026, 10, 9, 19, 20), now), '2d 2h');
  });

  test('Upcoming soonest first, Past latest first; ties keep the server order', () {
    final g = groupBookings([
      booking(1, '2026-10-01', '19:00:00'),
      booking(2, '2026-10-09', '19:00:00'),
      booking(3, '2026-10-08', '19:00:00'),
      booking(4, '2026-10-05', '19:00:00'),
      booking(5, '2026-10-09', '19:00:00'),
    ], now);
    expect(g.upcoming.map((b) => b.bookingId), [3, 2, 5]);
    expect(g.past.map((b) => b.bookingId), [4, 1]);
  });

  group('timeline', () {
    test('a paid upcoming booking is at Paid; after the show starts, Show starts; a scanned ticket, Used', () {
      final upcoming = bookingTimeline(booking(1, '2026-10-08', '19:00:00'), now);
      expect(upcoming.steps, [TimelineStep.booked, TimelineStep.paid, TimelineStep.showStarts]);
      expect(upcoming.current, TimelineStep.paid);
      expect(bookingTimeline(booking(1, '2026-10-07', '15:00:00'), now).current, TimelineStep.showStarts);
      expect(bookingTimeline(booking(1, '2026-10-07', '15:00:00', ticket: 'USED'), now).current, TimelineStep.used);
    });

    test('cancelled: with a refund trail when paid, without one otherwise', () {
      final refunding = bookingTimeline(
          booking(1, '2026-10-08', '19:00:00', status: BookingStatus.cancelled, refund: RefundState.pending), now);
      expect(refunding.steps,
          [TimelineStep.booked, TimelineStep.paid, TimelineStep.cancelled, TimelineStep.refundPending]);
      expect(refunding.current, TimelineStep.refundPending);
      final plain = bookingTimeline(booking(2, '2026-10-08', '19:00:00', status: BookingStatus.cancelled), now);
      expect(plain.steps, [TimelineStep.booked, TimelineStep.cancelled]);
    });
  });
}
