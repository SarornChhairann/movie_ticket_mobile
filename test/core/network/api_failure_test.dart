import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';

DioException _withBody(int status, Object? body) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: status, data: body),
  );
}

void main() {
  test('reads code and error from the server body', () {
    final failure = ApiFailure.fromDioException(_withBody(403, {
      'error': 'This account is suspended.',
      'type': 'FORBIDDEN',
      'code': 'ACCOUNT_BLOCKED',
    }));

    expect(
      failure,
      const ApiFailure.server(
        status: 403,
        code: 'ACCOUNT_BLOCKED',
        message: 'This account is suspended.',
      ),
    );
  });

  test('tolerates a body without code', () {
    final failure = ApiFailure.fromDioException(
      _withBody(400, {'error': 'Please select at least one seat.', 'type': 'BAD_REQUEST'}),
    );

    expect(
      failure,
      const ApiFailure.server(status: 400, message: 'Please select at least one seat.'),
    );
  });

  test('maps a timeout without response to network', () {
    final failure = ApiFailure.fromDioException(DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.connectionTimeout,
    ));

    expect(failure, const ApiFailure.network());
  });
}
