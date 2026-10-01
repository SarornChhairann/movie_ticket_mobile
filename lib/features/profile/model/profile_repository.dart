import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import '../../auth/model/dto/user_dto.dart';
import '../../auth/model/user.dart';
import 'profile_request_dtos.dart';

class ProfileRepository {
  ProfileRepository(this._dio);

  final Dio _dio;

  Future<Result<User, ApiFailure>> fetch() =>
      _user(() => _dio.get<Map<String, dynamic>>('/profile'));

  Future<Result<User, ApiFailure>> update({required String name, required String phone}) => _user(
        () => _dio.post<Map<String, dynamic>>(
          '/profile',
          data: UpdateProfileDto(name: name.trim(), phone: phone.trim()).toJson(),
        ),
      );

  Future<Result<void, ApiFailure>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _dio.post<void>(
        '/profile/change-password',
        data: ChangePasswordDto(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ).toJson(),
      );
      return const Ok(null);
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    }
  }

  Future<Result<User, ApiFailure>> _user(
    Future<Response<Map<String, dynamic>>> Function() call,
  ) async {
    try {
      final response = await call();
      return Ok(User.fromDto(UserDto.fromJson(response.data!)));
    } on DioException catch (e) {
      return Err(ApiFailure.fromDioException(e));
    }
  }
}
