import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_failure.dart';
import 'package:movie_ticket_mobile/features/checkout/model/checkout_repository.dart';
import 'package:movie_ticket_mobile/features/checkout/model/confirmation.dart';
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

  group('ConfirmRequested', () {
    const confirmation = Confirmation(
      bookingId: 99,
      status: 'CONFIRMED',
      movieTitle: 'Dune',
      hallName: 'Hall 1',
      totalAmount: 12.5,
      tickets: [TicketPass(code: 'T-1', seatCode: 'D1', status: 'ACTIVE')],
    );
    const guest = GuestInfo(name: 'Dara', phone: '012');

    void stubConfirm(Result<Confirmation, CheckoutFailure> result) => when(() => repository.confirm(
          any(),
          guest: any(named: 'guest'),
          promoCode: any(named: 'promoCode'),
          food: any(named: 'food'),
          paymentMethod: any(named: 'paymentMethod'),
        )).thenAnswer((_) async => result);

    blocTest<CheckoutBloc, CheckoutState>(
      'success replaces the form with the confirmation',
      setUp: () => stubConfirm(const Ok(confirmation)),
      build: build,
      seed: () => ready(guest: guest, food: {8: 1}),
      act: (bloc) => bloc.add(const ConfirmRequested()),
      expect: () => [
        ready(guest: guest, food: {8: 1}).copyWith(submitting: true),
        const CheckoutState.success(confirmation),
      ],
      verify: (_) => verify(() => repository.confirm(testHold, guest: guest, promoCode: null, food: {8: 1})).called(1),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a double tap submits once',
      setUp: () => stubConfirm(const Ok(confirmation)),
      build: build,
      seed: () => ready(guest: guest),
      act: (bloc) => bloc
        ..add(const ConfirmRequested())
        ..add(const ConfirmRequested()),
      verify: (_) => verify(() => repository.confirm(
            any(),
            guest: any(named: 'guest'),
            promoCode: any(named: 'promoCode'),
            food: any(named: 'food'),
          )).called(1),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an invalid guest form never confirms',
      build: build,
      seed: ready,
      act: (bloc) => bloc.add(const ConfirmRequested()),
      expect: () => const <CheckoutState>[],
      verify: (_) => verifyNever(() => repository.confirm(any(), guest: any(named: 'guest'))),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'payment failure keeps the hold, shows the message, and re-quotes',
      setUp: () {
        stubConfirm(const Err(CheckoutFailure.paymentFailed('Card declined.')));
        stubQuote(Ok(testQuote()));
      },
      build: build,
      seed: () => ready(guest: guest),
      act: (bloc) => bloc.add(const ConfirmRequested()),
      expect: () => [
        ready(guest: guest).copyWith(submitting: true),
        ready(guest: guest).copyWith(effect: CheckoutEffect.paymentFailed, message: 'Card declined.'),
        ready(guest: guest).copyWith(quoting: true),
        ready(guest: guest),
      ],
      verify: (_) => verify(() => repository.quote(testHold, promoCode: null, food: const {})).called(1),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'losing the hold at confirm goes back to the seat map',
      setUp: () => stubConfirm(const Err(CheckoutFailure.seatConflict('Seats were taken.'))),
      build: build,
      seed: () => ready(guest: guest),
      act: (bloc) => bloc.add(const ConfirmRequested()),
      expect: () => [
        ready(guest: guest).copyWith(submitting: true),
        ready(guest: guest).copyWith(effect: CheckoutEffect.holdExpired),
      ],
    );

    test('pay is blocked while submitting', () {
      expect(ready(guest: guest).copyWith(submitting: true).canPay, isFalse);
    });
  });
}
