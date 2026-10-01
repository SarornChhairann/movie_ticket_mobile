import 'package:json_annotation/json_annotation.dart';

part 'profile_request_dtos.g.dart';

@JsonSerializable(createFactory: false)
class UpdateProfileDto {
  const UpdateProfileDto({required this.name, required this.phone});

  final String name;
  final String phone;

  Map<String, dynamic> toJson() => _$UpdateProfileDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class ChangePasswordDto {
  const ChangePasswordDto({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  Map<String, dynamic> toJson() => _$ChangePasswordDtoToJson(this);
}
