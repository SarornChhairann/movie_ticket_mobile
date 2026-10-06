import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_repository.dart';

import 'hall_fixtures.dart';

void main() {
  late DioAdapter adapter;
  late HallRepository repository;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    adapter = DioAdapter(dio: dio);
    repository = HallRepository(dio);
  });

  test('lists halls from the public route in server order', () async {
    adapter.onGet('/api/halls', (s) => s.reply(200, [hallJson(id: 2), hallJson(id: 1, cinemaId: 'c-major')]));

    final halls = (await repository.fetchHalls() as Ok<List<Hall>, ApiFailure>).value;
    expect(halls.map((h) => h.id), [2, 1]);
  });

  test('schedule sends the date only when one is chosen', () async {
    adapter
      ..onGet('/api/halls/1/showtimes', (s) => s.reply(200, scheduleJson()))
      ..onGet('/api/halls/1/showtimes', (s) => s.reply(200, scheduleJson()), queryParameters: {'date': '2026-10-08'});

    expect(await repository.fetchSchedule(1), isA<Ok<HallSchedule, ApiFailure>>());
    expect(await repository.fetchSchedule(1, date: DateTime(2026, 10, 8)), isA<Ok<HallSchedule, ApiFailure>>());
  });

  test('a missing hall is a server failure', () async {
    adapter.onGet('/api/halls/9/showtimes', (s) => s.reply(404, {'error': 'Hall not found: 9', 'type': 'NOT_FOUND'}));

    final failure = (await repository.fetchSchedule(9) as Err<HallSchedule, ApiFailure>).failure;
    expect(failure, isA<ApiFailureServer>());
  });
}
