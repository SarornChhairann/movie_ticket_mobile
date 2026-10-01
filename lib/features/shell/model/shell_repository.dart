import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import 'home_response_dto.dart';
import 'home_summary.dart';

class ShellRepository {
  ShellRepository(this._dio);

  final Dio _dio;

  /// Calls the public home endpoint to prove the API is reachable.
  Future<Result<HomeSummary, ApiFailure>> fetchHome() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/');
      return Ok(HomeSummary.fromDto(HomeResponseDto.fromJson(response.data ?? {})));
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    } on FormatException catch (e) {
      return Err(ApiFailure.unknown(e.message));
    }
  }
}
