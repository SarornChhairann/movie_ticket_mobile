import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/shell/model/home_summary.dart';
import 'package:movie_ticket_mobile/features/shell/model/shell_repository.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late ShellRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    adapter = DioAdapter(dio: dio);
    repository = ShellRepository(dio);
  });

  test('maps the home body to list counts', () async {
    adapter.onGet('/', (server) => server.reply(200, {
          'nowShowing': [{}, {}],
          'comingSoon': [{}],
          'heroMovies': [],
          'cinemas': [{}, {}, {}],
          'today': '2026-10-01',
          'featuredMovie': null,
        }));

    final result = await repository.fetchHome();

    expect(
      (result as Ok<HomeSummary, ApiFailure>).value,
      const HomeSummary(nowShowingCount: 2, comingSoonCount: 1, cinemaCount: 3),
    );
  });

  test('returns a server failure instead of throwing', () async {
    adapter.onGet('/', (server) => server.reply(500, {'error': 'boom', 'type': 'INTERNAL_SERVER_ERROR'}));

    final result = await repository.fetchHome();

    expect(
      (result as Err<HomeSummary, ApiFailure>).failure,
      const ApiFailure.server(status: 500, message: 'boom'),
    );
  });
}
