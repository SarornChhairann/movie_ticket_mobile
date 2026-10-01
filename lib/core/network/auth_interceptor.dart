import 'dart:async';

import 'package:dio/dio.dart';

import '../session/auth_tokens.dart';
import '../session/session_end.dart';
import '../session/token_store.dart';

/// Attaches the bearer token and recovers from one expired access token.
///
/// On a 401 for a request that carried a token it refreshes once through
/// [_refreshDio] (a bare Dio without this interceptor, so refresh can never
/// loop), retries the original request once, and otherwise clears the session
/// and emits [SessionExpired] on [sessionEnded]. A `403 ACCOUNT_BLOCKED` to an
/// authenticated call clears the session and emits [SessionBlocked]. Being a [QueuedInterceptor], parallel 401s
/// are handled one at a time: the later ones see the already-refreshed token
/// and only retry.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this._tokenStore, required this._refreshDio});

  static const _retriedKey = 'auth.retried';
  static const _authPathPrefix = '/api/auth/';
  static const accountBlockedCode = 'ACCOUNT_BLOCKED';

  final TokenStore _tokenStore;
  final Dio _refreshDio;
  final _sessionEnded = StreamController<SessionEnd>.broadcast();

  /// Fires when the network layer cleared the session.
  Stream<SessionEnd> get sessionEnded => _sessionEnded.stream;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final sentAuth = request.headers['Authorization'] as String?;

    final blockedMessage = _blockedMessage(err.response);
    if (sentAuth != null && blockedMessage != null) {
      await _tokenStore.clear();
      _sessionEnded.add(SessionBlocked(blockedMessage));
      handler.next(err);
      return;
    }
    if (err.response?.statusCode != 401 ||
        sentAuth == null ||
        request.extra[_retriedKey] == true ||
        request.uri.path.startsWith(_authPathPrefix)) {
      handler.next(err);
      return;
    }

    final current = await _tokenStore.readAccessToken();
    final String? token;
    if (current != null && 'Bearer $current' != sentAuth) {
      // An earlier queued 401 already refreshed; reuse its token.
      token = current;
    } else {
      token = await _refresh();
    }

    if (token == null) {
      await _tokenStore.clear();
      // Emit once: later queued 401s find the store already empty.
      if (current != null) {
        _sessionEnded.add(const SessionExpired());
      }
      handler.next(err);
      return;
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.extra[_retriedKey] = true;
    try {
      handler.resolve(await _refreshDio.fetch<dynamic>(request));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// The server message when [response] is `403` with `code: ACCOUNT_BLOCKED`.
  static String? _blockedMessage(Response<dynamic>? response) {
    final data = response?.data;
    if (response?.statusCode != 403 || data is! Map || data['code'] != accountBlockedCode) {
      return null;
    }
    final error = data['error'];
    return error is String ? error : '';
  }

  Future<String?> _refresh() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '${_authPathPrefix}refresh',
        data: {'refresh_token': refreshToken},
      );
      final tokens = AuthTokens.fromJson(response.data!);
      await _tokenStore.save(tokens);
      return tokens.accessToken;
    } on Object {
      return null;
    }
  }
}
