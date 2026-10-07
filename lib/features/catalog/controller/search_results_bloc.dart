import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/bloc/debounce.dart';
import '../../../core/network/result.dart';
import '../model/catalog_repository.dart';
import '../model/hall.dart';
import '../model/local_prefs_store.dart';
import '../model/movie.dart';
import 'movie_list_bloc.dart' show MovieListBloc;

part 'search_results_bloc.freezed.dart';

/// What Home had loaded when the search opened; results start from it.
class SearchSeed {
  const SearchSeed({this.nowShowing = const [], this.comingSoon = const [], this.halls = const []});

  final List<Movie> nowShowing;
  final List<Movie> comingSoon;
  final List<Hall> halls;
}

sealed class SearchResultsEvent {
  const SearchResultsEvent();
}

/// Opens the view: reads the recent searches.
final class SearchOpened extends SearchResultsEvent {
  const SearchOpened();
}

final class SearchQueryChanged extends SearchResultsEvent {
  const SearchQueryChanged(this.query);

  final String query;
}

/// The keyboard's search key, a result tapped, or a recent search re-run:
/// the query is remembered as a recent search.
final class SearchCommitted extends SearchResultsEvent {
  const SearchCommitted();
}

final class RecentSearchesCleared extends SearchResultsEvent {
  const RecentSearchesCleared();
}

final class _ServerSearchRequested extends SearchResultsEvent {
  const _ServerSearchRequested(this.query);

  final String query;
}

@freezed
abstract class SearchResultsState with _$SearchResultsState {
  const SearchResultsState._();

  const factory SearchResultsState({
    @Default('') String query,
    @Default([]) List<String> recent,
    @Default([]) List<Movie> nowShowing,
    @Default([]) List<Movie> comingSoon,
    @Default([]) List<Hall> halls,

    /// The server search for [query] has not answered yet.
    @Default(false) bool searching,
  }) = _SearchResultsState;

  bool get hasQuery => query.trim().isNotEmpty;

  /// Now showing first, then coming soon.
  List<Movie> get movies => [...nowShowing, ...comingSoon];

  /// A query with nothing to show, and nothing more on the way.
  bool get isEmpty => hasQuery && !searching && movies.isEmpty && halls.isEmpty;
}

/// Home's search results view (sprint 22, H4). Its own state, so Home's rails
/// are never filtered: movies match on title in what Home loaded at once, then
/// the debounced `GET /movies?tab=&search=` answer replaces them; halls match
/// name, cinema, or city client-side.
class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  SearchResultsBloc(this._repository, this._store, this._seed) : super(const SearchResultsState()) {
    on<SearchOpened>((_, emit) async => emit(state.copyWith(recent: (await _store.read()).recentSearches)));
    on<SearchQueryChanged>(_onQueryChanged);
    on<_ServerSearchRequested>(_onServerSearch, transformer: debounce(MovieListBloc.searchDebounce));
    on<SearchCommitted>((_, emit) async {
      if (!state.hasQuery) return;
      await _store.addRecentSearch(state.query);
      emit(state.copyWith(recent: (await _store.read()).recentSearches));
    });
    on<RecentSearchesCleared>((_, emit) async {
      await _store.clearRecentSearches();
      emit(state.copyWith(recent: const []));
    });
  }

  final CatalogRepository _repository;
  final LocalPrefsStore _store;
  final SearchSeed _seed;

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchResultsState> emit) {
    final q = event.query.trim().toLowerCase();
    if (q.isEmpty) {
      emit(state.copyWith(query: event.query, nowShowing: const [], comingSoon: const [], halls: const [], searching: false));
      return;
    }
    bool hit(Movie m) => m.title.toLowerCase().contains(q);
    emit(state.copyWith(
      query: event.query,
      nowShowing: _seed.nowShowing.where(hit).toList(),
      comingSoon: _seed.comingSoon.where(hit).toList(),
      halls: filterHalls(_seed.halls, q),
      searching: true,
    ));
    add(_ServerSearchRequested(event.query));
  }

  Future<void> _onServerSearch(_ServerSearchRequested event, Emitter<SearchResultsState> emit) async {
    final q = event.query.trim();
    final (now, soon) = await (
      _repository.fetchMovies(MovieTab.nowShowing, search: q),
      _repository.fetchMovies(MovieTab.comingSoon, search: q),
    ).wait;
    // A newer query was typed meanwhile: its own request will answer.
    if (state.query != event.query) return;
    emit(state.copyWith(
      // A failed list keeps the title matches from what Home loaded.
      nowShowing: switch (now) {
        Ok(:final value) => value,
        Err() => state.nowShowing,
      },
      comingSoon: switch (soon) {
        Ok(:final value) => value,
        Err() => state.comingSoon,
      },
      searching: false,
    ));
  }
}
