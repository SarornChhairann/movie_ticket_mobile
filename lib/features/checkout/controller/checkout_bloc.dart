import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/telemetry/journey_tracker.dart';
import '../../../core/bloc/debounce.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../../../core/platform/link_opener.dart';
import '../../../core/storage/booking_cache.dart';
import '../../seats/model/seat_map.dart';
import '../../seats/model/seat_repository.dart';
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
    this._cache,
    this._holds,
    this._tracker = const NoopJourneyTracker(),
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
    on<CheckoutHoldExtendRequested>(_onHoldExtendRequested);
  }

  static const foodDebounce = Debounce.requote;

  final JourneyTracker _tracker;
  final CheckoutRepository _repository;
  final DateTime Function() _clock;
  final Duration _tick;
  final CanOpenLink _canOpenLink;

  /// Where a paid booking is kept on the device; null in tests that do not need it.
  final BookingCache? _cache;

  /// Extends the hold (and tells the seat map); null in tests that do not need it.
  final SeatRepository? _holds;
  Timer? _ticker;

  Future<void> _onQuoteRequested(QuoteRequested event, Emitter<CheckoutState> emit) async {
    emit(CheckoutState.loading(event.hold));
    final result = await _repository.quote(event.hold);
    switch (result) {
      case Ok(:final value):
        _ticker?.cancel();
        _ticker = Timer.periodic(_tick, (_) => add(const HoldTicked()));
        _tracker.track(JourneyEvent(JourneyEventName.checkoutViewed, {'showtimeId': event.hold.showtimeId}));
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
        _tracker.track(JourneyEvent(JourneyEventName.payStarted, {'showtimeId': s.hold.showtimeId}));
        emit(current.copyWith(
          payway: PaywayLaunch(
            session: value,
            canOpenAba: canOpenAba,
            holdExpiresAt: s.hold.expiresAt,
            guestPhone: s.requiresGuest ? s.guest.phone.trim() : null,
          ),
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

  Future<void> _onHoldExtendRequested(CheckoutHoldExtendRequested event, Emitter<CheckoutState> emit) async {
    final s = state;
    final holds = _holds;
    if (s is! CheckoutReady || holds == null || !s.canExtend) return;
    emit(s.copyWith(extending: true, effect: null, message: null));
    final result = await holds.extend(s.hold);
    final current = state;
    if (current is! CheckoutReady) return;
    switch (result) {
      case Ok(:final value):
        final hold = current.hold.copyWith(expiresAt: value.expiresAt, extended: true);
        _tracker.track(JourneyEvent(JourneyEventName.holdExtended, {'step': 'checkout'}));
        emit(current.copyWith(
          hold: hold,
          extending: false,
          secondsLeft: _secondsLeft(hold),
          effect: CheckoutEffect.holdExtended,
        ));
      case Err(failure: ApiFailureServer(code: 'HOLD_EXPIRED')):
        _ticker?.cancel();
        emit(current.copyWith(extending: false, secondsLeft: 0, effect: CheckoutEffect.holdExpired));
      case Err(failure: ApiFailureServer(code: 'HOLD_EXTEND_LIMIT', :final message)):
        emit(current.copyWith(
          hold: current.hold.copyWith(extended: true),
          extending: false,
          effect: CheckoutEffect.error,
          message: message,
        ));
      case Err(failure: ApiFailureServer(:final message)):
        emit(current.copyWith(extending: false, effect: CheckoutEffect.error, message: message));
      case Err():
        emit(current.copyWith(extending: false, effect: CheckoutEffect.error, message: ''));
    }
  }

  Future<void> _onPaywayFinished(PaywayFinished event, Emitter<CheckoutState> emit) async {
    final s = state;
    if (s is! CheckoutReady) return;
    final idle = s.copyWith(submitting: false, payway: null, effect: null, message: null);
    switch (event.outcome) {
      case PaywayOutcomeApproved(:final confirmation):
        _ticker?.cancel();
        _tracker.track(JourneyEvent(JourneyEventName.paySucceeded, {'showtimeId': s.hold.showtimeId}));
        // A guest finds it again under Bookings; the account copy works offline.
        await _cache?.put(
          s.requiresGuest ? BookingOwner.guest : BookingOwner.account,
          confirmation,
          phone: s.requiresGuest ? s.guest.phone.trim() : null,
        );
        emit(CheckoutState.success(confirmation));
      case PaywayOutcomeDeclined() || PaywayOutcomeCancelled():
        _tracker.track(JourneyEvent(JourneyEventName.payFailed, {'showtimeId': s.hold.showtimeId}));
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
        CheckoutSeatLimit(:final message) ||
        CheckoutBookingNotFound(:final message) ||
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
