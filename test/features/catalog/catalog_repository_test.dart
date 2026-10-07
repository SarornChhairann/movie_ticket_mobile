import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';

import 'catalog_fixtures.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late CatalogRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    adapter = DioAdapter(dio: dio);
    repository = CatalogRepository(dio);
  });

  test('sends tab and search, and never emits archived movies', () async {
    adapter.onGet(
      '/movies',
      (s) => s.reply(200, {
        'movies': [movieJson(id: 1), movieJson(id: 2, status: 'ARCHIVED')],
        'comingSoon': [],
      }),
      queryParameters: {'tab': 'NOW_SHOWING', 'search': 'dune'},
    );

    final result = await repository.fetchMovies(MovieTab.nowShowing, search: ' dune ');

    expect((result as Ok<List<Movie>, ApiFailure>).value.map((m) => m.id), [1]);
  });

  test('detail passes the date as YYYY-MM-DD', () async {
    adapter.onGet('/movies/1', (s) => s.reply(200, detailJson()), queryParameters: {'date': '2026-10-02'});

    final result = await repository.fetchDetail(1, date: DateTime(2026, 10, 2));

    expect((result as Ok<MovieDetail, ApiFailure>).value.movie.title, 'Dune');
  });

  test('showing: asks /api/movies for the date, maps chips, and drops movies without times', () async {
    adapter.onGet(
      '/api/movies',
      (s) => s.reply(200, [
        {
          'id': 1,
          'title': 'Dune',
          'posterPath': '/uploads/movies/dune.jpg',
          'bannerPath': '',
          'rating': 'PG-13',
          'status': 'NOW_SHOWING',
          'genre': 'Sci-Fi',
          'durationMinutes': 155,
          'showtimes': [
            {
              'showtimeId': 10,
              'time': '19:30',
              'showDate': '2026-10-07',
              'hallName': 'Hall 3',
              'cinemaName': 'Legend',
              'hasDolbyAtmos': true,
              'hasScreenX': false,
            },
            // An older API without the G34 fields still parses.
            {'showtimeId': 11, 'time': '21:45:00'},
          ],
        },
        {'id': 2, 'title': 'Heat', 'showtimes': []},
      ]),
      queryParameters: {'type': 'now_showing', 'date': '2026-10-07'},
    );

    final result = await repository.fetchShowing(DateTime(2026, 10, 7));

    final movies = (result as Ok<List<ShowingMovie>, ApiFailure>).value;
    expect(movies.map((m) => m.movie.id), [1]);
    final dune = movies.single;
    expect(dune.movie.posterUrl, 'http://api.test/uploads/movies/dune.jpg');
    expect(dune.movie.bannerUrl, isNull);
    expect(dune.movie.durationMinutes, 155);
    expect(dune.movie.genre, 'Sci-Fi');
    expect(dune.slots.map((s) => (s.id, s.time, s.hallName)), [(10, '19:30', 'Hall 3'), (11, '21:45', '')]);
    expect(dune.dolby, isTrue);
    expect(dune.screenX, isFalse);
  });

  test('showing: a network error becomes a failure', () async {
    adapter.onGet(
      '/api/movies',
      (s) => s.throws(0, DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline')),
      queryParameters: {'type': 'now_showing', 'date': '2026-10-07'},
    );

    final result = await repository.fetchShowing(DateTime(2026, 10, 7));

    expect((result as Err<List<ShowingMovie>, ApiFailure>).failure, isA<ApiFailureNetwork>());
  });

  test('server error becomes a failure', () async {
    adapter.onGet('/movies/9', (s) => s.reply(400, {'error': 'Movie not found: 9', 'type': 'BAD_REQUEST'}));

    final result = await repository.fetchDetail(9);

    expect((result as Err<MovieDetail, ApiFailure>).failure,
        const ApiFailure.server(status: 400, message: 'Movie not found: 9'));
  });
}
