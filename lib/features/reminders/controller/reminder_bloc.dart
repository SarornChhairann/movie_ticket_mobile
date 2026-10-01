import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/result.dart';
import '../model/reminder_repository.dart';

part 'reminder_bloc.freezed.dart';

sealed class ReminderEvent {
  const ReminderEvent();
}

final class SubmitRequested extends ReminderEvent {
  const SubmitRequested({required this.movieId, required this.email});

  final int movieId;
  final String email;
}

@freezed
sealed class ReminderState with _$ReminderState {
  const factory ReminderState.idle() = ReminderIdle;
  const factory ReminderState.submitting() = ReminderSubmitting;
  const factory ReminderState.success() = ReminderSuccess;

  /// `REMINDER_EXISTS` — shown as a friendly notice, not an error.
  const factory ReminderState.alreadySubscribed() = ReminderAlreadySubscribed;

  /// [message] is the server's text; empty when the network failed.
  const factory ReminderState.failure(String message) = ReminderFailureState;
}

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc(this._repository) : super(const ReminderState.idle()) {
    on<SubmitRequested>(_onSubmitRequested);
  }

  final ReminderRepository _repository;

  Future<void> _onSubmitRequested(SubmitRequested event, Emitter<ReminderState> emit) async {
    if (state is ReminderSubmitting) return;
    emit(const ReminderState.submitting());
    emit(switch (await _repository.subscribe(movieId: event.movieId, email: event.email)) {
      Ok() => const ReminderState.success(),
      Err(failure: ReminderExists()) => const ReminderState.alreadySubscribed(),
      Err(:final failure) => ReminderState.failure(failure.message),
    });
  }
}
