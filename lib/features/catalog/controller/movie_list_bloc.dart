import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/telemetry/journey_tracker.dart';
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

/// Language filter on the loaded movies; `null` is All. No API call.
final class LanguageSelected extends MovieListEvent {
  const LanguageSelected(this.language);

  final String? language;
}

/// Rating filter on the loaded movies; `null` is All. No API call.
final class RatingSelected extends MovieListEvent {
  const RatingSelected(this.rating);

  final String? rating;
}

/// Sets genre, language, and rating back to All. Keeps the search; no API call.
final class MovieFiltersCleared extends MovieListEvent {
  const MovieFiltersCleared();
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
    String? language,
    String? rating,
  }) = MovieListInitial;

  const factory MovieListState.loading({
    required MovieTab tab,
    required String search,
    String? genre,
    String? language,
    String? rating,
  }) = MovieListLoading;

  const factory MovieListState.ready({
    required MovieTab tab,
    required String search,
    String? genre,
    String? language,
    String? rating,
    required List<Movie> nowShowing,
    required List<Movie> comingSoon,
  }) = MovieListReady;

  const factory MovieListState.failure({
    required MovieTab tab,
    required String search,
    String? genre,
    String? language,
    String? rating,
    required ApiFailure failure,
  }) = MovieListFailure;

  /// [t]'s movies after genre, then language, then rating (each an exact trim
  /// match; null is All). Empty until loaded.
  List<Movie> moviesFor(MovieTab t) {
    final s = this;
    if (s is! MovieListReady) return const [];
    final all = t == MovieTab.nowShowing ? s.nowShowing : s.comingSoon;
    bool matches(String? value, String? selected) => selected == null || value?.trim() == selected;
    return [
      for (final m in all)
        if (matches(m.genre, genre) && matches(m.language, language) && matches(m.rating, rating)) m,
    ];
  }

  /// Explore's list.
  List<Movie> get visible => moviesFor(tab);

  /// Distinct genres on the loaded movies, sorted; the selected one is kept
  /// even if a new search no longer returns it, so it can be cleared.
  List<String> get genres => _choices((m) => m.genre, genre);

  List<String> get languages => _choices((m) => m.language, language);

  List<String> get ratings => _choices((m) => m.rating, rating);

  /// Movie filters that are not All (for the tune badge).
  int get activeFilterCount => [genre, language, rating].where((v) => v != null).length;

  List<String> _choices(String? Function(Movie) field, String? selected) {
    final s = this;
    final set = <String>{
      if (s is MovieListReady)
        for (final m in [...s.nowShowing, ...s.comingSoon])
          if (field(m) != null && field(m)!.trim().isNotEmpty) field(m)!.trim(),
      ?selected,
    };
    return set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc(this._repository, {this._tracker = const NoopJourneyTracker()}) : super(const MovieListState.initial()) {
    on<TabChanged>((event, emit) => emit(state.copyWith(tab: event.tab)));
    on<GenreSelected>((event, emit) => emit(state.copyWith(genre: event.genre)));
    on<LanguageSelected>((event, emit) => emit(state.copyWith(language: event.language)));
    on<RatingSelected>((event, emit) => emit(state.copyWith(rating: event.rating)));
    on<MovieFiltersCleared>((_, emit) => emit(state.copyWith(genre: null, language: null, rating: null)));
    on<SearchChanged>(
      (event, emit) => _load(emit, search: event.query),
      transformer: debounce(searchDebounce),
    );
    on<RefreshRequested>((_, emit) {
      _tracker.track(JourneyEvent(JourneyEventName.homeViewed));
      return _load(emit);
    });
  }

  static const searchDebounce = Duration(milliseconds: 300);

  final JourneyTracker _tracker;
  final CatalogRepository _repository;

  /// Loads both lists. The spinner only shows before the first result; later
  /// loads keep the current lists on screen.
  Future<void> _load(Emitter<MovieListState> emit, {String? search}) async {
    final q = search ?? state.search;
    if (state is! MovieListReady) {
      emit(MovieListState.loading(
          tab: state.tab, search: q, genre: state.genre, language: state.language, rating: state.rating));
    }
    final (now, soon) = await (
      _repository.fetchMovies(MovieTab.nowShowing, search: q),
      _repository.fetchMovies(MovieTab.comingSoon, search: q),
    ).wait;
    // Tab and filters are read now: they may have changed while loading.
    emit(switch ((now, soon)) {
      (Ok(value: final n), Ok(value: final c)) => MovieListState.ready(
          tab: state.tab,
          search: q,
          genre: state.genre,
          language: state.language,
          rating: state.rating,
          nowShowing: n,
          comingSoon: c),
      (Err(:final failure), _) || (_, Err(:final failure)) => MovieListState.failure(
          tab: state.tab,
          search: q,
          genre: state.genre,
          language: state.language,
          rating: state.rating,
          failure: failure),
    });
  }
}
