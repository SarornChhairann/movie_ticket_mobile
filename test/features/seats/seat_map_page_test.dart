import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map.dart';
import 'package:movie_ticket_mobile/features/seats/controller/seat_map_bloc.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map_args.dart';
import 'package:movie_ticket_mobile/features/seats/view/party_size_sheet.dart';
import 'package:movie_ticket_mobile/features/seats/view/seat_map_page.dart';

import '../../helpers/finders.dart';
import '../../helpers/localized_app.dart';
import 'seat_fixtures.dart';

class _MockSeatMapBloc extends MockBloc<SeatMapEvent, SeatMapState> implements SeatMapBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(const HoldRequested());
  });

  Future<_MockSeatMapBloc> pump(WidgetTester tester, SeatMapState state) async {
    final bloc = _MockSeatMapBloc();
    whenListen(bloc, const Stream<SeatMapState>.empty(), initialState: state);
    await pumpLocalized(
      tester,
      BlocProvider<SeatMapBloc>.value(value: bloc, child: const SeatMapPage()),
    );
    return bloc;
  }

  SeatMapReady ready({Set<int> selected = const {}}) => SeatMapReady(
        data: seatMap(heldByOthers: {2}),
        heldByOthers: const {2},
        booked: const {3, 14},
        selected: selected,
      );

  testWidgets('booked and held seats have no tap handler; available seats do', (tester) async {
    final bloc = await pump(tester, ready());

    expect(find.byKey(const Key('seat.3')), findsNothing);
    expect(find.byKey(const Key('seat.2')), findsNothing);
    expect(find.text('A3'), findsOneWidget);

    await tester.tap(find.byKey(const Key('seat.1')));
    verify(() => bloc.add(any(that: isA<SeatToggled>().having((e) => e.seatId, 'seatId', 1)))).called(1);
  });

  testWidgets('a half-booked couple pair shows both halves as taken and neither is tappable', (tester) async {
    await pump(tester, ready());

    // B4 (id 14) is booked, so its partner B3 (id 13) is locked too; B1+B2 stay open.
    expect(find.byKey(const Key('seat.14')), findsNothing);
    expect(find.byKey(const Key('seat.13')), findsNothing);
    expect(find.byKey(const Key('seat.11')), findsOneWidget);
    expect(find.byKey(const Key('seat.12')), findsOneWidget);
  });

  testWidgets('continue is disabled until a seat is selected', (tester) async {
    await pump(tester, ready());
    expect(filledButtonIn(tester, const Key('seats.continue')).onPressed, isNull);
  });

  testWidgets('selected seats are listed and continue requests a hold', (tester) async {
    final bloc = await pump(tester, ready(selected: {1}));

    expect(tester.widget<Text>(find.byKey(const Key('seats.summary'))).data, 'A1');
    await tester.tap(find.byKey(const Key('seats.continue')));
    verify(() => bloc.add(any(that: isA<HoldRequested>()))).called(1);
  });

  testWidgets('dark seat screen: title, legend with reserved and held, seat count, no prices', (tester) async {
    await pump(tester, ready(selected: {1}));

    expect(find.text('Select Seat'), findsOneWidget);
    expect(find.text('Reserved'), findsOneWidget);
    expect(find.text('Held'), findsOneWidget);
    expect(find.text('1 seat(s) selected'), findsOneWidget);
    expect(find.textContaining(r'$'), findsNothing);
    expect(Theme.of(tester.element(find.byType(SeatMapPage))).brightness, Brightness.dark);
  });

  testWidgets('time chips come from the detail screen; another time releases and reloads', (tester) async {
    final bloc = _MockSeatMapBloc();
    whenListen(bloc, const Stream<SeatMapState>.empty(), initialState: ready());
    await pumpLocalized(
      tester,
      BlocProvider<SeatMapBloc>.value(
        value: bloc,
        child: SeatMapPage(
          args: SeatMapArgs(
            showtimeId: seatMap().showtimeId,
            options: [
              ShowtimeOption(id: seatMap().showtimeId, time: '14:00', hallName: 'Hall 1'),
              const ShowtimeOption(id: 77, time: '19:30', hallName: 'Hall 2'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('19:30 · Hall 2'), findsOneWidget);
    await tester.tap(find.byKey(const Key('seatTime.77')));
    verify(() => bloc.add(any(that: isA<ReleaseRequested>()))).called(1);
    verify(() => bloc.add(any(that: isA<LoadRequested>().having((e) => e.showtimeId, 'id', 77)))).called(1);
  });

  group('sprint 14', () {
    final hold = Hold(showtimeId: 50, seatIds: {1}, expiresAt: DateTime(2026, 10, 2, 20));

    testWidgets('the extend banner shows in the hold\'s last minute and sends the extend', (tester) async {
      final bloc = await pump(tester, ready(selected: {1}).copyWith(hold: hold, secondsLeft: 45));

      expect(find.byKey(const Key('hold.banner')), findsOneWidget);
      expect(find.text('Your seats are held for 0:45 more.'), findsOneWidget);
      await tester.tap(find.byKey(const Key('hold.extend')));
      verify(() => bloc.add(any(that: isA<HoldExtendRequested>()))).called(1);
    });

    testWidgets('no banner before the last minute, and no Extend once used', (tester) async {
      await pump(tester, ready(selected: {1}).copyWith(hold: hold, secondsLeft: 61));
      expect(find.byKey(const Key('hold.banner')), findsNothing);

      await pump(tester, ready(selected: {1}).copyWith(hold: hold.copyWith(extended: true), secondsLeft: 30));
      expect(find.byKey(const Key('hold.banner')), findsOneWidget);
      expect(find.byKey(const Key('hold.extend')), findsNothing);
    });

    testWidgets('Best seats with a party size asks the bloc; the party button shows the size', (tester) async {
      final bloc = await pump(tester, ready().copyWith(partySize: 2, partyAsked: true));

      expect(find.text('2 seats'), findsOneWidget);
      await tester.tap(find.byKey(const Key('seats.best')));
      await tester.pump();
      verify(() => bloc.add(any(that: isA<BestSeatsRequested>()))).called(1);
    });

    testWidgets('the first map asks how many seats; a choice is sent to the bloc', (tester) async {
      final bloc = _MockSeatMapBloc();
      whenListen(
        bloc,
        Stream<SeatMapState>.fromIterable([ready()]),
        initialState: const SeatMapState.loading(),
      );
      await pumpLocalized(tester, BlocProvider<SeatMapBloc>.value(value: bloc, child: const SeatMapPage()));
      await tester.pumpAndSettle();

      expect(find.byType(PartySizeSheet), findsOneWidget);
      await tester.tap(find.byKey(const Key('party.3')));
      await tester.pumpAndSettle();
      // The listener runs in the bloc stream's (real) zone, so its continuation does too.
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));

      verify(() => bloc.add(any(that: isA<PartySizeChosen>().having((e) => e.size, 'size', 3)))).called(1);
    });
  });

  group('seat experience (sprint 17)', () {
    testWidgets('list mode reads rows and seats with their state', (tester) async {
      final bloc = await pump(tester, ready().copyWith(partyAsked: true));
      await tester.tap(find.byKey(const Key('seats.viewToggle')));
      await tester.pumpAndSettle();

      // A1 free, A2 held by someone else, A3 booked.
      expect(find.text('Row A: 1 available — seats 1'), findsOneWidget);
      await tester.tap(find.byKey(const Key('seats.row.A')));
      await tester.pumpAndSettle();
      expect(find.text('Seat 1, available'), findsOneWidget);
      expect(find.text('Seat 2, held by someone else'), findsOneWidget);
      expect(find.text('Seat 3, booked'), findsOneWidget);

      await tester.tap(find.byKey(const Key('seats.listSeat.1')));
      verify(() => bloc.add(any(that: isA<SeatToggled>().having((e) => e.seatId, 'seatId', 1)))).called(1);

      await tester.tap(find.byKey(const Key('seats.row.B')));
      await tester.pumpAndSettle();
      expect(find.text('Seat 1, available, couple pair with 2'), findsOneWidget);
    });

    testWidgets('with a screen reader on, list mode is the default', (tester) async {
      final bloc = _MockSeatMapBloc();
      whenListen(bloc, const Stream<SeatMapState>.empty(), initialState: ready().copyWith(partyAsked: true));
      await pumpLocalized(
        tester,
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(accessibleNavigation: true),
            child: BlocProvider<SeatMapBloc>.value(value: bloc, child: const SeatMapPage()),
          ),
        ),
      );

      expect(find.byKey(const Key('seats.list')), findsOneWidget);
      expect(find.byKey(const Key('seats.canvas')), findsNothing);
    });

    testWidgets('a seat taken from the pending selection is named, with Pick next best', (tester) async {
      final bloc = await pump(tester, ready(selected: {1}).copyWith(justTaken: ['A2']));

      expect(find.text('A2 was just taken'), findsOneWidget);
      await tester.tap(find.byKey(const Key('seats.pickNext')));
      verify(() => bloc.add(any(that: isA<PickNextBestRequested>()))).called(1);
    });

    testWidgets('zoomed in: mini-map and Whole hall appear; Whole hall zooms back out', (tester) async {
      await pump(tester, ready().copyWith(partyAsked: true));
      expect(find.byKey(const Key('seats.minimap')), findsNothing);

      final viewer = tester.widget<InteractiveViewer>(find.byKey(const Key('seats.canvas')));
      viewer.transformationController!.value = Matrix4.identity()..scaleByDouble(2.5, 2.5, 1, 1);
      await tester.pump();
      expect(find.byKey(const Key('seats.minimap')), findsOneWidget);

      await tester.tap(find.byKey(const Key('seats.fitHall')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('seats.minimap')), findsNothing);
    });

    testWidgets('reduced motion: rows are drawn flat (no perspective)', (tester) async {
      final bloc = _MockSeatMapBloc();
      whenListen(bloc, const Stream<SeatMapState>.empty(), initialState: ready().copyWith(partyAsked: true));
      await pumpLocalized(
        tester,
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: BlocProvider<SeatMapBloc>.value(value: bloc, child: const SeatMapPage()),
          ),
        ),
      );
      final scales = tester
          .widgetList<Transform>(find.descendant(of: find.byKey(const Key('seats.canvas')), matching: find.byType(Transform)))
          .map((t) => t.transform.getMaxScaleOnAxis())
          .where((v) => v != 1.0);
      expect(scales.where((v) => v > 0.9 && v < 1), isEmpty);
    });
  });
}
