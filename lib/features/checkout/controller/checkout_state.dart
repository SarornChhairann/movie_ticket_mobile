import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/validation/validators.dart';
import '../../seats/model/seat_map.dart';
import '../model/checkout_failure.dart';
import '../model/payway.dart';
import '../model/quote.dart';

part 'checkout_state.freezed.dart';

/// One-shot outcomes consumed by a `BlocListener`.
enum CheckoutEffect {
  holdExpired,
  error,
  paymentFailed,

  /// PayWay checkout created: open the web view for [CheckoutReady.payway].
  paywayStarted,

  /// The hold's one extend went through.
  holdExtended,
}

/// PayWay needs at least this much hold left to start a payment.
const payMinHoldSeconds = 180;

@freezed
sealed class CheckoutState with _$CheckoutState {
  const CheckoutState._();

  const factory CheckoutState.initial() = CheckoutInitial;
  const factory CheckoutState.loading(Hold hold) = CheckoutLoading;

  const factory CheckoutState.ready({
    required Hold hold,

    /// Last good server quote; a failed re-quote keeps it on screen.
    required Quote quote,

    /// Food the user picked (`foodItemId → quantity`); may be ahead of [quote]
    /// while a re-quote is pending.
    @Default(<int, int>{}) Map<int, int> food,
    @Default(GuestInfo()) GuestInfo guest,
    @Default(false) bool quoting,

    /// A payment is being started or its PayWay page is open.
    @Default(false) bool submitting,

    /// The open PayWay payment, while its web view is up.
    PaywayLaunch? payway,
    int? secondsLeft,

    /// The extend call is running.
    @Default(false) bool extending,
    CheckoutEffect? effect,

    /// Server message for [CheckoutEffect.error].
    String? message,
  }) = CheckoutReady;

  const factory CheckoutState.failure(Hold hold, CheckoutFailure failure) = CheckoutFailureState;

  /// Paid and booked; the view replaces the stack with the success screen.
  const factory CheckoutState.success(BookingSummary confirmation) = CheckoutSuccess;
}

extension CheckoutReadyX on CheckoutReady {
  bool get requiresGuest => quote.user == null;

  bool get guestValid =>
      Validators.required(guest.name) == null &&
      Validators.required(guest.phone) == null &&
      (guest.email.trim().isEmpty || Validators.email(guest.email) == null);

  /// The Pay button's guard. Validation lives here, not in the view.
  bool get canPay => !quoting && !submitting && !holdTooShort && (!requiresGuest || guestValid);

  /// Under PayWay's minimum: Pay would only fail with `HOLD_EXPIRED`, so it is
  /// disabled instead (sprint 14). Extend, if unused, lifts it.
  bool get holdTooShort => secondsLeft != null && secondsLeft! < payMinHoldSeconds;

  bool get canExtend => !hold.extended && !extending && holdAlive && payway == null;

  bool get holdAlive => (secondsLeft ?? 0) > 0;
}
