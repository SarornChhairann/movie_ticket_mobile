import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/session/pending_payment_store.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/payway_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_failure.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_repository.dart';
import 'package:movie_ticket_mobile/features/checkout/model/payway.dart';

import 'checkout_fixtures.dart';

class _MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late _MockCheckoutRepository repository;

  const confirmation = BookingSummary(
    bookingId: 99,
    status: BookingStatus.confirmed,
    movieTitle: 'Dune',
    hallName: 'Hall 1',
    totalAmount: 12.5,
    tickets: [TicketPass(code: 'T-1', seatCode: 'D1', status: 'ACTIVE')],
  );
  const session = PaywaySession(
    bookingId: 99,
    tranId: 'CK2RT1',
    amount: 12.5,
    checkoutUrl: 'https://checkout-sandbox.payway.com.kh/abc',
  );
  final launch = PaywayLaunch(session: session, canOpenAba: false, holdExpiresAt: testHold.expiresAt);
  final initial = PaywayState(launch: launch);

  PaywayBloc build({Duration pollEvery = const Duration(hours: 1)}) =>
      PaywayBloc(repository, launch, clock: () => testNow, pollEvery: pollEvery);

  setUp(() => repository = _MockCheckoutRepository());

  void stubPolls(List<Result<PaywayStatus, CheckoutFailure>> results) {
    final queue = [...results];
    when(() => repository.pollPayway(any()))
        .thenAnswer((_) async => queue.length > 1 ? queue.removeAt(0) : queue.first);
  }

  test('polls every interval; PENDING then APPROVED finishes and stops the timer', () async {
    stubPolls(const [Ok(PaywayStatus.pending()), Ok(PaywayStatus.approved(confirmation))]);
    final bloc = build(pollEvery: const Duration(milliseconds: 10))..add(const PaywayOpened());

    await expectLater(bloc.stream, emitsThrough(predicate<PaywayState>((s) => s.outcome != null)));

    expect(bloc.state.outcome, const PaywayOutcome.approved(confirmation));
    expect(bloc.isPolling, isFalse);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    verify(() => repository.pollPayway('CK2RT1')).called(2);
    await bloc.close();
  });

  blocTest<PaywayBloc, PaywayState>(
    'DECLINED and CANCELLED end the page',
    setUp: () => stubPolls(const [Ok(PaywayStatus.declined())]),
    build: build,
    act: (bloc) => bloc.add(const PaywayPolled()),
    expect: () => [initial.copyWith(outcome: const PaywayOutcome.declined())],
  );

  blocTest<PaywayBloc, PaywayState>(
    'network errors keep polling and say so only after three in a row',
    setUp: () => stubPolls(const [Err(CheckoutFailure.network())]),
    build: build,
    act: (bloc) async {
      for (var i = 0; i < 3; i++) {
        bloc.add(const PaywayPolled());
        await Future<void>.delayed(Duration.zero);
      }
    },
    expect: () => [
      initial.copyWith(failures: 1),
      initial.copyWith(failures: 2),
      initial.copyWith(failures: 3, message: ''),
    ],
  );

  blocTest<PaywayBloc, PaywayState>(
    'a PENDING answer clears the failure count',
    setUp: () => stubPolls(const [Ok(PaywayStatus.pending())]),
    build: build,
    seed: () => initial.copyWith(failures: 3, message: 'down'),
    act: (bloc) => bloc.add(const PaywayResumed()),
    expect: () => [initial],
  );

  blocTest<PaywayBloc, PaywayState>(
    'closing calls close once and ends dismissed',
    setUp: () => when(() => repository.closePayway(any())).thenAnswer((_) async => const Ok(PaywayStatus.cancelled())),
    build: build,
    act: (bloc) => bloc
      ..add(const PaywayCloseRequested())
      ..add(const PaywayCloseRequested()),
    expect: () => [
      initial.copyWith(closing: true),
      initial.copyWith(outcome: const PaywayOutcome.dismissed()),
    ],
    verify: (_) => verify(() => repository.closePayway('CK2RT1')).called(1),
  );

  blocTest<PaywayBloc, PaywayState>(
    'a payment approved just before the close still succeeds',
    setUp: () => when(() => repository.closePayway(any()))
        .thenAnswer((_) async => const Ok(PaywayStatus.approved(confirmation))),
    build: build,
    act: (bloc) => bloc.add(const PaywayCloseRequested()),
    expect: () => [
      initial.copyWith(closing: true),
      initial.copyWith(outcome: const PaywayOutcome.approved(confirmation)),
    ],
  );

  blocTest<PaywayBloc, PaywayState>(
    'the hold ending closes the transaction and reports it',
    setUp: () => when(() => repository.closePayway(any())).thenAnswer((_) async => const Ok(PaywayStatus.cancelled())),
    build: () => PaywayBloc(repository, launch, clock: () => testHold.expiresAt.add(const Duration(seconds: 1))),
    act: (bloc) async {
      bloc.add(const PaywayOpened());
      await Future<void>.delayed(const Duration(milliseconds: 20));
    },
    expect: () => [
      initial.copyWith(closing: true),
      initial.copyWith(outcome: const PaywayOutcome.holdExpired()),
    ],
    verify: (_) => verify(() => repository.closePayway('CK2RT1')).called(1),
  );

  group('pending record (sprint 13)', () {
    late PendingPaymentStore store;
    const sessionId = '3f2b8c1e-6a4d-4c3b-9e2f-1a2b3c4d5e6f';
    final guestLaunch = launch.copyWith(
      session: session.copyWith(reference: 'AB3DEF7H'),
      guestPhone: '012345678',
    );

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      store = PendingPaymentStore(const FlutterSecureStorage());
    });

    PaywayBloc buildWithStore() => PaywayBloc(repository, guestLaunch,
        clock: () => testNow, pollEvery: const Duration(hours: 1), pendingStore: store, sessionId: sessionId);

    test('opening the page writes the record with this run\'s session', () async {
      final bloc = buildWithStore()..add(const PaywayOpened());
      await pumpEventQueue();

      final record = await store.read();
      expect(record!.tranId, 'CK2RT1');
      expect(record.bookingId, 99);
      expect(record.reference, 'AB3DEF7H');
      expect(record.sessionId, sessionId);
      expect(record.startedAt, testNow);
      expect(record.holdExpiresAt, testHold.expiresAt);
      expect(record.guestPhone, '012345678');
      await bloc.close();
    });

    test('a settled payment clears it', () async {
      stubPolls(const [Ok(PaywayStatus.declined())]);
      final bloc = buildWithStore()..add(const PaywayOpened());
      await pumpEventQueue();
      bloc.add(const PaywayPolled());

      await bloc.stream.firstWhere((s) => s.outcome != null);

      expect(await store.read(), isNull);
      await bloc.close();
    });

    test('closing the page clears it', () async {
      when(() => repository.closePayway(any())).thenAnswer((_) async => const Ok(PaywayStatus.cancelled()));
      final bloc = buildWithStore()..add(const PaywayOpened());
      await pumpEventQueue();
      bloc.add(const PaywayCloseRequested());

      await bloc.stream.firstWhere((s) => s.outcome != null);

      expect(await store.read(), isNull);
      await bloc.close();
    });
  });
}
