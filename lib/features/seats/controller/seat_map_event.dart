import '../model/seat_map.dart';

sealed class SeatMapEvent {
  const SeatMapEvent();
}

final class LoadRequested extends SeatMapEvent {
  const LoadRequested(this.showtimeId);

  final int showtimeId;
}

final class SeatToggled extends SeatMapEvent {
  const SeatToggled(this.seatId);

  final int seatId;
}

/// Continue: hold the current selection (releasing seats dropped since the
/// last hold).
final class HoldRequested extends SeatMapEvent {
  const HoldRequested();
}

final class ReleaseRequested extends SeatMapEvent {
  const ReleaseRequested();
}

final class RemoteSeatChanged extends SeatMapEvent {
  const RemoteSeatChanged(this.event);

  final SeatEvent event;
}

final class HoldTicked extends SeatMapEvent {
  const HoldTicked();
}

final class HoldExpired extends SeatMapEvent {
  const HoldExpired();
}

/// "How many seats?" answered; null means skipped (the server cap applies).
final class PartySizeChosen extends SeatMapEvent {
  const PartySizeChosen(this.size);

  final int? size;
}

/// Pick and hold the best block for the party size.
final class BestSeatsRequested extends SeatMapEvent {
  const BestSeatsRequested();
}

/// Use the hold's one extend.
final class HoldExtendRequested extends SeatMapEvent {
  const HoldExtendRequested();
}

/// Internal: the hold changed elsewhere (an extend from checkout).
final class HoldChanged extends SeatMapEvent {
  const HoldChanged(this.hold);

  final Hold hold;
}

/// The app came back to the front: ask the server whether the hold survived.
final class HoldRecheckRequested extends SeatMapEvent {
  const HoldRecheckRequested();
}

/// The "seats released while you were away" banner was acted on.
final class HoldLostAcknowledged extends SeatMapEvent {
  const HoldLostAcknowledged();
}

/// Load the last showtime again after a failure.
final class RetryRequested extends SeatMapEvent {
  const RetryRequested();
}

/// "F7 was just taken": run Best seats again for the whole party.
final class PickNextBestRequested extends SeatMapEvent {
  const PickNextBestRequested();
}

/// The "just taken" banner was closed.
final class JustTakenDismissed extends SeatMapEvent {
  const JustTakenDismissed();
}
