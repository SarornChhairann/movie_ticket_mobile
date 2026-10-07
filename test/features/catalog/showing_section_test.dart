import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/motion/poster_hero.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/catalog/view/featured_hero.dart';
import 'package:movie_ticket_mobile/features/catalog/view/showing_rail.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map_args.dart';

import '../../helpers/localized_app.dart';
import '../../helpers/screens.dart';
import '../../helpers/showing.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

void main() {
  late List<RouteSettings> pushed;

  Route<void> record(RouteSettings settings) {
    pushed.add(settings);
    return MaterialPageRoute<void>(settings: settings, builder: (_) => const Scaffold());
  }

  setUp(() => pushed = []);

  Future<ShowingCubit> pumpSection(WidgetTester tester, {ShowingCubit? cubit}) async {
    final showing = cubit ?? showingStub(movies: showingMovies);
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(
      tester,
      BlocProvider<ShowingCubit>.value(value: showing, child: const Scaffold(body: ShowingSection())),
      onGenerateRoute: record,
    );
    await tester.pump(const Duration(seconds: 1));
    return showing;
  }

  testWidgets('a time chip opens the seat map for that showtime, with the day\'s other times', (tester) async {
    final cubit = await pumpSection(tester);

    await tester.tap(find.byKey(const Key('showing.slot.102')));
    await tester.pump();

    expect(pushed.last.name, AppRoutes.seatMap);
    final args = pushed.last.arguments! as SeatMapArgs;
    expect(args.showtimeId, 102);
    expect(args.date, showingDates.first);
    expect(args.options.map((o) => (o.id, o.time, o.hallName)), [(101, '19:30', 'Hall 3'), (102, '21:45', 'Hall 3')]);
    verify(() => cubit.showtimeChosen(showingMovies.first, showingMovies.first.slots[1])).called(1);
  });

  testWidgets('the rest of the card opens the movie', (tester) async {
    await pumpSection(tester);

    await tester.tap(find.descendant(of: find.byKey(const Key('showing.1')), matching: find.text('Dune')));
    await tester.pump();

    expect(pushed.last.name, AppRoutes.movieDetail);
    final args = pushed.last.arguments! as MovieDetailArgs;
    expect((args.movieId, args.heroSource), (1, HeroSource.showing));
  });

  testWidgets('the header names the day; Dolby shows only on the movie that has it', (tester) async {
    await pumpSection(tester);

    expect(find.text('Showing Today'), findsOneWidget);
    expect(find.text('155 min · PG-13 · Sci-Fi'), findsOneWidget);
    expect(find.byKey(const Key('showing.1.dolby')), findsOneWidget);
    expect(find.byKey(const Key('showing.3.dolby')), findsNothing);
  });

  testWidgets('date chips: Today, Tomorrow, then the weekday; a tap picks that date', (tester) async {
    final cubit = await pumpSection(tester);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
    expect(find.text('Fri 9'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home.date.2026-10-09')));
    verify(() => cubit.dateSelected(DateTime(2026, 10, 9))).called(1);
  });

  testWidgets('an empty day says so and offers the next day with shows', (tester) async {
    final cubit = await pumpSection(
      tester,
      cubit: showingStub(
        state: ShowingState.ready(dates: showingDates, date: showingDates.first, movies: const [], nextDate: showingDates[2]),
      ),
    );

    expect(find.text('No shows Today'), findsOneWidget);
    await tester.tap(find.byKey(const Key('showing.nextDate')));
    verify(() => cubit.dateSelected(showingDates[2])).called(1);
  });

  testWidgets('a failure retries the same date in place', (tester) async {
    final cubit = await pumpSection(
      tester,
      cubit: showingStub(
        state: ShowingState.failure(dates: showingDates, date: showingDates[1], failure: const ApiFailure.network()),
      ),
    );

    expect(find.byKey(const Key('showing.failure')), findsOneWidget);
    await tester.tap(find.text('Retry'));
    verify(() => cubit.dateSelected(showingDates[1])).called(1);
  });

  testWidgets('retries that fail again inside the crossfade do not crash (duplicate keys)', (tester) async {
    final repository = _MockCatalog();
    var answer = Completer<Result<List<ShowingMovie>, ApiFailure>>();
    when(() => repository.fetchShowing(any())).thenAnswer((_) => answer.future);
    final cubit = ShowingCubit(repository, now: () => DateTime(2026, 10, 7, 9));
    addTearDown(cubit.close);
    const down = Err<List<ShowingMovie>, ApiFailure>(ApiFailure.server(status: 500, message: 'Down'));

    unawaited(cubit.load());
    answer.complete(down);
    await pumpSection(tester, cubit: cubit);
    expect(find.byKey(const Key('showing.failure')), findsOneWidget);

    // Retry → loading → the server fails again, three times inside one 250 ms crossfade.
    for (var i = 0; i < 3; i++) {
      answer = Completer();
      await tester.tap(find.text('Retry').last, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 30));
      answer.complete(down);
      await tester.pump(const Duration(milliseconds: 30));
    }

    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const Key('showing.failure')), findsOneWidget);
  });

  testWidgets('the featured hero opens the movie from Book', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(
      tester,
      const Scaffold(
        body: FeaturedHero(
          movie: Movie(id: 7, title: 'Dune: Part Two', comingSoon: false, durationMinutes: 166, rating: 'PG-13'),
        ),
      ),
      onGenerateRoute: record,
    );

    expect(find.text('166 min · PG-13'), findsOneWidget);
    await tester.tap(find.byKey(const Key('home.featured.book')));
    await tester.pump();

    final args = pushed.last.arguments! as MovieDetailArgs;
    expect((pushed.last.name, args.movieId, args.heroSource), (AppRoutes.movieDetail, 7, HeroSource.featured));
  });

  testWidgets('Home order: hero, Showing, Now in Cinemas, then Coming soon', (tester) async {
    await pumpScreen(tester, mainScreens()['home']!());

    double top(Key key) => tester.getTopLeft(find.byKey(key)).dy;
    expect(top(const Key('section.showing')), lessThan(top(const Key('rail.nowShowing'))));
    await tester.scrollUntilVisible(find.byKey(const Key('section.comingSoon')), 300,
        scrollable: find.byType(Scrollable).first);
    expect(top(const Key('rail.nowShowing')), lessThan(top(const Key('section.comingSoon'))));
  });
}
