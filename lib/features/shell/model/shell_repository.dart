import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../../../core/storage/home_cache.dart';
import 'home_response_dto.dart';
import 'home_summary.dart';

class ShellRepository {
  ShellRepository(this._dio, {this._cache});

  final Dio _dio;
  final HomeCache? _cache;

  /// Calls the public home endpoint to prove the API is reachable; it also
  /// carries Home's featured movie. With no connection it answers from the
  /// saved copy (`Ok(…, savedAt:)`), so Home knows it is offline and keeps its hero.
  Future<Result<HomeSummary, ApiFailure>> fetchHome() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/');
      final body = response.data ?? const <String, dynamic>{};
      // Only what the hero needs is saved, not the whole catalog.
      unawaited(_cache?.write(HomeCache.home, {
        'featuredMovie': body['featuredMovie'],
        'heroMovies': [if (body['heroMovies'] case [final first, ...]) first],
      }));
      return Ok(_summary(body));
    } on DioException catch (e) {
      final failure = ApiFailure.fromDioException(e);
      final saved = failure is ApiFailureNetwork ? await _cache?.read(HomeCache.home) : null;
      if (saved == null) return Err(failure);
      return Ok(_summary(saved.body), savedAt: saved.savedAt);
    } on FormatException catch (e) {
      return Err(ApiFailure.unknown(e.message));
    }
  }

  HomeSummary _summary(Object? body) => HomeSummary.fromDto(
        HomeResponseDto.fromJson(body is Map<String, dynamic> ? body : const {}),
        baseUrl: _dio.options.baseUrl,
      );
}
