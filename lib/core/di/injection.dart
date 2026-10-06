import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/auth/auth_module.dart';
import '../../features/catalog/catalog_module.dart';
import '../../features/checkout/checkout_module.dart';
import '../../features/profile/profile_module.dart';
import '../../features/reminders/reminders_module.dart';
import '../../features/seats/seats_module.dart';
import '../../features/shell/shell_module.dart';
import '../../features/tickets/tickets_module.dart';
import '../navigation/shell_tabs.dart';
import '../telemetry/journey_tracker.dart';
import '../network/auth_interceptor.dart';
import '../network/connectivity_monitor.dart';
import '../network/dio_client.dart';
import '../network/session_header_interceptor.dart';
import '../session/pending_payment_store.dart';
import '../session/session_id_provider.dart';
import '../storage/booking_cache.dart';
import '../session/token_store.dart';

final GetIt getIt = GetIt.instance;

/// The only place that registers dependencies. Features expose
/// `registerX(GetIt)` and are called from here. [restoredSessionId] is the session
/// of an ABA payment the previous run left open (see [PendingPaymentStore]).
void configureDependencies({required String baseUrl, String? restoredSessionId}) {
  getIt
    ..registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage())
    ..registerLazySingleton(() => TokenStore(getIt()))
    ..registerLazySingleton(() => PendingPaymentStore(getIt()))
    ..registerLazySingleton(ShellTabs.new)
    ..registerLazySingleton(ConnectivityMonitor.new)
    // Funnel events (sprint 19); the debug sink until a vendor is chosen (D5).
    ..registerLazySingleton<JourneyTracker>(DebugJourneyTracker.new)
    ..registerLazySingleton(() => BookingCache(getIt(), getApplicationDocumentsDirectory))
    ..registerLazySingleton(() => SessionIdProvider(restored: restoredSessionId))
    ..registerLazySingleton(() => SessionHeaderInterceptor(getIt()))
    ..registerLazySingleton(
      () => AuthInterceptor(tokenStore: getIt(), refreshDio: createBareDio(baseUrl)),
    )
    ..registerLazySingleton<Dio>(
      () => createDio(
        baseUrl: baseUrl,
        sessionHeaderInterceptor: getIt(),
        authInterceptor: getIt(),
        connectivityMonitor: getIt(),
      ),
    );

  registerShell(getIt);
  registerAuth(getIt);
  registerProfile(getIt);
  registerCatalog(getIt);
  registerSeats(getIt);
  registerCheckout(getIt);
  registerTickets(getIt);
  registerReminders(getIt);
}
