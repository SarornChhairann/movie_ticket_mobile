sealed class PaywayEvent {
  const PaywayEvent();
}

/// The web view is up: start polling every few seconds and watch the hold.
final class PaywayOpened extends PaywayEvent {
  const PaywayOpened();
}

/// Internal: the poll timer fired.
final class PaywayPolled extends PaywayEvent {
  const PaywayPolled();
}

/// The app came back to the front (e.g. ABA Mobile returned through `cinekh://payway/return`): poll now.
final class PaywayResumed extends PaywayEvent {
  const PaywayResumed();
}

/// The customer confirmed leaving the payment page.
final class PaywayCloseRequested extends PaywayEvent {
  const PaywayCloseRequested();
}

/// Internal: the seat hold ran out before PayWay approved.
final class PaywayHoldExpired extends PaywayEvent {
  const PaywayHoldExpired();
}
