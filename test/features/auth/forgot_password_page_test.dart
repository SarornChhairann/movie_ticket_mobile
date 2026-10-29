import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/auth/controller/password_reset_bloc.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_failure.dart';
import 'package:movie_ticket_mobile/features/auth/view/forgot_password_page.dart';

import '../../helpers/localized_app.dart';

class _MockResetBloc extends MockBloc<PasswordResetEvent, PasswordResetState> implements PasswordResetBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(const ResetCodeResent());
  });

  Future<_MockResetBloc> pumpPage(WidgetTester tester, PasswordResetState state, {String email = ''}) async {
    final bloc = _MockResetBloc();
    whenListen(bloc, const Stream<PasswordResetState>.empty(), initialState: state);
    await pumpLocalized(
      tester,
      BlocProvider<PasswordResetBloc>.value(value: bloc, child: ForgotPasswordPage(initialEmail: email)),
    );
    return bloc;
  }

  testWidgets('email step prefills the login email and requests a code', (tester) async {
    final bloc = await pumpPage(tester, const PasswordResetState(), email: 'dara@example.com');

    await tester.tap(find.byKey(const Key('reset.sendCode')));
    await tester.pump();

    verify(() => bloc.add(any(that: isA<ResetCodeRequested>()))).called(1);
  });

  testWidgets('code step rejects a short code', (tester) async {
    final bloc = await pumpPage(
      tester,
      const PasswordResetState(step: PasswordResetStep.code, email: 'dara@example.com'),
    );

    await tester.enterText(find.byKey(const Key('reset.code')), '123');
    await tester.enterText(find.byKey(const Key('reset.password')), 'newsecret');
    await tester.enterText(find.byKey(const Key('reset.confirm')), 'newsecret');
    await tester.tap(find.byKey(const Key('reset.submit')));
    await tester.pump();

    expect(find.text('Enter the 6 digits from the email.'), findsOneWidget);
    verifyNever(() => bloc.add(any(that: isA<ResetSubmitted>())));
  });

  testWidgets('code step submits a valid form', (tester) async {
    final bloc = await pumpPage(
      tester,
      const PasswordResetState(step: PasswordResetStep.code, email: 'dara@example.com'),
    );

    await tester.enterText(find.byKey(const Key('reset.code')), '123456');
    await tester.enterText(find.byKey(const Key('reset.password')), 'newsecret');
    await tester.enterText(find.byKey(const Key('reset.confirm')), 'newsecret');
    await tester.tap(find.byKey(const Key('reset.submit')));
    await tester.pump();

    verify(() => bloc.add(any(that: isA<ResetSubmitted>()))).called(1);
  });

  testWidgets('a wrong code shows our banner text', (tester) async {
    await pumpPage(
      tester,
      const PasswordResetState(
        step: PasswordResetStep.code,
        email: 'dara@example.com',
        failure: AuthFailure.resetCodeInvalid(),
      ),
    );

    expect(find.text('That code is wrong or has expired. Request a new one.'), findsOneWidget);
  });
}
