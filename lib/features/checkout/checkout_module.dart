import 'package:get_it/get_it.dart';

import '../../core/session/pending_payment_store.dart';
import '../../core/session/session_id_provider.dart';

import 'controller/checkout_bloc.dart';
import 'controller/payment_resume_bloc.dart';
import 'controller/payway_bloc.dart';
import 'model/checkout_repository.dart';
import 'model/payway.dart';

void registerCheckout(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => CheckoutRepository(getIt()))
    ..registerFactory(() => CheckoutBloc(getIt(), cache: getIt(), holds: getIt(), tracker: getIt()))
    ..registerFactoryParam<PaywayBloc, PaywayLaunch, void>(
      (launch, _) => PaywayBloc(
        getIt(),
        launch,
        pendingStore: getIt(),
        sessionId: getIt<SessionIdProvider>().sessionId,
      ),
    )
    ..registerFactoryParam<PaymentResumeBloc, PendingPayment, void>(
      (pending, _) => PaymentResumeBloc(getIt(), pending, store: getIt(), cache: getIt()),
    );
}
