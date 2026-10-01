import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_failure.freezed.dart';

/// Transport-level failure built from a [DioException].
///
/// Feature repositories turn this into their own failure type by branching on
/// [ApiFailureServer.status] and [ApiFailureServer.code], never on message text.
@freezed
sealed class ApiFailure with _$ApiFailure {
  const ApiFailure._();

  /// The server answered with an error body `{error, type, code?}`.
  const factory ApiFailure.server({
    required int status,
    String? code,
    required String message,
  }) = ApiFailureServer;

  /// No response: timeout, DNS, refused connection.
  const factory ApiFailure.network() = ApiFailureNetwork;

  const factory ApiFailure.unknown([String? message]) = ApiFailureUnknown;

  factory ApiFailure.fromDioException(DioException e) {
    final response = e.response;
    if (response == null) {
      return switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError =>
          const ApiFailure.network(),
        _ => ApiFailure.unknown(e.message),
      };
    }
    final status = response.statusCode ?? 0;
    final body = response.data;
    if (body is Map) {
      final error = body['error'];
      final code = body['code'];
      return ApiFailure.server(
        status: status,
        code: code is String ? code : null,
        message: error is String ? error : (response.statusMessage ?? ''),
      );
    }
    return ApiFailure.server(
      status: status,
      message: response.statusMessage ?? '',
    );
  }
}
