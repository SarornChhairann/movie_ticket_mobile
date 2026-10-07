import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/format/cinema_clock.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../../../core/telemetry/journey_tracker.dart';
import '../model/catalog_repository.dart';
import '../model/movie.dart';

part 'showing_cubit.freezed.dart';

/// Home's date strip and "Showing" rail (sprint 20). Every case carries the
/// strip's [dates] and the selected [date] so the strip never jumps.
@freezed
sealed class ShowingState with _$ShowingState {
  const factory ShowingState.initial({@Default([]) List<DateTime> dates, DateTime? date}) = ShowingInitial;

  const factory ShowingState.loading({required List<DateTime> dates, required DateTime date}) = ShowingLoading;

  /// [nextDate]: when [movies] is empty, the next strip date that has shows (if any).
  /// [savedAt]: the movies are the copy saved on this phone (no connection), so
  /// their times cannot be booked now (sprint 21).
  const factory ShowingState.ready({
    required List<DateTime> dates,
    required DateTime date,
    required List<ShowingMovie> movies,
    DateTime? nextDate,
    DateTime? savedAt,
  }) = ShowingReady;

  const factory ShowingState.failure({
    required List<DateTime> dates,
    required DateTime date,
    required ApiFailure failure,
  }) = ShowingFailure;
}

class ShowingCubit extends Cubit<ShowingState> {
  ShowingCubit(this._repository, {this._tracker = const NoopJourneyTracker(), DateTime Function()? now})
      : _now = now ?? CinemaClock.now,
        super(const ShowingState.initial());

  /// Today plus the next six days (decision D3).
  static const days = 7;

  final CatalogRepository _repository;
  final JourneyTracker _tracker;

  /// Cinema wall clock (contract 4); injected for tests.
  final DateTime Function() _now;

  /// The strip's dates, starting today at the cinema.
  List<DateTime> stripDates() {
    final now = _now();
    return [for (var i = 0; i < days; i++) DateTime(now.year, now.month, now.day + i)];
  }

  /// First load and pull to refresh: rebuilds the strip (the day may have
  /// changed) and keeps the selected date while it is still on it.
  Future<void> load() {
    final dates = stripDates();
    final keep = state.date;
    return _show(dates, keep != null && dates.contains(keep) ? keep : dates.first);
  }

  Future<void> dateSelected(DateTime date) {
    if (date == state.date && state is ShowingReady) return Future.value();
    return _show(state.dates.isEmpty ? stripDates() : state.dates, date);
  }

  /// A time chip was tapped; the view opens the seat map.
  void showtimeChosen(ShowingMovie showing, ShowtimeSlot slot) => _tracker.track(JourneyEvent(
        JourneyEventName.showtimeSelected,
        {'movieId': showing.movie.id, 'showtimeId': slot.id, 'source': 'showing'},
      ));

  Future<void> _show(List<DateTime> dates, DateTime date) async {
    emit(ShowingState.loading(dates: dates, date: date));
    final result = await _repository.fetchShowing(date);
    if (isClosed || state.date != date) return;
    switch (result) {
      case Err(:final failure):
        emit(ShowingState.failure(dates: dates, date: date, failure: failure));
      case Ok(value: final movies, :final savedAt) when movies.isNotEmpty:
        emit(ShowingState.ready(dates: dates, date: date, movies: movies, savedAt: savedAt));
      case Ok(:final savedAt) when savedAt != null:
        // Offline with nothing saved for this day: no look-ahead over the network.
        emit(ShowingState.ready(dates: dates, date: date, movies: const [], savedAt: savedAt));
      case Ok():
        emit(ShowingState.ready(dates: dates, date: date, movies: const []));
        final next = await _nextDateWithShows(dates, date);
        if (!isClosed && state.date == date && next != null) {
          emit(ShowingState.ready(dates: dates, date: date, movies: const [], nextDate: next));
        }
    }
  }

  /// Looks ahead on the strip only, and only after an empty day; stops at the
  /// first hit or the first failure.
  Future<DateTime?> _nextDateWithShows(List<DateTime> dates, DateTime from) async {
    for (final d in dates.where((d) => d.isAfter(from))) {
      final result = await _repository.fetchShowing(d);
      if (isClosed || state.date != from) return null;
      switch (result) {
        case Ok(value: final movies) when movies.isNotEmpty:
          return d;
        case Err():
          return null;
        case Ok():
          continue;
      }
    }
    return null;
  }
}
