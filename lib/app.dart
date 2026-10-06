import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/widgets/connectivity_banner.dart';
import 'core/session/pending_payment_store.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controller/auth_bloc.dart';
import 'features/auth/model/auth_failure.dart';
import 'features/auth/view/auth_gate.dart';
import 'features/auth/view/splash_page.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.router,
    required this.authBloc,
    this.splashMinDisplay = SplashPage.minDisplay,
    this.pendingPayment,
    this.offline,
  });

  final AppRouter router;
  final AuthBloc authBloc;

  /// The splash stays at least this long, even when the session restores at once.
  final Duration splashMinDisplay;

  /// An ABA payment the previous run left open; its resume screen opens over Home once.
  final PendingPayment? pendingPayment;

  /// True after repeated network failures: shows the offline banner app-wide.
  final ValueListenable<bool>? offline;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();

  /// Minimum splash time. Ticker-driven (pauses with the app, testable), and
  /// [AnimationBehavior.preserve] keeps its length under reduced motion.
  late final AnimationController _splashHold = AnimationController(
    vsync: this,
    duration: widget.splashMinDisplay,
    animationBehavior: AnimationBehavior.preserve,
  );

  /// The session resolved while the splash was still holding.
  bool _splashExitPending = false;

  /// The state before the change the listener is handling.
  AuthState _previous = const AuthState.unknown();

  /// Cleared once the resume screen has been pushed.
  late PendingPayment? _pendingPayment = widget.pendingPayment;

  @override
  void initState() {
    super.initState();
    _splashHold
      ..addStatusListener((status) {
        if (status != AnimationStatus.completed || !_splashExitPending) return;
        _splashExitPending = false;
        // Use the latest state: it may have changed again during the hold.
        _onAuthChanged(widget.authBloc.state);
      })
      ..forward();
  }

  @override
  void dispose() {
    _splashHold.dispose();
    widget.authBloc.close();
    super.dispose();
  }

  /// Leaving the splash waits for [App.splashMinDisplay]; everything else is immediate.
  void _onRootChange(AuthState previous, AuthState current) {
    if (_rootFor(previous) == AppRoutes.splash && !_splashHold.isCompleted) {
      _splashExitPending = true;
      return;
    }
    _onAuthChanged(current);
  }

  /// The screen stack root for each session state. Signed in or not, the app
  /// opens on Home; login is pushed on demand (`requireSignIn`).
  static String _rootFor(AuthState state) => switch (state) {
    AuthUnknownState() => AppRoutes.splash,
    AuthGuest() || AuthAuthenticated() => AppRoutes.shell,
    AuthBlockedState() => AppRoutes.blocked,
  };

  /// Logout or an expired session: drop every signed-in screen back to Home.
  static bool _signedOut(AuthState previous, AuthState current) =>
      previous is AuthAuthenticated && current is AuthGuest;

  /// Navigates after the current frame: called straight from the listener, the
  /// reset pushed the new root but left the old screens underneath (e.g. the
  /// splash or a signed-in screen still reachable with back).
  void _onAuthChanged(AuthState current) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _resetStack(current));
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _resetStack(AuthState current) {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;
    navigator.pushNamedAndRemoveUntil(_rootFor(current), (_) => false);
    final pending = _pendingPayment;
    if (pending != null && _rootFor(current) == AppRoutes.shell) {
      _pendingPayment = null;
      navigator.pushNamed(AppRoutes.paymentResume, arguments: pending);
      return;
    }
    // Expired mid-use: offer to sign straight back in, with the reason shown.
    if (current is AuthGuest && current.failure is AuthSessionExpired) {
      navigator.pushNamed(AppRoutes.login, arguments: const LoginArgs());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.authBloc,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        onGenerateTitle: (context) => 'app.title'.tr(context: context),
        theme: AppTheme.forLocale(context.locale),
        themeMode: ThemeMode.dark,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: _rootFor(widget.authBloc.state),
        onGenerateRoute: widget.router.onGenerateRoute,
        builder: (context, child) => BlocListener<AuthBloc, AuthState>(
          // Reset the stack when the root changes (splash → Home, blocked) or on
          // sign-out. Signing in does not reset: the login screen pops itself and
          // the user continues the action that asked for it.
          listenWhen: (previous, current) {
            _previous = previous;
            return _rootFor(previous) != _rootFor(current) ||
                _signedOut(previous, current);
          },
          listener: (context, current) => _onRootChange(_previous, current),
          child: widget.offline == null
              ? child!
              : ConnectivityBanner(offline: widget.offline!, child: child!),
        ),
      ),
    );
  }
}
