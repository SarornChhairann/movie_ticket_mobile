import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'controller/favourite_halls_cubit.dart';
import 'controller/hall_list_bloc.dart';
import 'controller/hall_schedule_bloc.dart';
import 'controller/movie_detail_bloc.dart';
import 'controller/movie_list_bloc.dart';
import 'controller/recently_viewed_cubit.dart';
import 'controller/search_results_bloc.dart';
import 'controller/showing_cubit.dart';
import 'model/catalog_repository.dart';
import 'model/hall_repository.dart';
import 'model/local_prefs_store.dart';

void registerCatalog(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => CatalogRepository(getIt(), cache: getIt()))
    ..registerLazySingleton(() => HallRepository(getIt(), cache: getIt()))
    // Favourites, recently viewed, recent searches (sprint 22); wiped on sign-out.
    ..registerLazySingleton(() => LocalPrefsStore(getApplicationDocumentsDirectory))
    ..registerFactory(() => MovieListBloc(getIt()))
    ..registerFactory(() => ExploreMovieListBloc(getIt()))
    ..registerFactory(() => FavouriteHallsCubit(getIt(), getIt()))
    ..registerFactory(() => RecentlyViewedCubit(getIt()))
    ..registerFactoryParam<SearchResultsBloc, SearchSeed, void>((seed, _) => SearchResultsBloc(getIt(), getIt(), seed))
    ..registerFactory(() => MovieDetailBloc(getIt(), tracker: getIt()))
    ..registerFactory(() => HallListBloc(getIt()))
    ..registerFactory(() => ShowingCubit(getIt(), tracker: getIt()))
    ..registerFactory(() => HallScheduleBloc(getIt(), tracker: getIt()));
}
