import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/di/injection.dart';
import 'core/l10n/app_locales.dart';
import 'core/network/connectivity_monitor.dart';
import 'core/router/app_router.dart';
import 'core/session/pending_payment_store.dart';
import 'features/auth/controller/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // An ABA payment the last run left open (killed during the hand-off): this run
  // reuses its session so it can still be polled, and opens the resume screen.
  final pendingPayment =
      await PendingPaymentStore(const FlutterSecureStorage()).readResumable(DateTime.now());
  configureDependencies(baseUrl: requireApiBaseUrl(), restoredSessionId: pendingPayment?.sessionId);
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.en,
      child: App(
        router: AppRouter(getIt),
        authBloc: getIt<AuthBloc>()..add(const SessionStarted()),
        pendingPayment: pendingPayment,
        offline: getIt<ConnectivityMonitor>().offline,
      ),
    ),
  );
}
