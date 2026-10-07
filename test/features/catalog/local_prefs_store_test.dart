import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/catalog/model/local_prefs_store.dart';

void main() {
  late Directory docs;
  LocalPrefsStore store() => LocalPrefsStore(() async => docs);
  File file() => File('${docs.path}/${LocalPrefsStore.fileName}');

  setUp(() async => docs = await Directory.systemTemp.createTemp('local_prefs_test'));
  tearDown(() => docs.delete(recursive: true));

  test('favourites add and remove, in the order added, and survive a restart', () async {
    final s = store();
    await s.setFavouriteHall(3, favourite: true);
    await s.setFavouriteHall(1, favourite: true);
    await s.setFavouriteHall(3, favourite: true);
    expect((await s.read()).favouriteHalls, [1, 3], reason: 'adding again moves it to the end, never duplicates');

    await s.setFavouriteHall(1, favourite: false);
    expect((await store().read()).favouriteHalls, [3], reason: 'a new instance is the next app run');
  });

  test('recently viewed: newest first, de-duplicated, capped at 10', () async {
    final s = store();
    for (var id = 1; id <= 12; id++) {
      await s.addRecentMovie(id);
    }
    await s.addRecentMovie(5);

    final recent = (await store().read()).recentMovies;
    expect(recent, [5, 12, 11, 10, 9, 8, 7, 6, 4, 3]);
    expect(recent, hasLength(LocalPrefsStore.maxRecentMovies));
  });

  test('recent searches: last 5, trimmed, case-insensitive de-dup, blanks ignored; clear-all', () async {
    final s = store();
    for (final q in ['dune', 'heat', '  ', 'tum', 'avatar', 'legend', ' Dune ', 'joker']) {
      await s.addRecentSearch(q);
    }
    expect((await s.read()).recentSearches, ['joker', 'Dune', 'legend', 'avatar', 'tum']);

    await s.clearRecentSearches();
    expect((await store().read()).recentSearches, isEmpty);
  });

  test('sign-out wipes everything', () async {
    final s = store();
    await s.setFavouriteHall(1, favourite: true);
    await s.addRecentMovie(9);
    await s.addRecentSearch('dune');

    await s.clear();

    final after = await store().read();
    expect(after.favouriteHalls, isEmpty);
    expect(after.recentMovies, isEmpty);
    expect(after.recentSearches, isEmpty);
  });

  test('a corrupt or other-version file reads as empty and is overwritten', () async {
    await file().writeAsString('{not json');
    expect((await store().read()).favouriteHalls, isEmpty);

    await file().writeAsString('{"v": 99, "favouriteHalls": [1]}');
    final s = store();
    expect((await s.read()).favouriteHalls, isEmpty);

    await s.setFavouriteHall(2, favourite: true);
    expect((await store().read()).favouriteHalls, [2]);
  });

  test('changes are broadcast so every open screen follows', () async {
    final s = store();
    final seen = <List<int>>[];
    final sub = s.changes.listen((p) => seen.add(p.favouriteHalls));
    await s.setFavouriteHall(4, favourite: true);
    await s.setFavouriteHall(4, favourite: false);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(seen, [
      [4],
      <int>[],
    ]);
  });
}
