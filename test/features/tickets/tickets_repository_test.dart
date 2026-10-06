import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/storage/booking_cache.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_failure.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_repository.dart';

import '../../helpers/fake_adapter.dart';
import 'tickets_fixtures.dart';

void main() {
  late FakeAdapter adapter;
  late TicketsRepository repository;
  late BookingCache cache;
  late Directory docs;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    docs = await Directory.systemTemp.createTemp('tickets_repo_test');
    cache = BookingCache(const FlutterSecureStorage(), () async => docs);
  });

  tearDown(() => docs.delete(recursive: true).catchError((_) => docs));

  void serve(Future<ResponseBody> Function(RequestOptions o) handler) {
    adapter = FakeAdapter(handler);
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter;
    repository = TicketsRepository(dio, cache);
  }

  test('my bookings keeps the server order (newest first) and maps each booking', () async {
    serve((_) async => jsonBody(200, [
          bookingJson(id: 3, bookedAt: '2026-10-03T09:00:00'),
          bookingJson(id: 1, status: 'CANCELLED', bookedAt: '2026-10-01T09:00:00'),
        ]));

    final list = (await repository.myBookings() as Ok<BookingList, TicketsFailure>).value.bookings;

    expect(adapter.requests.first.path, '/bookings/my-bookings');
    expect(list.map((b) => b.bookingId), [3, 1]);
    expect(list.first.status, BookingStatus.confirmed);
    expect(list.first.seatCodes, ['D1', 'D2']);
    expect(list.last.status, BookingStatus.cancelled);
    expect(list.last.tickets.every((t) => t.cancelled), isTrue);
  });

  test('payment status becomes the refund state (absent from older servers means none)', () async {
    serve((_) async => jsonBody(200, [
          bookingJson(id: 3, status: 'CANCELLED', paymentStatus: 'REFUND_PENDING'),
          bookingJson(id: 2, status: 'CANCELLED', paymentStatus: 'REFUNDED'),
          bookingJson(id: 1, paymentStatus: 'PAID'),
          bookingJson(id: 0)..remove('paymentStatus'),
        ]));

    final list = (await repository.myBookings() as Ok<BookingList, TicketsFailure>).value.bookings;

    expect(list.map((b) => b.refund),
        [RefundState.pending, RefundState.refunded, RefundState.none, RefundState.none]);
  });

  test('a booking that is not ours is BOOKING_NOT_FOUND', () async {
    serve((_) async => jsonBody(404, {'error': 'Booking not found.', 'type': 'NOT_FOUND', 'code': 'BOOKING_NOT_FOUND'}));

    final result = await repository.booking(7);

    expect(adapter.requests.single.path, '/bookings/confirmation/7');
    expect((result as Err<BookingSummary, TicketsFailure>).failure, const TicketsFailure.notFound('Booking not found.'));
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
    expect((result as Ok<TicketQr, TicketsFailure>).value.png, png);
    expect(result.value.offline, isFalse);
    expect(await cache.readQr('T-1'), png, reason: 'kept for offline');
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

  test('a dropped connection is a network failure where there is no device copy', () async {
    serve((o) async => throw DioException.connectionError(requestOptions: o, reason: 'refused'));

    expect((await repository.cancel(3) as Err).failure, const TicketsFailure.network());
    expect((await repository.qrBytes('T-9') as Err).failure, const TicketsFailure.network());
  });

  group('device copy (sprint 13)', () {
    Future<ResponseBody> refused(RequestOptions o) async =>
        throw DioException.connectionError(requestOptions: o, reason: 'refused');

    test('my bookings are saved, then shown as the offline copy when the connection drops', () async {
      serve((o) async => o.path == '/bookings/my-bookings'
          ? jsonBody(200, [bookingJson(id: 3, bookedAt: '2026-10-03T09:00:00'), bookingJson(id: 1)])
          : ResponseBody.fromBytes([1, 2, 3], 200));
      await repository.myBookings();

      serve(refused);
      final list = (await repository.myBookings() as Ok<BookingList, TicketsFailure>).value;

      expect(list.offline, isTrue);
      expect(list.bookings.map((b) => b.bookingId), [3, 1]);
    });

    test('a server answer never falls back to the device copy', () async {
      await cache.put(BookingOwner.account, testBooking(id: 3));
      serve((_) async => jsonBody(500, {'error': 'Boom', 'type': 'INTERNAL_SERVER_ERROR'}));

      expect((await repository.myBookings() as Err).failure, const TicketsFailure.unknown('Boom'));
    });

    test('a QR opened once is shown offline', () async {
      final png = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);
      serve((_) async => ResponseBody.fromBytes(png, 200));
      await repository.qrBytes('T-1');

      serve(refused);
      final qr = (await repository.qrBytes('T-1') as Ok<TicketQr, TicketsFailure>).value;

      expect(qr.png, png);
      expect(qr.offline, isTrue);
    });

    test('lookup sends reference + phone and keeps the booking on this phone with the phone', () async {
      serve((o) async => o.path == '/bookings/lookup'
          ? jsonBody(200, bookingJson(id: 5)..['reference'] = 'AB3DEF7H')
          : ResponseBody.fromBytes([1], 200));

      final booking = (await repository.lookup(' AB3DEF7H ', '012 345 678') as Ok<BookingSummary, TicketsFailure>).value;

      final request = adapter.requests.first;
      expect(request.method, 'POST');
      expect(request.data, {'reference': 'AB3DEF7H', 'phone': '012 345 678'});
      expect(booking.reference, 'AB3DEF7H');
      final saved = (await cache.entries(BookingOwner.guest)).single;
      expect(saved.booking.bookingId, 5);
      expect(saved.phone, '012 345 678');
    });

    test('too many misses is its own failure', () async {
      serve((_) async => jsonBody(429, {'error': 'Too many attempts.', 'type': 'TOO_MANY_REQUESTS', 'code': 'TOO_MANY_ATTEMPTS'}));

      expect((await repository.lookup('ZZZZZZZZ', '012') as Err).failure,
          const TicketsFailure.tooManyAttempts('Too many attempts.'));
    });

    test('guest bookings refresh each saved booking by reference + phone; offline keeps the copy', () async {
      await cache.put(BookingOwner.guest, testBooking(id: 5).copyWith(reference: 'AB3DEF7H'), phone: '012');
      serve((o) async => o.path == '/bookings/lookup'
          ? jsonBody(200, bookingJson(id: 5, status: 'CANCELLED')..['reference'] = 'AB3DEF7H')
          : ResponseBody.fromBytes([1], 200));

      final fresh = (await repository.guestBookings() as Ok<BookingList, TicketsFailure>).value;
      expect(fresh.offline, isFalse);
      expect(fresh.bookings.single.status, BookingStatus.cancelled);

      serve(refused);
      final offline = (await repository.guestBookings() as Ok<BookingList, TicketsFailure>).value;
      expect(offline.offline, isTrue);
      expect(offline.bookings.single.status, BookingStatus.cancelled, reason: 'the last saved copy');
    });
  });
}
