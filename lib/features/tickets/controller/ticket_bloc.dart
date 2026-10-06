import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/telemetry/journey_tracker.dart';
import '../../../core/network/result.dart';
import '../model/tickets_failure.dart';
import '../model/tickets_repository.dart';

part 'ticket_bloc.freezed.dart';

sealed class TicketEvent {
  const TicketEvent();
}

final class QrRequested extends TicketEvent {
  const QrRequested(this.code, {this.source});

  final String code;

  /// Where the ticket was opened from (`up_next`, `booking_detail`, `success`),
  /// for the funnel; null on a retry.
  final String? source;
}

@freezed
sealed class TicketState with _$TicketState {
  const factory TicketState.initial() = TicketInitial;
  const factory TicketState.loading(String code) = TicketLoading;

  /// [png] is the server's QR image for [code]; [offline] when it is the device
  /// copy, saved at [savedAt].
  const factory TicketState.ready({
    required String code,
    required Uint8List png,
    @Default(false) bool offline,
    DateTime? savedAt,
  }) = TicketReady;
  const factory TicketState.failure({required String code, required TicketsFailure failure}) = TicketFailureState;
}

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc(this._repository, {this._tracker = const NoopJourneyTracker()}) : super(const TicketState.initial()) {
    on<QrRequested>(_onQrRequested);
  }

  final JourneyTracker _tracker;
  final TicketsRepository _repository;

  Future<void> _onQrRequested(QrRequested event, Emitter<TicketState> emit) async {
    final source = event.source;
    if (source != null) _tracker.track(JourneyEvent(JourneyEventName.ticketOpened, {'source': source}));
    emit(TicketState.loading(event.code));
    emit(switch (await _repository.qrBytes(event.code)) {
      Ok(:final value) =>
        TicketState.ready(code: event.code, png: value.png, offline: value.offline, savedAt: value.savedAt),
      Err(:final failure) => TicketState.failure(code: event.code, failure: failure),
    });
  }
}
