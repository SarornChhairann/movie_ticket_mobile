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
