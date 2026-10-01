import 'package:freezed_annotation/freezed_annotation.dart';

import 'dto/user_dto.dart';

part 'user.freezed.dart';

enum UserStatus { active, suspended, banned }

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required int id,
    required String name,
    required String email,
    String? phone,
    required String role,
    required int points,
    required UserStatus status,
  }) = _User;

  factory User.fromDto(UserDto dto) => User(
        id: dto.id,
        name: dto.name,
        email: dto.email,
        phone: dto.phone,
        role: dto.role,
        points: dto.points,
        status: switch (dto.status) {
          'SUSPENDED' => UserStatus.suspended,
          'BANNED' => UserStatus.banned,
          _ => UserStatus.active,
        },
      );

  bool get isBlocked => status != UserStatus.active;
}
