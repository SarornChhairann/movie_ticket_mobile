import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';
import '../model/seat_map.dart';

part 'seat_map_state.freezed.dart';

/// How a seat is drawn. "Held" is a UI state from `seat_holds`, never a seat
/// status.
enum SeatUiState { available, selected, heldByMe, heldByOthers, booked }

/// One-shot outcomes consumed by a `BlocListener`.
enum SeatMapEffect {
  proceed,
  expired,
  pairError,
  conflict,
  limit,

  /// Best seats found no block in one row.
  noBlock,

  /// The hold was extended.
  extended,
}

@freezed
sealed class SeatMapState with _$SeatMapState {
  const SeatMapState._();

  const factory SeatMapState.initial() = SeatMapInitial;
  const factory SeatMapState.loading() = SeatMapLoading;

  const factory SeatMapState.ready({
    required SeatMapData data,
    required Set<int> heldByOthers,
    required Set<int> booked,
    @Default(<int>{}) Set<int> selected,
    Hold? hold,
    @Default(false) bool holding,
    int? secondsLeft,

    /// "How many seats?" for this visit; null when skipped or not asked yet.
    int? partySize,

    /// The party size question was answered or skipped; it is asked once per visit.
    @Default(false) bool partyAsked,

    /// The extend call is running.
    @Default(false) bool extending,

    /// The server no longer had the hold when the app came back (sprint 16).
    @Default(false) bool holdLost,

    /// Best seats' picks, left to right, while they light up one by one
    /// (sprint 17); empty once the hold answers.
    @Default(<int>[]) List<int> revealOrder,

    /// Codes of seats in the pending selection that someone else just took
    /// (sprint 17); shown once with **Pick next best**.
    @Default(<String>[]) List<String> justTaken,
    SeatMapEffect? effect,

    /// Server message for [SeatMapEffect.conflict].
    String? message,
  }) = SeatMapReady;

  const factory SeatMapState.failure(ApiFailure failure) = SeatMapFailure;
}

extension SeatMapReadyX on SeatMapReady {
  SeatUiState seatState(SeatView seat) {
    if (booked.contains(seat.id)) return SeatUiState.booked;
    if (heldByOthers.contains(seat.id)) return SeatUiState.heldByOthers;
    if (selected.contains(seat.id)) {
      return (hold?.seatIds.contains(seat.id) ?? false) ? SeatUiState.heldByMe : SeatUiState.selected;
    }
    return SeatUiState.available;
  }

  bool isTappable(SeatView seat) {
    final s = seatState(seat);
    return s != SeatUiState.booked && s != SeatUiState.heldByOthers;
  }

  List<SeatView> get selectedSeats =>
      data.seats.where((s) => selected.contains(s.id)).toList()..sort((a, b) => a.code.compareTo(b.code));

  bool get canContinue => selected.isNotEmpty && !holding;

  /// Most seats this visit may pick: the party size if one was chosen, else the
  /// server cap; null when neither is known.
  int? get seatCap => partySize ?? (data.maxSeats > 0 ? data.maxSeats : null);

  /// True when adding [count] more seats would pass [seatCap].
  bool wouldExceedLimit(int count) {
    final cap = seatCap;
    return cap != null && selected.length + count > cap;
  }

  /// Extend is offered once, while the hold is alive.
  bool get canExtend => hold != null && !hold!.extended && !extending && (secondsLeft ?? 0) > 0;
}
