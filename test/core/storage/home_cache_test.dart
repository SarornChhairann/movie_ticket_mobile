import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/storage/home_cache.dart';

void main() {
  late Directory docs;
  var now = DateTime(2026, 10, 7, 18, 40);
  HomeCache cache() => HomeCache(() async => docs, clock: () => now);
  File file() => File('${docs.path}/${HomeCache.fileName}');

  setUp(() async => docs = await Directory.systemTemp.createTemp('home_cache_test'));
  tearDown(() => docs.delete(recursive: true));

  test('an answer reads back, with when it was saved, from a new instance (next app run)', () async {
    await cache().write(HomeCache.halls, [
      {'id': 1, 'name': 'Hall 1'},
    ]);

    final saved = await cache().read(HomeCache.halls);
    expect(saved?.body, [
      {'id': 1, 'name': 'Hall 1'},
    ]);
    expect(saved?.savedAt, now);
    expect(await cache().read(HomeCache.home), isNull);
  });

  test('a later write replaces its key and keeps the others', () async {
    final c = cache();
    await c.write(HomeCache.movies('NOW_SHOWING'), {'movies': ['old']});
    await c.write(HomeCache.halls, []);
    now = DateTime(2026, 10, 7, 19);
    await c.write(HomeCache.movies('NOW_SHOWING'), {'movies': ['new']});

    final again = cache();
    expect((await again.read(HomeCache.movies('NOW_SHOWING')))?.body, {'movies': ['new']});
    expect((await again.read(HomeCache.movies('NOW_SHOWING')))?.savedAt, DateTime(2026, 10, 7, 19));
    expect(await again.read(HomeCache.halls), isNotNull);
  });

  test('writes started together all land (Home loads in parallel)', () async {
    final c = cache();
    await Future.wait([
      c.write(HomeCache.home, {}),
      c.write(HomeCache.halls, []),
      c.write(HomeCache.movies('NOW_SHOWING'), {}),
      c.write(HomeCache.movies('COMING_SOON'), {}),
      c.write(HomeCache.showing('2026-10-07'), []),
    ]);

    final keys = (jsonDecode(await file().readAsString())['entries'] as Map).keys;
    expect(keys, hasLength(5));
  });

  test('only the latest seven Showing days are kept', () async {
    final c = cache();
    for (var d = 1; d <= 9; d++) {
      await c.write(HomeCache.showing('2026-10-${'$d'.padLeft(2, '0')}'), []);
    }

    expect(await cache().read(HomeCache.showing('2026-10-02')), isNull);
    expect(await cache().read(HomeCache.showing('2026-10-03')), isNotNull);
    expect(await cache().read(HomeCache.showing('2026-10-09')), isNotNull);
  });

  test('a corrupt file or another version is ignored, then overwritten', () async {
    await file().writeAsString('{not json');
    expect(await cache().read(HomeCache.halls), isNull);

    await file().writeAsString(jsonEncode({
      'v': 0,
      'entries': {
        'halls': {'savedAt': '2026-10-01T00:00:00.000', 'body': []},
      },
    }));
    final c = cache();
    expect(await c.read(HomeCache.halls), isNull);

    await c.write(HomeCache.home, {});
    expect(jsonDecode(await file().readAsString())['v'], HomeCache.version);
  });
}
