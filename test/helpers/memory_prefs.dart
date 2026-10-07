import 'dart:async';

import 'package:movie_ticket_mobile/features/catalog/model/local_prefs_store.dart';

/// [LocalPrefsStore] in memory, for widget tests (file IO does not run in fake async).
class MemoryPrefs implements LocalPrefsStore {
  MemoryPrefs([this._prefs = LocalPrefs.empty]);

  LocalPrefs _prefs;
  final _changes = StreamController<LocalPrefs>.broadcast(sync: true);

  void _set(LocalPrefs next) {
    _prefs = next;
    _changes.add(next);
  }

  @override
  Stream<LocalPrefs> get changes => _changes.stream;

  @override
  Future<LocalPrefs> read() async => _prefs;

  @override
  Future<void> setFavouriteHall(int hallId, {required bool favourite}) async => _set(LocalPrefs(
        favouriteHalls: [..._prefs.favouriteHalls.where((id) => id != hallId), if (favourite) hallId],
        recentMovies: _prefs.recentMovies,
        recentSearches: _prefs.recentSearches,
      ));

  @override
  Future<void> addRecentMovie(int movieId) async => _set(LocalPrefs(
        favouriteHalls: _prefs.favouriteHalls,
        recentMovies: [movieId, ..._prefs.recentMovies.where((id) => id != movieId)],
        recentSearches: _prefs.recentSearches,
      ));

  @override
  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    _set(LocalPrefs(
      favouriteHalls: _prefs.favouriteHalls,
      recentMovies: _prefs.recentMovies,
      recentSearches: [query.trim(), ..._prefs.recentSearches.where((s) => s != query.trim())],
    ));
  }

  @override
  Future<void> clearRecentSearches() async =>
      _set(LocalPrefs(favouriteHalls: _prefs.favouriteHalls, recentMovies: _prefs.recentMovies));

  @override
  Future<void> clear() async => _set(LocalPrefs.empty);
}
