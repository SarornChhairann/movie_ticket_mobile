import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/auth/view/auth_gate.dart';
import 'package:movie_ticket_mobile/features/auth/view/login_page.dart';
import 'package:movie_ticket_mobile/features/auth/view/register_page.dart';

import '../../helpers/localized_app.dart';
import 'auth_fixtures.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const SignInRequested());
    await initTestLocalization();
  });

  late _MockAuthBloc bloc;
  late StreamController<AuthState> states;
  late List<AuthGateResult> results;

  /// A screen with an action that calls [requireSignIn], under a navigator that
  /// knows the real login and register routes.
  Future<void> pump(
    WidgetTester tester, {
    AuthState initial = const AuthState.guest(),
    bool allowGuest = false,
  }) async {
    bloc = _MockAuthBloc();
    states = StreamController<AuthState>.broadcast();
    addTearDown(states.close);
    whenListen(bloc, states.stream, initialState: initial);
    results = [];
    await pumpLocalized(
      tester,
      BlocProvider<AuthBloc>.value(
        value: bloc,
        child: Navigator(
          // Same shape as AppRouter: login is a typed full-screen sheet.
          onGenerateRoute: (settings) => switch (settings.name) {
            AppRoutes.login => MaterialPageRoute<AuthGateResult>(
                settings: settings,
                fullscreenDialog: true,
                builder: (_) => LoginPage(args: settings.arguments! as LoginArgs),
              ),
            AppRoutes.register => MaterialPageRoute<void>(settings: settings, builder: (_) => const RegisterPage()),
            _ => MaterialPageRoute<void>(
                settings: settings,
                builder: (_) => Scaffold(
                  body: Builder(
                    builder: (context) => TextButton(
                      key: const Key('action'),
                      onPressed: () async => results.add(
                        await requireSignIn(context, reasonKey: 'auth.reason.bookings', allowGuest: allowGuest),
                      ),
                      child: const Text('Protected action'),
                    ),
                  ),
                ),
              ),
          },
        ),
      ),
    );
  }

  Future<void> tapAction(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('action')));
    await tester.pumpAndSettle();
  }

  testWidgets('a signed-in user passes straight through', (tester) async {
    await pump(tester, initial: const AuthState.authenticated(testUser));

    await tapAction(tester);

    expect(results, [AuthGateResult.signedIn]);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('a guest gets the login sheet with the reason; closing it cancels the action', (tester) async {
    await pump(tester);

    await tapAction(tester);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Sign in to see your bookings and tickets.'), findsOneWidget);
    expect(find.byKey(const Key('login.guest')), findsNothing, reason: 'no guest option outside checkout');
    verify(() => bloc.add(any(that: isA<SignInRequested>()))).called(1);

    await tester.tap(find.byKey(const Key('login.close')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsNothing);
    expect(results, [AuthGateResult.dismissed]);
  });

  testWidgets('signing in returns to the action with signedIn', (tester) async {
    await pump(tester);
    await tapAction(tester);

    states.add(const AuthState.guest(submitting: true));
    await tester.pump();
    states.add(const AuthState.authenticated(testUser));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsNothing);
    expect(results, [AuthGateResult.signedIn]);
  });

  testWidgets('signing up on the register screen closes both and continues', (tester) async {
    await pump(tester);
    await tapAction(tester);
    await tester.tap(find.byKey(const Key('login.register')));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);

    states.add(const AuthState.authenticated(testUser));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsNothing);
    expect(find.byType(LoginPage), findsNothing);
    expect(results, [AuthGateResult.signedIn]);
  });

  testWidgets('checkout offers guest; choosing it continues as guest', (tester) async {
    await pump(tester, allowGuest: true);
    await tapAction(tester);

    await tester.tap(find.byKey(const Key('login.guest')));
    await tester.pumpAndSettle();

    verify(() => bloc.add(any(that: isA<GuestContinued>()))).called(1);
    expect(results, [AuthGateResult.guest]);
  });

  testWidgets('a guest who already chose guest checkout is not asked again', (tester) async {
    await pump(tester, initial: const AuthState.guest(guestCheckout: true), allowGuest: true);

    await tapAction(tester);

    expect(find.byType(LoginPage), findsNothing);
    expect(results, [AuthGateResult.guest]);
  });

  testWidgets('the sheet cannot be dismissed mid-request', (tester) async {
    await pump(tester);
    await tapAction(tester);
    states.add(const AuthState.guest(submitting: true));
    await tester.pump();
    await tester.pump();

    expect(tester.widget<IconButton>(find.byKey(const Key('login.close'))).onPressed, isNull);
  });
}
