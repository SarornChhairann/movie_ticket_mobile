import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';
import '../../auth/model/user.dart';

part 'profile_state.freezed.dart';

/// One-shot outcome of a save, consumed by a `BlocListener`.
enum ProfileNotice { saved, passwordChanged }

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileInitial;
  const factory ProfileState.loading() = ProfileLoading;

  /// [error] is the server message of the last failed save; [notice] is set
  /// once after a successful one. Both reset on the next action.
  const factory ProfileState.ready(
    User user, {
    @Default(false) bool saving,
    String? error,
    ProfileNotice? notice,
  }) = ProfileReady;

  const factory ProfileState.failure(ApiFailure failure) = ProfileFailure;
}
