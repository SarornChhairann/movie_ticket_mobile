import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../controller/auth_bloc.dart';

/// How an on-demand sign-in ended.
enum AuthGateResult {
  /// Signed in (now or already): continue the action as the user.
  signedIn,

  /// Chose guest checkout: continue the action without an account.
  guest,

  /// Closed the login screen: do not continue.
  dismissed,
}

/// Login route argument: why sign-in is asked for, and whether "continue as
/// guest" is offered (only where the API supports guests, i.e. checkout).
class LoginArgs {
  const LoginArgs({this.reasonKey, this.allowGuest = false});

  /// Translation key shown under the title, e.g. `auth.reason.bookings`.
  final String? reasonKey;
  final bool allowGuest;
}

/// E-commerce style gate: browsing is open, and an action that needs an account
/// calls this first. Signed-in users pass straight through; otherwise the login
/// screen opens over the current one and the caller resumes with the result.
Future<AuthGateResult> requireSignIn(
  BuildContext context, {
  String? reasonKey,
  bool allowGuest = false,
}) async {
  final auth = context.read<AuthBloc>();
  final state = auth.state;
  if (state is AuthAuthenticated) return AuthGateResult.signedIn;
  if (allowGuest && state is AuthGuest && state.guestCheckout) return AuthGateResult.guest;

  auth.add(const SignInRequested());
  final result = await Navigator.of(context).pushNamed<AuthGateResult>(
    AppRoutes.login,
    arguments: LoginArgs(reasonKey: reasonKey, allowGuest: allowGuest),
  );
  // Back gesture/button returns null.
  if (result != null) return result;
  return auth.state is AuthAuthenticated ? AuthGateResult.signedIn : AuthGateResult.dismissed;
}
