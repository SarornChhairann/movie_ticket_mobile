import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/session/session_end.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_failure.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_repository.dart';

import 'auth_fixtures.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late StreamController<SessionEnd> sessionEnded;

  setUp(() {
    repository = _MockAuthRepository();
    sessionEnded = StreamController<SessionEnd>.broadcast();
    when(() => repository.sessionEnded).thenAnswer((_) => sessionEnded.stream);
  });

  tearDown(() => sessionEnded.close());

  group('SessionStarted', () {
    blocTest<AuthBloc, AuthState>(
      'restores a stored session',
      setUp: () => when(() => repository.restoreSession()).thenAnswer((_) async => const Ok(testUser)),
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const SessionStarted()),
      expect: () => const [AuthState.authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'without a stored session opens Home as a signed-out shopper (no login wall)',
      setUp: () => when(() => repository.restoreSession()).thenAnswer((_) async => const Ok(null)),
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const SessionStarted()),
      expect: () => const [AuthState.guest()],
    );

    blocTest<AuthBloc, AuthState>(
      'offline at start still opens Home; the failure waits for the next sign-in',
      setUp: () =>
          when(() => repository.restoreSession()).thenAnswer((_) async => const Err(AuthFailure.network())),
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const SessionStarted()),
      expect: () => const [AuthState.guest(failure: AuthFailure.network())],
    );
  });

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'success signs the user in',
      setUp: () => when(() => repository.login(any(), any())).thenAnswer((_) async => const Ok(testUser)),
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const LoginRequested(email: 'dara@example.com', password: 'secret1')),
      expect: () => const [
        AuthState.guest(submitting: true),
        AuthState.authenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'ACCOUNT_BLOCKED shows the blocked notice',
      setUp: () => when(() => repository.login(any(), any()))
          .thenAnswer((_) async => const Err(AuthFailure.blocked('This account is suspended.'))),
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const LoginRequested(email: 'dara@example.com', password: 'secret1')),
      expect: () => const [
        AuthState.guest(submitting: true),
        AuthState.blocked('This account is suspended.'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'bad credentials stay on login with a failure',
      setUp: () => when(() => repository.login(any(), any()))
          .thenAnswer((_) async => const Err(AuthFailure.invalidCredentials())),
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const LoginRequested(email: 'dara@example.com', password: 'wrong1')),
      expect: () => const [
        AuthState.guest(submitting: true),
        AuthState.guest(failure: AuthFailure.invalidCredentials()),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'a failed login keeps the guest-checkout choice',
      setUp: () => when(() => repository.login(any(), any()))
          .thenAnswer((_) async => const Err(AuthFailure.invalidCredentials())),
      build: () => AuthBloc(repository),
      seed: () => const AuthState.guest(guestCheckout: true),
      act: (bloc) => bloc.add(const LoginRequested(email: 'dara@example.com', password: 'wrong1')),
      expect: () => const [
        AuthState.guest(submitting: true, guestCheckout: true),
        AuthState.guest(failure: AuthFailure.invalidCredentials(), guestCheckout: true),
      ],
    );
  });

  blocTest<AuthBloc, AuthState>(
    'opening the login screen clears a stale banner',
    build: () => AuthBloc(repository),
    seed: () => const AuthState.guest(failure: AuthFailure.invalidCredentials(), guestCheckout: true),
    act: (bloc) => bloc.add(const SignInRequested()),
    expect: () => const [AuthState.guest(guestCheckout: true)],
  );

  blocTest<AuthBloc, AuthState>(
    'RegisterRequested signs the new user in',
    setUp: () =>
        when(() => repository.register(any(), any(), any())).thenAnswer((_) async => const Ok(testUser)),
    build: () => AuthBloc(repository),
    act: (bloc) => bloc.add(
      const RegisterRequested(name: 'Dara Sok', email: 'dara@example.com', password: 'secret1'),
    ),
    expect: () => const [
      AuthState.guest(submitting: true),
      AuthState.authenticated(testUser),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'LogoutRequested clears the session through the repository',
    setUp: () => when(() => repository.logout()).thenAnswer((_) async {}),
    build: () => AuthBloc(repository),
    seed: () => const AuthState.authenticated(testUser),
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => const [AuthState.guest()],
    verify: (_) => verify(() => repository.logout()).called(1),
  );

  blocTest<AuthBloc, AuthState>(
    'GuestContinued remembers guest checkout without calling login',
    build: () => AuthBloc(repository),
    seed: () => const AuthState.guest(),
    act: (bloc) => bloc.add(const GuestContinued()),
    expect: () => const [AuthState.guest(guestCheckout: true)],
    verify: (_) => verifyNever(() => repository.login(any(), any())),
  );

  group('session ended by the network layer', () {
    blocTest<AuthBloc, AuthState>(
      'blocked account shows the blocked notice',
      build: () => AuthBloc(repository),
      seed: () => const AuthState.authenticated(testUser),
      act: (_) => sessionEnded.add(const SessionBlocked('This account is banned.')),
      expect: () => const [AuthState.blocked('This account is banned.')],
    );

    blocTest<AuthBloc, AuthState>(
      'expired session signs out with a notice for the login screen',
      build: () => AuthBloc(repository),
      seed: () => const AuthState.authenticated(testUser),
      act: (_) => sessionEnded.add(const SessionExpired()),
      expect: () => const [AuthState.guest(failure: AuthFailure.sessionExpired())],
    );

    blocTest<AuthBloc, AuthState>(
      'a guest ignores an expired session',
      build: () => AuthBloc(repository),
      seed: () => const AuthState.guest(),
      act: (_) => sessionEnded.add(const SessionExpired()),
      expect: () => const <AuthState>[],
    );
  });

  blocTest<AuthBloc, AuthState>(
    'UserRefreshRequested reloads the signed-in user (new points)',
    setUp: () => when(() => repository.currentUser()).thenAnswer((_) async => Ok(testUser.copyWith(points: 132))),
    build: () => AuthBloc(repository),
    seed: () => const AuthState.authenticated(testUser),
    act: (bloc) => bloc.add(const UserRefreshRequested()),
    expect: () => [AuthState.authenticated(testUser.copyWith(points: 132))],
  );

  blocTest<AuthBloc, AuthState>(
    'a guest ignores UserRefreshRequested',
    build: () => AuthBloc(repository),
    seed: () => const AuthState.guest(),
    act: (bloc) => bloc.add(const UserRefreshRequested()),
    expect: () => const <AuthState>[],
    verify: (_) => verifyNever(() => repository.currentUser()),
  );
}
