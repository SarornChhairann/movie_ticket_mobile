import 'package:json_annotation/json_annotation.dart';

part 'auth_request_dtos.g.dart';

@JsonSerializable(createFactory: false)
class LoginRequestDto {
  const LoginRequestDto({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class RegisterRequestDto {
  const RegisterRequestDto({required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class RefreshRequestDto {
  const RefreshRequestDto({required this.refreshToken});

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  Map<String, dynamic> toJson() => _$RefreshRequestDtoToJson(this);
}
