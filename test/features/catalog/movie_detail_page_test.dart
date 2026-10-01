import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_detail_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_detail_page.dart';

import '../../helpers/localized_app.dart';

class _MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class _RouteRecorder extends NavigatorObserver {
  final pushed = <RouteSettings>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => pushed.add(route.settings);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  testWidgets('tapping a showtime routes to the seat map with its id', (tester) async {
    final bloc = _MockMovieDetailBloc();
    final date = DateTime(2026, 10, 2);
    whenListen(
      bloc,
      const Stream<MovieDetailState>.empty(),
      initialState: MovieDetailState.ready(MovieDetail(
        movie: const Movie(id: 1, title: 'Dune', comingSoon: false),
        availableDates: [date],
        selectedDate: date,
        cinemas: const [
          CinemaGroup(cinemaName: 'Legend', halls: [
            HallGroup(hallName: 'Hall 1', dolby: true, screenX: false, slots: [
              ShowtimeSlot(
                id: 42,
                time: '19:30',
                hallName: 'Hall 1',
                cinemaName: 'Legend',
                dolby: true,
                screenX: false,
                normalPrice: 6.5,
              ),
            ]),
          ]),
        ],
      )),
    );
    final recorder = _RouteRecorder();

    await pumpLocalized(
      tester,
      Navigator(
        observers: [recorder],
        onGenerateRoute: (settings) => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => settings.name == AppRoutes.seatMap
              ? const Scaffold()
              : BlocProvider<MovieDetailBloc>.value(value: bloc, child: const MovieDetailPage()),
        ),
      ),
    );

    expect(find.text('Legend'), findsOneWidget);
    expect(find.text('Hall 1 · Dolby Atmos'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('showtime.42')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('showtime.42')));
    await tester.pumpAndSettle();

    final seatRoute = recorder.pushed.last;
    expect(seatRoute.name, AppRoutes.seatMap);
    expect(seatRoute.arguments, 42);
  });
}
