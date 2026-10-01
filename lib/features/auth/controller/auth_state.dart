import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/auth_failure.dart';
import '../model/user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  /// Restoring a stored session.
  const factory AuthState.unknown() = AuthUnknownState;

  /// Signed out, browsing (the default after start-up — there is no login wall).
  /// [submitting] and [failure] belong to the on-demand login/register screens;
  /// [failure] is shown as a banner until the next submit. [guestCheckout] is set
  /// once the shopper chose "continue as guest" at Book Ticket, so they are not
  /// asked again this session.
  const factory AuthState.guest({
    @Default(false) bool submitting,
    AuthFailure? failure,
    @Default(false) bool guestCheckout,
  }) = AuthGuest;

  const factory AuthState.authenticated(User user) = AuthAuthenticated;

  const factory AuthState.blocked(String message) = AuthBlockedState;
}
