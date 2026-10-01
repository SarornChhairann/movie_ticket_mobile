import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/network/auth_interceptor.dart';
import 'package:movie_ticket_mobile/core/network/session_header_interceptor.dart';
import 'package:movie_ticket_mobile/core/session/auth_tokens.dart';
import 'package:movie_ticket_mobile/core/session/session_end.dart';
import 'package:movie_ticket_mobile/core/session/session_id_provider.dart';
import 'package:movie_ticket_mobile/core/session/token_store.dart';

import '../../helpers/fake_adapter.dart';

const _base = 'http://api.test';

void main() {
  late TokenStore tokenStore;
  late Dio dio;
  late Dio refreshDio;
  late AuthInterceptor auth;
  late SessionIdProvider sessionIdProvider;

  /// Valid access token on the server; anything else is a 401.
  var validToken = 'new-access';
  var refreshSucceeds = true;
  var refreshCalls = 0;

  late FakeAdapter apiAdapter;

  Future<ResponseBody> api(RequestOptions o) async {
    if (o.path == '/protected') {
      await Future<void>.delayed(const Duration(milliseconds: 5));
      return o.headers['Authorization'] == 'Bearer $validToken'
          ? jsonBody(200, {'ok': true})
          : jsonBody(401, {'error': 'expired', 'type': 'UNAUTHORIZED'});
    }
    if (o.path == '/blocked') {
      return jsonBody(403, {
        'error': 'This account is banned.',
        'type': 'FORBIDDEN',
        'code': 'ACCOUNT_BLOCKED',
      });
    }
    if (o.path == '/api/auth/refresh') {
      refreshCalls++;
      return refreshSucceeds
          ? jsonBody(200, {
              'access_token': 'new-access',
              'refresh_token': 'new-refresh',
              'expires_in': 300,
              'token_type': 'Bearer',
            })
          : jsonBody(401, {'error': 'invalid refresh', 'type': 'UNAUTHORIZED'});
    }
    return jsonBody(200, {'ok': true});
  }

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    tokenStore = TokenStore(const FlutterSecureStorage());
    validToken = 'new-access';
    refreshSucceeds = true;
    refreshCalls = 0;
    apiAdapter = FakeAdapter(api);

    refreshDio = Dio(BaseOptions(baseUrl: _base))..httpClientAdapter = apiAdapter;
    auth = AuthInterceptor(tokenStore: tokenStore, refreshDio: refreshDio);
    sessionIdProvider = SessionIdProvider();
    dio = Dio(BaseOptions(baseUrl: _base))
      ..httpClientAdapter = apiAdapter
      ..interceptors.addAll([SessionHeaderInterceptor(sessionIdProvider), auth]);
  });

  Future<void> signIn(String access) => tokenStore.save(
        AuthTokens(accessToken: access, refreshToken: 'old-refresh', expiresIn: 300),
      );

  group('session header', () {
    test('sends the same X-Session-Id on every request', () async {
      await dio.get<dynamic>('/public');
      await dio.get<dynamic>('/public');

      final ids = apiAdapter.requests.map((r) => r.headers['X-Session-Id']).toList();
      expect(ids, [sessionIdProvider.sessionId, sessionIdProvider.sessionId]);
    });
  });

  group('bearer header', () {
    test('adds Authorization when a token exists', () async {
      await signIn('new-access');

      await dio.get<dynamic>('/public');

      expect(apiAdapter.requests.single.headers['Authorization'], 'Bearer new-access');
    });

    test('skips Authorization when no token is stored', () async {
      await dio.get<dynamic>('/public');

      expect(apiAdapter.requests.single.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('401 handling', () {
    test('refreshes once, stores the new tokens, and retries the request', () async {
      await signIn('old-access');

      final response = await dio.get<dynamic>('/protected');

      expect(response.statusCode, 200);
      expect(refreshCalls, 1);
      expect(await tokenStore.readAccessToken(), 'new-access');
      expect(await tokenStore.readRefreshToken(), 'new-refresh');
      expect(apiAdapter.requests.where((r) => r.path == '/protected'), hasLength(2));
    });

    test('clears the session and does not retry when refresh fails', () async {
      await signIn('old-access');
      refreshSucceeds = false;
      final expired = expectLater(auth.sessionEnded, emits(isA<SessionExpired>()));

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'status', 401)),
      );

      await expired;
      expect(refreshCalls, 1);
      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
      expect(apiAdapter.requests.where((r) => r.path == '/protected'), hasLength(1));
    });

    test('a retried request that is still 401 is not refreshed again', () async {
      await signIn('old-access');
      validToken = 'never-valid';

      await expectLater(dio.get<dynamic>('/protected'), throwsA(isA<DioException>()));

      expect(refreshCalls, 1);
      expect(apiAdapter.requests.where((r) => r.path == '/protected'), hasLength(2));
    });

    test('parallel 401s share one refresh', () async {
      await signIn('old-access');

      final responses = await Future.wait([
        dio.get<dynamic>('/protected'),
        dio.get<dynamic>('/protected'),
        dio.get<dynamic>('/protected'),
      ]);

      expect(responses.map((r) => r.statusCode), everyElement(200));
      expect(refreshCalls, 1);
    });

    test('a 401 without a bearer token is passed through untouched', () async {
      await expectLater(dio.get<dynamic>('/protected'), throwsA(isA<DioException>()));

      expect(refreshCalls, 0);
    });
  });

  group('blocked account', () {
    test('403 ACCOUNT_BLOCKED on an authenticated call clears the session and emits blocked', () async {
      await signIn('new-access');
      final blocked = expectLater(
        auth.sessionEnded,
        emits(isA<SessionBlocked>().having((e) => e.message, 'message', 'This account is banned.')),
      );

      await expectLater(dio.get<dynamic>('/blocked'), throwsA(isA<DioException>()));

      await blocked;
      expect(await tokenStore.readAccessToken(), isNull);
      expect(refreshCalls, 0);
    });
  });
}
