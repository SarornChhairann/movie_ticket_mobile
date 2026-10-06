import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import 'catalog_mapper.dart';
import 'dto/hall_dtos.dart';
import 'hall.dart';
import 'hall_mapper.dart';

/// Public hall reads (`/api/halls`). Never calls `/admin/halls`.
class HallRepository {
  HallRepository(this._dio);

  final Dio _dio;

  Future<Result<List<Hall>, ApiFailure>> fetchHalls() async {
    try {
      final response = await _dio.get<List<dynamic>>('/api/halls');
      return Ok([
        for (final row in response.data ?? const [])
          HallMapper.hall(HallDto.fromJson(row as Map<String, dynamic>)),
      ]);
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    }
  }

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
