import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/di/injection.dart';
import 'core/l10n/app_locales.dart';
import 'core/router/app_router.dart';
import 'features/auth/controller/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  configureDependencies(baseUrl: requireApiBaseUrl());
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.en,
      child: App(
        router: AppRouter(getIt),
        authBloc: getIt<AuthBloc>()..add(const SessionStarted()),
      ),
    ),
  );
}
