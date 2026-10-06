import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/network/result.dart';
import '../model/tickets_failure.dart';
import '../model/tickets_repository.dart';

part 'booking_lookup_bloc.freezed.dart';

sealed class BookingLookupEvent {
  const BookingLookupEvent();
}

final class LookupSubmitted extends BookingLookupEvent {
  const LookupSubmitted({required this.reference, required this.phone});

  final String reference;
  final String phone;
}

@freezed
abstract class BookingLookupState with _$BookingLookupState {
  const factory BookingLookupState({
    @Default(false) bool submitting,

    /// Set once; the view pops with it.
    BookingSummary? found,
    TicketsFailure? failure,
  }) = _BookingLookupState;
}

/// Guest "Find my booking": reference + phone → the booking, saved on the device.
class BookingLookupBloc extends Bloc<BookingLookupEvent, BookingLookupState> {
  BookingLookupBloc(this._repository) : super(const BookingLookupState()) {
    on<LookupSubmitted>(_onSubmitted);
  }

  final TicketsRepository _repository;

  Future<void> _onSubmitted(LookupSubmitted event, Emitter<BookingLookupState> emit) async {
    // One lookup at a time, and none once found (the page is leaving).
    if (state.submitting || state.found != null) return;
    emit(state.copyWith(submitting: true, failure: null));
    emit(switch (await _repository.lookup(event.reference, event.phone)) {
      Ok(:final value) => state.copyWith(submitting: false, found: value),
      Err(:final failure) => state.copyWith(submitting: false, failure: failure),
    });
  }
}
