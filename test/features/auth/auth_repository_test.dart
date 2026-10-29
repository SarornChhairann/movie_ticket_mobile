import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_ticket_mobile/core/network/auth_interceptor.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/session/auth_tokens.dart';
import 'package:movie_ticket_mobile/core/session/token_store.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_failure.dart';
import 'package:movie_ticket_mobile/features/auth/model/auth_repository.dart';
import 'package:movie_ticket_mobile/features/auth/model/user.dart';

import 'auth_fixtures.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late TokenStore tokenStore;
  late AuthRepository repository;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    tokenStore = TokenStore(const FlutterSecureStorage());
    dio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    adapter = DioAdapter(dio: dio);
    repository = AuthRepository(
      dio,
      tokenStore,
      AuthInterceptor(tokenStore: tokenStore, refreshDio: Dio()),
    );
  });

  Future<void> storeSession() => tokenStore.save(
        const AuthTokens(accessToken: 'old', refreshToken: 'refresh-0', expiresIn: 300),
      );

  test('login stores tokens and loads the user from /profile', () async {
    adapter
      ..onPost('/api/auth/login', (s) => s.reply(200, tokenJson),
          data: {'email': 'dara@example.com', 'password': 'secret1'})
      ..onGet('/profile', (s) => s.reply(200, profileJson));

    final result = await repository.login(' dara@example.com ', 'secret1');

    expect((result as Ok<User, AuthFailure>).value, testUser);
    expect(await tokenStore.readAccessToken(), 'access-1');
    expect(await tokenStore.readRefreshToken(), 'refresh-1');
  });

  test('login 403 ACCOUNT_BLOCKED maps to blocked and stores nothing', () async {
    adapter.onPost(
      '/api/auth/login',
      (s) => s.reply(403, {
        'error': 'This account is suspended.',
        'type': 'FORBIDDEN',
        'code': 'ACCOUNT_BLOCKED',
      }),
      data: Matchers.any,
    );

    final result = await repository.login('dara@example.com', 'secret1');

    expect((result as Err<User, AuthFailure>).failure,
        const AuthFailure.blocked('This account is suspended.'));
    expect(await tokenStore.readAccessToken(), isNull);
  });

  test('login 401 maps to invalid credentials', () async {
    adapter.onPost('/api/auth/login', (s) => s.reply(401, {'error': 'Invalid', 'type': 'UNAUTHORIZED'}),
        data: Matchers.any);

    final result = await repository.login('dara@example.com', 'wrong1');

    expect((result as Err<User, AuthFailure>).failure, const AuthFailure.invalidCredentials());
  });

  test('register 409 maps to email in use and does not log in', () async {
    adapter.onPost('/api/auth/register',
        (s) => s.reply(409, {'error': 'Email is already in use.', 'type': 'CONFLICT'}),
        data: Matchers.any);

    final result = await repository.register('Dara', 'dara@example.com', 'secret1');

    expect((result as Err<User, AuthFailure>).failure,
        const AuthFailure.emailInUse('Email is already in use.'));
  });

  test('logout clears storage even when the API fails', () async {
    await storeSession();
    adapter.onPost('/api/auth/logout', (s) => s.reply(500, {'error': 'boom'}),
        data: {'refresh_token': 'refresh-0'});

    await repository.logout();

    expect(await tokenStore.readAccessToken(), isNull);
    expect(await tokenStore.readRefreshToken(), isNull);
  });

  test('restoreSession without a refresh token returns no user', () async {
    final result = await repository.restoreSession();

    expect((result as Ok<User?, AuthFailure>).value, isNull);
  });

  test('restoreSession refreshes then loads the profile', () async {
    await storeSession();
    adapter
      ..onPost('/api/auth/refresh', (s) => s.reply(200, tokenJson), data: {'refresh_token': 'refresh-0'})
      ..onGet('/profile', (s) => s.reply(200, profileJson));

    final result = await repository.restoreSession();

    expect((result as Ok<User?, AuthFailure>).value, testUser);
    expect(await tokenStore.readAccessToken(), 'access-1');
  });

  test('restoreSession with a rejected refresh token clears it', () async {
    await storeSession();
    adapter.onPost('/api/auth/refresh', (s) => s.reply(401, {'error': 'expired'}), data: Matchers.any);

    final result = await repository.restoreSession();

    expect((result as Ok<User?, AuthFailure>).value, isNull);
    expect(await tokenStore.readRefreshToken(), isNull);
  });
  test('requestPasswordReset posts the trimmed email', () async {
    adapter.onPost('/api/auth/forgot-password', (s) => s.reply(202, {'message': 'ok'}),
        data: {'email': 'dara@example.com'});

    expect(await repository.requestPasswordReset(' dara@example.com '), isA<Ok<void, AuthFailure>>());
  });

  test('resetPassword 400 RESET_CODE_INVALID maps to resetCodeInvalid', () async {
    adapter.onPost(
      '/api/auth/reset-password',
      (s) => s.reply(400, {'error': 'That code is wrong.', 'type': 'BAD_REQUEST', 'code': 'RESET_CODE_INVALID'}),
      data: {'email': 'dara@example.com', 'code': '000000', 'newPassword': 'newsecret'},
    );

    final result = await repository.resetPassword(email: 'dara@example.com', code: '000000', newPassword: 'newsecret');

    expect((result as Err<void, AuthFailure>).failure, const AuthFailure.resetCodeInvalid());
  });

  test('resetPassword 204 succeeds and stores no tokens', () async {
    adapter.onPost('/api/auth/reset-password', (s) => s.reply(204, null), data: Matchers.any);

    final result = await repository.resetPassword(email: 'dara@example.com', code: '123456', newPassword: 'newsecret');

    expect(result, isA<Ok<void, AuthFailure>>());
    expect(await tokenStore.readAccessToken(), isNull);
  });
}
