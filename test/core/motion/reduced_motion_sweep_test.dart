import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/widgets/sticky_summary_bar.dart';
import 'package:movie_ticket_mobile/core/widgets/booking_progress.dart';
import 'package:movie_ticket_mobile/core/widgets/booking_capsule.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' hide RefreshRequested;
import 'package:movie_ticket_mobile/features/catalog/controller/movie_detail_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_detail_page.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_home_view.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/view/checkout_page.dart';
import 'package:movie_ticket_mobile/features/checkout/view/pay_success_page.dart';
import 'package:movie_ticket_mobile/features/seats/controller/seat_map_bloc.dart';
import 'package:movie_ticket_mobile/features/seats/view/seat_map_page.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/my_bookings_bloc.dart' as tickets;
import 'package:movie_ticket_mobile/features/tickets/view/my_bookings_page.dart';

import '../../features/checkout/checkout_fixtures.dart';
import '../../features/seats/seat_fixtures.dart';
import '../../features/tickets/tickets_fixtures.dart';
import '../../helpers/localized_app.dart';

class _Auth extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class _List extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

class _Halls extends MockBloc<HallListEvent, HallListState> implements HallListBloc {}

class _Detail extends MockBloc<MovieDetailEvent, MovieDetailState> implements MovieDetailBloc {}

class _Seats extends MockBloc<SeatMapEvent, SeatMapState> implements SeatMapBloc {}

class _Checkout extends MockBloc<CheckoutEvent, CheckoutState> implements CheckoutBloc {}

class _Bookings extends MockBloc<tickets.MyBookingsEvent, tickets.MyBookingsState>
    implements tickets.MyBookingsBloc {
  @override
  bool get guest => false;
}

/// Sprint 8: with the OS "reduce motion" setting, every screen is complete on its
/// first frame — nothing runs, nothing auto-advances, nothing loops.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  B mock<B extends BlocBase<S>, S>(B bloc, S state) {
    whenListen(bloc, Stream<S>.empty(), initialState: state);
    return bloc;
  }

  final comingSoon = [
    for (final id in [2, 5, 9]) Movie(id: id, title: 'Soon $id', comingSoon: true, releaseDate: DateTime(2026, 12, 1)),
  ];
  const nowShowing = [Movie(id: 1, title: 'Dune', comingSoon: false)];

  const halls = [
    Hall(id: 1, name: 'Legend Sen Sok · Atmos', type: 'ATMOS', totalSeats: 60, dolby: true, cinemaId: 'c1', cinemaName: 'Legend'),
  ];

  Future<void> pumpReduced(WidgetTester tester, Widget screen,
      {HallListState hallState = const HallListState.ready(halls)}) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mock(_Auth(), const AuthState.guest())),
          BlocProvider<HallListBloc>.value(value: mock(_Halls(), hallState)),
        ],
        child: Builder(
          builder: (context) =>
              MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: screen),
        ),
      ),
    );
    await tester.pump();
  }

  void expectStill(WidgetTester tester, String screen) =>
      expect(tester.hasRunningAnimations, isFalse, reason: '$screen is still animating under reduced motion');

  testWidgets('Home with the carousel and rails', (tester) async {
    await pumpReduced(
      tester,
      BlocProvider<MovieListBloc>.value(
        value: mock(
          _List(),
          MovieListState.ready(tab: MovieTab.nowShowing, search: '', nowShowing: nowShowing, comingSoon: comingSoon),
        ),
        child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {})),
      ),
    );
    expect(find.byKey(const Key('carousel')), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const Key('hall.1')), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.byKey(const Key('hall.1')), findsOneWidget, reason: 'the final hall list shows under reduced motion');
    expectStill(tester, 'Home');

    await tester.pump(const Duration(seconds: 12));
    expectStill(tester, 'Home after 12 s (no auto-advance)');
  });

  testWidgets('Home loading skeleton does not shimmer', (tester) async {
    await pumpReduced(
      tester,
      BlocProvider<MovieListBloc>.value(
        value: mock(_List(), const MovieListState.loading(tab: MovieTab.nowShowing, search: '')),
        child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {})),
      ),
      hallState: const HallListState.loading(),
    );
    expect(find.byKey(const Key('home.skeleton')), findsOneWidget);
    expectStill(tester, 'Home skeleton');
  });

  testWidgets('Movie detail', (tester) async {
    final date = DateTime(2026, 10, 2);
    await pumpReduced(
      tester,
      BlocProvider<MovieDetailBloc>.value(
        value: mock(
          _Detail(),
          MovieDetailState.ready(MovieDetail(
            movie: const Movie(id: 1, title: 'Dune', comingSoon: false),
            availableDates: [date],
            selectedDate: date,
            cinemas: const [],
          )),
        ),
        child: const MovieDetailPage(),
      ),
    );
    expectStill(tester, 'Movie detail');
  });

  testWidgets('Seat map', (tester) async {
    await pumpReduced(
      tester,
      BlocProvider<SeatMapBloc>.value(
        value: mock<_Seats, SeatMapState>(
          _Seats(),
          SeatMapReady(data: seatMap(heldByOthers: {2}), heldByOthers: const {2}, booked: const {3}, selected: const {1}),
        ),
        child: const SeatMapPage(),
      ),
    );
    expectStill(tester, 'Seat map');
  });

  testWidgets('Checkout', (tester) async {
    await pumpReduced(
      tester,
      BlocProvider<CheckoutBloc>.value(
        value: mock<_Checkout, CheckoutState>(_Checkout(), CheckoutReady(hold: testHold, quote: testQuote(), secondsLeft: 600)),
        child: const CheckoutPage(),
      ),
    );
    expectStill(tester, 'Checkout');
  });

  testWidgets('Pay success shows the issued ticket at once', (tester) async {
    await pumpReduced(tester, PaySuccessPage(confirmation: testBooking()));
    expect(find.byKey(const Key('pay.issued')), findsOneWidget);
    expectStill(tester, 'Pay success');
  });

  testWidgets('Bookings loading', (tester) async {
    await pumpReduced(
      tester,
      BlocProvider<tickets.MyBookingsBloc>.value(
        value: mock(_Bookings(), const tickets.MyBookingsState.loading()),
        child: const MyBookingsPage(),
      ),
    );
    expect(find.byKey(const Key('bookings.skeleton')), findsOneWidget);
    expectStill(tester, 'Bookings skeleton');
  });

  testWidgets('Bookings loaded', (tester) async {
    await pumpReduced(
      tester,
      BlocProvider<tickets.MyBookingsBloc>.value(
        value: mock(_Bookings(), tickets.MyBookingsState.ready(bookings: [testBooking(status: BookingStatus.cancelled)])),
        child: const MyBookingsPage(),
      ),
    );
    expectStill(tester, 'Bookings');
  });

  testWidgets('the rail skeleton has the loaded rail\'s height, so nothing jumps', (tester) async {
    Widget home(MovieListState state) => BlocProvider<MovieListBloc>.value(
          value: mock(_List(), state),
          child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {})),
        );
    await pumpReduced(tester, home(const MovieListState.loading(tab: MovieTab.nowShowing, search: '')));
    final skeleton = tester.getSize(find.byKey(const Key('rail.skeleton')));

    await pumpReduced(
      tester,
      home(MovieListState.ready(tab: MovieTab.nowShowing, search: '', nowShowing: nowShowing, comingSoon: comingSoon)),
    );
    expect(tester.getSize(find.byKey(const Key('rail.nowShowing'))).height, skeleton.height);
  });

  testWidgets('booking flow pieces are still: progress, capsule with timer, summary bar', (tester) async {
    await pumpReduced(
      tester,
      Scaffold(
        body: const Column(children: [
          BookingProgress(current: FlowStep.pay, snacksSkipped: true),
          BookingCapsule(showtimeId: 50, title: 'Dune', line: 'Hall 1 · 19:30', seats: ['D1'], secondsLeft: 45),
        ]),
        bottomNavigationBar: StickySummaryBar(summary: const Text('2 seats'), actionLabel: 'Pay', onAction: () {}),
      ),
    );
    expectStill(tester, 'Booking flow');
  });
}
