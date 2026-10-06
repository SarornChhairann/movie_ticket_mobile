import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_schedule_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/dto/hall_dtos.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_mapper.dart';
import 'package:movie_ticket_mobile/features/catalog/view/hall_schedule_page.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map_args.dart';

import '../../helpers/localized_app.dart';
import 'hall_fixtures.dart';

class _Schedule extends MockBloc<HallScheduleEvent, HallScheduleState> implements HallScheduleBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(const ScheduleRequested(0));
  });

  final schedule = HallMapper.schedule(HallScheduleDto.fromJson(scheduleJson()), 'http://api.test');
  late _Schedule bloc;
  final pushed = <RouteSettings>[];

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    addTearDown(tester.view.resetPhysicalSize);
    pushed.clear();
    bloc = _Schedule();
    whenListen(bloc, const Stream<HallScheduleState>.empty(),
        initialState: HallScheduleState.ready(hallId: 1, schedule: schedule));
    await pumpLocalized(
      tester,
      BlocProvider<HallScheduleBloc>.value(value: bloc, child: const HallSchedulePage()),
      onGenerateRoute: (settings) {
        pushed.add(settings);
        return MaterialPageRoute<void>(settings: settings, builder: (_) => const Scaffold(body: Text('next')));
      },
    );
  }

  testWidgets('shows the hall, its amenities as stored, and the date chips', (tester) async {
    await pump(tester);

    expect(find.byKey(const Key('hall.schedule')), findsOneWidget);
    expect(find.text('Cinema c-legend'), findsOneWidget);
    expect(find.byKey(const Key('hall.date.2026-10-07')), findsOneWidget);
    expect(find.byKey(const Key('hall.date.2026-10-08')), findsOneWidget);
    expect(find.byKey(const Key('hall.amenities')), findsOneWidget);
    expect(find.text('Dolby Atmos, អេក្រង់ 4K'), findsOneWidget);
    expect(find.byKey(const Key('hall.showtime.14')), findsNothing, reason: 'blocked row dropped');
  });

  testWidgets('a date chip requests that date', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('hall.date.2026-10-08')));
    verify(() => bloc.add(any(that: isA<DateSelected>().having((e) => e.date, 'date', DateTime(2026, 10, 8)))))
        .called(1);
  });

  testWidgets('a time opens the seat map with every time on that date at this hall', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('hall.showtime.13')));
    await tester.pumpAndSettle();

    expect(pushed.single.name, AppRoutes.seatMap);
    final args = pushed.single.arguments! as SeatMapArgs;
    expect(args.showtimeId, 13);
    expect(args.date, DateTime(2026, 10, 7));
    expect(args.options.map((o) => o.id), [11, 12, 13]);
    expect(args.options.map((o) => o.time), ['10:00', '13:30', '19:15']);
    expect(args.options.map((o) => o.hallName).toSet(), {'Legend Sen Sok · Atmos'});
  });

  testWidgets('prices are the showtime\'s own, never summed', (tester) async {
    await pump(tester);

    expect(find.text('Seat \$5.00 · Couple \$8.50'), findsOneWidget);
    expect(find.text('Seat \$6.00 · Couple \$10.00'), findsOneWidget);
    expect(find.textContaining('\$13.50'), findsNothing);
  });

  testWidgets('a movie title opens movie detail', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('hall.movieTitle.6')));
    await tester.pumpAndSettle();
    expect(pushed.single.name, AppRoutes.movieDetail);
    expect((pushed.single.arguments! as MovieDetailArgs).movieId, 6);
  });
}
