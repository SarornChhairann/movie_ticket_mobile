import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';
import '../model/seat_map.dart';

part 'seat_map_state.freezed.dart';

/// How a seat is drawn. "Held" is a UI state from `seat_holds`, never a seat
/// status.
enum SeatUiState { available, selected, heldByMe, heldByOthers, booked }

/// One-shot outcomes consumed by a `BlocListener`.
enum SeatMapEffect { proceed, expired, pairError, conflict }

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
}
