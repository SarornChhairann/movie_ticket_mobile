import 'package:get_it/get_it.dart';

import 'controller/hall_list_bloc.dart';
import 'controller/hall_schedule_bloc.dart';
import 'controller/movie_detail_bloc.dart';
import 'controller/movie_list_bloc.dart';
import 'model/catalog_repository.dart';
import 'model/hall_repository.dart';

void registerCatalog(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => CatalogRepository(getIt()))
    ..registerLazySingleton(() => HallRepository(getIt()))
    ..registerFactory(() => MovieListBloc(getIt()))
    ..registerFactory(() => MovieDetailBloc(getIt()))
    ..registerFactory(() => HallListBloc(getIt()))
    ..registerFactory(() => HallScheduleBloc(getIt()));
}
