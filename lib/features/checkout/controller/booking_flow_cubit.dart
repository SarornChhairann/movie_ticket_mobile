import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/telemetry/journey_tracker.dart';
import '../../../core/widgets/booking_progress.dart';

part 'booking_flow_cubit.freezed.dart';

/// Where the customer is in one booking and what they are buying (sprint 16).
@freezed
abstract class BookingFlowState with _$BookingFlowState {
  const factory BookingFlowState({
    @Default(FlowStep.seats) FlowStep step,
    @Default(false) bool snacksSkipped,
    int? showtimeId,
    @Default('') String title,
    String? posterUrl,
    @Default('') String hallName,
    String? showDate,
    String? showTime,
    @Default(<String>[]) List<String> seatCodes,
    @Default(0) int foodCount,

    /// The server's total, once a quote has come back; never computed here.
    num? totalAmount,

    /// When the hold ends; null while nothing is held.
    DateTime? holdExpiresAt,
  }) = _BookingFlowState;
}

/// Read-only aggregation of what the steps already know: the seat map and
/// checkout blocs stay the source of truth and push their facts in here. It owns
/// no rules — only which step is showing.
class BookingFlowCubit extends Cubit<BookingFlowState> {
  BookingFlowCubit({String? posterUrl, this._tracker = const NoopJourneyTracker()})
      : super(BookingFlowState(posterUrl: posterUrl));

  final JourneyTracker _tracker;

  /// The seat map loaded or changed (showtime, held seats, expiry).
  void seatsChanged({
    required int showtimeId,
    required String title,
    required String hallName,
    String? showDate,
    String? showTime,
    required List<String> seatCodes,
    DateTime? holdExpiresAt,
  }) {
    emit(state.copyWith(
      showtimeId: showtimeId,
      title: title,
      hallName: hallName,
      showDate: showDate,
      showTime: showTime,
      seatCodes: seatCodes,
      holdExpiresAt: holdExpiresAt,
    ));
  }

  /// Checkout has a server quote: food units and the server total.
  void quoteChanged({required int foodCount, required num totalAmount, required DateTime holdExpiresAt}) {
    emit(state.copyWith(foodCount: foodCount, totalAmount: totalAmount, holdExpiresAt: holdExpiresAt));
  }

  /// Arrived on checkout from the seat map: Snacks when there is a menu, else
  /// straight to Pay with Snacks marked skipped.
  void enteredCheckout({required bool hasMenu}) {
    if (state.step != FlowStep.seats) return;
    emit(hasMenu
        ? state.copyWith(step: FlowStep.snacks, snacksSkipped: false)
        : state.copyWith(step: FlowStep.pay, snacksSkipped: true));
  }

  /// Snacks → Pay. [skipped] when the customer took nothing.
  void snacksDone({required bool skipped}) {
    if (skipped) _tracker.track(JourneyEvent(JourneyEventName.snacksSkipped, {'step': FlowStep.snacks.name}));
    emit(state.copyWith(step: FlowStep.pay, snacksSkipped: skipped));
  }

  /// The flow ends with the seat map: unless it reached Tickets, it was
  /// abandoned at its current step.
  @override
  Future<void> close() {
    if (state.showtimeId != null && state.step != FlowStep.tickets) {
      _tracker.track(JourneyEvent(JourneyEventName.flowAbandoned, {'step': state.step.name}));
    }
    return super.close();
  }

  void stepTo(FlowStep step) => emit(state.copyWith(step: step));

  /// Back to the seat map: the hold may still be live, the basket stays.
  void backToSeats() => emit(state.copyWith(step: FlowStep.seats, totalAmount: null));

  /// The hold ended (expired, or the server no longer has it): nothing is held.
  void holdLost() => emit(state.copyWith(step: FlowStep.seats, seatCodes: const [], holdExpiresAt: null, totalAmount: null));

  void paid() => emit(state.copyWith(step: FlowStep.tickets, holdExpiresAt: null));

  /// Seconds left on the hold at [now], or null when nothing is held.
  int? secondsLeft(DateTime now) {
    final end = state.holdExpiresAt;
    if (end == null) return null;
    final left = end.difference(now).inSeconds;
    return left < 0 ? 0 : left;
  }
}

/// The flow cubit above [context], or null outside a booking flow (e.g. a seat
/// map opened from a test or a deep link).
BookingFlowCubit? maybeFlow(BuildContext context) {
  try {
    return BlocProvider.of<BookingFlowCubit>(context, listen: false);
  } on Object {
    return null;
  }
}
