import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/telemetry/journey_tracker.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../model/best_seats.dart';
import '../model/couple_pairing.dart';
import '../model/seat_map.dart';
import '../model/seat_repository.dart';
import 'seat_map_event.dart';
import 'seat_map_state.dart';

export 'seat_map_event.dart';
export 'seat_map_state.dart';

class SeatMapBloc extends Bloc<SeatMapEvent, SeatMapState> {
  SeatMapBloc(
    this._repository, {
    DateTime Function()? clock,
    this._tick = const Duration(seconds: 1),
    this._tracker = const NoopJourneyTracker(),
  })
      : _clock = clock ?? DateTime.now,
        super(const SeatMapState.initial()) {
    on<LoadRequested>(_onLoadRequested);
    on<SeatToggled>(_onSeatToggled);
    on<HoldRequested>(_onHoldRequested);
    on<ReleaseRequested>(_onReleaseRequested);
    on<RemoteSeatChanged>(_onRemoteSeatChanged);
    on<HoldTicked>(_onHoldTicked);
    on<HoldExpired>(_onHoldExpired);
    on<PartySizeChosen>(_onPartySizeChosen);
    on<BestSeatsRequested>(_onBestSeatsRequested);
    on<HoldExtendRequested>(_onHoldExtendRequested);
    on<HoldChanged>(_onHoldChanged);
    on<HoldRecheckRequested>(_onHoldRecheckRequested);
    on<HoldLostAcknowledged>((_, emit) {
      final s = state;
      if (s is SeatMapReady) emit(s.copyWith(holdLost: false, effect: null));
    });
    on<PickNextBestRequested>(_onPickNextBest);
    on<JustTakenDismissed>((_, emit) {
      final s = state;
      if (s is SeatMapReady) emit(s.copyWith(justTaken: const [], effect: null));
    });
    on<RetryRequested>((_, emit) async {
      final id = _lastShowtimeId;
      if (id != null) await _onLoadRequested(LoadRequested(id), emit);
    });
  }

  int? _lastShowtimeId;

  /// Server wins: if the hold is gone (expired, released by an admin, server
  /// restarted), drop it and the selection and say so once.
  Future<void> _onHoldRecheckRequested(HoldRecheckRequested event, Emitter<SeatMapState> emit) async {
    final s = state;
    final hold = s is SeatMapReady ? s.hold : null;
    if (s is! SeatMapReady || hold == null) return;
    final mine = await _repository.heldByMe(s.data.showtimeId);
    if (mine == null) return; // offline: keep what we know; the ticker still runs
    if (mine.containsAll(hold.seatIds)) return;
    _stopTicker();
    final current = state;
    if (current is! SeatMapReady) return;
    emit(current.copyWith(hold: null, secondsLeft: null, selected: const {}, holdLost: true, effect: null));
  }

  static const _seatConflictCodes = {'SEAT_HELD', 'SEAT_BOOKED'};

  final SeatRepository _repository;
  final JourneyTracker _tracker;
  final DateTime Function() _clock;
  final Duration _tick;
  StreamSubscription<SeatEvent>? _events;
  StreamSubscription<Hold>? _holdChanges;
  Timer? _ticker;

  Future<void> _onLoadRequested(LoadRequested event, Emitter<SeatMapState> emit) async {
    _lastShowtimeId = event.showtimeId;
    emit(const SeatMapState.loading());
    await _reload(emit, event.showtimeId);
    await _events?.cancel();
    _events = _repository.watch(event.showtimeId).listen((e) => add(RemoteSeatChanged(e)));
    _holdChanges ??= _repository.holdChanges.listen((hold) => add(HoldChanged(hold)));
  }

  /// Fetches the map, keeping the current selection where still possible.
  Future<void> _reload(Emitter<SeatMapState> emit, int showtimeId, {Set<int> keepSelected = const {}}) async {
    // The party size belongs to the visit, not to one load of the map.
    final before = state;
    final result = await _repository.loadMap(showtimeId);
    switch (result) {
      case Ok(:final value):
        final booked = {for (final s in value.seats) if (s.booked) s.id};
        emit(SeatMapState.ready(
          data: value,
          heldByOthers: value.heldByOthers,
          booked: booked,
          selected: keepSelected.difference(booked).difference(value.heldByOthers),
          partySize: before is SeatMapReady ? before.partySize : null,
          partyAsked: before is SeatMapReady && before.partyAsked,
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
    if (selecting && s.wouldExceedLimit(ids.length)) {
      emit(s.copyWith(effect: SeatMapEffect.limit, message: null));
      return;
    }
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
    await _hold(emit, s, proceed: true);
  }

  void _onPartySizeChosen(PartySizeChosen event, Emitter<SeatMapState> emit) {
    final s = state;
    if (s is! SeatMapReady) return;
    final size = event.size;
    // A smaller party drops what no longer fits: keep the first seats picked by code.
    final keep = size == null ? s.selected : s.selectedSeats.take(size).map((x) => x.id).toSet();
    emit(s.copyWith(partySize: size, partyAsked: true, selected: keep, effect: null, message: null));
  }

  Future<void> _onBestSeatsRequested(BestSeatsRequested event, Emitter<SeatMapState> emit) async {
    final s = state;
    final size = s is SeatMapReady ? s.partySize : null;
    if (s is! SeatMapReady || size == null || s.holding) return;
    await _pickBest(emit, s, size);
  }

  /// Someone took part of the pending selection: pick a fresh block for the
  /// whole party (a block for only the missing seats could land rows away).
  Future<void> _onPickNextBest(PickNextBestRequested event, Emitter<SeatMapState> emit) async {
    final s = state;
    if (s is! SeatMapReady || s.holding) return;
    final count = s.partySize ?? s.selected.length + s.justTaken.length;
    if (count == 0) return;
    await _pickBest(emit, s.copyWith(justTaken: const []), count);
  }

  Future<void> _pickBest(Emitter<SeatMapState> emit, SeatMapReady s, int count) async {
    // Our own held seats are free to pick again; everyone else's are not.
    final ids = bestSeats(s.data.seats, count: count, unavailable: s.booked.union(s.heldByOthers));
    if (ids == null) {
      emit(s.copyWith(effect: SeatMapEffect.noBlock, message: null));
      return;
    }
    _tracker.track(JourneyEvent(JourneyEventName.bestSeatsUsed, {'seatCount': ids.length}));
    // Light them up in order before the hold answers (sprint 17), and hold right
    // away so nobody takes them while the customer looks; Continue proceeds. If
    // the server says no, the old selection comes back.
    await _hold(emit, s.copyWith(selected: ids.toSet(), revealOrder: ids), proceed: false, rollbackTo: s.selected);
  }

  Future<void> _onHoldExtendRequested(HoldExtendRequested event, Emitter<SeatMapState> emit) async {
    final s = state;
    if (s is! SeatMapReady || !s.canExtend) return;
    emit(s.copyWith(extending: true, effect: null, message: null));
    final result = await _repository.extend(s.hold!);
    final current = state;
    if (current is! SeatMapReady) return;
    switch (result) {
      case Ok(:final value):
        _tracker.track(JourneyEvent(JourneyEventName.holdExtended, {'step': 'seats'}));
        emit(current.copyWith(
          hold: value,
          extending: false,
          secondsLeft: _secondsLeft(value),
          effect: SeatMapEffect.extended,
        ));
      case Err(failure: ApiFailureServer(code: 'HOLD_EXPIRED')):
        emit(current.copyWith(extending: false));
        add(const HoldExpired());
      case Err(failure: ApiFailureServer(code: 'HOLD_EXTEND_LIMIT', :final message)):
        emit(current.copyWith(
          hold: current.hold?.copyWith(extended: true),
          extending: false,
          effect: SeatMapEffect.conflict,
          message: message,
        ));
      case Err(:final failure):
        emit(current.copyWith(extending: false, effect: SeatMapEffect.conflict, message: _messageOf(failure)));
    }
  }

  void _onHoldChanged(HoldChanged event, Emitter<SeatMapState> emit) {
    final s = state;
    final hold = s is SeatMapReady ? s.hold : null;
    if (s is! SeatMapReady || hold == null || hold.showtimeId != event.hold.showtimeId) return;
    final updated = hold.copyWith(expiresAt: event.hold.expiresAt, extended: event.hold.extended);
    emit(s.copyWith(hold: updated, secondsLeft: _secondsLeft(updated), effect: null));
  }

  /// Holds [s.selected] (releasing seats dropped since the last hold). [proceed]
  /// opens checkout on success; Best seats only holds.
  Future<void> _hold(Emitter<SeatMapState> emit, SeatMapReady s, {required bool proceed, Set<int>? rollbackTo}) async {
    emit(s.copyWith(holding: true, effect: null, message: null));
    final dropped = s.hold?.seatIds.difference(s.selected) ?? const <int>{};
    await _repository.release(s.data.showtimeId, dropped);

    final result = await _repository.hold(s.data.showtimeId, s.selected);
    switch (result) {
      case Ok(:final value):
        _startTicker();
        _tracker.track(JourneyEvent(
          JourneyEventName.seatsHeld,
          {'showtimeId': s.data.showtimeId, 'seatCount': s.selected.length},
        ));
        emit(s.copyWith(
          hold: value,
          holding: false,
          secondsLeft: _secondsLeft(value),
          revealOrder: const [],
          effect: proceed ? SeatMapEffect.proceed : null,
          message: null,
        ));
      case Err(failure: ApiFailureServer(:final code, :final message)) when _seatConflictCodes.contains(code):
        // Someone else got a seat: reload so the map shows it, keep the rest selected.
        await _reload(emit, s.data.showtimeId, keepSelected: rollbackTo ?? s.selected);
        final r = state;
        if (r is SeatMapReady) emit(r.copyWith(effect: SeatMapEffect.conflict, message: message));
      case Err(:final failure):
        // Picks that were only lit up fade back to what was chosen before.
        final back = s.copyWith(holding: false, selected: rollbackTo ?? s.selected, revealOrder: const []);
        emit(switch (failure) {
          ApiFailureServer(code: 'SEAT_LIMIT', :final message) => back.copyWith(effect: SeatMapEffect.limit, message: message),
          ApiFailureServer(code: 'COUPLE_PAIR_INVALID') => back.copyWith(effect: SeatMapEffect.pairError, message: null),
          _ => back.copyWith(effect: SeatMapEffect.conflict, message: _messageOf(failure)),
        });
    }
  }

  /// Codes of the pending selection's seats among [taken] (not our own hold).
  static List<String> _lostCodes(SeatMapReady s, Set<int> taken) {
    final mine = s.hold?.seatIds ?? const <int>{};
    final lost = s.selected.intersection(taken).difference(mine);
    return [for (final seat in s.data.seats) if (lost.contains(seat.id)) seat.code];
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
        final lost = _lostCodes(s, seatIds);
        emit(s.copyWith(
          heldByOthers: s.heldByOthers.union(seatIds),
          selected: s.selected.difference(seatIds),
          justTaken: lost.isEmpty ? s.justTaken : lost,
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
        final lost = _lostCodes(s, seatIds);
        emit(s.copyWith(
          justTaken: lost.isEmpty ? s.justTaken : lost,
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
    await _holdChanges?.cancel();
    final s = state;
    // The seat page closes only after checkout above it is gone, so leaving it
    // always gives the seats back (the server TTL is the backstop).
    if (s is SeatMapReady && s.hold != null) {
      unawaited(_repository.release(s.data.showtimeId, s.hold!.seatIds));
    }
    return super.close();
  }
}
