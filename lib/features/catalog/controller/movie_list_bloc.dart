import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/bloc/debounce.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../model/catalog_repository.dart';
import '../model/movie.dart';

part 'movie_list_bloc.freezed.dart';

sealed class MovieListEvent {
  const MovieListEvent();
}

/// Explore's active list. Both lists are already loaded, so this does not refetch.
final class TabChanged extends MovieListEvent {
  const TabChanged(this.tab);

  final MovieTab tab;
}

final class SearchChanged extends MovieListEvent {
  const SearchChanged(this.query);

  final String query;
}

/// Filters by one of the genres present on the loaded movies; `null` is All.
/// Client-side only: there is no genre endpoint.
final class GenreSelected extends MovieListEvent {
  const GenreSelected(this.genre);

  final String? genre;
}

final class RefreshRequested extends MovieListEvent {
  const RefreshRequested();
}

/// Home shows both rails and Explore shows [tab]; both share search and genre.
@freezed
sealed class MovieListState with _$MovieListState {
  const MovieListState._();

  const factory MovieListState.initial({
    @Default(MovieTab.nowShowing) MovieTab tab,
    @Default('') String search,
    String? genre,
  }) = MovieListInitial;

  const factory MovieListState.loading({required MovieTab tab, required String search, String? genre}) =
      MovieListLoading;

  const factory MovieListState.ready({
    required MovieTab tab,
    required String search,
    String? genre,
    required List<Movie> nowShowing,
    required List<Movie> comingSoon,
  }) = MovieListReady;

  const factory MovieListState.failure({
    required MovieTab tab,
    required String search,
    String? genre,
    required ApiFailure failure,
  }) = MovieListFailure;

  /// [t]'s movies after the genre filter; empty until loaded.
  List<Movie> moviesFor(MovieTab t) {
    final s = this;
    if (s is! MovieListReady) return const [];
    final all = t == MovieTab.nowShowing ? s.nowShowing : s.comingSoon;
    final g = genre;
    return g == null ? all : all.where((m) => m.genre?.trim() == g).toList();
  }

  /// Explore's list.
  List<Movie> get visible => moviesFor(tab);

  /// Distinct genres on the loaded movies, sorted; the selected one is kept
  /// even if a new search no longer returns it, so it can be cleared.
  List<String> get genres {
    final s = this;
    if (s is! MovieListReady) return genre == null ? const [] : [genre!];
    final set = <String>{
      for (final m in [...s.nowShowing, ...s.comingSoon])
        if (m.genre != null && m.genre!.trim().isNotEmpty) m.genre!.trim(),
      ?genre,
    };
    return set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc(this._repository) : super(const MovieListState.initial()) {
    on<TabChanged>((event, emit) => emit(state.copyWith(tab: event.tab)));
    on<GenreSelected>((event, emit) => emit(state.copyWith(genre: event.genre)));
    on<SearchChanged>(
      (event, emit) => _load(emit, search: event.query),
      transformer: debounce(searchDebounce),
    );
    on<RefreshRequested>((_, emit) => _load(emit));
  }

  static const searchDebounce = Duration(milliseconds: 300);

  final CatalogRepository _repository;

  /// Loads both lists. The spinner only shows before the first result; later
  /// loads keep the current lists on screen.
  Future<void> _load(Emitter<MovieListState> emit, {String? search}) async {
    final q = search ?? state.search;
    if (state is! MovieListReady) {
      emit(MovieListState.loading(tab: state.tab, search: q, genre: state.genre));
    }
    final (now, soon) = await (
      _repository.fetchMovies(MovieTab.nowShowing, search: q),
      _repository.fetchMovies(MovieTab.comingSoon, search: q),
    ).wait;
    // Tab and genre are read now: they may have changed while loading.
    emit(switch ((now, soon)) {
      (Ok(value: final n), Ok(value: final c)) =>
        MovieListState.ready(tab: state.tab, search: q, genre: state.genre, nowShowing: n, comingSoon: c),
      (Err(:final failure), _) || (_, Err(:final failure)) =>
        MovieListState.failure(tab: state.tab, search: q, genre: state.genre, failure: failure),
    });
  }
}
