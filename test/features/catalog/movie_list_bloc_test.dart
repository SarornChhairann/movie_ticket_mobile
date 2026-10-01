import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late _MockCatalogRepository repository;
  const dune = Movie(id: 1, title: 'Dune', comingSoon: false, genre: 'Science fiction');
  const heat = Movie(id: 3, title: 'Heat', comingSoon: false, genre: 'Crime');
  const avatar = Movie(id: 2, title: 'Avatar 3', comingSoon: true, genre: 'Science fiction');

  setUpAll(() => registerFallbackValue(MovieTab.nowShowing));
  setUp(() => repository = _MockCatalogRepository());

  void stubBoth({List<Movie> now = const [dune, heat], List<Movie> soon = const [avatar]}) {
    when(() => repository.fetchMovies(MovieTab.nowShowing, search: any(named: 'search')))
        .thenAnswer((_) async => Ok(now));
    when(() => repository.fetchMovies(MovieTab.comingSoon, search: any(named: 'search')))
        .thenAnswer((_) async => Ok(soon));
  }

  MovieListReady ready({String search = '', String? genre, MovieTab tab = MovieTab.nowShowing}) => MovieListReady(
        tab: tab,
        search: search,
        genre: genre,
        nowShowing: const [dune, heat],
        comingSoon: const [avatar],
      );

  blocTest<MovieListBloc, MovieListState>(
    'refresh loads both rails at once',
    setUp: stubBoth,
    build: () => MovieListBloc(repository),
    act: (bloc) => bloc.add(const RefreshRequested()),
    expect: () => [const MovieListState.loading(tab: MovieTab.nowShowing, search: ''), ready()],
    verify: (_) {
      verify(() => repository.fetchMovies(MovieTab.nowShowing, search: '')).called(1);
      verify(() => repository.fetchMovies(MovieTab.comingSoon, search: '')).called(1);
    },
  );

  blocTest<MovieListBloc, MovieListState>(
    'a refresh with lists on screen keeps them instead of a spinner',
    setUp: () => stubBoth(now: const [dune]),
    build: () => MovieListBloc(repository),
    seed: ready,
    act: (bloc) => bloc.add(const RefreshRequested()),
    expect: () => [ready().copyWith(nowShowing: const [dune])],
  );

  blocTest<MovieListBloc, MovieListState>(
    'either list failing is a failure that keeps tab and search',
    setUp: () {
      stubBoth();
      when(() => repository.fetchMovies(MovieTab.comingSoon, search: any(named: 'search')))
          .thenAnswer((_) async => const Err(ApiFailure.network()));
    },
    build: () => MovieListBloc(repository),
    act: (bloc) => bloc.add(const RefreshRequested()),
    expect: () => const [
      MovieListState.loading(tab: MovieTab.nowShowing, search: ''),
      MovieListState.failure(tab: MovieTab.nowShowing, search: '', failure: ApiFailure.network()),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'tab switch is local: no refetch',
    build: () => MovieListBloc(repository),
    seed: ready,
    act: (bloc) => bloc.add(const TabChanged(MovieTab.comingSoon)),
    expect: () => [ready(tab: MovieTab.comingSoon)],
    verify: (bloc) {
      expect(bloc.state.visible, [avatar]);
      verifyNever(() => repository.fetchMovies(any(), search: any(named: 'search')));
    },
  );

  group('genres', () {
    test('are the distinct genres the API returned, with no hard-coded ones', () {
      expect(ready().genres, ['Crime', 'Science fiction']);
    });

    blocTest<MovieListBloc, MovieListState>(
      'selecting a genre hides non-matching titles on both rails; All clears it',
      build: () => MovieListBloc(repository),
      seed: ready,
      act: (bloc) => bloc
        ..add(const GenreSelected('Crime'))
        ..add(const GenreSelected(null)),
      expect: () => [ready(genre: 'Crime'), ready()],
      verify: (_) {
        expect(ready(genre: 'Crime').moviesFor(MovieTab.nowShowing), [heat]);
        expect(ready(genre: 'Crime').moviesFor(MovieTab.comingSoon), isEmpty);
        verifyNever(() => repository.fetchMovies(any(), search: any(named: 'search')));
      },
    );

    test('a selected genre stays in the list even when a search no longer returns it', () {
      const state = MovieListReady(
        tab: MovieTab.nowShowing,
        search: 'zzz',
        genre: 'Crime',
        nowShowing: [],
        comingSoon: [],
      );
      expect(state.genres, ['Crime']);
    });
  });

  blocTest<MovieListBloc, MovieListState>(
    'typing quickly sends one search per list after the debounce',
    setUp: stubBoth,
    build: () => MovieListBloc(repository),
    act: (bloc) => bloc
      ..add(const SearchChanged('d'))
      ..add(const SearchChanged('du'))
      ..add(const SearchChanged('dune')),
    wait: MovieListBloc.searchDebounce + const Duration(milliseconds: 100),
    expect: () => [const MovieListState.loading(tab: MovieTab.nowShowing, search: 'dune'), ready(search: 'dune')],
    verify: (_) {
      verify(() => repository.fetchMovies(MovieTab.nowShowing, search: 'dune')).called(1);
      verifyNever(() => repository.fetchMovies(any(), search: 'd'));
    },
  );
}
