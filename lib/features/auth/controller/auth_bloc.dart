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

/// App-level session state. Provided above the navigator; the router reacts to
/// its state type.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState.unknown()) {
    on<SessionStarted>(_onSessionStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GuestContinued>((_, emit) => emit(const AuthState.guest()));
    on<SignInRequested>((_, emit) => emit(const AuthState.unauthenticated()));
    on<LogoutRequested>(_onLogoutRequested);
    on<SessionEnded>(_onSessionEnded);
    on<BlockedAcknowledged>((_, emit) => emit(const AuthState.unauthenticated()));
    on<UserUpdated>(_onUserUpdated);
    on<UserRefreshRequested>(_onUserRefreshRequested);
    _sessionEndedSubscription = _repository.sessionEnded.listen((reason) => add(SessionEnded(reason)));
  }

  final AuthRepository _repository;
  late final StreamSubscription<SessionEnd> _sessionEndedSubscription;

  Future<void> _onSessionStarted(SessionStarted event, Emitter<AuthState> emit) async {
    final result = await _repository.restoreSession();
    emit(switch (result) {
      Ok(value: final User user) => _signedIn(user),
      Ok() => const AuthState.unauthenticated(),
      Err(failure: AuthBlocked(:final message)) => AuthState.blocked(message),
      Err(:final failure) => AuthState.unauthenticated(failure: failure),
    });
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.unauthenticated(submitting: true));
    emit(_fromResult(await _repository.login(event.email, event.password)));
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.unauthenticated(submitting: true));
    emit(_fromResult(await _repository.register(event.name, event.email, event.password)));
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }

  void _onSessionEnded(SessionEnded event, Emitter<AuthState> emit) {
    // A guest has no session to end.
    if (state is AuthGuest) {
      return;
    }
    emit(switch (event.reason) {
      SessionBlocked(:final message) => AuthState.blocked(message),
      SessionExpired() => const AuthState.unauthenticated(failure: AuthFailure.sessionExpired()),
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
        Err(:final failure) => AuthState.unauthenticated(failure: failure),
      };

  AuthState _signedIn(User user) =>
      user.isBlocked ? const AuthState.blocked('') : AuthState.authenticated(user);

  @override
  Future<void> close() async {
    await _sessionEndedSubscription.cancel();
    return super.close();
  }
}
