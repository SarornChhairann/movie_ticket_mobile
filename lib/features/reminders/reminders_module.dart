import 'package:get_it/get_it.dart';

import 'controller/reminder_bloc.dart';
import 'model/reminder_repository.dart';

void registerReminders(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => ReminderRepository(getIt()))
    ..registerFactory(() => ReminderBloc(getIt()));
}
