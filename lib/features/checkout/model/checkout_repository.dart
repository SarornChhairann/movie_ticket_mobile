import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/model/booking_summary.dart';
import '../../../core/model/dto/booking_detail_dto.dart';
import '../../../core/network/result.dart';
import '../../seats/model/seat_map.dart';
import 'checkout_failure.dart';
import 'dto/booking_dtos.dart';
import 'dto/quote_dtos.dart';
import 'quote.dart';

class CheckoutRepository {
  CheckoutRepository(this._dio);

  final Dio _dio;

  /// Confirms and pays for the seats of [hold]. Never sends a total.
  Future<Result<BookingSummary, CheckoutFailure>> confirm(
    Hold hold, {
    GuestInfo? guest,
    String? promoCode,
    Map<int, int> food = const {},
    String paymentMethod = 'CARD',
  }) async {
    final selected = _foodJson(food);
    String? blankToNull(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/bookings/checkout/${hold.showtimeId}',
        data: ConfirmRequestDto(
          seatIds: hold.seatIds.toList()..sort(),
          guestName: blankToNull(guest?.name),
          guestPhone: blankToNull(guest?.phone),
          guestEmail: blankToNull(guest?.email),
          promoCode: blankToNull(promoCode),
          paymentMethod: paymentMethod,
          foodItems: selected.isEmpty ? null : selected,
        ).toJson(),
      );
      return Ok(BookingSummary.fromDto(BookingDetailDto.fromJson(response.data!)));
    } on DioException catch (e) {
      return Err(CheckoutFailure.fromApi(ApiFailure.fromDioException(e)));
    }
  }

  Future<Result<BookingSummary, CheckoutFailure>> getConfirmation(int bookingId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/bookings/confirmation/$bookingId');
      return Ok(BookingSummary.fromDto(BookingDetailDto.fromJson(response.data!)));
    } on DioException catch (e) {
      return Err(CheckoutFailure.fromApi(ApiFailure.fromDioException(e)));
    }
  }

  static Map<String, int> _foodJson(Map<int, int> food) => {
        for (final e in food.entries)
          if (e.value > 0) '${e.key}': e.value,
      };

  /// Prices exactly the seats of [hold]. Read-only on the server.
  Future<Result<Quote, CheckoutFailure>> quote(
    Hold hold, {
    String? promoCode,
    Map<int, int> food = const {},
  }) async {
    final selected = _foodJson(food);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/bookings/quote/${hold.showtimeId}',
        data: QuoteRequestDto(
          seatIds: hold.seatIds.toList()..sort(),
          promoCode: (promoCode == null || promoCode.trim().isEmpty) ? null : promoCode.trim(),
          foodItems: selected.isEmpty ? null : selected,
        ).toJson(),
      );
      return Ok(Quote.fromDto(QuoteResponseDto.fromJson(response.data!), baseUrl: _dio.options.baseUrl));
    } on DioException catch (e) {
      return Err(CheckoutFailure.fromApi(ApiFailure.fromDioException(e)));
    }
  }
}
