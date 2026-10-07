import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Home's device copy (sprint 21, decision D4): the last server answer for each
/// Home read, as raw JSON, in one versioned file in the app documents folder.
/// Each write replaces its key (never appends); the file holds no personal data.
/// Repositories read it back only when the server cannot be reached.
class HomeCache {
  HomeCache(this._documentsDir, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  static const version = 1;
  static const fileName = 'home_cache.json';

  /// Keys of the Home reads.
  static const home = 'home';
  static const halls = 'halls';
  static String movies(String tab) => 'movies.$tab';
  static String showing(String isoDate) => 'showing.$isoDate';

  /// At most this many Showing days are kept (the strip's length).
  static const maxShowingDays = 7;

  final Future<Directory> Function() _documentsDir;
  final DateTime Function() _clock;

  Map<String, ({Object? body, DateTime savedAt})>? _entries;

  /// Writes run one after another so concurrent Home loads never lose a key.
  Future<void> _queue = Future.value();

  /// Completes when the writes started so far are on disk.
  Future<void> get idle => _queue;

  /// The saved answer for [key] and when it was saved, or null.
  Future<({Object? body, DateTime savedAt})?> read(String key) async => (await _load())[key];

  Future<void> write(String key, Object? body) {
    final done = _queue.then((_) async {
      final entries = await _load();
      entries[key] = (body: body, savedAt: _clock());
      _pruneShowing(entries);
      final file = await _file();
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode({
        'v': version,
        'entries': {
          for (final e in entries.entries) e.key: {'savedAt': e.value.savedAt.toIso8601String(), 'body': e.value.body},
        },
      }), flush: true);
    });
    // A failed write must not block later ones; the cache is best effort.
    _queue = done.catchError((Object _) {});
    return _queue;
  }

  void _pruneShowing(Map<String, ({Object? body, DateTime savedAt})> entries) {
    final days = entries.keys.where((k) => k.startsWith('showing.')).toList()..sort();
    for (final k in days.take(days.length > maxShowingDays ? days.length - maxShowingDays : 0)) {
      entries.remove(k);
    }
  }

  Future<Map<String, ({Object? body, DateTime savedAt})>> _load() async {
    if (_entries case final entries?) return entries;
    final loaded = <String, ({Object? body, DateTime savedAt})>{};
    try {
      final file = await _file();
      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        // A corrupt file or another version is ignored and overwritten by the next write.
        if (json is Map<String, dynamic> && json['v'] == version && json['entries'] is Map<String, dynamic>) {
          for (final e in (json['entries'] as Map<String, dynamic>).entries) {
            final value = e.value;
            final savedAt = value is Map<String, dynamic> ? DateTime.tryParse('${value['savedAt']}') : null;
            if (savedAt != null) loaded[e.key] = (body: (value as Map<String, dynamic>)['body'], savedAt: savedAt);
          }
        }
      }
    } on FormatException {
      // Ignored: see above.
    } on FileSystemException {
      // No documents folder access: behave as an empty cache.
    }
    return _entries ??= loaded;
  }

  Future<File> _file() async => File('${(await _documentsDir()).path}/$fileName');
}
