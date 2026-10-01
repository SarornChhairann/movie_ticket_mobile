import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/theme/app_theme.dart';
import 'package:movie_ticket_mobile/features/seats/controller/seat_map_bloc.dart';
import 'package:movie_ticket_mobile/features/seats/view/seat_map_page.dart';

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
      Theme(
        data: AppTheme.light,
        child: BlocProvider<SeatMapBloc>.value(value: bloc, child: const SeatMapPage()),
      ),
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

  testWidgets('continue is disabled until a seat is selected', (tester) async {
    await pump(tester, ready());
    expect(tester.widget<FilledButton>(find.byKey(const Key('seats.continue'))).onPressed, isNull);
  });

  testWidgets('selected seats are listed and continue requests a hold', (tester) async {
    final bloc = await pump(tester, ready(selected: {1}));

    expect(tester.widget<Text>(find.byKey(const Key('seats.summary'))).data, 'A1');
    await tester.tap(find.byKey(const Key('seats.continue')));
    verify(() => bloc.add(any(that: isA<HoldRequested>()))).called(1);
  });
}
