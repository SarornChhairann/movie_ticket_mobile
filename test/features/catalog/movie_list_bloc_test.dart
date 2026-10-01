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
  const dune = Movie(id: 1, title: 'Dune', comingSoon: false);
  const avatar = Movie(id: 2, title: 'Avatar 3', comingSoon: true);

  setUpAll(() => registerFallbackValue(MovieTab.nowShowing));
  setUp(() => repository = _MockCatalogRepository());

  void stubMovies(List<Movie> movies) => when(() => repository.fetchMovies(any(), search: any(named: 'search')))
      .thenAnswer((_) async => Ok(movies));

  blocTest<MovieListBloc, MovieListState>(
    'refresh loads now showing',
    setUp: () => stubMovies([dune]),
    build: () => MovieListBloc(repository),
    act: (bloc) => bloc.add(const RefreshRequested()),
    expect: () => const [
      MovieListState.loading(tab: MovieTab.nowShowing, search: ''),
      MovieListState.ready(tab: MovieTab.nowShowing, search: '', movies: [dune]),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'empty result is ready with no movies',
    setUp: () => stubMovies([]),
    build: () => MovieListBloc(repository),
    act: (bloc) => bloc.add(const RefreshRequested()),
    expect: () => const [
      MovieListState.loading(tab: MovieTab.nowShowing, search: ''),
      MovieListState.ready(tab: MovieTab.nowShowing, search: '', movies: []),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'failure keeps tab and search',
    setUp: () => when(() => repository.fetchMovies(any(), search: any(named: 'search')))
        .thenAnswer((_) async => const Err(ApiFailure.network())),
    build: () => MovieListBloc(repository),
    act: (bloc) => bloc.add(const RefreshRequested()),
    expect: () => const [
      MovieListState.loading(tab: MovieTab.nowShowing, search: ''),
      MovieListState.failure(tab: MovieTab.nowShowing, search: '', failure: ApiFailure.network()),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'tab switch reloads coming soon',
    setUp: () => stubMovies([avatar]),
    build: () => MovieListBloc(repository),
    act: (bloc) => bloc.add(const TabChanged(MovieTab.comingSoon)),
    expect: () => const [
      MovieListState.loading(tab: MovieTab.comingSoon, search: ''),
      MovieListState.ready(tab: MovieTab.comingSoon, search: '', movies: [avatar]),
    ],
    verify: (_) => verify(() => repository.fetchMovies(MovieTab.comingSoon, search: '')).called(1),
  );

  blocTest<MovieListBloc, MovieListState>(
    'typing quickly sends one search request after the debounce',
    setUp: () => stubMovies([dune]),
    build: () => MovieListBloc(repository),
    act: (bloc) => bloc
      ..add(const SearchChanged('d'))
      ..add(const SearchChanged('du'))
      ..add(const SearchChanged('dune')),
    wait: MovieListBloc.searchDebounce + const Duration(milliseconds: 100),
    expect: () => const [
      MovieListState.loading(tab: MovieTab.nowShowing, search: 'dune'),
      MovieListState.ready(tab: MovieTab.nowShowing, search: 'dune', movies: [dune]),
    ],
    verify: (_) {
      verify(() => repository.fetchMovies(MovieTab.nowShowing, search: 'dune')).called(1);
      verifyNever(() => repository.fetchMovies(any(), search: 'd'));
    },
  );
}
