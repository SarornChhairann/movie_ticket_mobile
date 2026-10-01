import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/auth_interceptor.dart';

part 'auth_failure.freezed.dart';

@freezed
sealed class AuthFailure with _$AuthFailure {
  const AuthFailure._();

  const factory AuthFailure.invalidCredentials() = AuthInvalidCredentials;
  const factory AuthFailure.blocked(String message) = AuthBlocked;
  const factory AuthFailure.emailInUse(String message) = AuthEmailInUse;
  const factory AuthFailure.validation(String message) = AuthValidation;
  const factory AuthFailure.sessionExpired() = AuthSessionExpired;
  const factory AuthFailure.network() = AuthNetwork;
  const factory AuthFailure.unknown(String message) = AuthUnknown;

  /// Branches on status and `code`, never on message text.
  factory AuthFailure.fromApi(ApiFailure failure) => switch (failure) {
        ApiFailureServer(code: AuthInterceptor.accountBlockedCode, :final message) =>
          AuthFailure.blocked(message),
        ApiFailureServer(status: 401) => const AuthFailure.invalidCredentials(),
        ApiFailureServer(status: 409, :final message) => AuthFailure.emailInUse(message),
        ApiFailureServer(status: 400, :final message) => AuthFailure.validation(message),
        ApiFailureServer(:final message) => AuthFailure.unknown(message),
        ApiFailureNetwork() => const AuthFailure.network(),
        ApiFailureUnknown(:final message) => AuthFailure.unknown(message ?? ''),
      };
}
