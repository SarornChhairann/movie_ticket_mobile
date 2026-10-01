import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_ticket_mobile/app.dart';
import 'package:movie_ticket_mobile/core/l10n/app_locales.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_failure.dart';
import 'package:movie_ticket_mobile/features/auth/view/splash_page.dart';

import 'features/auth/auth_fixtures.dart';
import 'helpers/localized_app.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

/// Real stack rules from [App], with each route drawn as its name.
class _FakeRouter extends AppRouter {
  _FakeRouter() : super(GetIt.asNewInstance());

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) => MaterialPageRoute<Object?>(
        settings: settings,
        builder: (_) => Scaffold(body: Text('route:${settings.name}')),
      );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  late StreamController<AuthState> states;

  Future<void> pump(WidgetTester tester, AuthState initial) async {
    states = StreamController<AuthState>.broadcast();
    addTearDown(states.close);
    final bloc = _MockAuthBloc();
    whenListen(bloc, states.stream, initialState: initial);
    await tester.runAsync(() async {
      await tester.pumpWidget(EasyLocalization(
        supportedLocales: AppLocales.supported,
        path: AppLocales.path,
        fallbackLocale: AppLocales.en,
        startLocale: AppLocales.en,
        saveLocale: false,
        child: App(router: _FakeRouter(), authBloc: bloc),
      ));
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
    });
  }

  Future<void> emit(WidgetTester tester, AuthState state) async {
    states.add(state);
    await tester.pump();
    await tester.pumpAndSettle();
  }

  NavigatorState navigator(WidgetTester tester) => tester.state<NavigatorState>(find.byType(Navigator).first);

  testWidgets('restore with no session lands on Home, never on login', (tester) async {
    await pump(tester, const AuthState.unknown());
    expect(find.text('route:${AppRoutes.splash}'), findsOneWidget);

    await emit(tester, const AuthState.guest());
    await tester.pump(SplashPage.minDisplay);
    await tester.pumpAndSettle();

    expect(find.text('route:${AppRoutes.shell}'), findsOneWidget);
    expect(find.text('route:${AppRoutes.login}'), findsNothing);
    expect(find.text('route:${AppRoutes.splash}', skipOffstage: false), findsNothing, reason: 'no back to splash');
  });

  testWidgets('a fast restore still keeps the splash for its minimum time', (tester) async {
    await pump(tester, const AuthState.unknown());

    states.add(const AuthState.guest()); // resolved almost at once
    await tester.pump();
    // Step frame by frame: pumpAndSettle would run through the hold.
    await tester.pump(SplashPage.minDisplay - const Duration(milliseconds: 500));
    expect(find.text('route:${AppRoutes.splash}'), findsOneWidget);
    expect(find.text('route:${AppRoutes.shell}'), findsNothing);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('route:${AppRoutes.shell}'), findsOneWidget);
  });

  testWidgets('a slow restore leaves as soon as it finishes, with no extra wait', (tester) async {
    await pump(tester, const AuthState.unknown());
    await tester.pump(SplashPage.minDisplay + const Duration(seconds: 1));
    expect(find.text('route:${AppRoutes.splash}'), findsOneWidget);

    await emit(tester, const AuthState.authenticated(testUser));

    expect(find.text('route:${AppRoutes.shell}'), findsOneWidget);
  });

  testWidgets('signing in keeps the stack so the waiting action can continue', (tester) async {
    await pump(tester, const AuthState.guest());
    await emit(tester, const AuthState.guest());
    navigator(tester).pushNamed(AppRoutes.movieDetail, arguments: 1);
    navigator(tester).pushNamed(AppRoutes.login);
    await tester.pumpAndSettle();

    await emit(tester, const AuthState.authenticated(testUser));

    // Login closes itself (LoginPage); App must not wipe the detail screen.
    expect(find.text('route:${AppRoutes.login}', skipOffstage: false), findsOneWidget);
    expect(find.text('route:${AppRoutes.movieDetail}', skipOffstage: false), findsOneWidget);
  });

  testWidgets('logout drops signed-in screens back to Home', (tester) async {
    await pump(tester, const AuthState.authenticated(testUser));
    await emit(tester, const AuthState.authenticated(testUser));
    navigator(tester).pushNamed(AppRoutes.myBookings);
    await tester.pumpAndSettle();

    await emit(tester, const AuthState.guest());

    expect(find.text('route:${AppRoutes.shell}'), findsOneWidget);
    expect(find.text('route:${AppRoutes.myBookings}', skipOffstage: false), findsNothing);
    expect(find.text('route:${AppRoutes.login}'), findsNothing);
  });

  testWidgets('an expired session returns to Home and reopens login with the notice', (tester) async {
    await pump(tester, const AuthState.authenticated(testUser));
    navigator(tester).pushNamed(AppRoutes.myBookings);
    await tester.pumpAndSettle();

    await emit(tester, const AuthState.guest(failure: AuthFailure.sessionExpired()));

    expect(find.text('route:${AppRoutes.login}'), findsOneWidget);
    expect(find.text('route:${AppRoutes.shell}', skipOffstage: false), findsOneWidget);
    expect(find.text('route:${AppRoutes.myBookings}', skipOffstage: false), findsNothing);
  });
}
