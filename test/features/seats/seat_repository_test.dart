import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/session/session_id_provider.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_realtime.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_repository.dart';

import 'seat_fixtures.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SeatRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    adapter = DioAdapter(dio: dio);
    repository = SeatRepository(dio, SessionIdProvider(), SeatRealtime(baseUrl: 'http://api.test'));
  });

  test('loadMap maps seats, booked status, couple type, and held-by-others', () async {
    adapter.onGet('/bookings/seats/50', (s) => s.reply(200, seatMapJson()));

    final map = (await repository.loadMap(50) as Ok<SeatMapData, ApiFailure>).value;

    expect(map.movieTitle, 'Dune');
    expect(map.heldByOthers, {2});
    expect(map.seats.firstWhere((s) => s.id == 3).booked, isTrue);
    expect(map.seats.firstWhere((s) => s.id == 11).couple, isTrue);
    expect(map.seats.firstWhere((s) => s.id == 11).number, 1);
  });

  test('hold sends showtime seat ids and maps the expiry epoch', () async {
    final expires = DateTime(2026, 10, 2, 19, 10);
    adapter.onPost(
      '/api/seat-holds/hold',
      (s) => s.reply(200, {'showtimeId': 50, 'expiresAtEpochMs': expires.millisecondsSinceEpoch, 'holdMinutes': 10}),
      data: {'showtimeId': 50, 'seatIds': [1, 2]},
    );

    final hold = (await repository.hold(50, {2, 1}) as Ok<Hold, ApiFailure>).value;

    expect(hold.seatIds, {1, 2});
    expect(hold.expiresAt, expires);
  });

  test('a seat conflict keeps the server code', () async {
    adapter.onPost(
      '/api/seat-holds/hold',
      (s) => s.reply(409, {'error': 'Held by another user.', 'type': 'CONFLICT', 'code': 'SEAT_HELD'}),
      data: Matchers.any,
    );

    final failure = (await repository.hold(50, {1}) as Err<Hold, ApiFailure>).failure;

    expect(failure, const ApiFailure.server(status: 409, code: 'SEAT_HELD', message: 'Held by another user.'));
  });

  test('state returns held-by-others for polling', () async {
    adapter.onGet(
      '/api/seat-holds/state',
      (s) => s.reply(200, {'heldByOthers': [4, 5], 'heldByMe': [1]}),
      queryParameters: {'showtimeId': 50},
    );

    expect(await repository.heldByOthers(50), {4, 5});
  });

  test('websocket URL is derived from the API base URL', () {
    expect(SeatRealtime.webSocketUrl('http://10.0.2.2:8010'), 'ws://10.0.2.2:8010/ws/websocket');
    expect(SeatRealtime.webSocketUrl('https://api.example.com/'), 'wss://api.example.com/ws/websocket');
  });
}
