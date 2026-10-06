import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'auth_interceptor.dart';
import 'connectivity_monitor.dart';
import 'session_header_interceptor.dart';

BaseOptions _baseOptions(String baseUrl) => BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

/// The app's single API client.
Dio createDio({
  required String baseUrl,
  required SessionHeaderInterceptor sessionHeaderInterceptor,
  required AuthInterceptor authInterceptor,
  ConnectivityMonitor? connectivityMonitor,
}) {
  final dio = Dio(_baseOptions(baseUrl));
  dio.interceptors.addAll([
    sessionHeaderInterceptor,
    authInterceptor,
    ?connectivityMonitor,
    // Method, URL, and status only: headers and bodies carry tokens and passwords.
    if (kDebugMode)
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        requestBody: false,
        responseBody: false,
      ),
  ]);
  return dio;
}

/// Interceptor-free client used by [AuthInterceptor] to refresh and retry.
Dio createBareDio(String baseUrl) => Dio(_baseOptions(baseUrl));
