import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/debounce.dart';
import '../../../core/network/result.dart';
import '../../../core/platform/link_opener.dart';
import '../../seats/model/seat_map.dart';
import '../model/checkout_failure.dart';
import '../model/checkout_repository.dart';
import '../model/payway.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

export 'checkout_event.dart';
export 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc(
    this._repository, {
    DateTime Function()? clock,
    this._tick = const Duration(seconds: 1),
    this._canOpenLink = canOpenAppLink,
  })  : _clock = clock ?? DateTime.now,
        super(const CheckoutState.initial()) {
    on<QuoteRequested>(_onQuoteRequested);
    on<PromoApplied>(_onPromoApplied);
    on<PromoCleared>(_onPromoCleared);
    on<FoodChanged>(_onFoodChanged);
    on<FoodRequoteRequested>(_onFoodRequote, transformer: debounce(foodDebounce));
    on<GuestEdited>(_onGuestEdited);
    on<HoldTicked>(_onHoldTicked);
    on<PaymentStartRequested>(_onPaymentStartRequested);
    on<PaywayFinished>(_onPaywayFinished);
  }

  static const foodDebounce = Duration(milliseconds: 300);

  final CheckoutRepository _repository;
  final DateTime Function() _clock;
  final Duration _tick;
  final CanOpenLink _canOpenLink;
  Timer? _ticker;

  Future<void> _onQuoteRequested(QuoteRequested event, Emitter<CheckoutState> emit) async {
    emit(CheckoutState.loading(event.hold));
    final result = await _repository.quote(event.hold);
    switch (result) {
      case Ok(:final value):
        _ticker?.cancel();
        _ticker = Timer.periodic(_tick, (_) => add(const HoldTicked()));
        emit(CheckoutState.ready(hold: event.hold, quote: value, secondsLeft: _secondsLeft(event.hold)));
      case Err(:final failure):
        emit(CheckoutState.failure(event.hold, failure));
    }
  }

  Future<void> _onPromoApplied(PromoApplied event, Emitter<CheckoutState> emit) =>
      _requote(emit, promoCode: event.code.trim());

  Future<void> _onPromoCleared(PromoCleared event, Emitter<CheckoutState> emit) =>
      _requote(emit, promoCode: '');

  void _onFoodChanged(FoodChanged event, Emitter<CheckoutState> emit) {
    final s = state;
    if (s is! CheckoutReady) return;
    final item = s.quote.foodItems.where((f) => f.id == event.foodItemId).firstOrNull;
    if (item == null) return;
    // At least 0; at most the stock when the item has a limited stock.
    final max = item.maxQuantity;
    final qty = event.quantity < 0 ? 0 : (max != null && event.quantity > max ? max : event.quantity);
    final food = {...s.food, event.foodItemId: qty}..removeWhere((_, q) => q == 0);
    emit(s.copyWith(food: food, effect: null, message: null));
    add(const FoodRequoteRequested());
  }

  Future<void> _onFoodRequote(FoodRequoteRequested event, Emitter<CheckoutState> emit) => _requote(emit);

  void _onGuestEdited(GuestEdited event, Emitter<CheckoutState> emit) {
    final s = state;
    if (s is CheckoutReady) emit(s.copyWith(guest: event.guest, effect: null, message: null));
  }

  void _onHoldTicked(HoldTicked event, Emitter<CheckoutState> emit) {
    final s = state;
    if (s is! CheckoutReady) return;
    final left = _secondsLeft(s.hold);
    // While the PayWay page is open it owns the expiry: it closes the transaction first.
    if (left <= 0 && s.payway == null) {
      _ticker?.cancel();
      emit(s.copyWith(secondsLeft: 0, effect: CheckoutEffect.holdExpired, message: null));
      return;
    }
    emit(s.copyWith(secondsLeft: left > 0 ? left : 0, effect: null));
  }

  Future<void> _onPaymentStartRequested(PaymentStartRequested event, Emitter<CheckoutState> emit) async {
    final s = state;
    if (s is! CheckoutReady || !s.canPay) return; // also drops a second tap while submitting
    emit(s.copyWith(submitting: true, effect: null, message: null));
    final result = await _repository.startPayway(
      s.hold,
      guest: s.requiresGuest ? s.guest : null,
      promoCode: s.quote.promoCode,
      food: s.food,
    );
    switch (result) {
      case Ok(:final value):
        final canOpenAba = value.abaDeeplink.isNotEmpty && await _canOpenLink(value.abaDeeplink);
        final current = state;
        if (current is! CheckoutReady) return;
        emit(current.copyWith(
          payway: PaywayLaunch(session: value, canOpenAba: canOpenAba, holdExpiresAt: s.hold.expiresAt),
          effect: CheckoutEffect.paywayStarted,
        ));
      case Err(failure: CheckoutPaymentFailed(:final message)):
        // The hold is kept: show the message and refresh the quote for a retry.
        final current = state;
        if (current is! CheckoutReady) return;
        emit(current.copyWith(submitting: false, effect: CheckoutEffect.paymentFailed, message: message));
        await _requote(emit);
      case Err(failure: CheckoutHoldExpired() || CheckoutSeatConflict()):
        _ticker?.cancel();
        final current = state;
        if (current is! CheckoutReady) return;
        emit(current.copyWith(submitting: false, effect: CheckoutEffect.holdExpired));
      case Err(:final failure):
        final current = state;
        if (current is! CheckoutReady) return;
        emit(current.copyWith(submitting: false, effect: CheckoutEffect.error, message: _messageOf(failure)));
    }
  }

  Future<void> _onPaywayFinished(PaywayFinished event, Emitter<CheckoutState> emit) async {
    final s = state;
    if (s is! CheckoutReady) return;
    final idle = s.copyWith(submitting: false, payway: null, effect: null, message: null);
    switch (event.outcome) {
      case PaywayOutcomeApproved(:final confirmation):
        _ticker?.cancel();
        emit(CheckoutState.success(confirmation));
      case PaywayOutcomeDeclined() || PaywayOutcomeCancelled():
        // Seats are still available and the hold is kept: the failed dialog offers a retry.
        emit(idle.copyWith(secondsLeft: _secondsLeft(s.hold), effect: CheckoutEffect.paymentFailed));
        await _requote(emit);
      case PaywayOutcomeHoldExpired():
        _ticker?.cancel();
        emit(idle.copyWith(secondsLeft: 0, effect: CheckoutEffect.holdExpired));
      case PaywayOutcomeDismissed():
        final left = _secondsLeft(s.hold);
        if (left <= 0) {
          _ticker?.cancel();
          emit(idle.copyWith(secondsLeft: 0, effect: CheckoutEffect.holdExpired));
        } else {
          emit(idle.copyWith(secondsLeft: left));
        }
    }
  }

  /// Re-prices the hold. [promoCode] null keeps the applied promo, '' clears it.
  Future<void> _requote(Emitter<CheckoutState> emit, {String? promoCode}) async {
    final s = state;
    if (s is! CheckoutReady) return;
    emit(s.copyWith(quoting: true, effect: null, message: null));
    final promo = promoCode ?? s.quote.promoCode;
    final result = await _repository.quote(s.hold, promoCode: promo, food: s.food);
    final current = state;
    if (current is! CheckoutReady) return;
    switch (result) {
      case Ok(:final value):
        emit(current.copyWith(quote: value, quoting: false));
      case Err(failure: CheckoutHoldExpired()):
        _ticker?.cancel();
        emit(current.copyWith(quoting: false, effect: CheckoutEffect.holdExpired));
      case Err(:final failure):
        emit(current.copyWith(quoting: false, effect: CheckoutEffect.error, message: _messageOf(failure)));
    }
  }

  int _secondsLeft(Hold hold) => hold.expiresAt.difference(_clock()).inSeconds;

  static String _messageOf(CheckoutFailure failure) => switch (failure) {
        CheckoutPromoInvalid(:final message) ||
        CheckoutSeatConflict(:final message) ||
        CheckoutPaymentFailed(:final message) ||
        CheckoutBlocked(:final message) ||
        CheckoutUnknown(:final message) =>
          message,
        CheckoutHoldExpired() || CheckoutPairInvalid() || CheckoutNetwork() => '',
      };

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
