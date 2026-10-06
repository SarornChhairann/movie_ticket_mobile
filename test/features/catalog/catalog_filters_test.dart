import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' as halls;
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';

import 'hall_fixtures.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

class _MockHallRepository extends Mock implements HallRepository {}

/// Sprint 11: movie filters (genre, language, rating) and hall filters (city,
/// type, Dolby, ScreenX) are applied in memory; none of them calls the API.
void main() {
  const dune = Movie(id: 1, title: 'Dune', comingSoon: false, genre: 'Sci-Fi', language: 'English', rating: 'PG-13');
  const heat = Movie(id: 2, title: 'Heat', comingSoon: false, genre: 'Crime', language: 'English', rating: 'R');
  const tum = Movie(id: 3, title: 'Tum', comingSoon: false, genre: 'Sci-Fi', language: ' Khmer ', rating: 'PG-13');
  const soon = Movie(id: 4, title: 'Soon', comingSoon: true, genre: 'Crime', language: 'Khmer', rating: 'G');

  MovieListReady ready({String search = '', String? genre, String? language, String? rating}) => MovieListReady(
        tab: MovieTab.nowShowing,
        search: search,
        genre: genre,
        language: language,
        rating: rating,
        nowShowing: const [dune, heat, tum],
        comingSoon: const [soon],
      );

  group('moviesFor', () {
    test('genre AND language AND rating, each an exact trim match', () {
      expect(ready(genre: 'Sci-Fi').moviesFor(MovieTab.nowShowing), [dune, tum]);
      expect(ready(genre: 'Sci-Fi', language: 'Khmer').moviesFor(MovieTab.nowShowing), [tum]);
      expect(ready(language: 'English', rating: 'R').moviesFor(MovieTab.nowShowing), [heat]);
      expect(ready(genre: 'Crime', rating: 'PG-13').moviesFor(MovieTab.nowShowing), isEmpty);
      expect(ready(language: 'Khmer').moviesFor(MovieTab.comingSoon), [soon]);
    });

    test('a null field removes nothing; search results are whatever the ready list holds', () {
      expect(ready().moviesFor(MovieTab.nowShowing), [dune, heat, tum]);
      expect(ready(search: 'zzz').moviesFor(MovieTab.nowShowing), [dune, heat, tum]);
    });

    test('choices are distinct, trimmed, A–Z ignoring case; a selection survives a search', () {
      expect(ready().languages, ['English', 'Khmer']);
      expect(ready().ratings, ['G', 'PG-13', 'R']);
      const empty = MovieListReady(
          tab: MovieTab.nowShowing, search: 'zzz', language: 'Thai', nowShowing: [], comingSoon: []);
      expect(empty.languages, ['Thai']);
    });

    test('active filter count is the movie fields that are not All', () {
      expect(ready().activeFilterCount, 0);
      expect(ready(genre: 'Crime', rating: 'R').activeFilterCount, 2);
    });
  });

  group('MovieListBloc filters', () {
    late _MockCatalogRepository repository;
    setUpAll(() => registerFallbackValue(MovieTab.nowShowing));
    setUp(() => repository = _MockCatalogRepository());

    blocTest<MovieListBloc, MovieListState>(
      'language and rating apply without calling the repository',
      build: () => MovieListBloc(repository),
      seed: ready,
      act: (bloc) => bloc
        ..add(const LanguageSelected('Khmer'))
        ..add(const RatingSelected('PG-13')),
      expect: () => [ready(language: 'Khmer'), ready(language: 'Khmer', rating: 'PG-13')],
      verify: (_) => verifyZeroInteractions(repository),
    );

    blocTest<MovieListBloc, MovieListState>(
      'clear resets genre, language, and rating and keeps the search',
      build: () => MovieListBloc(repository),
      seed: () => ready(search: 'du', genre: 'Sci-Fi', language: 'English', rating: 'PG-13'),
      act: (bloc) => bloc.add(const MovieFiltersCleared()),
      expect: () => [ready(search: 'du')],
      verify: (_) => verifyZeroInteractions(repository),
    );

    blocTest<MovieListBloc, MovieListState>(
      'a refresh keeps the language and rating',
      setUp: () => when(() => repository.fetchMovies(any(), search: any(named: 'search')))
          .thenAnswer((_) async => const Ok([dune])),
      build: () => MovieListBloc(repository),
      seed: () => ready(language: 'English', rating: 'R'),
      act: (bloc) => bloc.add(const RefreshRequested()),
      expect: () => [
        const MovieListReady(
            tab: MovieTab.nowShowing,
            search: '',
            language: 'English',
            rating: 'R',
            nowShowing: [dune],
            comingSoon: [dune]),
      ],
    );
  });

  group('filterHalls', () {
    test('search plus city, type, Dolby, and ScreenX', () {
      expect(filterHalls(testHalls, '', city: 'សៀមរាប').map((h) => h.id), [3]);
      expect(filterHalls(testHalls, '', type: 'STANDARD').map((h) => h.id), [2]);
      expect(filterHalls(testHalls, '', dolbyOnly: true).map((h) => h.id), [1]);
      expect(filterHalls(testHalls, '', screenXOnly: true).map((h) => h.id), [3]);
      expect(filterHalls(testHalls, 'legend', city: 'ភ្នំពេញ', type: 'ATMOS').map((h) => h.id), [1]);
      expect(filterHalls(testHalls, 'major', dolbyOnly: true), isEmpty);
      expect(filterHalls(testHalls, ''), testHalls);
    });
  });

  group('HallListBloc filters', () {
    late _MockHallRepository repository;
    setUp(() => repository = _MockHallRepository());

    blocTest<halls.HallListBloc, halls.HallListState>(
      'city, type, Dolby, and ScreenX change state without a refetch; clear resets them',
      build: () => halls.HallListBloc(repository),
      seed: () => const halls.HallListState.ready(testHalls),
      act: (bloc) => bloc
        ..add(const halls.HallCitySelected('ភ្នំពេញ'))
        ..add(const halls.HallTypeSelected('ATMOS'))
        ..add(const halls.HallDolbyToggled())
        ..add(const halls.HallScreenXToggled())
        ..add(const halls.HallFiltersCleared()),
      expect: () => const [
        halls.HallListState.ready(testHalls, city: 'ភ្នំពេញ'),
        halls.HallListState.ready(testHalls, city: 'ភ្នំពេញ', type: 'ATMOS'),
        halls.HallListState.ready(testHalls, city: 'ភ្នំពេញ', type: 'ATMOS', dolbyOnly: true),
        halls.HallListState.ready(testHalls, city: 'ភ្នំពេញ', type: 'ATMOS', dolbyOnly: true, screenXOnly: true),
        halls.HallListState.ready(testHalls),
      ],
      verify: (_) => verifyZeroInteractions(repository),
    );

    test('choices and active count come from the loaded halls', () {
      const state = halls.HallListState.ready(testHalls, type: 'IMAX', dolbyOnly: true);
      expect(state.types, ['ATMOS', 'IMAX', 'STANDARD']);
      expect(state.cities, ['ភ្នំពេញ', 'សៀមរាប']);
      expect(state.activeFilterCount, 2);
    });

    blocTest<halls.HallListBloc, halls.HallListState>(
      'filters chosen before the first load survive it',
      setUp: () => when(() => repository.fetchHalls()).thenAnswer((_) async => const Ok(testHalls)),
      build: () => halls.HallListBloc(repository),
      act: (bloc) => bloc
        ..add(const halls.HallDolbyToggled())
        ..add(const halls.LoadRequested()),
      expect: () => const [
        halls.HallListState.initial(dolbyOnly: true),
        halls.HallListState.loading(dolbyOnly: true),
        halls.HallListState.ready(testHalls, dolbyOnly: true),
      ],
    );
  });
}
