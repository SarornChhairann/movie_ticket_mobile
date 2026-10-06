import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_failure.dart';

part 'tickets_failure.freezed.dart';

@freezed
sealed class TicketsFailure with _$TicketsFailure {
  const TicketsFailure._();

  const factory TicketsFailure.notOwner(String message) = TicketsNotOwner;
  const factory TicketsFailure.alreadyCancelled(String message) = TicketsAlreadyCancelled;

  /// Inside the cancellation window; the booking is unchanged.
  const factory TicketsFailure.cancelWindow(String message) = TicketsCancelWindow;

  /// Not this client's booking, or no such booking (`BOOKING_NOT_FOUND`).
  const factory TicketsFailure.notFound(String message) = TicketsNotFound;

  /// Too many lookups that found nothing (`TOO_MANY_ATTEMPTS`); try again later.
  const factory TicketsFailure.tooManyAttempts(String message) = TicketsTooManyAttempts;
  const factory TicketsFailure.network() = TicketsNetwork;
  const factory TicketsFailure.unknown(String message) = TicketsUnknown;

  /// Branches on `code`, never on message text.
  static TicketsFailure fromApi(ApiFailure failure) => switch (failure) {
        ApiFailureServer(code: 'NOT_OWNER', :final message) => TicketsFailure.notOwner(message),
        ApiFailureServer(code: 'ALREADY_CANCELLED', :final message) => TicketsFailure.alreadyCancelled(message),
        ApiFailureServer(code: 'CANCEL_WINDOW', :final message) => TicketsFailure.cancelWindow(message),
        ApiFailureServer(code: 'BOOKING_NOT_FOUND', :final message) => TicketsFailure.notFound(message),
        ApiFailureServer(code: 'TOO_MANY_ATTEMPTS', :final message) => TicketsFailure.tooManyAttempts(message),
        ApiFailureServer(:final message) => TicketsFailure.unknown(message),
        ApiFailureNetwork() => const TicketsFailure.network(),
        ApiFailureUnknown(:final message) => TicketsFailure.unknown(message ?? ''),
      };

  /// The server's message; empty for [TicketsNetwork] (the view shows its own copy).
  String get message => switch (this) {
        TicketsNotOwner(:final message) ||
        TicketsAlreadyCancelled(:final message) ||
        TicketsCancelWindow(:final message) ||
        TicketsNotFound(:final message) ||
        TicketsTooManyAttempts(:final message) ||
        TicketsUnknown(:final message) =>
          message,
        TicketsNetwork() => '',
      };
}
