import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/auth_interceptor.dart';
import '../../../core/network/result.dart';
import '../../../core/session/auth_tokens.dart';
import '../../../core/session/session_end.dart';
import '../../../core/session/token_store.dart';
import 'auth_failure.dart';
import 'dto/auth_request_dtos.dart';
import 'dto/user_dto.dart';
import 'user.dart';

/// Login, register, session restore, and logout against `/api/auth/**`.
///
/// Login and refresh return no user id, status, or points (gap G4), so every
/// successful token exchange is followed by `GET /profile`.
class AuthRepository {
  AuthRepository(this._dio, this._tokenStore, this._authInterceptor);

  final Dio _dio;
  final TokenStore _tokenStore;
  final AuthInterceptor _authInterceptor;

  /// Session cleared by the network layer (expired refresh or blocked account).
  Stream<SessionEnd> get sessionEnded => _authInterceptor.sessionEnded;

  Future<Result<User, AuthFailure>> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: LoginRequestDto(email: email.trim(), password: password).toJson(),
      );
      await _tokenStore.save(AuthTokens.fromJson(response.data!));
      return await _loadProfile();
    } on DioException catch (e) {
      return Err(AuthFailure.fromApi(ApiFailure.fromDioException(e)));
    }
  }

  /// Register returns no tokens (gap G3), so a successful register logs in with
  /// the same credentials.
  Future<Result<User, AuthFailure>> register(String name, String email, String password) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/auth/register',
        data: RegisterRequestDto(name: name.trim(), email: email.trim(), password: password).toJson(),
      );
    } on DioException catch (e) {
      return Err(AuthFailure.fromApi(ApiFailure.fromDioException(e)));
    }
    return login(email, password);
  }

  /// Restores a stored session on app start. `Ok(null)` means there is no
  /// usable session and the user should log in.
  Future<Result<User?, AuthFailure>> restoreSession() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null) {
      return const Ok(null);
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/refresh',
        data: RefreshRequestDto(refreshToken: refreshToken).toJson(),
      );
      await _tokenStore.save(AuthTokens.fromJson(response.data!));
    } on DioException catch (e) {
      final failure = AuthFailure.fromApi(ApiFailure.fromDioException(e));
      // Offline: keep the tokens so the next start can retry.
      if (failure is AuthNetwork) {
        return Err(failure);
      }
      await _tokenStore.clear();
      return failure is AuthBlocked ? Err(failure) : const Ok(null);
    }
    return switch (await _loadProfile()) {
      Ok(:final value) => Ok(value),
      Err(:final failure) => Err(failure),
    };
  }

  /// Revokes the refresh token, then clears local storage even if that fails.
  Future<void> logout() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    try {
      if (refreshToken != null) {
        await _dio.post<void>(
          '/api/auth/logout',
          data: RefreshRequestDto(refreshToken: refreshToken).toJson(),
        );
      }
    } on DioException {
      // The server session expires on its own; the local copy must go regardless.
    } finally {
      await _tokenStore.clear();
    }
  }

  /// Re-reads the signed-in user (e.g. new points after a purchase). Unlike the
  /// session start path, a failure here never clears the session.
  Future<Result<User, AuthFailure>> currentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/profile');
      return Ok(User.fromDto(UserDto.fromJson(response.data!)));
    } on DioException catch (e) {
      return Err(AuthFailure.fromApi(ApiFailure.fromDioException(e)));
    }
  }

  Future<Result<User, AuthFailure>> _loadProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/profile');
      return Ok(User.fromDto(UserDto.fromJson(response.data!)));
    } on DioException catch (e) {
      final failure = AuthFailure.fromApi(ApiFailure.fromDioException(e));
      if (failure is! AuthNetwork) {
        await _tokenStore.clear();
      }
      return Err(failure);
    }
  }
}
