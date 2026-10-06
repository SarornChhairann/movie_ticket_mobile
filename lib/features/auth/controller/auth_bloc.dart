import '../../../core/storage/booking_cache.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/result.dart';
import '../../../core/session/session_end.dart';
import '../model/auth_failure.dart';
import '../model/auth_repository.dart';
import '../model/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

/// App-level session state. Provided above the navigator. Signed out is
/// [AuthGuest]: the app opens on Home and asks for sign-in only when an action
/// needs it (see `requireSignIn`).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository, {this._bookingCache}) : super(const AuthState.unknown()) {
    on<SessionStarted>(_onSessionStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GuestContinued>((_, emit) => emit(const AuthState.guest(guestCheckout: true)));
    on<SignInRequested>(_onSignInRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<SessionEnded>(_onSessionEnded);
    on<BlockedAcknowledged>((_, emit) => emit(const AuthState.guest()));
    on<UserUpdated>(_onUserUpdated);
    on<UserRefreshRequested>(_onUserRefreshRequested);
    _sessionEndedSubscription = _repository.sessionEnded.listen((reason) => add(SessionEnded(reason)));
  }

  final AuthRepository _repository;
  late final StreamSubscription<SessionEnd> _sessionEndedSubscription;

  /// The account's bookings saved on the device leave with the session; null in tests.
  final BookingCache? _bookingCache;

  Future<void> _onSessionStarted(SessionStarted event, Emitter<AuthState> emit) async {
    final result = await _repository.restoreSession();
    emit(switch (result) {
      Ok(value: final User user) => _signedIn(user),
      Ok() => const AuthState.guest(),
      Err(failure: AuthBlocked(:final message)) => AuthState.blocked(message),
      // Offline or a server error: still open Home; the banner shows on next sign-in.
      Err(:final failure) => AuthState.guest(failure: failure),
    });
  }

  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) {
    final s = state;
    if (s is AuthGuest) emit(s.copyWith(submitting: false, failure: null));
  }

  /// The guest state while a login/register call runs, keeping the checkout choice.
  AuthState get _submitting => switch (state) {
        AuthGuest(:final guestCheckout) => AuthState.guest(submitting: true, guestCheckout: guestCheckout),
        _ => const AuthState.guest(submitting: true),
      };

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(_submitting);
    emit(_fromResult(await _repository.login(event.email, event.password)));
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(_submitting);
    emit(_fromResult(await _repository.register(event.name, event.email, event.password)));
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _repository.logout();
    await _bookingCache?.clearAccount();
    emit(const AuthState.guest());
  }

  Future<void> _onSessionEnded(SessionEnded event, Emitter<AuthState> emit) async {
    // A guest has no session to end.
    if (state is AuthGuest) {
      return;
    }
    await _bookingCache?.clearAccount();
    emit(switch (event.reason) {
      SessionBlocked(:final message) => AuthState.blocked(message),
      SessionExpired() => const AuthState.guest(failure: AuthFailure.sessionExpired()),
    });
  }

  void _onUserUpdated(UserUpdated event, Emitter<AuthState> emit) {
    if (state is AuthAuthenticated) {
      emit(AuthState.authenticated(event.user));
    }
  }

  Future<void> _onUserRefreshRequested(UserRefreshRequested event, Emitter<AuthState> emit) async {
    if (state is! AuthAuthenticated) return;
    final result = await _repository.currentUser();
    if (result case Ok(:final value) when state is AuthAuthenticated) {
      emit(AuthState.authenticated(value));
    }
  }

  AuthState _fromResult(Result<User, AuthFailure> result) => switch (result) {
        Ok(:final value) => _signedIn(value),
        Err(failure: AuthBlocked(:final message)) => AuthState.blocked(message),
        Err(:final failure) => switch (state) {
            AuthGuest(:final guestCheckout) => AuthState.guest(failure: failure, guestCheckout: guestCheckout),
            _ => AuthState.guest(failure: failure),
          },
      };

  AuthState _signedIn(User user) =>
      user.isBlocked ? const AuthState.blocked('') : AuthState.authenticated(user);

  @override
  Future<void> close() async {
    await _sessionEndedSubscription.cancel();
    return super.close();
  }
}
