import 'package:get_it/get_it.dart';

import 'controller/checkout_bloc.dart';
import 'model/checkout_repository.dart';

void registerCheckout(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => CheckoutRepository(getIt()))
    ..registerFactory(() => CheckoutBloc(getIt()));
}
