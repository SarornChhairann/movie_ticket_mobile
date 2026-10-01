import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../model/couple_pairing.dart';
import '../model/seat_map.dart';
import '../model/seat_repository.dart';
import 'seat_map_event.dart';
import 'seat_map_state.dart';

export 'seat_map_event.dart';
export 'seat_map_state.dart';

class SeatMapBloc extends Bloc<SeatMapEvent, SeatMapState> {
  SeatMapBloc(this._repository, {DateTime Function()? clock, this._tick = const Duration(seconds: 1)})
      : _clock = clock ?? DateTime.now,
        super(const SeatMapState.initial()) {
    on<LoadRequested>(_onLoadRequested);
    on<SeatToggled>(_onSeatToggled);
    on<HoldRequested>(_onHoldRequested);
    on<ReleaseRequested>(_onReleaseRequested);
    on<RemoteSeatChanged>(_onRemoteSeatChanged);
    on<HoldTicked>(_onHoldTicked);
    on<HoldExpired>(_onHoldExpired);
  }

  static const _seatConflictCodes = {'SEAT_HELD', 'SEAT_BOOKED'};

  final SeatRepository _repository;
  final DateTime Function() _clock;
  final Duration _tick;
  StreamSubscription<SeatEvent>? _events;
  Timer? _ticker;

  Future<void> _onLoadRequested(LoadRequested event, Emitter<SeatMapState> emit) async {
    emit(const SeatMapState.loading());
    await _reload(emit, event.showtimeId);
    await _events?.cancel();
    _events = _repository.watch(event.showtimeId).listen((e) => add(RemoteSeatChanged(e)));
  }

  /// Fetches the map, keeping the current selection where still possible.
  Future<void> _reload(Emitter<SeatMapState> emit, int showtimeId, {Set<int> keepSelected = const {}}) async {
    final result = await _repository.loadMap(showtimeId);
    switch (result) {
      case Ok(:final value):
        final booked = {for (final s in value.seats) if (s.booked) s.id};
        emit(SeatMapState.ready(
          data: value,
          heldByOthers: value.heldByOthers,
          booked: booked,
          selected: keepSelected.difference(booked).difference(value.heldByOthers),
        ));
      case Err(:final failure):
        emit(SeatMapState.failure(failure));
    }
  }

  void _onSeatToggled(SeatToggled event, Emitter<SeatMapState> emit) {
    final s = state;
    if (s is! SeatMapReady || s.holding) return;
    final seat = s.data.seats.where((x) => x.id == event.seatId).firstOrNull;
    if (seat == null || !s.isTappable(seat)) return;

    final ids = {seat.id};
    if (seat.couple) {
      final partnerCode = CouplePairing.partnerCode(seat.code);
      final partner = s.data.seats.where((x) => x.code == partnerCode && x.couple).firstOrNull;
      if (partner == null || !s.isTappable(partner)) {
        emit(s.copyWith(effect: SeatMapEffect.pairError, message: null));
        return;
      }
      ids.add(partner.id);
    }
    final selecting = !s.selected.contains(seat.id);
    final selected = selecting ? s.selected.union(ids) : s.selected.difference(ids);
    emit(s.copyWith(selected: selected, effect: null, message: null));
  }

  Future<void> _onHoldRequested(HoldRequested event, Emitter<SeatMapState> emit) async {
    final s = state;
    if (s is! SeatMapReady || !s.canContinue) return;

    final coupleCodes = s.selectedSeats.where((x) => x.couple).map((x) => x.code);
    if (!CouplePairing.validPairs(coupleCodes)) {
      emit(s.copyWith(effect: SeatMapEffect.pairError, message: null));
      return;
    }

    emit(s.copyWith(holding: true, effect: null, message: null));
    final dropped = s.hold?.seatIds.difference(s.selected) ?? const <int>{};
    await _repository.release(s.data.showtimeId, dropped);

    final result = await _repository.hold(s.data.showtimeId, s.selected);
    switch (result) {
      case Ok(:final value):
        _startTicker();
        emit(s.copyWith(
          hold: value,
          holding: false,
          secondsLeft: _secondsLeft(value),
          effect: SeatMapEffect.proceed,
          message: null,
        ));
      case Err(failure: ApiFailureServer(:final code, :final message)) when _seatConflictCodes.contains(code):
        // Someone else got a seat: reload so the map shows it, keep the rest selected.
        await _reload(emit, s.data.showtimeId, keepSelected: s.selected);
        final r = state;
        if (r is SeatMapReady) emit(r.copyWith(effect: SeatMapEffect.conflict, message: message));
      case Err(failure: ApiFailureServer(code: 'COUPLE_PAIR_INVALID')):
        emit(s.copyWith(holding: false, effect: SeatMapEffect.pairError, message: null));
      case Err(:final failure):
        emit(s.copyWith(holding: false, effect: SeatMapEffect.conflict, message: _messageOf(failure)));
    }
  }

  Future<void> _onReleaseRequested(ReleaseRequested event, Emitter<SeatMapState> emit) async {
    final s = state;
    if (s is! SeatMapReady || s.hold == null) return;
    _stopTicker();
    await _repository.release(s.data.showtimeId, s.hold!.seatIds);
    emit(s.copyWith(hold: null, secondsLeft: null, effect: null, message: null));
  }

  void _onRemoteSeatChanged(RemoteSeatChanged event, Emitter<SeatMapState> emit) {
    final s = state;
    if (s is! SeatMapReady) return;
    switch (event.event) {
      case SeatChange(:final sessionId) when sessionId == _repository.sessionId:
        return; // our own hold/release echoed back
      case SeatChange(type: SeatEventType.held, :final seatIds):
        emit(s.copyWith(
          heldByOthers: s.heldByOthers.union(seatIds),
          selected: s.selected.difference(seatIds),
          effect: null,
        ));
      case SeatChange(type: SeatEventType.released, :final seatIds):
        // A hold ended, or a cancelled booking freed its seats: either way they are available.
        emit(s.copyWith(
          heldByOthers: s.heldByOthers.difference(seatIds),
          booked: s.booked.difference(seatIds),
          effect: null,
        ));
      case SeatChange(type: SeatEventType.booked, :final seatIds):
        emit(s.copyWith(
          booked: s.booked.union(seatIds),
          heldByOthers: s.heldByOthers.difference(seatIds),
          selected: s.selected.difference(seatIds),
          effect: null,
        ));
      case SeatSnapshot(:final heldByOthers):
        final mine = s.hold?.seatIds ?? const <int>{};
        final others = heldByOthers.difference(mine);
        emit(s.copyWith(heldByOthers: others, selected: s.selected.difference(others), effect: null));
    }
  }

  void _onHoldTicked(HoldTicked event, Emitter<SeatMapState> emit) {
    final s = state;
    if (s is! SeatMapReady || s.hold == null) return;
    final left = _secondsLeft(s.hold!);
    if (left <= 0) {
      add(const HoldExpired());
      return;
    }
    emit(s.copyWith(secondsLeft: left, effect: null));
  }

  Future<void> _onHoldExpired(HoldExpired event, Emitter<SeatMapState> emit) async {
    final s = state;
    if (s is! SeatMapReady) return;
    _stopTicker();
    await _reload(emit, s.data.showtimeId);
    final r = state;
    if (r is SeatMapReady) emit(r.copyWith(effect: SeatMapEffect.expired));
  }

  int _secondsLeft(Hold hold) => hold.expiresAt.difference(_clock()).inSeconds;

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(_tick, (_) => add(const HoldTicked()));
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  static String _messageOf(ApiFailure failure) => switch (failure) {
        ApiFailureServer(:final message) => message,
        ApiFailureNetwork() => '',
        ApiFailureUnknown(:final message) => message ?? '',
      };

  @override
  Future<void> close() async {
    _stopTicker();
    await _events?.cancel();
    final s = state;
    // The seat page closes only after checkout above it is gone, so leaving it
    // always gives the seats back (the server TTL is the backstop).
    if (s is SeatMapReady && s.hold != null) {
      unawaited(_repository.release(s.data.showtimeId, s.hold!.seatIds));
    }
    return super.close();
  }
}
