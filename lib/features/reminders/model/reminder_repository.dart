import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';

/// Why a reminder was not created. [message] is the server's text ('' for network).
sealed class ReminderFailure {
  const ReminderFailure(this.message);

  final String message;

  /// Branches on `code`, never on message text.
  static ReminderFailure fromApi(ApiFailure failure) => switch (failure) {
        ApiFailureServer(code: 'REMINDER_EXISTS', :final message) => ReminderExists(message),
        ApiFailureServer(:final message) => ReminderRejected(message),
        ApiFailureNetwork() => const ReminderNetwork(),
        ApiFailureUnknown(:final message) => ReminderRejected(message ?? ''),
      };
}

/// 409 `REMINDER_EXISTS`: the email is already subscribed to this movie.
final class ReminderExists extends ReminderFailure {
  const ReminderExists(super.message);
}

/// 400 invalid email / movie, or any other server error.
final class ReminderRejected extends ReminderFailure {
  const ReminderRejected(super.message);
}

final class ReminderNetwork extends ReminderFailure {
  const ReminderNetwork() : super('');
}

class ReminderRepository {
  ReminderRepository(this._dio);

  final Dio _dio;

  /// `POST /api/reminders`.
  Future<Result<void, ReminderFailure>> subscribe({required int movieId, required String email}) async {
    try {
      await _dio.post<Map<String, dynamic>>('/api/reminders', data: {'movieId': movieId, 'email': email.trim()});
      return const Ok(null);
    } on DioException catch (e) {
      return Err(ReminderFailure.fromApi(ApiFailure.fromDioException(e)));
    }
  }
}
