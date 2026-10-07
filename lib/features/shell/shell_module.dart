import 'package:get_it/get_it.dart';

import 'controller/shell_cubit.dart';
import 'model/shell_repository.dart';

void registerShell(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => ShellRepository(getIt(), cache: getIt()))
    ..registerFactory(() => ShellCubit(getIt(), tracker: getIt()));
}
