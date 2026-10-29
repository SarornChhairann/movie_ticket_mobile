import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/auth/controller/password_reset_bloc.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_failure.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() => repository = _MockAuthRepository());

  const codeStep = PasswordResetState(step: PasswordResetStep.code, email: 'dara@example.com');

  blocTest<PasswordResetBloc, PasswordResetState>(
    'requesting a code moves to the code step with a codeSent notice',
    setUp: () => when(() => repository.requestPasswordReset('dara@example.com'))
        .thenAnswer((_) async => const Ok(null)),
    build: () => PasswordResetBloc(repository),
    act: (bloc) => bloc.add(const ResetCodeRequested(' dara@example.com ')),
    expect: () => const [
      PasswordResetState(email: 'dara@example.com', submitting: true),
      PasswordResetState(step: PasswordResetStep.code, email: 'dara@example.com', notice: PasswordResetNotice.codeSent),
    ],
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'offline while requesting stays on the email step with the failure',
    setUp: () => when(() => repository.requestPasswordReset(any()))
        .thenAnswer((_) async => const Err(AuthFailure.network())),
    build: () => PasswordResetBloc(repository),
    act: (bloc) => bloc.add(const ResetCodeRequested('dara@example.com')),
    expect: () => const [
      PasswordResetState(email: 'dara@example.com', submitting: true),
      PasswordResetState(email: 'dara@example.com', failure: AuthFailure.network()),
    ],
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'a correct code finishes the flow',
    setUp: () => when(() => repository.resetPassword(
          email: 'dara@example.com',
          code: '123456',
          newPassword: 'newsecret',
        )).thenAnswer((_) async => const Ok(null)),
    build: () => PasswordResetBloc(repository),
    seed: () => codeStep,
    act: (bloc) => bloc.add(const ResetSubmitted(code: '123456', newPassword: 'newsecret')),
    expect: () => [
      codeStep.copyWith(submitting: true),
      codeStep.copyWith(step: PasswordResetStep.done),
    ],
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'a wrong code stays on the code step with resetCodeInvalid',
    setUp: () => when(() => repository.resetPassword(
          email: any(named: 'email'),
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        )).thenAnswer((_) async => const Err(AuthFailure.resetCodeInvalid())),
    build: () => PasswordResetBloc(repository),
    seed: () => codeStep,
    act: (bloc) => bloc.add(const ResetSubmitted(code: '000000', newPassword: 'newsecret')),
    expect: () => [
      codeStep.copyWith(submitting: true),
      codeStep.copyWith(failure: const AuthFailure.resetCodeInvalid()),
    ],
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'resend asks again for the same email',
    setUp: () => when(() => repository.requestPasswordReset('dara@example.com'))
        .thenAnswer((_) async => const Ok(null)),
    build: () => PasswordResetBloc(repository),
    seed: () => codeStep,
    act: (bloc) => bloc.add(const ResetCodeResent()),
    verify: (_) => verify(() => repository.requestPasswordReset('dara@example.com')).called(1),
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'changing the email goes back to the email step',
    build: () => PasswordResetBloc(repository),
    seed: () => codeStep.copyWith(failure: const AuthFailure.resetCodeInvalid()),
    act: (bloc) => bloc.add(const ResetEmailEditRequested()),
    expect: () => [codeStep.copyWith(step: PasswordResetStep.email)],
  );
}
