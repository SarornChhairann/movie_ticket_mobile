import 'package:get_it/get_it.dart';

import 'controller/checkout_bloc.dart';
import 'controller/payway_bloc.dart';
import 'model/checkout_repository.dart';
import 'model/payway.dart';

void registerCheckout(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => CheckoutRepository(getIt()))
    ..registerFactory(() => CheckoutBloc(getIt()))
    ..registerFactoryParam<PaywayBloc, PaywayLaunch, void>((launch, _) => PaywayBloc(getIt(), launch));
}
