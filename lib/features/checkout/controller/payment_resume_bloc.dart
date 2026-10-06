import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/network/result.dart';
import '../../../core/session/pending_payment_store.dart';
import '../../../core/storage/booking_cache.dart';
import '../model/checkout_failure.dart';
import '../model/checkout_repository.dart';
import '../model/payway.dart';

part 'payment_resume_bloc.freezed.dart';

sealed class PaymentResumeEvent {
  const PaymentResumeEvent();
}

/// The resume screen opened: ask the server now, then keep asking.
final class ResumeStarted extends PaymentResumeEvent {
  const ResumeStarted();
}

/// Internal: the poll timer fired.
final class ResumePolled extends PaymentResumeEvent {
  const ResumePolled();
}

/// How the payment the last run left open ended.
@freezed
sealed class ResumeOutcome with _$ResumeOutcome {
  const factory ResumeOutcome.approved(BookingSummary confirmation) = ResumeApproved;

  /// Declined, cancelled, closed, or the hold ran out: no tickets, seats not booked.
  const factory ResumeOutcome.failed() = ResumeFailed;
}

@freezed
abstract class PaymentResumeState with _$PaymentResumeState {
  const factory PaymentResumeState({
    required PendingPayment payment,

    /// Polls that failed in a row on the network; the offline note shows from the third.
    @Default(0) int failures,

    /// Set once; the view leaves with it.
    ResumeOutcome? outcome,
  }) = _PaymentResumeState;
}

/// Picks up an ABA payment the previous run left open (sprint 13). The session id
/// was restored at start-up, so the server still treats this run as the owner.
/// Settled → the pending record is cleared; network trouble → it stays, so the
/// next start can try again.
class PaymentResumeBloc extends Bloc<PaymentResumeEvent, PaymentResumeState> {
  PaymentResumeBloc(
    this._repository,
    PendingPayment payment, {
    required this._store,
    this._cache,
    DateTime Function()? clock,
    this.pollEvery = const Duration(seconds: 3),
  })  : _clock = clock ?? DateTime.now,
        super(PaymentResumeState(payment: payment)) {
    on<ResumeStarted>(_onStarted);
    on<ResumePolled>(_onPolled);
  }

  /// Network failures in a row before the offline note shows.
  static const failuresBeforeMessage = 3;

  final CheckoutRepository _repository;
  final PendingPaymentStore _store;
  final BookingCache? _cache;
  final DateTime Function() _clock;
  final Duration pollEvery;
  Timer? _poller;
  bool _busy = false;

  Future<void> _onStarted(ResumeStarted event, Emitter<PaymentResumeState> emit) async {
    _poller?.cancel();
    _poller = Timer.periodic(pollEvery, (_) => add(const ResumePolled()));
    await _onPolled(const ResumePolled(), emit);
  }

  Future<void> _onPolled(ResumePolled event, Emitter<PaymentResumeState> emit) async {
    if (_busy || state.outcome != null) return;
    _busy = true;
    try {
      final tranId = state.payment.tranId;
      var result = await _repository.pollPayway(tranId);
      // Still pending after the hold ended: close it, unless it was approved just now.
      if (result case Ok(value: PaywayPending()) when !_clock().isBefore(state.payment.holdExpiresAt)) {
        result = await _repository.closePayway(tranId);
        if (result case Ok(value: PaywayPending())) {
          result = const Ok(PaywayStatus.cancelled());
        }
      }
      switch (result) {
        case Ok(value: PaywayPending()):
          emit(state.copyWith(failures: 0));
        case Ok(value: PaywayApproved(:final confirmation)):
          final phone = state.payment.guestPhone;
          await _cache?.put(phone == null ? BookingOwner.account : BookingOwner.guest, confirmation, phone: phone);
          await _settle(emit, ResumeOutcome.approved(confirmation));
        case Ok(value: PaywayDeclined() || PaywayCancelled()):
          await _settle(emit, const ResumeOutcome.failed());
        case Err(failure: CheckoutNetwork()):
          emit(state.copyWith(failures: state.failures + 1));
        case Err():
          // The server answered and will not settle it for us (e.g. no longer ours).
          await _settle(emit, const ResumeOutcome.failed());
      }
    } finally {
      _busy = false;
    }
  }

  Future<void> _settle(Emitter<PaymentResumeState> emit, ResumeOutcome outcome) async {
    _poller?.cancel();
    await _store.clear();
    emit(state.copyWith(outcome: outcome));
  }

  /// Whether the poll timer is running (tests).
  bool get isPolling => _poller?.isActive ?? false;

  @override
  Future<void> close() {
    _poller?.cancel();
    return super.close();
  }
}
