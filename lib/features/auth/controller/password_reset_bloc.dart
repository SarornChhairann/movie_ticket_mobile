import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/result.dart';
import '../model/auth_failure.dart';
import '../model/auth_repository.dart';

part 'password_reset_bloc.freezed.dart';

sealed class PasswordResetEvent {
  const PasswordResetEvent();
}

/// Step 1: email the code to [email].
final class ResetCodeRequested extends PasswordResetEvent {
  const ResetCodeRequested(this.email);

  final String email;
}

/// Step 2: send another code to the same email.
final class ResetCodeResent extends PasswordResetEvent {
  const ResetCodeResent();
}

/// Step 2: back to step 1 to fix the email.
final class ResetEmailEditRequested extends PasswordResetEvent {
  const ResetEmailEditRequested();
}

/// Step 2: set [newPassword] with the emailed [code].
final class ResetSubmitted extends PasswordResetEvent {
  const ResetSubmitted({required this.code, required this.newPassword});

  final String code;
  final String newPassword;
}

enum PasswordResetStep { email, code, done }

/// One screen, two steps. [notice] is a one-shot flag (`codeSent`) for a
/// snackbar, consumed by a `BlocListener`.
@freezed
abstract class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState({
    @Default(PasswordResetStep.email) PasswordResetStep step,
    @Default('') String email,
    @Default(false) bool submitting,
    AuthFailure? failure,
    PasswordResetNotice? notice,
  }) = _PasswordResetState;
}

enum PasswordResetNotice { codeSent }

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetBloc(this._repository) : super(const PasswordResetState()) {
    on<ResetCodeRequested>((event, emit) => _sendCode(event.email.trim(), emit));
    on<ResetCodeResent>((_, emit) => _sendCode(state.email, emit));
    on<ResetEmailEditRequested>((_, emit) => emit(state.copyWith(step: PasswordResetStep.email, failure: null)));
    on<ResetSubmitted>(_onSubmitted);
  }

  final AuthRepository _repository;

  Future<void> _sendCode(String email, Emitter<PasswordResetState> emit) async {
    if (state.submitting) return;
    emit(state.copyWith(email: email, submitting: true, failure: null, notice: null));
    emit(switch (await _repository.requestPasswordReset(email)) {
      Ok() => state.copyWith(step: PasswordResetStep.code, submitting: false, notice: PasswordResetNotice.codeSent),
      Err(:final failure) => state.copyWith(submitting: false, failure: failure),
    });
  }

  Future<void> _onSubmitted(ResetSubmitted event, Emitter<PasswordResetState> emit) async {
    if (state.submitting) return;
    emit(state.copyWith(submitting: true, failure: null, notice: null));
    final result = await _repository.resetPassword(
      email: state.email,
      code: event.code,
      newPassword: event.newPassword,
    );
    emit(switch (result) {
      Ok() => state.copyWith(step: PasswordResetStep.done, submitting: false),
      Err(:final failure) => state.copyWith(submitting: false, failure: failure),
    });
  }
}
