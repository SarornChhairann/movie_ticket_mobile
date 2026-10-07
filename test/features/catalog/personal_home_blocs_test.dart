import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/favourite_halls_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/recently_viewed_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/search_results_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/local_prefs_store.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';

import 'hall_fixtures.dart';

class _Halls extends Mock implements HallRepository {}

class _Catalog extends Mock implements CatalogRepository {}

void main() {
  late Directory docs;
  late LocalPrefsStore store;

  setUpAll(() => registerFallbackValue(MovieTab.nowShowing));
  setUp(() async {
    docs = await Directory.systemTemp.createTemp('personal_home_test');
    store = LocalPrefsStore(() async => docs);
  });
  tearDown(() => docs.delete(recursive: true));

  const dune = Movie(id: 1, title: 'Dune', comingSoon: false);
  const heat = Movie(id: 2, title: 'Heat', comingSoon: false);
  const duneTwo = Movie(id: 5, title: 'Dune: Part Three', comingSoon: true);

  group('FavouriteHallsCubit', () {
    HallSchedule schedule(List<String> times) => HallSchedule(
          hall: senSokAtmos,
          availableDates: [DateTime(2026, 10, 7)],
          selectedDate: DateTime(2026, 10, 7),
          showtimes: [
            for (final (i, t) in times.indexed)
              HallShowtime(id: i, date: DateTime(2026, 10, 7), time: t, movieId: 1, movieTitle: 'Dune'),
          ],
        );

    test('toggle adds and removes through the store; another cubit follows', () async {
      final halls = _Halls();
      final home = FavouriteHallsCubit(store, halls)..load();
      final page = FavouriteHallsCubit(store, halls)..load();
      addTearDown(home.close);
      addTearDown(page.close);

      await page.toggle(1);
      await Future<void>.delayed(Duration.zero);
      expect(home.state.ids, [1]);
      expect(page.state.isFavourite(1), isTrue);

      await page.toggle(1);
      await Future<void>.delayed(Duration.zero);
      expect(home.state.ids, isEmpty);
    });

    test("Home loads each favourite's next showtime today by the cinema clock", () async {
      await store.setFavouriteHall(1, favourite: true);
      await store.setFavouriteHall(2, favourite: true);
      final halls = _Halls();
      when(() => halls.fetchSchedule(1, date: DateTime(2026, 10, 7)))
          .thenAnswer((_) async => Ok(schedule(['10:00', '21:15', '18:30'])));
      when(() => halls.fetchSchedule(2, date: DateTime(2026, 10, 7)))
          .thenAnswer((_) async => const Err(ApiFailure.network()));
      final cubit = FavouriteHallsCubit(store, halls, now: () => DateTime(2026, 10, 7, 17, 5));
      addTearDown(cubit.close);

      await cubit.load(withTimes: true);

      expect(cubit.state.ids, [1, 2]);
      expect(cubit.state.nextTimes, {1: '18:30'}, reason: 'past times skipped; unknown when the call fails');
    });

    test('a hall with nothing left today shows no time', () async {
      await store.setFavouriteHall(1, favourite: true);
      final halls = _Halls();
      when(() => halls.fetchSchedule(1, date: any(named: 'date'))).thenAnswer((_) async => Ok(schedule(['10:00'])));
      final cubit = FavouriteHallsCubit(store, halls, now: () => DateTime(2026, 10, 7, 23));
      addTearDown(cubit.close);

      await cubit.load(withTimes: true);

      expect(cubit.state.nextTimes, isEmpty);
    });
  });

  group('RecentlyViewedCubit', () {
    test('records opens newest first', () async {
      final cubit = RecentlyViewedCubit(store)..load();
      addTearDown(cubit.close);
      await cubit.viewed(1);
      await cubit.viewed(2);
      await cubit.viewed(1);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, [1, 2]);
    });

    test('the rail drops ids no longer listed and hides below two', () {
      expect(recentMovies([9, 2, 1], [dune, heat]), [heat, dune], reason: '9 is archived: dropped silently');
      expect(recentMovies([9, 1], [dune, heat]), isEmpty, reason: 'one left is not a rail');
      expect(recentMovies([], [dune, heat]), isEmpty);
    });
  });

  group('SearchResultsBloc', () {
    late _Catalog catalog;
    const seed = SearchSeed(nowShowing: [dune, heat], comingSoon: [duneTwo], halls: testHalls);

    setUp(() {
      catalog = _Catalog();
      when(() => catalog.fetchMovies(MovieTab.nowShowing, search: any(named: 'search')))
          .thenAnswer((_) async => const Ok([dune]));
      when(() => catalog.fetchMovies(MovieTab.comingSoon, search: any(named: 'search')))
          .thenAnswer((_) async => const Ok([duneTwo]));
    });

    blocTest<SearchResultsBloc, SearchResultsState>(
      'matches loaded titles and halls at once, then the debounced server answer',
      build: () => SearchResultsBloc(catalog, store, seed),
      act: (bloc) => bloc.add(const SearchQueryChanged('dune')),
      wait: const Duration(milliseconds: 400),
      expect: () => [
        const SearchResultsState(query: 'dune', nowShowing: [dune], comingSoon: [duneTwo], searching: true),
        const SearchResultsState(query: 'dune', nowShowing: [dune], comingSoon: [duneTwo]),
      ],
      verify: (_) => verify(() => catalog.fetchMovies(MovieTab.nowShowing, search: 'dune')).called(1),
    );

    blocTest<SearchResultsBloc, SearchResultsState>(
      'halls match name, cinema, or city',
      build: () => SearchResultsBloc(catalog, store, seed),
      act: (bloc) => bloc.add(const SearchQueryChanged('siem')),
      wait: const Duration(milliseconds: 400),
      setUp: () {
        when(() => catalog.fetchMovies(any(), search: any(named: 'search'))).thenAnswer((_) async => const Ok([]));
      },
      verify: (bloc) {
        expect(bloc.state.halls, [majorSiemReap]);
        expect(bloc.state.movies, isEmpty);
        expect(bloc.state.isEmpty, isFalse);
      },
    );

    blocTest<SearchResultsBloc, SearchResultsState>(
      'nothing anywhere is one empty state; typing fast asks the server once',
      setUp: () {
        when(() => catalog.fetchMovies(any(), search: any(named: 'search'))).thenAnswer((_) async => const Ok([]));
      },
      build: () => SearchResultsBloc(catalog, store, seed),
      act: (bloc) => bloc
        ..add(const SearchQueryChanged('z'))
        ..add(const SearchQueryChanged('zz'))
        ..add(const SearchQueryChanged('zzz')),
      wait: const Duration(milliseconds: 400),
      verify: (bloc) {
        expect(bloc.state.isEmpty, isTrue);
        verify(() => catalog.fetchMovies(MovieTab.nowShowing, search: any(named: 'search'))).called(1);
      },
    );

    blocTest<SearchResultsBloc, SearchResultsState>(
      'a failed server search keeps the title matches from Home',
      setUp: () {
        when(() => catalog.fetchMovies(any(), search: any(named: 'search')))
            .thenAnswer((_) async => const Err(ApiFailure.network()));
      },
      build: () => SearchResultsBloc(catalog, store, seed),
      act: (bloc) => bloc.add(const SearchQueryChanged('heat')),
      wait: const Duration(milliseconds: 400),
      verify: (bloc) {
        expect(bloc.state.nowShowing, [heat]);
        expect(bloc.state.searching, isFalse);
      },
    );

    blocTest<SearchResultsBloc, SearchResultsState>(
      'committing remembers the query; clear-all forgets every recent search',
      build: () => SearchResultsBloc(catalog, store, seed),
      act: (bloc) async {
        bloc.add(const SearchQueryChanged('dune'));
        bloc.add(const SearchCommitted());
        await Future<void>.delayed(const Duration(milliseconds: 400));
        bloc.add(const RecentSearchesCleared());
      },
      wait: const Duration(milliseconds: 100),
      verify: (bloc) async {
        expect(bloc.state.recent, isEmpty);
        expect((await store.read()).recentSearches, isEmpty);
      },
    );

    test('opening reads the saved recent searches', () async {
      await store.addRecentSearch('heat');
      final bloc = SearchResultsBloc(catalog, store, seed)..add(const SearchOpened());
      addTearDown(bloc.close);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.recent, ['heat']);
    });
  });
}
