import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' as halls;
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_home_view.dart';

import '../../helpers/localized_app.dart';
import '../../helpers/showing.dart';

class _MovieList extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

class _HallList extends MockBloc<halls.HallListEvent, halls.HallListState> implements halls.HallListBloc {}

/// Sprint 21: lazy halls, per-section failure, one awaited refresh, offline times.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(const RefreshRequested());
    registerFallbackValue(const halls.LoadRequested());
  });

  final ready = MovieListState.ready(
    tab: MovieTab.nowShowing,
    search: '',
    nowShowing: const [Movie(id: 1, title: 'Dune', comingSoon: false)],
    comingSoon: const [],
  );

  late _MovieList movieBloc;
  late _HallList hallBloc;

  Future<void> pump(
    WidgetTester tester, {
    MovieListState? movies,
    halls.HallListState hallState = const halls.HallListState.ready([]),
    ShowingCubit? showing,
    Future<void> Function()? onRefresh,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    movieBloc = _MovieList();
    whenListen(movieBloc, const Stream<MovieListState>.empty(), initialState: movies ?? ready);
    hallBloc = _HallList();
    whenListen(hallBloc, const Stream<halls.HallListState>.empty(), initialState: hallState);
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<MovieListBloc>.value(value: movieBloc),
          BlocProvider<halls.HallListBloc>.value(value: hallBloc),
          BlocProvider<ShowingCubit>.value(value: showing ?? showingStub(movies: showingMovies)),
        ],
        child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {}, onRefresh: onRefresh)),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('200 halls: only the rows near the screen are built', (tester) async {
    final many = [
      for (var i = 1; i <= 200; i++)
        Hall(id: i, name: 'Hall $i', cinemaId: 'c${i ~/ 10}', cinemaName: 'Cinema ${i ~/ 10}', totalSeats: 60),
    ];
    await pump(tester, hallState: halls.HallListState.ready(many));
    await tester.scrollUntilVisible(find.byKey(const Key('hall.1')), 300, scrollable: find.byType(Scrollable).first);

    final built = find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key! as ValueKey<String>).value.startsWith('hall-'));
    expect(built.evaluate().length, lessThan(30));
    expect(find.byKey(const Key('hall.200')), findsNothing);
  });

  testWidgets('a movie failure is an inline Retry; Showing and the halls stay', (tester) async {
    await pump(
      tester,
      movies: const MovieListState.failure(tab: MovieTab.nowShowing, search: '', failure: ApiFailure.server(status: 500, message: 'Down')),
      hallState: const halls.HallListState.ready([Hall(id: 7, name: 'Hall 7', cinemaId: 'c', cinemaName: 'C')]),
    );

    expect(find.byKey(const Key('home.movies.failure')), findsOneWidget);
    expect(find.byKey(const Key('section.showing')), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const Key('hall.7')), 300, scrollable: find.byType(Scrollable).first);

    await tester.scrollUntilVisible(find.byKey(const Key('home.movies.retry')), -300,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byKey(const Key('home.movies.retry')));
    verify(() => movieBloc.add(any(that: isA<RefreshRequested>()))).called(1);
  });

  testWidgets('one pull reloads every section and waits for the last one', (tester) async {
    final showing = showingStub(movies: showingMovies);
    final shell = Completer<void>();
    var shellCalls = 0;
    await pump(tester, showing: showing, onRefresh: () {
      shellCalls++;
      return shell.future;
    });

    await tester.fling(find.byType(Scrollable).first, const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final movieRefresh = verify(() => movieBloc.add(captureAny(that: isA<RefreshRequested>()))).captured.single
        as RefreshRequested;
    final hallRefresh = verify(() => hallBloc.add(captureAny(that: isA<halls.RefreshRequested>()))).captured.single
        as halls.RefreshRequested;
    verify(showing.load).called(1);
    expect(shellCalls, 1);
    expect(find.byType(RefreshProgressIndicator), findsOneWidget, reason: 'still waiting');

    movieRefresh.done!.complete();
    hallRefresh.done!.complete();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(RefreshProgressIndicator), findsOneWidget, reason: 'the shell has not settled yet');

    shell.complete();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(RefreshProgressIndicator), findsNothing);
  });

  testWidgets('saved times are shown but cannot be booked offline', (tester) async {
    await pump(
      tester,
      showing: showingStub(
        state: ShowingState.ready(
          dates: showingDates,
          date: showingDates.first,
          movies: showingMovies,
          savedAt: DateTime(2026, 10, 7, 18, 40),
        ),
      ),
    );

    expect(find.byKey(const Key('showing.offline')), findsOneWidget);
    final chip = tester.widget<ChoiceChip>(
      find.descendant(of: find.byKey(const Key('showing.slot.101')), matching: find.byType(ChoiceChip)),
    );
    expect(chip.onSelected, isNull);
  });
}
