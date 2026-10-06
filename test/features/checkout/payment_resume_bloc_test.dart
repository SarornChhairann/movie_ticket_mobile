import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/session/pending_payment_store.dart';
import 'package:movie_ticket_mobile/core/storage/booking_cache.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/payment_resume_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_failure.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_repository.dart';
import 'package:movie_ticket_mobile/features/checkout/model/payway.dart';

class _MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late _MockCheckoutRepository repository;
  late PendingPaymentStore store;
  late BookingCache cache;
  late Directory docs;

  final now = DateTime(2026, 10, 6, 19, 5);
  const confirmation = BookingSummary(
    bookingId: 99,
    reference: 'AB3DEF7H',
    status: BookingStatus.confirmed,
    movieTitle: 'Dune',
    hallName: 'Hall 1',
    totalAmount: 12.5,
    tickets: [TicketPass(code: 'T-1', seatCode: 'D1', status: 'ACTIVE', bookingReference: 'AB3DEF7H')],
  );

  PendingPayment pending({String? phone = '012345678', Duration holdLeft = const Duration(minutes: 5)}) =>
      PendingPayment(
        tranId: 'CK2RT1',
        bookingId: 99,
        reference: 'AB3DEF7H',
        sessionId: '3f2b8c1e-6a4d-4c3b-9e2f-1a2b3c4d5e6f',
        startedAt: now.subtract(const Duration(minutes: 3)),
        holdExpiresAt: now.add(holdLeft),
        guestPhone: phone,
      );

  setUp(() async {
    repository = _MockCheckoutRepository();
    FlutterSecureStorage.setMockInitialValues({});
    store = PendingPaymentStore(const FlutterSecureStorage());
    docs = await Directory.systemTemp.createTemp('resume_test');
    cache = BookingCache(const FlutterSecureStorage(), () async => docs);
  });

  tearDown(() => docs.delete(recursive: true));

  PaymentResumeBloc build(PendingPayment payment) => PaymentResumeBloc(repository, payment,
      store: store, cache: cache, clock: () => now, pollEvery: const Duration(milliseconds: 10));

  Future<PaymentResumeState> settle(PaymentResumeBloc bloc) =>
      bloc.stream.firstWhere((s) => s.outcome != null);

  test('APPROVED: success, the record is cleared, and a guest booking is saved for lookup', () async {
    final payment = pending();
    await store.write(payment);
    when(() => repository.pollPayway('CK2RT1')).thenAnswer((_) async => const Ok(PaywayStatus.approved(confirmation)));
    final bloc = build(payment)..add(const ResumeStarted());

    final state = await settle(bloc);

    expect(state.outcome, const ResumeOutcome.approved(confirmation));
    expect(await store.read(), isNull);
    final saved = (await cache.entries(BookingOwner.guest)).single;
    expect(saved.booking.reference, 'AB3DEF7H');
    expect(saved.phone, '012345678');
    expect(bloc.isPolling, isFalse);
    await bloc.close();
  });

  test('a signed-in payment is saved as the account copy', () async {
    when(() => repository.pollPayway(any())).thenAnswer((_) async => const Ok(PaywayStatus.approved(confirmation)));
    final bloc = build(pending(phone: null))..add(const ResumeStarted());

    await settle(bloc);

    expect((await cache.entries(BookingOwner.account)).single.booking.bookingId, 99);
    await bloc.close();
  });

  test('PENDING keeps polling while the hold lasts', () async {
    final payment = pending();
    await store.write(payment);
    var polls = 0;
    when(() => repository.pollPayway(any())).thenAnswer((_) async {
      polls++;
      return polls < 3 ? const Ok(PaywayStatus.pending()) : const Ok(PaywayStatus.approved(confirmation));
    });
    final bloc = build(payment)..add(const ResumeStarted());

    await settle(bloc);

    expect(polls, 3);
    verifyNever(() => repository.closePayway(any()));
    await bloc.close();
  });

  test('PENDING after the hold ended closes the payment and fails', () async {
    final payment = pending(holdLeft: const Duration(seconds: -1));
    await store.write(payment);
    when(() => repository.pollPayway(any())).thenAnswer((_) async => const Ok(PaywayStatus.pending()));
    when(() => repository.closePayway('CK2RT1')).thenAnswer((_) async => const Ok(PaywayStatus.cancelled()));
    final bloc = build(payment)..add(const ResumeStarted());

    final state = await settle(bloc);

    expect(state.outcome, const ResumeOutcome.failed());
    verify(() => repository.closePayway('CK2RT1')).called(1);
    expect(await store.read(), isNull);
    await bloc.close();
  });

  test('DECLINED fails and clears the record; nothing is saved', () async {
    final payment = pending();
    await store.write(payment);
    when(() => repository.pollPayway(any())).thenAnswer((_) async => const Ok(PaywayStatus.declined()));
    final bloc = build(payment)..add(const ResumeStarted());

    final state = await settle(bloc);

    expect(state.outcome, const ResumeOutcome.failed());
    expect(await store.read(), isNull);
    expect(await cache.entries(BookingOwner.guest), isEmpty);
    await bloc.close();
  });

  test('no connection keeps the record so the next start tries again', () async {
    final payment = pending();
    await store.write(payment);
    when(() => repository.pollPayway(any())).thenAnswer((_) async => const Err(CheckoutFailure.network()));
    final bloc = build(payment)..add(const ResumeStarted());

    final state = await bloc.stream.firstWhere((s) => s.failures >= PaymentResumeBloc.failuresBeforeMessage);

    expect(state.outcome, isNull);
    expect(await store.read(), isNotNull);
    await bloc.close();
  });
}
