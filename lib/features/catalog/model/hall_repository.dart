import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import 'catalog_mapper.dart';
import 'dto/hall_dtos.dart';
import 'hall.dart';
import 'hall_mapper.dart';
import '../../../core/storage/home_cache.dart';

/// Public hall reads (`/api/halls`). Never calls `/admin/halls`. The hall list
/// falls back to [HomeCache] when there is no connection (sprint 21).
class HallRepository {
  HallRepository(this._dio, {this._cache});

  final Dio _dio;
  final HomeCache? _cache;

  Future<Result<List<Hall>, ApiFailure>> fetchHalls() async {
    try {
      final response = await _dio.get<List<dynamic>>('/api/halls');
      unawaited(_cache?.write(HomeCache.halls, response.data));
      return Ok(_halls(response.data));
    } on DioException catch (e) {
      final failure = ApiFailure.fromDioException(e);
      final saved = failure is ApiFailureNetwork ? await _cache?.read(HomeCache.halls) : null;
      if (saved == null) return Err(failure);
      return Ok(_halls(saved.body), savedAt: saved.savedAt);
    }
  }

  List<Hall> _halls(Object? body) => [
        for (final row in body is List<dynamic> ? body : const [])
          HallMapper.hall(HallDto.fromJson(row as Map<String, dynamic>)),
      ];

  Future<Result<HallSchedule, ApiFailure>> fetchSchedule(int hallId, {DateTime? date}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/halls/$hallId/showtimes',
        queryParameters: {if (date != null) 'date': CatalogMapper.isoDate(date)},
      );
      return Ok(HallMapper.schedule(HallScheduleDto.fromJson(response.data!), _dio.options.baseUrl));
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    }
  }
}
