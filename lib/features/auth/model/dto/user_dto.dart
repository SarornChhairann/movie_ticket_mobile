import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// `GET /profile` / `POST /profile` body.
@JsonSerializable(createToJson: false)
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.points = 0,
    required this.status,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final int points;
  final String status;
}
