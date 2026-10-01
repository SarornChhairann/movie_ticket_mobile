import 'package:json_annotation/json_annotation.dart';

part 'auth_tokens.g.dart';

/// Token fields of the login/refresh response, under their OAuth2 names.
@JsonSerializable(createToJson: false)
class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  /// Access token lifetime in seconds.
  @JsonKey(name: 'expires_in')
  final int expiresIn;
}
