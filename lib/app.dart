import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controller/auth_bloc.dart';

class App extends StatefulWidget {
  const App({super.key, required this.router, required this.authBloc});

  final AppRouter router;
  final AuthBloc authBloc;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    widget.authBloc.close();
    super.dispose();
  }

  /// The screen stack root for each session state.
  static String _rootFor(AuthState state) => switch (state) {
        AuthUnknownState() => AppRoutes.splash,
        AuthUnauthenticated() => AppRoutes.login,
        AuthGuest() || AuthAuthenticated() => AppRoutes.shell,
        AuthBlockedState() => AppRoutes.blocked,
      };

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.authBloc,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        onGenerateTitle: (context) => 'app.title'.tr(context: context),
        theme: AppTheme.light,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: _rootFor(widget.authBloc.state),
        onGenerateRoute: widget.router.onGenerateRoute,
        builder: (context, child) => BlocListener<AuthBloc, AuthState>(
          // Only a change of session kind resets the stack; submitting/failure
          // updates on the login screen do not.
          listenWhen: (previous, current) => _rootFor(previous) != _rootFor(current),
          listener: (context, state) => _navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(_rootFor(state), (_) => false),
          child: child!,
        ),
      ),
    );
  }
}
