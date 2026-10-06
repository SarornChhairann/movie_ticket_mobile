import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/network/session_header_interceptor.dart';
import 'package:movie_ticket_mobile/core/session/pending_payment_store.dart';
import 'package:movie_ticket_mobile/core/session/session_id_provider.dart';

void main() {
  const sessionId = '3f2b8c1e-6a4d-4c3b-9e2f-1a2b3c4d5e6f';
  final startedAt = DateTime(2026, 10, 6, 19);
  final payment = PendingPayment(
    tranId: 'CK2RT1',
    bookingId: 99,
    reference: 'AB3DEF7H',
    sessionId: sessionId,
    startedAt: startedAt,
    holdExpiresAt: startedAt.add(const Duration(minutes: 8)),
    guestPhone: '012345678',
  );

  late PendingPaymentStore store;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    store = PendingPaymentStore(const FlutterSecureStorage());
  });

  test('a record written before the web view reads back whole', () async {
    await store.write(payment);

    final read = await store.read();

    expect(read!.tranId, 'CK2RT1');
    expect(read.bookingId, 99);
    expect(read.reference, 'AB3DEF7H');
    expect(read.sessionId, sessionId);
    expect(read.startedAt, startedAt);
    expect(read.holdExpiresAt, payment.holdExpiresAt);
    expect(read.guestPhone, '012345678');
  });

  test('under 30 minutes old it is resumed; older it is cleared', () async {
    await store.write(payment);
    expect(await store.readResumable(startedAt.add(const Duration(minutes: 29))), isNotNull);

    expect(await store.readResumable(startedAt.add(const Duration(minutes: 30))), isNull);
    expect(await store.read(), isNull, reason: 'a stale record is removed');
  });

  test('an unreadable record is cleared, not resumed', () async {
    FlutterSecureStorage.setMockInitialValues({'payway.pending': '{not json'});

    expect(await store.readResumable(startedAt), isNull);
    expect(await const FlutterSecureStorage().read(key: 'payway.pending'), isNull);
  });

  test('the restored session id is the X-Session-Id of this run', () async {
    final provider = SessionIdProvider(restored: sessionId);
    final options = RequestOptions(path: '/bookings/payway/CK2RT1');

    SessionHeaderInterceptor(provider).onRequest(options, RequestInterceptorHandler());

    expect(options.headers[SessionHeaderInterceptor.headerName], sessionId);
  });
}
