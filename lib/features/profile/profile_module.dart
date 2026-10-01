import 'package:get_it/get_it.dart';

import 'controller/profile_bloc.dart';
import 'model/profile_repository.dart';

void registerProfile(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => ProfileRepository(getIt()))
    ..registerFactory(() => ProfileBloc(getIt()));
}
