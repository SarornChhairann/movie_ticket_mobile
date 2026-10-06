import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Watches every API call (sprint 19): two network failures in a row (timeout,
/// refused, DNS) mean "offline"; the next response of any kind means back
/// online. A server error is an answer, so it never counts as offline.
class ConnectivityMonitor extends Interceptor {
  /// Failures in a row before the banner shows.
  static const failuresBeforeOffline = 2;

  final _offline = ValueNotifier(false);
  int _failures = 0;

  ValueListenable<bool> get offline => _offline;

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _online();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      _online();
    } else if (_isNetwork(err.type)) {
      _failures++;
      if (_failures >= failuresBeforeOffline) _offline.value = true;
    }
    handler.next(err);
  }

  void _online() {
    _failures = 0;
    _offline.value = false;
  }

  static bool _isNetwork(DioExceptionType type) => switch (type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError =>
          true,
        _ => false,
      };
}
