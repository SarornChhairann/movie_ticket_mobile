import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/auth_module.dart';
import '../../features/catalog/catalog_module.dart';
import '../../features/checkout/checkout_module.dart';
import '../../features/profile/profile_module.dart';
import '../../features/reminders/reminders_module.dart';
import '../../features/seats/seats_module.dart';
import '../../features/shell/shell_module.dart';
import '../../features/tickets/tickets_module.dart';
import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';
import '../network/session_header_interceptor.dart';
import '../session/session_id_provider.dart';
import '../session/token_store.dart';

final GetIt getIt = GetIt.instance;

/// The only place that registers dependencies. Features expose
/// `registerX(GetIt)` and are called from here.
void configureDependencies({required String baseUrl}) {
  getIt
    ..registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage())
    ..registerLazySingleton(() => TokenStore(getIt()))
    ..registerLazySingleton(SessionIdProvider.new)
    ..registerLazySingleton(() => SessionHeaderInterceptor(getIt()))
    ..registerLazySingleton(
      () => AuthInterceptor(tokenStore: getIt(), refreshDio: createBareDio(baseUrl)),
    )
    ..registerLazySingleton<Dio>(
      () => createDio(
        baseUrl: baseUrl,
        sessionHeaderInterceptor: getIt(),
        authInterceptor: getIt(),
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
