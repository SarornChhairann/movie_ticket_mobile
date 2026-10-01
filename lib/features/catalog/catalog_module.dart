import 'package:get_it/get_it.dart';

import 'controller/movie_detail_bloc.dart';
import 'controller/movie_list_bloc.dart';
import 'model/catalog_repository.dart';

void registerCatalog(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => CatalogRepository(getIt()))
    ..registerFactory(() => MovieListBloc(getIt()))
    ..registerFactory(() => MovieDetailBloc(getIt()));
}
