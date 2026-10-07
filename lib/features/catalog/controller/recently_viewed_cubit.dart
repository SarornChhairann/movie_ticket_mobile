import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/local_prefs_store.dart';
import '../model/movie.dart';

/// Recently viewed movie ids, newest first (sprint 22, decision D6). Movie
/// detail records each open; Home's rail reads the list. On this phone only.
class RecentlyViewedCubit extends Cubit<List<int>> {
  RecentlyViewedCubit(this._store) : super(const []) {
    _subscription = _store.changes.listen((prefs) {
      if (!isClosed) emit(prefs.recentMovies);
    });
  }

  /// Home shows the rail only with at least this many movies still listed.
  static const minForRail = 2;

  final LocalPrefsStore _store;
  late final StreamSubscription<LocalPrefs> _subscription;

  Future<void> load() async {
    final prefs = await _store.read();
    if (!isClosed) emit(prefs.recentMovies);
  }

  /// Movie detail was opened.
  Future<void> viewed(int movieId) => _store.addRecentMovie(movieId);

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}

/// [ids] resolved against the loaded lists, in [ids] order; archived or missing
/// ids are dropped silently. Empty when fewer than [RecentlyViewedCubit.minForRail] remain.
List<Movie> recentMovies(List<int> ids, List<Movie> loaded) {
  final byId = {for (final m in loaded) m.id: m};
  final movies = [for (final id in ids) ?byId[id]];
  return movies.length < RecentlyViewedCubit.minForRail ? const [] : movies;
}
