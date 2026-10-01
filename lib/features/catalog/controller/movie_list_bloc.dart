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

final class TabChanged extends MovieListEvent {
  const TabChanged(this.tab);

  final MovieTab tab;
}

final class SearchChanged extends MovieListEvent {
  const SearchChanged(this.query);

  final String query;
}

final class RefreshRequested extends MovieListEvent {
  const RefreshRequested();
}

@freezed
sealed class MovieListState with _$MovieListState {
  const factory MovieListState.initial({
    @Default(MovieTab.nowShowing) MovieTab tab,
    @Default('') String search,
  }) = MovieListInitial;

  const factory MovieListState.loading({required MovieTab tab, required String search}) =
      MovieListLoading;

  const factory MovieListState.ready({
    required MovieTab tab,
    required String search,
    required List<Movie> movies,
  }) = MovieListReady;

  const factory MovieListState.failure({
    required MovieTab tab,
    required String search,
    required ApiFailure failure,
  }) = MovieListFailure;
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc(this._repository) : super(const MovieListState.initial()) {
    on<TabChanged>((event, emit) => _load(emit, tab: event.tab));
    on<SearchChanged>(
      (event, emit) => _load(emit, search: event.query),
      transformer: debounce(searchDebounce),
    );
    on<RefreshRequested>((_, emit) => _load(emit));
  }

  static const searchDebounce = Duration(milliseconds: 300);

  final CatalogRepository _repository;

  Future<void> _load(Emitter<MovieListState> emit, {MovieTab? tab, String? search}) async {
    final t = tab ?? state.tab;
    final q = search ?? state.search;
    emit(MovieListState.loading(tab: t, search: q));
    emit(switch (await _repository.fetchMovies(t, search: q)) {
      Ok(:final value) => MovieListState.ready(tab: t, search: q, movies: value),
      Err(:final failure) => MovieListState.failure(tab: t, search: q, failure: failure),
    });
  }
}
