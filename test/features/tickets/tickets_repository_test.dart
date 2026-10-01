import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_failure.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_repository.dart';

import '../../helpers/fake_adapter.dart';
import 'tickets_fixtures.dart';

void main() {
  late FakeAdapter adapter;
  late TicketsRepository repository;

  void serve(Future<ResponseBody> Function(RequestOptions o) handler) {
    adapter = FakeAdapter(handler);
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter;
    repository = TicketsRepository(dio);
  }

  test('my bookings keeps the server order (newest first) and maps each booking', () async {
    serve((_) async => jsonBody(200, [
          bookingJson(id: 3, bookedAt: '2026-10-03T09:00:00'),
          bookingJson(id: 1, status: 'CANCELLED', bookedAt: '2026-10-01T09:00:00'),
        ]));

    final list = (await repository.myBookings() as Ok<List<BookingSummary>, TicketsFailure>).value;

    expect(adapter.requests.single.path, '/bookings/my-bookings');
    expect(list.map((b) => b.bookingId), [3, 1]);
    expect(list.first.status, BookingStatus.confirmed);
    expect(list.first.seatCodes, ['D1', 'D2']);
    expect(list.last.status, BookingStatus.cancelled);
    expect(list.last.tickets.every((t) => t.cancelled), isTrue);
  });

  test('QR call asks for bytes and returns the PNG', () async {
    final png = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);
    serve((_) async => ResponseBody.fromBytes(png, 200, headers: {
          Headers.contentTypeHeader: ['image/png'],
        }));

    final result = await repository.qrBytes('T-1');

    final request = adapter.requests.single;
    expect(request.path, '/tickets/T-1/qr');
    expect(request.responseType, ResponseType.bytes);
    expect((result as Ok<Uint8List, TicketsFailure>).value, png);
  });

  test('cancel returns the server message', () async {
    serve((_) async => jsonBody(200, {'success': true, 'message': 'Booking #99 has been cancelled.'}));

    final result = await repository.cancel(99);

    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/bookings/cancel/99');
    expect((result as Ok<String, TicketsFailure>).value, 'Booking #99 has been cancelled.');
  });

  Future<TicketsFailure> cancelFailure(int status, Map<String, dynamic> body) async {
    serve((_) async => jsonBody(status, body));
    return (await repository.cancel(99) as Err<String, TicketsFailure>).failure;
  }

  test('cancel error codes map to failures with the server message', () async {
    expect(
      await cancelFailure(403, {'error': 'Not yours.', 'type': 'FORBIDDEN', 'code': 'NOT_OWNER'}),
      const TicketsFailure.notOwner('Not yours.'),
    );
    expect(
      await cancelFailure(409, {'error': 'Already.', 'type': 'CONFLICT', 'code': 'ALREADY_CANCELLED'}),
      const TicketsFailure.alreadyCancelled('Already.'),
    );
    expect(
      await cancelFailure(409, {'error': 'Too late.', 'type': 'CONFLICT', 'code': 'CANCEL_WINDOW'}),
      const TicketsFailure.cancelWindow('Too late.'),
    );
    expect(
      await cancelFailure(400, {'error': 'Booking not found: 99', 'type': 'BAD_REQUEST'}),
      const TicketsFailure.unknown('Booking not found: 99'),
    );
  });

  test('a dropped connection is a network failure', () async {
    serve((o) async => throw DioException.connectionError(requestOptions: o, reason: 'refused'));

    expect((await repository.myBookings() as Err).failure, const TicketsFailure.network());
  });
}
