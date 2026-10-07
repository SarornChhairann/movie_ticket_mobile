import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// What this phone remembers about the shopper (sprint 22, decisions D5/D6).
class LocalPrefs {
  const LocalPrefs({this.favouriteHalls = const [], this.recentMovies = const [], this.recentSearches = const []});

  /// Hall ids, in the order they were added.
  final List<int> favouriteHalls;

  /// Movie ids, newest first, at most [LocalPrefsStore.maxRecentMovies].
  final List<int> recentMovies;

  /// Queries, newest first, at most [LocalPrefsStore.maxRecentSearches].
  final List<String> recentSearches;

  static const empty = LocalPrefs();
}

/// Favourite halls, recently viewed movies, and recent searches, in one
/// versioned JSON file in the documents folder (apart from `HomeCache`). Stored on
/// this phone only; sign-out wipes it. A corrupt or other-version file reads as
/// empty and is overwritten by the next write.
class LocalPrefsStore {
  LocalPrefsStore(this._documentsDir);

  static const version = 1;
  static const fileName = 'local_prefs.json';
  static const maxRecentMovies = 10;
  static const maxRecentSearches = 5;

  final Future<Directory> Function() _documentsDir;
  final _changes = StreamController<LocalPrefs>.broadcast();

  LocalPrefs? _prefs;

  /// Writes run one after another so quick taps never lose an update.
  Future<void> _queue = Future.value();

  /// Every saved change, after it is applied in memory.
  Stream<LocalPrefs> get changes => _changes.stream;

  Future<LocalPrefs> read() async {
    await _queue;
    return _load();
  }

  Future<void> setFavouriteHall(int hallId, {required bool favourite}) => _update((p) => LocalPrefs(
        favouriteHalls: [
          for (final id in p.favouriteHalls)
            if (id != hallId) id,
          if (favourite) hallId,
        ],
        recentMovies: p.recentMovies,
        recentSearches: p.recentSearches,
      ));

  /// Movie detail was opened: [movieId] moves to the front.
  Future<void> addRecentMovie(int movieId) => _update((p) => LocalPrefs(
        favouriteHalls: p.favouriteHalls,
        recentMovies: [movieId, ...p.recentMovies.where((id) => id != movieId)].take(maxRecentMovies).toList(),
        recentSearches: p.recentSearches,
      ));

  /// A search was run; blank queries are ignored, case-insensitive duplicates merge.
  Future<void> addRecentSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return _queue;
    return _update((p) => LocalPrefs(
          favouriteHalls: p.favouriteHalls,
          recentMovies: p.recentMovies,
          recentSearches: [q, ...p.recentSearches.where((s) => s.toLowerCase() != q.toLowerCase())]
              .take(maxRecentSearches)
              .toList(),
        ));
  }

  Future<void> clearRecentSearches() => _update((p) => LocalPrefs(
        favouriteHalls: p.favouriteHalls,
        recentMovies: p.recentMovies,
      ));

  /// Sign-out: everything goes.
  Future<void> clear() => _update((_) => LocalPrefs.empty);

  Future<void> _update(LocalPrefs Function(LocalPrefs) change) {
    final done = _queue.then((_) async {
      final next = change(await _load());
      _prefs = next;
      _changes.add(next);
      final file = await _file();
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode({
        'v': version,
        'favouriteHalls': next.favouriteHalls,
        'recentMovies': next.recentMovies,
        'recentSearches': next.recentSearches,
      }), flush: true);
    });
    // Best effort: a failed write must not block later ones.
    _queue = done.catchError((Object _) {});
    return _queue;
  }

  Future<LocalPrefs> _load() async {
    if (_prefs case final prefs?) return prefs;
    var loaded = LocalPrefs.empty;
    try {
      final file = await _file();
      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        if (json is Map<String, dynamic> && json['v'] == version) {
          List<T> list<T>(Object? v) => [for (final e in v is List<dynamic> ? v : const []) if (e is T) e];
          loaded = LocalPrefs(
            favouriteHalls: list<int>(json['favouriteHalls']),
            recentMovies: list<int>(json['recentMovies']).take(maxRecentMovies).toList(),
            recentSearches: list<String>(json['recentSearches']).take(maxRecentSearches).toList(),
          );
        }
      }
    } on FormatException {
      // Corrupt: read as empty, overwritten by the next write.
    } on FileSystemException {
      // No documents folder access: behave as empty.
    }
    return _prefs ??= loaded;
  }

  Future<File> _file() async => File('${(await _documentsDir()).path}/$fileName');
}
