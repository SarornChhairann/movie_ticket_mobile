import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/telemetry/journey_tracker.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../model/catalog_repository.dart';
import '../model/movie.dart';

part 'movie_detail_bloc.freezed.dart';

sealed class MovieDetailEvent {
  const MovieDetailEvent();
}

final class DetailRequested extends MovieDetailEvent {
  const DetailRequested(this.movieId);

  final int movieId;
}

final class DateSelected extends MovieDetailEvent {
  const DateSelected(this.date);

  final DateTime date;
}

/// A time chip was tapped; Book Ticket uses this id.
final class ShowtimeSelected extends MovieDetailEvent {
  const ShowtimeSelected(this.showtimeId);

  final int showtimeId;
}

@freezed
sealed class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState.initial() = MovieDetailInitial;
  const factory MovieDetailState.loading() = MovieDetailLoading;

  /// [refreshing] is true while another date's showtimes load. [selectedShowtimeId]
  /// is always one of [detail]'s slots; a new date clears it.
  const factory MovieDetailState.ready(
    MovieDetail detail, {
    @Default(false) bool refreshing,
    int? selectedShowtimeId,
  }) = MovieDetailReady;

  const factory MovieDetailState.failure(ApiFailure failure) = MovieDetailFailure;
}

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc(this._repository, {this._tracker = const NoopJourneyTracker()})
      : super(const MovieDetailState.initial()) {
    on<DetailRequested>(_onDetailRequested);
    on<DateSelected>(_onDateSelected);
    on<ShowtimeSelected>(_onShowtimeSelected);
  }

  final JourneyTracker _tracker;
  final CatalogRepository _repository;
  int? _movieId;

  Future<void> _onDetailRequested(DetailRequested event, Emitter<MovieDetailState> emit) async {
    _tracker.track(JourneyEvent(JourneyEventName.movieOpened, {'movieId': event.movieId}));
    _movieId = event.movieId;
    emit(const MovieDetailState.loading());
    emit(switch (await _repository.fetchDetail(event.movieId)) {
      Ok(:final value) => MovieDetailState.ready(value),
      Err(:final failure) => MovieDetailState.failure(failure),
    });
  }

  Future<void> _onDateSelected(DateSelected event, Emitter<MovieDetailState> emit) async {
    final current = state;
    final movieId = _movieId;
    if (current is! MovieDetailReady || movieId == null) {
      return;
    }
    emit(current.copyWith(refreshing: true, selectedShowtimeId: null));
    emit(switch (await _repository.fetchDetail(movieId, date: event.date)) {
      Ok(:final value) => MovieDetailState.ready(value),
      Err(:final failure) => MovieDetailState.failure(failure),
    });
  }

  void _onShowtimeSelected(ShowtimeSelected event, Emitter<MovieDetailState> emit) {
    _tracker.track(JourneyEvent(JourneyEventName.showtimeSelected, {'showtimeId': event.showtimeId}));
    final current = state;
    if (current is! MovieDetailReady || current.refreshing) return;
    final exists = current.detail.cinemas
        .expand((c) => c.halls)
        .expand((h) => h.slots)
        .any((slot) => slot.id == event.showtimeId);
    if (exists) emit(current.copyWith(selectedShowtimeId: event.showtimeId));
  }
}
