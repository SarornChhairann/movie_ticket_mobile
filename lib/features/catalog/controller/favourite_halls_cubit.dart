import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/format/cinema_clock.dart';
import '../../../core/network/result.dart';
import '../model/hall_repository.dart';
import '../model/local_prefs_store.dart';

part 'favourite_halls_cubit.freezed.dart';

/// [ids] in the order they were added; [nextTimes] is each hall's next showtime
/// today (`HH:mm`, cinema clock) when known.
@freezed
abstract class FavouriteHallsState with _$FavouriteHallsState {
  const FavouriteHallsState._();

  const factory FavouriteHallsState({
    @Default([]) List<int> ids,
    @Default({}) Map<int, String> nextTimes,
  }) = _FavouriteHallsState;

  bool isFavourite(int hallId) => ids.contains(hallId);
}

/// Favourite halls (sprint 22, decision D5): on this phone only. Home's "Your
/// halls" asks [loadTimes] for each favourite's next showtime today through the
/// existing `GET /api/halls/{id}/showtimes`; a failure just leaves it unknown.
class FavouriteHallsCubit extends Cubit<FavouriteHallsState> {
  FavouriteHallsCubit(this._store, this._halls, {DateTime Function()? now})
      : _now = now ?? CinemaClock.now,
        super(const FavouriteHallsState()) {
    _subscription = _store.changes.listen((prefs) => _apply(prefs.favouriteHalls));
  }

  final LocalPrefsStore _store;
  final HallRepository _halls;

  /// Cinema wall clock; injected for tests.
  final DateTime Function() _now;
  late final StreamSubscription<LocalPrefs> _subscription;
  bool _withTimes = false;

  /// Reads the saved favourites. With [withTimes] (Home) it also loads, and
  /// keeps loading for new favourites, each hall's next showtime today.
  Future<void> load({bool withTimes = false}) async {
    _withTimes = _withTimes || withTimes;
    _apply((await _store.read()).favouriteHalls);
    if (_withTimes) await loadTimes();
  }

  Future<void> toggle(int hallId) => _store.setFavouriteHall(hallId, favourite: !state.isFavourite(hallId));

  /// Pull to refresh: every favourite's next showtime again.
  Future<void> loadTimes() => Future.wait([for (final id in state.ids) _loadTime(id)]);

  void _apply(List<int> ids) {
    if (isClosed) return;
    final added = ids.where((id) => !state.ids.contains(id)).toList();
    emit(FavouriteHallsState(
      ids: ids,
      nextTimes: {for (final e in state.nextTimes.entries) if (ids.contains(e.key)) e.key: e.value},
    ));
    if (_withTimes) {
      for (final id in added) {
        unawaited(_loadTime(id));
      }
    }
  }

  Future<void> _loadTime(int hallId) async {
    final now = _now();
    final today = DateTime(now.year, now.month, now.day);
    final result = await _halls.fetchSchedule(hallId, date: today);
    if (isClosed || !state.ids.contains(hallId)) return;
    final clock = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final next = switch (result) {
      Ok(:final value) => (value.showtimes
              .where((s) => _sameDay(s.date, today) && s.time.compareTo(clock) > 0)
              .map((s) => s.time)
              .toList()
            ..sort())
          .firstOrNull,
      Err() => null,
    };
    final times = {...state.nextTimes}..remove(hallId);
    if (next != null) times[hallId] = next;
    emit(state.copyWith(nextTimes: times));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}

bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
