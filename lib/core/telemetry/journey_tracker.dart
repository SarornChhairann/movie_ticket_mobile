import 'package:flutter/foundation.dart';

/// The booking funnel's events (sprint 19). Names are stable: a dashboard or a
/// vendor sink (decision D5) keys on them.
enum JourneyEventName {
  homeViewed('home_viewed'),
  movieOpened('movie_opened'),
  showtimeSelected('showtime_selected'),
  seatsHeld('seats_held'),
  bestSeatsUsed('best_seats_used'),
  holdExtended('hold_extended'),
  snacksSkipped('snacks_skipped'),
  checkoutViewed('checkout_viewed'),
  payStarted('pay_started'),
  paySucceeded('pay_succeeded'),
  payFailed('pay_failed'),
  flowAbandoned('flow_abandoned'),
  ticketOpened('ticket_opened');

  const JourneyEventName(this.wire);

  final String wire;
}

/// One funnel event. Properties are ids, counts, and step names only — never a
/// name, phone, email, reference, ticket code, or amount (no PII; tested).
@immutable
class JourneyEvent {
  JourneyEvent(this.name, [Map<String, Object> props = const {}]) : props = Map.unmodifiable(props) {
    final unknown = props.keys.where((k) => !allowedKeys.contains(k));
    if (unknown.isNotEmpty) throw ArgumentError('Telemetry property not allowed: ${unknown.join(', ')}');
  }

  /// The whole vocabulary of properties.
  static const allowedKeys = {'movieId', 'showtimeId', 'seatCount', 'step', 'source'};

  final JourneyEventName name;
  final Map<String, Object> props;

  @override
  String toString() => props.isEmpty ? name.wire : '${name.wire} $props';
}

/// Where funnel events go. Blocs fire them; views never do.
abstract interface class JourneyTracker {
  void track(JourneyEvent event);
}

/// Tracks nothing (tests and screens that do not care).
class NoopJourneyTracker implements JourneyTracker {
  const NoopJourneyTracker();

  @override
  void track(JourneyEvent event) {}
}

/// The default sink (D5): prints in debug builds, does nothing in release, and
/// counts this session's events for the gallery's Funnel panel.
class DebugJourneyTracker extends ChangeNotifier implements JourneyTracker {
  final Map<JourneyEventName, int> _counts = {};

  /// Events per name since the app started.
  Map<JourneyEventName, int> get counts => Map.unmodifiable(_counts);

  @override
  void track(JourneyEvent event) {
    if (!kDebugMode) return;
    _counts.update(event.name, (n) => n + 1, ifAbsent: () => 1);
    debugPrint('[journey] $event');
    notifyListeners();
  }
}
