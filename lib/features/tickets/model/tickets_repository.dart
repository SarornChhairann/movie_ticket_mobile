import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/model/dto/booking_detail_dto.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/network/result.dart';
import 'tickets_failure.dart';

class TicketsRepository {
  TicketsRepository(this._dio);

  final Dio _dio;

  /// The signed-in user's bookings, in the server's order (newest first).
  Future<Result<List<BookingSummary>, TicketsFailure>> myBookings() => _guard(() async {
        final response = await _dio.get<List<dynamic>>('/bookings/my-bookings');
        return [
          for (final json in response.data ?? const [])
            BookingSummary.fromDto(BookingDetailDto.fromJson(json as Map<String, dynamic>)),
        ];
      });

  Future<Result<BookingSummary, TicketsFailure>> booking(int id) => _guard(() async {
        final response = await _dio.get<Map<String, dynamic>>('/bookings/confirmation/$id');
        return BookingSummary.fromDto(BookingDetailDto.fromJson(response.data!));
      });

  /// Cancels booking [id]; the value is the server's confirmation message.
  Future<Result<String, TicketsFailure>> cancel(int id) => _guard(() async {
        final response = await _dio.post<Map<String, dynamic>>('/bookings/cancel/$id');
        return (response.data?['message'] as String?) ?? '';
      });

  /// The ticket's QR as PNG bytes. The URL is only ever built here.
  Future<Result<Uint8List, TicketsFailure>> qrBytes(String code) => _guard(() async {
        final response = await _dio.get<List<int>>(
          '/tickets/${Uri.encodeComponent(code)}/qr',
          options: Options(responseType: ResponseType.bytes),
        );
        return Uint8List.fromList(response.data ?? const []);
      });

  static Future<Result<T, TicketsFailure>> _guard<T>(Future<T> Function() call) async {
    try {
      return Ok(await call());
    } on DioException catch (e) {
      return Err(TicketsFailure.fromApi(ApiFailure.fromDioException(e)));
    }
  }
}
