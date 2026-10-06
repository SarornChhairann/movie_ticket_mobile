import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';

part 'checkout_failure.freezed.dart';

@freezed
sealed class CheckoutFailure with _$CheckoutFailure {
  const factory CheckoutFailure.holdExpired() = CheckoutHoldExpired;
  const factory CheckoutFailure.seatConflict(String message) = CheckoutSeatConflict;
  const factory CheckoutFailure.promoInvalid(String message) = CheckoutPromoInvalid;
  const factory CheckoutFailure.pairInvalid() = CheckoutPairInvalid;
  const factory CheckoutFailure.paymentFailed(String message) = CheckoutPaymentFailed;
  const factory CheckoutFailure.blocked(String message) = CheckoutBlocked;

  /// More seats than `max_seats_per_booking` (`SEAT_LIMIT`).
  const factory CheckoutFailure.seatLimit(String message) = CheckoutSeatLimit;

  /// Not this client's booking, or no such booking (`BOOKING_NOT_FOUND`).
  const factory CheckoutFailure.bookingNotFound(String message) = CheckoutBookingNotFound;
  const factory CheckoutFailure.network() = CheckoutNetwork;
  const factory CheckoutFailure.unknown(String message) = CheckoutUnknown;

  /// Branches on `code`, never on message text.
  static CheckoutFailure fromApi(ApiFailure failure) => switch (failure) {
        ApiFailureServer(code: 'HOLD_EXPIRED') => const CheckoutFailure.holdExpired(),
        ApiFailureServer(code: 'SEAT_HELD' || 'SEAT_BOOKED', :final message) =>
          CheckoutFailure.seatConflict(message),
        ApiFailureServer(code: 'PROMO_INVALID', :final message) => CheckoutFailure.promoInvalid(message),
        ApiFailureServer(code: 'COUPLE_PAIR_INVALID') => const CheckoutFailure.pairInvalid(),
        ApiFailureServer(code: 'PAYMENT_FAILED', :final message) => CheckoutFailure.paymentFailed(message),
        ApiFailureServer(code: 'ACCOUNT_BLOCKED', :final message) => CheckoutFailure.blocked(message),
        ApiFailureServer(code: 'SEAT_LIMIT', :final message) => CheckoutFailure.seatLimit(message),
        ApiFailureServer(code: 'BOOKING_NOT_FOUND', :final message) => CheckoutFailure.bookingNotFound(message),
        ApiFailureServer(:final message) => CheckoutFailure.unknown(message),
        ApiFailureNetwork() => const CheckoutFailure.network(),
        ApiFailureUnknown(:final message) => CheckoutFailure.unknown(message ?? ''),
      };
}
