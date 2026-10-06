import '../../seats/model/seat_map.dart';
import '../model/payway.dart';
import '../model/quote.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

/// Opens the screen for the hold the seat map just took.
final class QuoteRequested extends CheckoutEvent {
  const QuoteRequested(this.hold);

  final Hold hold;
}

final class PromoApplied extends CheckoutEvent {
  const PromoApplied(this.code);

  final String code;
}

final class PromoCleared extends CheckoutEvent {
  const PromoCleared();
}

/// Updates the quantity at once; the re-quote follows after a short pause.
final class FoodChanged extends CheckoutEvent {
  const FoodChanged(this.foodItemId, this.quantity);

  final int foodItemId;
  final int quantity;
}

/// Internal: debounced re-quote after food changes.
final class FoodRequoteRequested extends CheckoutEvent {
  const FoodRequoteRequested();
}

final class GuestEdited extends CheckoutEvent {
  const GuestEdited(this.guest);

  final GuestInfo guest;
}

/// **Process payment** on the pay sheet: starts the ABA KHQR payment. Ignored while
/// one is already running, so a double tap starts once.
final class PaymentStartRequested extends CheckoutEvent {
  const PaymentStartRequested();
}

/// The PayWay web view closed with [outcome].
final class PaywayFinished extends CheckoutEvent {
  const PaywayFinished(this.outcome);

  final PaywayOutcome outcome;
}

final class HoldTicked extends CheckoutEvent {
  const HoldTicked();
}
