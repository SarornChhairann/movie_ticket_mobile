import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/result.dart';
import '../model/checkout_failure.dart';
import '../model/checkout_repository.dart';
import '../model/payway.dart';
import 'payway_event.dart';
import 'payway_state.dart';

export 'payway_event.dart';
export 'payway_state.dart';

/// The PayWay web view screen: polls the server every [pollEvery] until PayWay
/// settles the payment, and closes the transaction when the customer leaves or
/// the hold ends.
class PaywayBloc extends Bloc<PaywayEvent, PaywayState> {
  PaywayBloc(
    this._repository,
    PaywayLaunch launch, {
    DateTime Function()? clock,
    this.pollEvery = const Duration(seconds: 3),
  })  : _clock = clock ?? DateTime.now,
        super(PaywayState(launch: launch)) {
    on<PaywayOpened>(_onOpened);
    on<PaywayPolled>(_onPolled);
    on<PaywayResumed>(_onPolled);
    on<PaywayCloseRequested>((_, emit) => _close(emit, const PaywayOutcome.dismissed()));
    on<PaywayHoldExpired>((_, emit) => _close(emit, const PaywayOutcome.holdExpired()));
  }

  /// Failures in a row before the message shows.
  static const failuresBeforeMessage = 3;

  final CheckoutRepository _repository;
  final DateTime Function() _clock;
  final Duration pollEvery;
  Timer? _poller;
  Timer? _holdTimer;
  bool _polling = false;

  String get _tranId => state.launch.session.tranId;

  void _onOpened(PaywayOpened event, Emitter<PaywayState> emit) {
    _poller?.cancel();
    _poller = Timer.periodic(pollEvery, (_) => add(const PaywayPolled()));
    _holdTimer?.cancel();
    final left = state.launch.holdExpiresAt.difference(_clock());
    _holdTimer = Timer(left.isNegative ? Duration.zero : left, () => add(const PaywayHoldExpired()));
  }

  Future<void> _onPolled(PaywayEvent event, Emitter<PaywayState> emit) async {
    if (_polling || state.outcome != null || state.closing) return;
    _polling = true;
    try {
      final result = await _repository.pollPayway(_tranId);
      if (state.outcome != null || state.closing) return;
      switch (result) {
        case Ok(value: PaywayPending()):
          emit(state.copyWith(failures: 0, message: null));
        case Ok(value: PaywayApproved(:final confirmation)):
          _finish(emit, PaywayOutcome.approved(confirmation));
        case Ok(value: PaywayDeclined()):
          _finish(emit, const PaywayOutcome.declined());
        case Ok(value: PaywayCancelled()):
          _finish(emit, const PaywayOutcome.cancelled());
        case Err(:final failure):
          // Keep polling; only say something after a few misses in a row.
          final failures = state.failures + 1;
          emit(state.copyWith(
            failures: failures,
            message: failures >= failuresBeforeMessage ? _messageOf(failure) : null,
          ));
      }
    } finally {
      _polling = false;
    }
  }

  Future<void> _close(Emitter<PaywayState> emit, PaywayOutcome fallback) async {
    if (state.outcome != null || state.closing) return;
    _stopTimers();
    emit(state.copyWith(closing: true));
    final result = await _repository.closePayway(_tranId);
    // A payment approved just before the close still completes.
    final outcome = switch (result) {
      Ok(value: PaywayApproved(:final confirmation)) => PaywayOutcome.approved(confirmation),
      _ => fallback,
    };
    emit(state.copyWith(closing: false, outcome: outcome));
  }

  void _finish(Emitter<PaywayState> emit, PaywayOutcome outcome) {
    _stopTimers();
    emit(state.copyWith(outcome: outcome, message: null));
  }

  void _stopTimers() {
    _poller?.cancel();
    _holdTimer?.cancel();
  }

  /// '' means the view shows its generic offline text.
  static String _messageOf(CheckoutFailure failure) => switch (failure) {
        CheckoutPromoInvalid(:final message) ||
        CheckoutSeatConflict(:final message) ||
        CheckoutPaymentFailed(:final message) ||
        CheckoutBlocked(:final message) ||
        CheckoutUnknown(:final message) =>
          message,
        CheckoutHoldExpired() || CheckoutPairInvalid() || CheckoutNetwork() => '',
      };

  /// Whether the poll timer is running (tests).
  bool get isPolling => _poller?.isActive ?? false;

  @override
  Future<void> close() {
    _stopTimers();
    return super.close();
  }
}
