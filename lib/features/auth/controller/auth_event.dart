import '../../../core/session/session_end.dart';
import '../model/user.dart';

sealed class AuthEvent {
  const AuthEvent();
}

/// App start: restore a stored session if there is one.
final class SessionStarted extends AuthEvent {
  const SessionStarted();
}

final class LoginRequested extends AuthEvent {
  const LoginRequested({required this.email, required this.password});

  final String email;
  final String password;
}

final class RegisterRequested extends AuthEvent {
  const RegisterRequested({required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;
}

/// The shopper chose to book without an account (guest checkout).
final class GuestContinued extends AuthEvent {
  const GuestContinued();
}

/// The login screen is about to open: clear any stale banner.
final class SignInRequested extends AuthEvent {
  const SignInRequested();
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// The network layer cleared the session.
final class SessionEnded extends AuthEvent {
  const SessionEnded(this.reason);

  final SessionEnd reason;
}

/// The blocked notice was dismissed.
final class BlockedAcknowledged extends AuthEvent {
  const BlockedAcknowledged();
}

/// Something server-side changed the user (points after a purchase): reload it.
final class UserRefreshRequested extends AuthEvent {
  const UserRefreshRequested();
}

/// Profile edits changed the signed-in user.
final class UserUpdated extends AuthEvent {
  const UserUpdated(this.user);

  final User user;
}
