import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/result.dart';
import '../../../core/telemetry/journey_tracker.dart';
import '../model/shell_repository.dart';
import 'shell_state.dart';

/// Tracks API connectivity for the home shell (offline = a failure, or the saved
/// copy when the server could not be reached) and Home visits. Locale is owned
/// by EasyLocalization, not duplicated here.
class ShellCubit extends Cubit<ShellState> {
  ShellCubit(this._repository, {this._tracker = const NoopJourneyTracker()}) : super(const ShellState.initial());

  final ShellRepository _repository;
  final JourneyTracker _tracker;

  Future<void> pingRequested() async {
    emit(const ShellState.loading());
    final result = await _repository.fetchHome();
    if (isClosed) return;
    emit(switch (result) {
      Ok(:final value, :final savedAt) => ShellState.ready(value, savedAt: savedAt),
      Err(:final failure) => ShellState.failure(failure),
    });
  }

  /// Home came on screen: cold start or a tab switch to Home, never a refresh (sprint 21).
  void homeViewed() => _tracker.track(JourneyEvent(JourneyEventName.homeViewed));
}
