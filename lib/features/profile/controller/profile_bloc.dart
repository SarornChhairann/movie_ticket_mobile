import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../model/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repository) : super(const ProfileState.initial()) {
    on<ProfileLoaded>(_onLoaded);
    on<ProfileSaved>(_onSaved);
    on<PasswordChangeRequested>(_onPasswordChangeRequested);
  }

  final ProfileRepository _repository;

  Future<void> _onLoaded(ProfileLoaded event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    emit(switch (await _repository.fetch()) {
      Ok(:final value) => ProfileState.ready(value),
      Err(:final failure) => ProfileState.failure(failure),
    });
  }

  Future<void> _onSaved(ProfileSaved event, Emitter<ProfileState> emit) async {
    final current = state;
    if (current is! ProfileReady || current.saving) {
      return;
    }
    emit(current.copyWith(saving: true, error: null, notice: null));
    emit(switch (await _repository.update(name: event.name, phone: event.phone)) {
      Ok(:final value) => ProfileState.ready(value, notice: ProfileNotice.saved),
      Err(:final failure) => current.copyWith(saving: false, error: _messageOf(failure), notice: null),
    });
  }

  Future<void> _onPasswordChangeRequested(
    PasswordChangeRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    if (current is! ProfileReady || current.saving) {
      return;
    }
    emit(current.copyWith(saving: true, error: null, notice: null));
    final result = await _repository.changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      confirmPassword: event.confirmPassword,
    );
    emit(switch (result) {
      Ok() => current.copyWith(saving: false, error: null, notice: ProfileNotice.passwordChanged),
      Err(:final failure) => current.copyWith(saving: false, error: _messageOf(failure), notice: null),
    });
  }

  static String _messageOf(ApiFailure failure) => switch (failure) {
        ApiFailureServer(:final message) => message,
        ApiFailureNetwork() => '',
        ApiFailureUnknown(:final message) => message ?? '',
      };
}
