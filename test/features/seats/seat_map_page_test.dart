import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/seats/controller/seat_map_bloc.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map_args.dart';
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
}
