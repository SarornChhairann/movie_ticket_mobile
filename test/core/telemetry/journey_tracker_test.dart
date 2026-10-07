import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_cubit.dart';
import 'package:movie_ticket_mobile/features/shell/model/shell_repository.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/telemetry/journey_tracker.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_detail_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart' as list;
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/booking_flow_cubit.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_repository.dart';
import 'package:movie_ticket_mobile/features/checkout/model/payway.dart';
import 'package:movie_ticket_mobile/features/checkout/model/quote.dart';
import 'package:movie_ticket_mobile/features/seats/controller/seat_map_bloc.dart' as seats;
import 'package:movie_ticket_mobile/features/seats/model/seat_map.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_repository.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/ticket_bloc.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_failure.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_repository.dart';

import '../../features/checkout/checkout_fixtures.dart';
import '../../features/seats/seat_fixtures.dart';

class _Shell extends Mock implements ShellRepository {}

class _Recorder implements JourneyTracker {
  final events = <JourneyEvent>[];

  @override
  void track(JourneyEvent event) => events.add(event);
}

class _Catalog extends Mock implements CatalogRepository {}

class _Seats extends Mock implements SeatRepository {}

class _Checkout extends Mock implements CheckoutRepository {}

class _Tickets extends Mock implements TicketsRepository {}

/// Sprint 19: the booking funnel is measurable, and carries no personal data.
void main() {
  setUpAll(() {
    registerFallbackValue(testHold);
    registerFallbackValue(<int>{});
    registerFallbackValue(MovieTab.nowShowing);
    registerFallbackValue(const GuestInfo());
  });

  group('JourneyEvent', () {
    test('only ids, counts, step names, and sources are allowed', () {
      expect(JourneyEvent.allowedKeys, {'movieId', 'showtimeId', 'seatCount', 'step', 'source'});
      for (final pii in ['name', 'phone', 'email', 'reference', 'ticketCode', 'amount', 'tranId']) {
        expect(() => JourneyEvent(JourneyEventName.payStarted, {pii: 'x'}), throwsArgumentError, reason: pii);
      }
    });

    test('the debug sink counts the session', () {
      final tracker = DebugJourneyTracker()
        ..track(JourneyEvent(JourneyEventName.homeViewed))
        ..track(JourneyEvent(JourneyEventName.homeViewed))
        ..track(JourneyEvent(JourneyEventName.payStarted, {'showtimeId': 50}));
      expect(tracker.counts[JourneyEventName.homeViewed], 2);
      expect(tracker.counts[JourneyEventName.payStarted], 1);
    });
  });

  test('a full guest booking (P1) emits the funnel in order, with no PII', () async {
    final tracker = _Recorder();
    final date = DateTime(2026, 10, 7);

    // Home: the shell counts the visit (sprint 21), the catalog loads without tracking.
    final catalog = _Catalog();
    when(() => catalog.fetchMovies(any(), search: any(named: 'search'))).thenAnswer((_) async => const Ok(<Movie>[]));
    ShellCubit(_Shell(), tracker: tracker).homeViewed();
    final home = list.MovieListBloc(catalog)..add(const list.RefreshRequested());
    await home.stream.firstWhere((s) => s is list.MovieListReady);

    // Detail → showtime.
    when(() => catalog.fetchDetail(1, date: any(named: 'date'))).thenAnswer((_) async => Ok(MovieDetail(
          movie: const Movie(id: 1, title: 'Dune', comingSoon: false),
          availableDates: [date],
          selectedDate: date,
          cinemas: const [],
        )));
    final detail = MovieDetailBloc(catalog, tracker: tracker)..add(const DetailRequested(1));
    await detail.stream.firstWhere((s) => s is MovieDetailReady);
    detail.add(const ShowtimeSelected(50));
    await pumpEventQueue();

    // Seats: party of 2, Best seats → held.
    final seatRepo = _Seats();
    when(() => seatRepo.sessionId).thenReturn('me');
    when(() => seatRepo.release(any(), any())).thenAnswer((_) async {});
    when(() => seatRepo.hold(50, {1, 2})).thenAnswer((_) async => Ok(Hold(showtimeId: 50, seatIds: {1, 2}, expiresAt: testHold.expiresAt)));
    final seatBloc = seats.SeatMapBloc(seatRepo, tracker: tracker, tick: const Duration(hours: 1));
    seatBloc.emit(seats.SeatMapState.ready(
      data: seatMap(),
      heldByOthers: const {},
      booked: const {3, 14},
      partySize: 2,
      partyAsked: true,
    ));
    seatBloc.add(const seats.BestSeatsRequested());
    await seatBloc.stream.firstWhere((s) => s is seats.SeatMapReady && s.hold != null);

    // Snacks skipped, checkout, pay.
    final flow = BookingFlowCubit(tracker: tracker)
      ..seatsChanged(showtimeId: 50, title: 'Dune', hallName: 'Hall 1', seatCodes: const ['A1', 'A2'])
      ..enteredCheckout(hasMenu: true)
      ..snacksDone(skipped: true);
    final checkoutRepo = _Checkout();
    when(() => checkoutRepo.quote(any(), promoCode: any(named: 'promoCode'), food: any(named: 'food')))
        .thenAnswer((_) async => Ok(testQuote()));
    when(() => checkoutRepo.startPayway(any(),
            guest: any(named: 'guest'), promoCode: any(named: 'promoCode'), food: any(named: 'food')))
        .thenAnswer((_) async => const Ok(PaywaySession(bookingId: 99, tranId: 'T1', amount: 12.5, checkoutUrl: 'https://checkout-sandbox.payway.com.kh/x')));
    final checkout = CheckoutBloc(checkoutRepo, clock: () => testNow, tick: const Duration(hours: 1), tracker: tracker, canOpenLink: (_) async => false)
      ..add(QuoteRequested(testHold));
    await checkout.stream.firstWhere((s) => s is CheckoutReady);
    checkout
      ..add(const GuestEdited(GuestInfo(name: 'Dara', phone: '012')))
      ..add(const PaymentStartRequested());
    await checkout.stream.firstWhere((s) => s is CheckoutReady && s.payway != null);
    const confirmation = BookingSummary(
      bookingId: 99,
      status: BookingStatus.confirmed,
      movieTitle: 'Dune',
      hallName: 'Hall 1',
      totalAmount: 12.5,
      tickets: [TicketPass(code: 'T-1', seatCode: 'A1', status: 'ACTIVE')],
    );
    checkout.add(const PaywayFinished(PaywayOutcome.approved(confirmation)));
    await checkout.stream.firstWhere((s) => s is CheckoutSuccess);
    flow.paid();
    await flow.close();

    // The ticket, from the success screen.
    final ticketsRepo = _Tickets();
    when(() => ticketsRepo.qrBytes(any()))
        .thenAnswer((_) async => Ok<TicketQr, TicketsFailure>((png: Uint8List(0), offline: false, savedAt: null)));
    final ticket = TicketBloc(ticketsRepo, tracker: tracker)..add(const QrRequested('T-1', source: 'success'));
    await ticket.stream.firstWhere((s) => s is TicketReady);

    expect(tracker.events.map((e) => e.name.wire), [
      'home_viewed',
      'movie_opened',
      'showtime_selected',
      'best_seats_used',
      'seats_held',
      'snacks_skipped',
      'checkout_viewed',
      'pay_started',
      'pay_succeeded',
      'ticket_opened',
    ]);
    for (final e in tracker.events) {
      expect(JourneyEvent.allowedKeys.containsAll(e.props.keys), isTrue, reason: '$e');
      expect(e.props.values.whereType<String>().where((v) => v.contains('Dara') || v.contains('012')), isEmpty);
    }
    for (final b in [home, detail, seatBloc, checkout, ticket]) {
      await b.close();
    }
  });

  test('leaving the flow before paying records where it was abandoned', () async {
    final tracker = _Recorder();
    final flow = BookingFlowCubit(tracker: tracker)
      ..seatsChanged(showtimeId: 50, title: 'Dune', hallName: 'Hall 1', seatCodes: const ['A1'])
      ..enteredCheckout(hasMenu: true);
    await flow.close();
    expect(tracker.events.single.name, JourneyEventName.flowAbandoned);
    expect(tracker.events.single.props, {'step': 'snacks'});
  });

}
