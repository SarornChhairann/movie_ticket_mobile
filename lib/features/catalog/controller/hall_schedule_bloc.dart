import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../model/hall.dart';
import '../model/hall_repository.dart';

part 'hall_schedule_bloc.freezed.dart';

sealed class HallScheduleEvent {
  const HallScheduleEvent();
}

final class ScheduleRequested extends HallScheduleEvent {
  const ScheduleRequested(this.hallId);

  final int hallId;
}

final class DateSelected extends HallScheduleEvent {
  const DateSelected(this.date);

  final DateTime date;
}

@freezed
sealed class HallScheduleState with _$HallScheduleState {
  const factory HallScheduleState.initial() = HallScheduleInitial;
  const factory HallScheduleState.loading(int hallId) = HallScheduleLoading;

  const factory HallScheduleState.ready({
    required int hallId,
    required HallSchedule schedule,

    /// A date change is loading; the previous date stays on screen.
    @Default(false) bool refreshing,
  }) = HallScheduleReady;

  const factory HallScheduleState.failure(int hallId, ApiFailure failure) = HallScheduleFailure;
}

/// One hall's bookable schedule. No hold and no total here: a time opens the seat map.
class HallScheduleBloc extends Bloc<HallScheduleEvent, HallScheduleState> {
  HallScheduleBloc(this._repository) : super(const HallScheduleState.initial()) {
    on<ScheduleRequested>(_onRequested);
    on<DateSelected>(_onDateSelected);
  }

  final HallRepository _repository;

  Future<void> _onRequested(ScheduleRequested event, Emitter<HallScheduleState> emit) async {
    emit(HallScheduleState.loading(event.hallId));
    final result = await _repository.fetchSchedule(event.hallId);
    emit(switch (result) {
      Ok(:final value) => HallScheduleState.ready(hallId: event.hallId, schedule: value),
      Err(:final failure) => HallScheduleState.failure(event.hallId, failure),
    });
  }

  Future<void> _onDateSelected(DateSelected event, Emitter<HallScheduleState> emit) async {
    final s = state;
    if (s is! HallScheduleReady || s.refreshing || event.date == s.schedule.selectedDate) return;
    emit(s.copyWith(refreshing: true));
    final result = await _repository.fetchSchedule(s.hallId, date: event.date);
    emit(switch (result) {
      Ok(:final value) => s.copyWith(schedule: value, refreshing: false),
      Err(:final failure) => HallScheduleState.failure(s.hallId, failure),
    });
  }
}
