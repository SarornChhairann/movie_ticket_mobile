import 'package:dio/dio.dart';

import '../session/session_id_provider.dart';

/// Adds `X-Session-Id` to every request.
class SessionHeaderInterceptor extends Interceptor {
  SessionHeaderInterceptor(this._sessionIdProvider);

  static const headerName = 'X-Session-Id';

  final SessionIdProvider _sessionIdProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[headerName] = _sessionIdProvider.sessionId;
    handler.next(options);
  }
}
