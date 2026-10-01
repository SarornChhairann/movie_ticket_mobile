import 'package:get_it/get_it.dart';

import 'controller/auth_bloc.dart';
import 'model/auth_repository.dart';

void registerAuth(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => AuthRepository(getIt(), getIt(), getIt()))
    ..registerFactory(() => AuthBloc(getIt()));
}
