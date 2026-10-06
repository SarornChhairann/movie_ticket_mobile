import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_failure.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_repository.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/features/checkout/model/payway.dart';
import 'package:movie_ticket_mobile/features/checkout/model/quote.dart';

import 'checkout_fixtures.dart';

class _MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late _MockCheckoutRepository repository;

  CheckoutBloc build() => CheckoutBloc(repository, clock: () => testNow, tick: const Duration(hours: 1));
  CheckoutReady ready({Quote? quote, Map<int, int> food = const {}, GuestInfo guest = const GuestInfo()}) =>
      CheckoutReady(hold: testHold, quote: quote ?? testQuote(), food: food, guest: guest, secondsLeft: 600);

  setUpAll(() => registerFallbackValue(testHold));
  setUp(() => repository = _MockCheckoutRepository());

  void stubQuote(Result<Quote, CheckoutFailure> result) => when(() => repository.quote(
        any(),
        promoCode: any(named: 'promoCode'),
        food: any(named: 'food'),
      )).thenAnswer((_) async => result);

  blocTest<CheckoutBloc, CheckoutState>(
    'loads the quote for the hold with a countdown',
    setUp: () => stubQuote(Ok(testQuote())),
    build: build,
    act: (bloc) => bloc.add(QuoteRequested(testHold)),
    expect: () => [CheckoutState.loading(testHold), ready()],
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'HOLD_EXPIRED on open is a failure the view sends back to the seat map',
    setUp: () => stubQuote(const Err(CheckoutFailure.holdExpired())),
    build: build,
    act: (bloc) => bloc.add(QuoteRequested(testHold)),
    expect: () => [
      CheckoutState.loading(testHold),
      CheckoutState.failure(testHold, const CheckoutFailure.holdExpired()),
    ],
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'a valid promo re-quotes and shows the discount',
    setUp: () => stubQuote(Ok(testQuote(promo: 'SAVE20', discount: 2, total: 10.5))),
    build: build,
    seed: ready,
    act: (bloc) => bloc.add(const PromoApplied(' SAVE20 ')),
    expect: () => [
      ready().copyWith(quoting: true),
      ready(quote: testQuote(promo: 'SAVE20', discount: 2, total: 10.5)),
    ],
    verify: (_) => verify(() => repository.quote(testHold, promoCode: 'SAVE20', food: const {})).called(1),
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'an invalid promo keeps the previous quote and shows the server message',
    setUp: () => stubQuote(const Err(CheckoutFailure.promoInvalid('Minimum purchase of \$50.00 required.'))),
    build: build,
    seed: ready,
    act: (bloc) => bloc.add(const PromoApplied('BIG50')),
    expect: () => [
      ready().copyWith(quoting: true),
      ready().copyWith(effect: CheckoutEffect.error, message: 'Minimum purchase of \$50.00 required.'),
    ],
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'food changes update at once and re-quote once after the debounce',
    setUp: () => stubQuote(Ok(testQuote(foodTotal: 3, total: 15.5))),
    build: build,
    seed: ready,
    act: (bloc) => bloc
      ..add(const FoodChanged(8, 1))
      ..add(const FoodChanged(8, 2))
      ..add(const FoodChanged(8, 3)),
    wait: CheckoutBloc.foodDebounce + const Duration(milliseconds: 100),
    expect: () => [
      ready(food: {8: 1}),
      ready(food: {8: 2}),
      ready(food: {8: 3}),
      ready(food: {8: 3}).copyWith(quoting: true),
      ready(quote: testQuote(foodTotal: 3, total: 15.5), food: {8: 3}),
    ],
    verify: (_) => verify(() => repository.quote(testHold, promoCode: null, food: {8: 3})).called(1),
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'food quantity is capped by stock and never negative',
    setUp: () => stubQuote(Ok(testQuote())),
    build: build,
    seed: ready,
    act: (bloc) => bloc
      ..add(const FoodChanged(7, 5))
      ..add(const FoodChanged(8, -1)),
    // -1 on an unselected item clamps to 0, which leaves the state unchanged (no emit).
    expect: () => [ready(food: {7: 2})],
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'concessions: Add sets 1, plus stops at stock, minus at 1 removes the key',
    setUp: () => stubQuote(Ok(testQuote())),
    build: build,
    seed: ready,
    act: (bloc) => bloc
      ..add(const FoodChanged(7, 1)) // Add
      ..add(const FoodChanged(7, 2)) // plus
      ..add(const FoodChanged(7, 3)) // plus past stock 2: clamped, no change
      ..add(const FoodChanged(7, 1)) // minus
      ..add(const FoodChanged(7, 0)), // minus at 1: back to Add
    expect: () => [
      ready(food: {7: 1}),
      ready(food: {7: 2}),
      ready(food: {7: 1}),
      ready(),
    ],
    verify: (bloc) => expect((bloc.state as CheckoutReady).food.containsKey(7), isFalse),
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'HOLD_EXPIRED on re-quote signals the way back to the seat map',
    setUp: () => stubQuote(const Err(CheckoutFailure.holdExpired())),
    build: build,
    seed: ready,
    act: (bloc) => bloc.add(const PromoApplied('X')),
    expect: () => [
      ready().copyWith(quoting: true),
      ready().copyWith(effect: CheckoutEffect.holdExpired),
    ],
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'the countdown reaching zero signals hold expired',
    build: () => CheckoutBloc(repository, clock: () => testHold.expiresAt, tick: const Duration(hours: 1)),
    seed: ready,
    act: (bloc) => bloc.add(const HoldTicked()),
    expect: () => [ready().copyWith(secondsLeft: 0, effect: CheckoutEffect.holdExpired)],
  );

  group('canPay', () {
    test('a guest needs name and phone; email is optional but must be valid', () {
      expect(ready().canPay, isFalse);
      expect(ready(guest: const GuestInfo(name: 'Dara')).canPay, isFalse);
      expect(ready(guest: const GuestInfo(name: 'Dara', phone: '012')).canPay, isTrue);
      expect(ready(guest: const GuestInfo(name: 'Dara', phone: '012', email: 'bad')).canPay, isFalse);
      expect(ready(guest: const GuestInfo(name: 'Dara', phone: '012', email: 'd@x.com')).canPay, isTrue);
    });

    test('a signed-in customer skips the guest form', () {
      final s = ready(quote: testQuote(user: const QuoteUser(name: 'Dara', phone: '012')));
      expect(s.requiresGuest, isFalse);
      expect(s.canPay, isTrue);
    });

    test('pay is blocked while a re-quote is running', () {
      expect(ready(guest: const GuestInfo(name: 'Dara', phone: '012')).copyWith(quoting: true).canPay, isFalse);
    });
  });

  group('PaymentStartRequested', () {
    const confirmation = BookingSummary(
      bookingId: 99,
      status: BookingStatus.confirmed,
      movieTitle: 'Dune',
      hallName: 'Hall 1',
      totalAmount: 12.5,
      tickets: [TicketPass(code: 'T-1', seatCode: 'D1', status: 'ACTIVE')],
    );
    const guest = GuestInfo(name: 'Dara', phone: '012');
    const session = PaywaySession(
      bookingId: 99,
      tranId: 'CK2RT1',
      amount: 12.5,
      checkoutUrl: 'https://checkout-sandbox.payway.com.kh/abc',
      abaDeeplink: 'abamobilebank://ababank.com?type=payway',
    );
    final launch = PaywayLaunch(session: session, canOpenAba: true, holdExpiresAt: testHold.expiresAt);

    void stubStart(Result<PaywaySession, CheckoutFailure> result) => when(() => repository.startPayway(
          any(),
          guest: any(named: 'guest'),
          promoCode: any(named: 'promoCode'),
          food: any(named: 'food'),
        )).thenAnswer((_) async => result);

    CheckoutBloc buildWith({bool canOpen = true}) => CheckoutBloc(repository,
        clock: () => testNow, tick: const Duration(hours: 1), canOpenLink: (_) async => canOpen);

    blocTest<CheckoutBloc, CheckoutState>(
      'starts the payment once and opens PayWay with the deeplink check',
      setUp: () => stubStart(const Ok(session)),
      build: buildWith,
      seed: () => ready(guest: guest, food: {8: 1}),
      act: (bloc) => bloc
        ..add(const PaymentStartRequested())
        ..add(const PaymentStartRequested()),
      expect: () => [
        ready(guest: guest, food: {8: 1}).copyWith(submitting: true),
        ready(guest: guest, food: {8: 1})
            .copyWith(submitting: true, payway: launch, effect: CheckoutEffect.paywayStarted),
      ],
      verify: (_) =>
          verify(() => repository.startPayway(testHold, guest: guest, promoCode: null, food: {8: 1})).called(1),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'no ABA app: the launch says so',
      setUp: () => stubStart(const Ok(session)),
      build: () => buildWith(canOpen: false),
      seed: () => ready(guest: guest),
      act: (bloc) => bloc.add(const PaymentStartRequested()),
      skip: 1,
      expect: () => [
        ready(guest: guest).copyWith(
            submitting: true, payway: launch.copyWith(canOpenAba: false), effect: CheckoutEffect.paywayStarted),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an invalid guest form never starts a payment',
      build: build,
      seed: ready,
      act: (bloc) => bloc.add(const PaymentStartRequested()),
      expect: () => const <CheckoutState>[],
      verify: (_) => verifyNever(() => repository.startPayway(any(), guest: any(named: 'guest'))),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'PayWay refusing the purchase keeps the hold, shows the message, and re-quotes',
      setUp: () {
        stubStart(const Err(CheckoutFailure.paymentFailed('Wrong hash')));
        stubQuote(Ok(testQuote()));
      },
      build: build,
      seed: () => ready(guest: guest),
      act: (bloc) => bloc.add(const PaymentStartRequested()),
      expect: () => [
        ready(guest: guest).copyWith(submitting: true),
        ready(guest: guest).copyWith(effect: CheckoutEffect.paymentFailed, message: 'Wrong hash'),
        ready(guest: guest).copyWith(quoting: true),
        ready(guest: guest),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'HOLD_EXPIRED at start goes back to the seat map',
      setUp: () => stubStart(const Err(CheckoutFailure.holdExpired())),
      build: build,
      seed: () => ready(guest: guest),
      act: (bloc) => bloc.add(const PaymentStartRequested()),
      expect: () => [
        ready(guest: guest).copyWith(submitting: true),
        ready(guest: guest).copyWith(effect: CheckoutEffect.holdExpired),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'approved from the web view is the success screen',
      build: build,
      seed: () => ready(guest: guest).copyWith(submitting: true, payway: launch),
      act: (bloc) => bloc.add(const PaywayFinished(PaywayOutcome.approved(confirmation))),
      expect: () => [const CheckoutState.success(confirmation)],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'declined from the web view is the payment-failed dialog with the hold kept',
      setUp: () => stubQuote(Ok(testQuote())),
      build: build,
      seed: () => ready(guest: guest).copyWith(submitting: true, payway: launch),
      act: (bloc) => bloc.add(const PaywayFinished(PaywayOutcome.declined())),
      expect: () => [
        ready(guest: guest).copyWith(effect: CheckoutEffect.paymentFailed),
        ready(guest: guest).copyWith(quoting: true),
        ready(guest: guest),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'closing the web view returns to checkout ready to pay again',
      build: build,
      seed: () => ready(guest: guest).copyWith(submitting: true, payway: launch),
      act: (bloc) => bloc.add(const PaywayFinished(PaywayOutcome.dismissed())),
      expect: () => [ready(guest: guest)],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'the hold ending inside the web view goes back to the seat map',
      build: build,
      seed: () => ready(guest: guest).copyWith(submitting: true, payway: launch),
      act: (bloc) => bloc.add(const PaywayFinished(PaywayOutcome.holdExpired())),
      expect: () => [ready(guest: guest).copyWith(secondsLeft: 0, effect: CheckoutEffect.holdExpired)],
    );

    test('pay is blocked while submitting', () {
      expect(ready(guest: guest).copyWith(submitting: true).canPay, isFalse);
    });
  });
}
