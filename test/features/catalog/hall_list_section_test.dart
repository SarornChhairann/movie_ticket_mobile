import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' as halls;
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_home_view.dart';

import '../../helpers/localized_app.dart';
import 'hall_fixtures.dart';
import '../../helpers/showing.dart';

class _MovieList extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

class _HallList extends MockBloc<halls.HallListEvent, halls.HallListState> implements halls.HallListBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(const halls.LoadRequested());
  });

  const nowShowing = [Movie(id: 1, title: 'Dune', genre: 'Sci-Fi', comingSoon: false)];
  MovieListState movies({String search = '', String? genre}) => MovieListState.ready(
      tab: MovieTab.nowShowing, search: search, genre: genre, nowShowing: nowShowing, comingSoon: const []);

  late _HallList hallBloc;

  Future<void> pump(
    WidgetTester tester, {
    required MovieListState movieState,
    halls.HallListState hallState = const halls.HallListState.ready(testHalls),
    RouteFactory? onGenerateRoute,
  }) async {
    tester.view.physicalSize = const Size(1080, 6000);
    addTearDown(tester.view.resetPhysicalSize);
    final movieBloc = _MovieList();
    whenListen(movieBloc, const Stream<MovieListState>.empty(), initialState: movieState);
    hallBloc = _HallList();
    whenListen(hallBloc, const Stream<halls.HallListState>.empty(), initialState: hallState);
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<MovieListBloc>.value(value: movieBloc),
          BlocProvider<halls.HallListBloc>.value(value: hallBloc),
          BlocProvider<ShowingCubit>.value(value: showingStub()),
        ],
        child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {})),
      ),
      onGenerateRoute: onGenerateRoute,
    );
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('Halls sits under Now in Cinemas, grouped by cinema with type, flags, and seats', (tester) async {
    await pump(tester, movieState: movies());

    final rail = tester.getTopLeft(find.byKey(const Key('rail.nowShowing'))).dy;
    // The section is a sliver (sprint 21): measure its header.
    expect(tester.getTopLeft(find.text('Halls')).dy, greaterThan(rail));
    expect(find.text('Halls'), findsOneWidget);
    expect(find.text('រោងភាពយន្ត Legend Aeon Sen Sok'), findsOneWidget, reason: 'one header per cinema');
    expect(find.text('ភ្នំពេញ'), findsOneWidget, reason: 'shared city once under the header');
    expect(find.byKey(const Key('hall.1')), findsOneWidget);
    expect(find.byKey(const Key('hall.1.dolby')), findsOneWidget);
    expect(find.byKey(const Key('hall.2.dolby')), findsNothing);
    expect(find.byKey(const Key('hall.3.screenX')), findsOneWidget);
    expect(find.text('Atmos'), findsOneWidget);
    expect(find.text('Standard'), findsOneWidget);
    expect(find.text('IMAX'), findsOneWidget, reason: 'unknown types are shown as sent');
    expect(find.text('60 seats'), findsOneWidget);
    final legend = tester.getTopLeft(find.byKey(const Key('hall.2'))).dy;
    expect(tester.getTopLeft(find.byKey(const Key('hall.3'))).dy, greaterThan(legend), reason: 'server order kept');
  });

  testWidgets('a movie search never filters Home halls (sprint 22: search has its own view)', (tester) async {
    await pump(tester, movieState: movies(search: 'zzz'));

    for (final id in [1, 2, 3]) {
      expect(find.byKey(Key('hall.$id')), findsOneWidget);
    }
  });

  testWidgets('a genre chip never hides halls', (tester) async {
    await pump(tester, movieState: movies(genre: 'Horror'));

    for (final id in [1, 2, 3]) {
      expect(find.byKey(Key('hall.$id')), findsOneWidget);
    }
  });

  testWidgets('a movie failure still shows the halls', (tester) async {
    await pump(
      tester,
      movieState: const MovieListState.failure(tab: MovieTab.nowShowing, search: '', failure: ApiFailure.network()),
    );

    expect(find.byKey(const Key('rail.nowShowing')), findsNothing);
    expect(find.byKey(const Key('hall.1')), findsOneWidget);
  });

  testWidgets('a hall failure still shows the rail, with its own retry', (tester) async {
    await pump(tester, movieState: movies(), hallState: const halls.HallListState.failure(ApiFailure.network()));

    expect(find.byKey(const Key('rail.nowShowing')), findsOneWidget);
    expect(find.byKey(const Key('hall.1')), findsNothing);
    await tester.tap(find.descendant(of: find.byKey(const Key('section.halls')), matching: find.text('Retry')));
    verify(() => hallBloc.add(any(that: isA<halls.LoadRequested>()))).called(1);
  });

  testWidgets('first load shows hall-row skeletons; an empty catalog says so', (tester) async {
    await pump(tester, movieState: movies(), hallState: const halls.HallListState.loading());
    expect(find.byKey(const Key('halls.skeleton')), findsOneWidget);

    await pump(tester, movieState: movies(), hallState: const halls.HallListState.ready([]));
    expect(find.text('No halls yet'), findsOneWidget);
  });

  testWidgets('a hall opens its schedule with the hall id', (tester) async {
    RouteSettings? pushed;
    await pump(
      tester,
      movieState: movies(),
      onGenerateRoute: (settings) {
        pushed = settings;
        return MaterialPageRoute<void>(settings: settings, builder: (_) => const Scaffold(body: Text('schedule')));
      },
    );

    await tester.tap(find.byKey(const Key('hall.2')));
    await tester.pumpAndSettle();
    expect(pushed?.name, AppRoutes.hallSchedule);
    expect(pushed?.arguments, 2);
  });
}
