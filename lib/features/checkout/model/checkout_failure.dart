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
        ApiFailureServer(:final message) => CheckoutFailure.unknown(message),
        ApiFailureNetwork() => const CheckoutFailure.network(),
        ApiFailureUnknown(:final message) => CheckoutFailure.unknown(message ?? ''),
      };
}
