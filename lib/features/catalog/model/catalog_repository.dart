import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import 'catalog_mapper.dart';
import 'dto/catalog_response_dtos.dart';
import 'movie.dart';

class CatalogRepository {
  CatalogRepository(this._dio);

  final Dio _dio;

  Future<Result<List<Movie>, ApiFailure>> fetchMovies(MovieTab tab, {String search = ''}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/movies',
        queryParameters: {
          'tab': tab.apiValue,
          if (search.trim().isNotEmpty) 'search': search.trim(),
        },
      );
      final dto = MovieListResponseDto.fromJson(response.data ?? {});
      return Ok([
        for (final m in dto.movies)
          // ARCHIVED never reaches the customer list, even if the server sent it.
          if (m.status != 'ARCHIVED') CatalogMapper.movie(m, _dio.options.baseUrl),
      ]);
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    }
  }

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
