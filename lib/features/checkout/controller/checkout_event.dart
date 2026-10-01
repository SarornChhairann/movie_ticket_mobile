import '../../seats/model/seat_map.dart';
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

/// Pay. Ignored while a confirm is already running, so a double tap submits once.
final class ConfirmRequested extends CheckoutEvent {
  const ConfirmRequested();
}

final class HoldTicked extends CheckoutEvent {
  const HoldTicked();
}
