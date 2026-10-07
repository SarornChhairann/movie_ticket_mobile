import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/motion/poster_hero.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/core/telemetry/journey_tracker.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' as halls;
import 'package:movie_ticket_mobile/features/catalog/controller/hall_schedule_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_detail_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_cubit.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_state.dart';
import 'package:movie_ticket_mobile/features/shell/model/home_summary.dart';
import 'package:movie_ticket_mobile/features/shell/model/shell_repository.dart';

import 'hall_fixtures.dart';

class _Catalog extends Mock implements CatalogRepository {}

class _Halls extends Mock implements HallRepository {}

class _Shell extends Mock implements ShellRepository {}

class _Recorder implements JourneyTracker {
  final events = <JourneyEvent>[];

  @override
  void track(JourneyEvent event) => events.add(event);
}

/// Sprint 21: saved copies reach the state, refresh can be awaited, and every
/// Home entry point says where it came from.
void main() {
  final savedAt = DateTime(2026, 10, 7, 18, 40);
  const dune = Movie(id: 1, title: 'Dune', comingSoon: false);

  setUpAll(() {
    registerFallbackValue(MovieTab.nowShowing);
    registerFallbackValue(DateTime(2026));
  });

  group('saved copies', () {
    test('movies: the saved time reaches the ready state', () async {
      final catalog = _Catalog();
      when(() => catalog.fetchMovies(any(), search: any(named: 'search')))
          .thenAnswer((_) async => Ok(const [dune], savedAt: savedAt));
      final bloc = MovieListBloc(catalog)..add(const RefreshRequested());

      final ready = await bloc.stream.firstWhere((s) => s is MovieListReady) as MovieListReady;
      expect(ready.savedAt, savedAt);
      await bloc.close();
    });

    test('halls: the saved time reaches the ready state', () async {
      final repo = _Halls();
      when(repo.fetchHalls).thenAnswer((_) async => Ok(testHalls, savedAt: savedAt));
      final bloc = halls.HallListBloc(repo)..add(const halls.LoadRequested());

      final ready = await bloc.stream.firstWhere((s) => s is halls.HallListReady) as halls.HallListReady;
      expect(ready.savedAt, savedAt);
      await bloc.close();
    });

    blocTest<ShellCubit, ShellState>(
      'shell: a saved home is ready with its time (Home shows the offline note)',
      build: () {
        final repo = _Shell();
        when(repo.fetchHome).thenAnswer(
          (_) async => Ok(const HomeSummary(nowShowingCount: 0, comingSoonCount: 0, cinemaCount: 0), savedAt: savedAt),
        );
        return ShellCubit(repo);
      },
      act: (c) => c.pingRequested(),
      expect: () => [
        const ShellState.loading(),
        ShellState.ready(const HomeSummary(nowShowingCount: 0, comingSoonCount: 0, cinemaCount: 0), savedAt: savedAt),
      ],
    );

    test('Showing: an offline day with nothing saved does not look ahead over the network', () async {
      final catalog = _Catalog();
      final day = DateTime(2026, 10, 7);
      when(() => catalog.fetchShowing(day)).thenAnswer((_) async => Ok(const [], savedAt: savedAt));
      final cubit = ShowingCubit(catalog, now: () => DateTime(2026, 10, 7, 12));

      await cubit.load();

      expect(cubit.state, isA<ShowingReady>().having((s) => s.savedAt, 'savedAt', savedAt));
      verify(() => catalog.fetchShowing(any())).called(1);
      await cubit.close();
    });
  });

  group('pull to refresh can be awaited', () {
    test('movies complete the refresh when the load settles, also on failure', () async {
      final catalog = _Catalog();
      final answer = Completer<Result<List<Movie>, ApiFailure>>();
      when(() => catalog.fetchMovies(any(), search: any(named: 'search'))).thenAnswer((_) => answer.future);
      final bloc = MovieListBloc(catalog);
      final done = Completer<void>();

      bloc.add(RefreshRequested(done));
      await pumpEventQueue();
      expect(done.isCompleted, isFalse);

      answer.complete(const Err(ApiFailure.network()));
      await done.future.timeout(const Duration(seconds: 1));
      await bloc.close();
    });

    test('halls complete the refresh even when nothing changes', () async {
      final repo = _Halls();
      when(repo.fetchHalls).thenAnswer((_) async => const Ok(testHalls));
      final bloc = halls.HallListBloc(repo)..add(const halls.LoadRequested());
      await bloc.stream.firstWhere((s) => s is halls.HallListReady);
      final done = Completer<void>();

      // Same halls: the bloc emits nothing, the refresh still settles.
      bloc.add(halls.RefreshRequested(done));
      await done.future.timeout(const Duration(seconds: 1));
      await bloc.close();
    });
  });

  group('telemetry', () {
    test('home_viewed comes from the shell, never from loading the catalog', () async {
      final recorder = _Recorder();
      ShellCubit(_Shell(), tracker: recorder).homeViewed();
      expect(recorder.events.map((e) => e.name), [JourneyEventName.homeViewed]);
    });

    test('each Home surface opens a movie with its source', () {
      String? source(HeroSource s) => MovieDetailArgs(movieId: 1, heroSource: s).trackingSource;
      expect(
        {for (final s in HeroSource.values) s: source(s)},
        {
          HeroSource.featured: 'hero',
          HeroSource.showing: 'showing',
          HeroSource.nowShowing: 'now',
          HeroSource.carousel: 'comingSoon',
          HeroSource.explore: 'explore',
          // Sprint 22.
          HeroSource.recent: 'recent',
          HeroSource.search: 'search',
        },
      );
      expect(const MovieDetailArgs(movieId: 1, source: 'hall').trackingSource, 'hall');
      expect(const MovieDetailArgs(movieId: 1).trackingSource, isNull);
    });

    test('movie_opened carries the source; a detail showtime says detail', () async {
      final catalog = _Catalog();
      final date = DateTime(2026, 10, 7);
      when(() => catalog.fetchDetail(1, date: any(named: 'date'))).thenAnswer((_) async => Ok(MovieDetail(
            movie: dune,
            availableDates: [date],
            selectedDate: date,
            cinemas: const [],
          )));
      final recorder = _Recorder();
      final bloc = MovieDetailBloc(catalog, tracker: recorder)..add(const DetailRequested(1, source: 'now'));
      await bloc.stream.firstWhere((s) => s is MovieDetailReady);
      bloc.add(const ShowtimeSelected(50));
      await pumpEventQueue();

      expect(recorder.events.map((e) => e.props), [
        {'movieId': 1, 'source': 'now'},
        {'movieId': 1, 'showtimeId': 50, 'source': 'detail'},
      ]);
      await bloc.close();
    });

    test('a hall schedule time is tracked with source hall', () async {
      final recorder = _Recorder();
      final bloc = HallScheduleBloc(_Halls(), tracker: recorder)..add(const ShowtimeChosen(movieId: 1, showtimeId: 50));
      await pumpEventQueue();

      expect(recorder.events.single.name, JourneyEventName.showtimeSelected);
      expect(recorder.events.single.props, {'movieId': 1, 'showtimeId': 50, 'source': 'hall'});
      await bloc.close();
    });
  });
}
