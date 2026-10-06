import '../../../core/model/booking_summary.dart';

/// Pure selectors behind the ticket wallet (sprint 18). Times are cinema wall
/// clock (see `CinemaClock`).

/// How far ahead Home's Up next looks.
const upNextWindow = Duration(days: 7);

/// The confirmed booking whose show starts next, within [upNextWindow] of [now];
/// null when there is none. Started shows are past; cancelled ones never count.
BookingSummary? nextBooking(Iterable<BookingSummary> bookings, DateTime now) {
  BookingSummary? best;
  for (final b in bookings) {
    final start = b.showStart;
    if (b.status != BookingStatus.confirmed || start == null) continue;
    if (!start.isAfter(now) || start.difference(now) > upNextWindow) continue;
    if (best == null || start.isBefore(best.showStart!)) best = b;
  }
  return best;
}

/// Bookings split for the Bookings tab: upcoming by show time (soonest first),
/// past by show time (latest first). A booking with no known time is upcoming.
({List<BookingSummary> upcoming, List<BookingSummary> past}) groupBookings(
  List<BookingSummary> bookings,
  DateTime now,
) {
  final upcoming = <BookingSummary>[];
  final past = <BookingSummary>[];
  for (final b in bookings) {
    final start = b.showStart;
    (start != null && !start.isAfter(now) ? past : upcoming).add(b);
  }
  int byStart(BookingSummary a, BookingSummary b) =>
      (a.showStart ?? DateTime(9999)).compareTo(b.showStart ?? DateTime(9999));
  // `sort` is not stable, so ties keep the server's order through the index.
  List<BookingSummary> stable(List<BookingSummary> list, int Function(BookingSummary, BookingSummary) cmp) {
    final indexed = list.indexed.toList()..sort((x, y) => cmp(x.$2, y.$2) != 0 ? cmp(x.$2, y.$2) : x.$1 - y.$1);
    return [for (final e in indexed) e.$2];
  }

  return (upcoming: stable(upcoming, byStart), past: stable(past, (a, b) => byStart(b, a)));
}

/// When the Up next card says the show is.
enum UpNextDay { tonight, tomorrow, later }

UpNextDay upNextDay(DateTime start, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(start.year, start.month, start.day);
  final days = day.difference(today).inDays;
  return switch (days) {
    0 => UpNextDay.tonight,
    1 => UpNextDay.tomorrow,
    _ => UpNextDay.later,
  };
}

/// "2h 10m", "45m", "3d 2h" — the time left, rounded down to the minute.
String untilText(DateTime start, DateTime now) {
  final left = start.difference(now);
  if (left.isNegative) return '0m';
  final days = left.inDays;
  final hours = left.inHours % 24;
  final minutes = left.inMinutes % 60;
  if (days > 0) return hours > 0 ? '${days}d ${hours}h' : '${days}d';
  if (left.inHours > 0) return minutes > 0 ? '${left.inHours}h ${minutes}m' : '${left.inHours}h';
  return '${minutes}m';
}

/// One step of a booking's story, from what the API already returns.
enum TimelineStep { booked, paid, showStarts, used, cancelled, refundPending, refunded }

/// The steps a booking has, in order, and which one it is at now. No state is
/// invented: each comes from status, tickets, refund, or the show time.
({List<TimelineStep> steps, TimelineStep current}) bookingTimeline(BookingSummary b, DateTime now) {
  final started = b.showStart != null && !b.showStart!.isAfter(now);
  final used = b.tickets.any((t) => t.status == 'USED');
  if (b.status == BookingStatus.cancelled) {
    final steps = [
      TimelineStep.booked,
      if (b.refund != RefundState.none) TimelineStep.paid,
      TimelineStep.cancelled,
      if (b.refund == RefundState.pending) TimelineStep.refundPending,
      if (b.refund == RefundState.refunded) TimelineStep.refunded,
    ];
    return (steps: steps, current: steps.last);
  }
  if (b.status != BookingStatus.confirmed) {
    return (steps: const [TimelineStep.booked, TimelineStep.paid, TimelineStep.showStarts], current: TimelineStep.booked);
  }
  final steps = [TimelineStep.booked, TimelineStep.paid, TimelineStep.showStarts, if (used) TimelineStep.used];
  final current = used ? TimelineStep.used : (started ? TimelineStep.showStarts : TimelineStep.paid);
  return (steps: steps, current: current);
}
