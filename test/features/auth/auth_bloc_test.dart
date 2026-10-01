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
      'without a stored session goes to login',
      setUp: () => when(() => repository.restoreSession()).thenAnswer((_) async => const Ok(null)),
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const SessionStarted()),
      expect: () => const [AuthState.unauthenticated()],
    );
  });

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'success signs the user in',
      setUp: () => when(() => repository.login(any(), any())).thenAnswer((_) async => const Ok(testUser)),
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const LoginRequested(email: 'dara@example.com', password: 'secret1')),
      expect: () => const [
        AuthState.unauthenticated(submitting: true),
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
        AuthState.unauthenticated(submitting: true),
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
        AuthState.unauthenticated(submitting: true),
        AuthState.unauthenticated(failure: AuthFailure.invalidCredentials()),
      ],
    );
  });

  blocTest<AuthBloc, AuthState>(
    'RegisterRequested signs the new user in',
    setUp: () =>
        when(() => repository.register(any(), any(), any())).thenAnswer((_) async => const Ok(testUser)),
    build: () => AuthBloc(repository),
    act: (bloc) => bloc.add(
      const RegisterRequested(name: 'Dara Sok', email: 'dara@example.com', password: 'secret1'),
    ),
    expect: () => const [
      AuthState.unauthenticated(submitting: true),
      AuthState.authenticated(testUser),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'LogoutRequested clears the session through the repository',
    setUp: () => when(() => repository.logout()).thenAnswer((_) async {}),
    build: () => AuthBloc(repository),
    seed: () => const AuthState.authenticated(testUser),
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => const [AuthState.unauthenticated()],
    verify: (_) => verify(() => repository.logout()).called(1),
  );

  blocTest<AuthBloc, AuthState>(
    'GuestContinued enters as guest without calling login',
    build: () => AuthBloc(repository),
    seed: () => const AuthState.unauthenticated(),
    act: (bloc) => bloc.add(const GuestContinued()),
    expect: () => const [AuthState.guest()],
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
      'expired session returns to login with a notice',
      build: () => AuthBloc(repository),
      seed: () => const AuthState.authenticated(testUser),
      act: (_) => sessionEnded.add(const SessionExpired()),
      expect: () => const [AuthState.unauthenticated(failure: AuthFailure.sessionExpired())],
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
