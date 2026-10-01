import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_failure.dart';
import 'package:movie_ticket_mobile/features/auth/view/login_page.dart';

import '../../helpers/finders.dart';
import '../../helpers/localized_app.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(const GuestContinued());
  });

  Future<_MockAuthBloc> pumpLogin(WidgetTester tester, AuthState state) async {
    final bloc = _MockAuthBloc();
    whenListen(bloc, const Stream<AuthState>.empty(), initialState: state);
    await pumpLocalized(tester, BlocProvider<AuthBloc>.value(value: bloc, child: const LoginPage()));
    return bloc;
  }

  testWidgets('invalid email shows a validation message and does not submit', (tester) async {
    final bloc = await pumpLogin(tester, const AuthState.guest());

    await tester.enterText(find.byKey(const Key('login.email')), 'dara@');
    await tester.enterText(find.byKey(const Key('login.password')), 'secret1');
    await tester.tap(find.byKey(const Key('login.submit')));
    await tester.pump();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    verifyNever(() => bloc.add(any(that: isA<LoginRequested>())));
  });

  testWidgets('valid form dispatches LoginRequested', (tester) async {
    final bloc = await pumpLogin(tester, const AuthState.guest());

    await tester.enterText(find.byKey(const Key('login.email')), 'dara@example.com');
    await tester.enterText(find.byKey(const Key('login.password')), 'secret1');
    await tester.tap(find.byKey(const Key('login.submit')));
    await tester.pump();

    verify(() => bloc.add(any(that: isA<LoginRequested>()))).called(1);
  });

  testWidgets('submit is disabled while submitting', (tester) async {
    await pumpLogin(tester, const AuthState.guest(submitting: true));

    expect(filledButtonIn(tester, const Key('login.submit')).onPressed, isNull);
  });

  testWidgets('bad credentials show a banner', (tester) async {
    await pumpLogin(
      tester,
      const AuthState.guest(failure: AuthFailure.invalidCredentials()),
    );

    expect(find.text('Incorrect email or password.'), findsOneWidget);
  });
}
