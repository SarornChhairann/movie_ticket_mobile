import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'controller/seat_map_bloc.dart';
import 'model/seat_realtime.dart';
import 'model/seat_repository.dart';

void registerSeats(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => SeatRealtime(baseUrl: getIt<Dio>().options.baseUrl))
    ..registerLazySingleton(() => SeatRepository(getIt(), getIt(), getIt()))
    ..registerFactory(() => SeatMapBloc(getIt(), tracker: getIt()));
}
