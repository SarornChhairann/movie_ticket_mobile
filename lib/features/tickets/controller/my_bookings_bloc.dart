import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/network/result.dart';
import '../model/tickets_failure.dart';
import '../model/tickets_repository.dart';

part 'my_bookings_bloc.freezed.dart';

sealed class MyBookingsEvent {
  const MyBookingsEvent();
}

final class LoadRequested extends MyBookingsEvent {
  const LoadRequested();
}

/// Pull to refresh: keeps the list on screen while it reloads.
final class RefreshRequested extends MyBookingsEvent {
  const RefreshRequested();
}

final class CancelRequested extends MyBookingsEvent {
  const CancelRequested(this.bookingId);

  final int bookingId;
}

/// One-shot outcomes consumed by a `BlocListener`.
enum MyBookingsEffect { cancelled, error }

@freezed
sealed class MyBookingsState with _$MyBookingsState {
  const MyBookingsState._();

  const factory MyBookingsState.initial() = MyBookingsInitial;
  const factory MyBookingsState.loading() = MyBookingsLoading;

  const factory MyBookingsState.ready({
    /// Server order: newest first.
    required List<BookingSummary> bookings,
    @Default(false) bool refreshing,

    /// The booking whose cancel is in flight.
    int? cancellingId,
    MyBookingsEffect? effect,

    /// Server message for [effect]; empty when the network failed.
    String? message,
  }) = MyBookingsReady;

  const factory MyBookingsState.failure(TicketsFailure failure) = MyBookingsFailure;

  BookingSummary? bookingById(int id) => switch (this) {
        MyBookingsReady(:final bookings) => bookings.where((b) => b.bookingId == id).firstOrNull,
        _ => null,
      };
}

class MyBookingsBloc extends Bloc<MyBookingsEvent, MyBookingsState> {
  MyBookingsBloc(this._repository) : super(const MyBookingsState.initial()) {
    on<LoadRequested>(_onLoadRequested);
    on<RefreshRequested>(_onRefreshRequested);
    on<CancelRequested>(_onCancelRequested);
  }

  final TicketsRepository _repository;

  Future<void> _onLoadRequested(LoadRequested event, Emitter<MyBookingsState> emit) async {
    emit(const MyBookingsState.loading());
    emit(switch (await _repository.myBookings()) {
      Ok(:final value) => MyBookingsState.ready(bookings: value),
      Err(:final failure) => MyBookingsState.failure(failure),
    });
  }

  Future<void> _onRefreshRequested(RefreshRequested event, Emitter<MyBookingsState> emit) async {
    final s = state;
    if (s is! MyBookingsReady) return _onLoadRequested(const LoadRequested(), emit);
    emit(s.copyWith(refreshing: true, effect: null, message: null));
    emit(switch (await _repository.myBookings()) {
      Ok(:final value) => MyBookingsState.ready(bookings: value),
      Err(:final failure) => s.copyWith(refreshing: false, effect: MyBookingsEffect.error, message: failure.message),
    });
  }

  Future<void> _onCancelRequested(CancelRequested event, Emitter<MyBookingsState> emit) async {
    final s = state;
    if (s is! MyBookingsReady || s.cancellingId != null) return;
    emit(s.copyWith(cancellingId: event.bookingId, effect: null, message: null));

    switch (await _repository.cancel(event.bookingId)) {
      case Ok(:final value):
        final bookings = await _rereadCancelled(s.bookings, event.bookingId);
        emit(MyBookingsState.ready(bookings: bookings, effect: MyBookingsEffect.cancelled, message: value));
      case Err(failure: TicketsAlreadyCancelled(:final message)):
        // The list was stale; show what the server has now.
        final bookings = await _rereadCancelled(s.bookings, event.bookingId);
        emit(MyBookingsState.ready(bookings: bookings, effect: MyBookingsEffect.error, message: message));
      case Err(:final failure):
        // Booking unchanged (e.g. CANCEL_WINDOW): it stays confirmed.
        emit(s.copyWith(effect: MyBookingsEffect.error, message: failure.message));
    }
  }

  /// Replaces cancelled booking [id] with the server's copy, or marks it
  /// cancelled locally if that read fails.
  Future<List<BookingSummary>> _rereadCancelled(List<BookingSummary> bookings, int id) async {
    final fresh = switch (await _repository.booking(id)) {
      Ok(:final value) => value,
      Err() => null,
    };
    return [
      for (final b in bookings)
        if (b.bookingId == id) fresh ?? _markCancelled(b) else b,
    ];
  }

  static BookingSummary _markCancelled(BookingSummary b) => b.copyWith(
        status: BookingStatus.cancelled,
        tickets: [for (final t in b.tickets) t.copyWith(status: 'CANCELLED')],
      );
}
