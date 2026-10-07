import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/storage/home_cache.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/shell/model/home_summary.dart';
import 'package:movie_ticket_mobile/features/shell/model/shell_repository.dart';

import 'catalog_fixtures.dart';
import 'hall_fixtures.dart';

/// Sprint 21: Home reads are saved on success and read back only when the
/// server cannot be reached — never on a server answer.
void main() {
  late Directory docs;
  late HomeCache cache;
  late DioAdapter adapter;
  late Dio dio;
  final savedAt = DateTime(2026, 10, 7, 18, 40);

  final offline = DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline');

  setUp(() async {
    docs = await Directory.systemTemp.createTemp('home_offline_test');
    cache = HomeCache(() async => docs, clock: () => savedAt);
    dio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    adapter = DioAdapter(dio: dio);
  });
  tearDown(() => docs.delete(recursive: true));

  group('movies', () {
    late CatalogRepository repository;
    setUp(() => repository = CatalogRepository(dio, cache: cache));

    const query = {'tab': 'NOW_SHOWING'};

    test('no connection: the saved list, marked with when it was saved', () async {
      adapter.onGet('/movies', (s) => s.reply(200, {
            'movies': [movieJson(id: 1), movieJson(id: 2, title: 'Heat')],
          }), queryParameters: query);
      final fresh = await repository.fetchMovies(MovieTab.nowShowing);
      expect((fresh as Ok<List<Movie>, ApiFailure>).savedAt, isNull);
      await cache.idle;

      adapter.onGet('/movies', (s) => s.throws(0, offline), queryParameters: query);
      final saved = await repository.fetchMovies(MovieTab.nowShowing) as Ok<List<Movie>, ApiFailure>;

      expect(saved.value.map((m) => m.id), [1, 2]);
      expect(saved.savedAt, savedAt);
    });

    test('an offline search filters the saved list by title; searches are never saved', () async {
      adapter.onGet('/movies', (s) => s.reply(200, {
            'movies': [movieJson(id: 1), movieJson(id: 2, title: 'Heat')],
          }), queryParameters: query);
      await repository.fetchMovies(MovieTab.nowShowing);
      adapter.onGet('/movies', (s) => s.reply(200, {'movies': <Object>[]}),
          queryParameters: {...query, 'search': 'zzz'});
      await repository.fetchMovies(MovieTab.nowShowing, search: 'zzz');
      await cache.idle;

      adapter.onGet('/movies', (s) => s.throws(0, offline), queryParameters: {...query, 'search': 'hea'});
      final saved = await repository.fetchMovies(MovieTab.nowShowing, search: 'hea') as Ok<List<Movie>, ApiFailure>;

      expect(saved.value.map((m) => m.title), ['Heat']);
    });

    test('a server error is shown, never the saved copy', () async {
      adapter.onGet('/movies', (s) => s.reply(200, {'movies': [movieJson(id: 1)]}), queryParameters: query);
      await repository.fetchMovies(MovieTab.nowShowing);
      await cache.idle;

      adapter.onGet('/movies', (s) => s.reply(500, {'error': 'boom'}), queryParameters: query);
      expect(await repository.fetchMovies(MovieTab.nowShowing), isA<Err<List<Movie>, ApiFailure>>());
    });

    test('no connection and nothing saved: a network failure', () async {
      adapter.onGet('/movies', (s) => s.throws(0, offline), queryParameters: query);
      final result = await repository.fetchMovies(MovieTab.nowShowing);
      expect((result as Err<List<Movie>, ApiFailure>).failure, isA<ApiFailureNetwork>());
    });

    test('Showing is saved per date', () async {
      final day = {'type': 'now_showing', 'date': '2026-10-07'};
      adapter.onGet('/api/movies', (s) => s.reply(200, [
            {
              'id': 1,
              'title': 'Dune',
              'showtimes': [
                {'showtimeId': 10, 'time': '19:30'},
              ],
            },
          ]), queryParameters: day);
      await repository.fetchShowing(DateTime(2026, 10, 7));
      await cache.idle;

      adapter.onGet('/api/movies', (s) => s.throws(0, offline), queryParameters: day);
      final saved = await repository.fetchShowing(DateTime(2026, 10, 7)) as Ok<List<ShowingMovie>, ApiFailure>;
      expect((saved.value.single.slots.single.id, saved.savedAt), (10, savedAt));

      adapter.onGet('/api/movies', (s) => s.throws(0, offline),
          queryParameters: {'type': 'now_showing', 'date': '2026-10-08'});
      expect(await repository.fetchShowing(DateTime(2026, 10, 8)), isA<Err<List<ShowingMovie>, ApiFailure>>());
    });
  });

  test('halls fall back to the saved list', () async {
    final repository = HallRepository(dio, cache: cache);
    adapter.onGet('/api/halls', (s) => s.reply(200, [hallJson(id: 2)]));
    await repository.fetchHalls();
    await cache.idle;

    adapter.onGet('/api/halls', (s) => s.throws(0, offline));
    final saved = await repository.fetchHalls() as Ok<List<Hall>, ApiFailure>;
    expect((saved.value.single.id, saved.savedAt), (2, savedAt));
  });

  test('home keeps only the hero movie, and falls back to it', () async {
    final repository = ShellRepository(dio, cache: cache);
    adapter.onGet('/', (s) => s.reply(200, {
          'nowShowing': [{}, {}],
          'heroMovies': [
            {'id': 2, 'title': 'Heat'},
            {'id': 3, 'title': 'Alien'},
          ],
          'featuredMovie': {'id': 1, 'title': 'Dune'},
        }));
    await repository.fetchHome();
    await cache.idle;
    final body = (await cache.read(HomeCache.home))!.body! as Map<String, dynamic>;
    expect(body.keys, unorderedEquals(['featuredMovie', 'heroMovies']));
    expect(body['heroMovies'], hasLength(1));

    adapter.onGet('/', (s) => s.throws(0, offline));
    final saved = await repository.fetchHome() as Ok<HomeSummary, ApiFailure>;
    expect((saved.value.featured?.title, saved.savedAt), ('Dune', savedAt));
  });
}
