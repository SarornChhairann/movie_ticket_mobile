import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/auth_failure.dart';
import '../model/user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  /// Restoring a stored session.
  const factory AuthState.unknown() = AuthUnknownState;

  /// On the login/register screens. [failure] is shown as a banner until the
  /// next submit.
  const factory AuthState.unauthenticated({
    @Default(false) bool submitting,
    AuthFailure? failure,
  }) = AuthUnauthenticated;

  const factory AuthState.guest() = AuthGuest;

  const factory AuthState.authenticated(User user) = AuthAuthenticated;

  const factory AuthState.blocked(String message) = AuthBlockedState;
}
