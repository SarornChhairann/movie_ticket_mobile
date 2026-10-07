import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import 'catalog_mapper.dart';
import 'dto/browse_dtos.dart';
import 'dto/catalog_response_dtos.dart';
import '../../../core/storage/home_cache.dart';
import 'movie.dart';

/// Network first. Home's lists are saved to [HomeCache] on every success and
/// read back only when there is no connection — never on a server answer
/// (sprint 21). A saved answer comes back as `Ok(value, savedAt: …)`.
class CatalogRepository {
  CatalogRepository(this._dio, {this._cache});

  final Dio _dio;
  final HomeCache? _cache;

  Future<Result<List<Movie>, ApiFailure>> fetchMovies(MovieTab tab, {String search = ''}) async {
    final query = search.trim();
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/movies',
        queryParameters: {
          'tab': tab.apiValue,
          if (query.isNotEmpty) 'search': query,
        },
      );
      // Only the unfiltered list is saved; an offline search filters it by title.
      if (query.isEmpty) unawaited(_cache?.write(HomeCache.movies(tab.apiValue), response.data));
      return Ok(_movies(response.data));
    } on DioException catch (e) {
      final failure = ApiFailure.fromDioException(e);
      final saved = failure is ApiFailureNetwork ? await _cache?.read(HomeCache.movies(tab.apiValue)) : null;
      if (saved == null) return Err(failure);
      final q = query.toLowerCase();
      return Ok(
        [for (final m in _movies(saved.body)) if (q.isEmpty || m.title.toLowerCase().contains(q)) m],
        savedAt: saved.savedAt,
      );
    }
  }

  List<Movie> _movies(Object? body) {
    final dto = MovieListResponseDto.fromJson(body is Map<String, dynamic> ? body : const {});
    return [
      for (final m in dto.movies)
        // ARCHIVED never reaches the customer list, even if the server sent it.
        if (m.status != 'ARCHIVED') CatalogMapper.movie(m, _dio.options.baseUrl),
    ];
  }

  /// Now-showing movies with showtimes on [date] (cinema date), each with up to
  /// four that have not started (G34).
  Future<Result<List<ShowingMovie>, ApiFailure>> fetchShowing(DateTime date) async {
    final key = HomeCache.showing(CatalogMapper.isoDate(date));
    try {
      final response = await _dio.get<List<dynamic>>(
        '/api/movies',
        queryParameters: {'type': 'now_showing', 'date': CatalogMapper.isoDate(date)},
      );
      unawaited(_cache?.write(key, response.data));
      return Ok(_showing(response.data));
    } on DioException catch (e) {
      final failure = ApiFailure.fromDioException(e);
      final saved = failure is ApiFailureNetwork ? await _cache?.read(key) : null;
      if (saved == null) return Err(failure);
      return Ok(_showing(saved.body), savedAt: saved.savedAt);
    }
  }

  List<ShowingMovie> _showing(Object? body) => [
        for (final json in body is List<dynamic> ? body : const [])
          CatalogMapper.showing(MovieBrowseDto.fromJson(json as Map<String, dynamic>), _dio.options.baseUrl),
      ].where((m) => m.slots.isNotEmpty).toList();

  Future<Result<MovieDetail, ApiFailure>> fetchDetail(int movieId, {DateTime? date}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/movies/$movieId',
        queryParameters: {if (date != null) 'date': CatalogMapper.isoDate(date)},
      );
      return Ok(CatalogMapper.detail(
        MovieDetailResponseDto.fromJson(response.data!),
        _dio.options.baseUrl,
      ));
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    }
  }
}
