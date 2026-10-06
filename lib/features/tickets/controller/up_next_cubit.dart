import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/cinema_clock.dart';
import '../../../core/model/booking_summary.dart';
import '../../../core/network/result.dart';
import '../model/ticket_wallet.dart';
import '../model/tickets_repository.dart';

/// Home's Up next (sprint 18): the next confirmed show within a week, and the
/// cinema-clock time to count down from. Ticks once a minute; hides when the
/// show starts.
class UpNextState {
  const UpNextState({this.booking, required this.now});

  final BookingSummary? booking;

  /// Cinema wall clock at the last tick.
  final DateTime now;
}

class UpNextCubit extends Cubit<UpNextState> {
  UpNextCubit(this._repository, {DateTime Function()? clock, this.tick = const Duration(minutes: 1)})
      : _clock = clock ?? CinemaClock.now,
        super(UpNextState(now: (clock ?? CinemaClock.now)()));

  final TicketsRepository _repository;
  final DateTime Function() _clock;
  final Duration tick;
  Timer? _timer;
  List<BookingSummary> _bookings = const [];

  /// The account's bookings (server, falling back to the device copy) when
  /// [signedIn], else the guest's bookings saved on this phone.
  Future<void> load({required bool signedIn}) async {
    if (signedIn) {
      _bookings = switch (await _repository.myBookings()) {
        Ok(:final value) => value.bookings,
        Err() => const [],
      };
    } else {
      _bookings = await _repository.savedGuestBookings();
    }
    _refresh();
    _timer?.cancel();
    _timer = Timer.periodic(tick, (_) => _refresh());
  }

  void _refresh() {
    if (isClosed) return;
    final now = _clock();
    emit(UpNextState(booking: nextBooking(_bookings, now), now: now));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
