import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/model/booking_summary.dart';
import 'dto/payway_dtos.dart';

part 'payway.freezed.dart';

/// A started ABA KHQR payment. [amount] is the server total, display only.
@freezed
abstract class PaywaySession with _$PaywaySession {
  const factory PaywaySession({
    required int bookingId,

    /// The booking reference; empty from a server older than sprint 13.
    @Default('') String reference,
    required String tranId,
    required num amount,
    required String checkoutUrl,

    /// `abapay_deeplink`; empty when PayWay sent none.
    @Default('') String abaDeeplink,
  }) = _PaywaySession;

  factory PaywaySession.fromDto(PaywayStartResponseDto dto) => PaywaySession(
        bookingId: dto.bookingId,
        reference: dto.reference ?? '',
        tranId: dto.tranId,
        amount: dto.amount,
        checkoutUrl: dto.checkoutUrl,
        abaDeeplink: dto.abaDeeplink ?? '',
      );
}

/// What the web view needs: the session, whether ABA Mobile is installed, and
/// when the seat hold ends.
@freezed
abstract class PaywayLaunch with _$PaywayLaunch {
  const factory PaywayLaunch({
    required PaywaySession session,
    required bool canOpenAba,
    required DateTime holdExpiresAt,

    /// The guest's phone; null when signed in. Kept with the pending payment so a
    /// paid guest booking can be found again by reference + phone.
    String? guestPhone,
  }) = _PaywayLaunch;
}

/// The server's view of a payment (one poll).
@freezed
sealed class PaywayStatus with _$PaywayStatus {
  const factory PaywayStatus.pending() = PaywayPending;
  const factory PaywayStatus.approved(BookingSummary confirmation) = PaywayApproved;
  const factory PaywayStatus.declined() = PaywayDeclined;
  const factory PaywayStatus.cancelled() = PaywayCancelled;

  static PaywayStatus fromDto(PaywayStatusDto dto) => switch (dto.status) {
        'APPROVED' when dto.confirmation != null => PaywayStatus.approved(BookingSummary.fromDto(dto.confirmation!)),
        'DECLINED' => const PaywayStatus.declined(),
        'CANCELLED' => const PaywayStatus.cancelled(),
        _ => const PaywayStatus.pending(),
      };
}

/// How the web view ended; returned to checkout when it pops.
@freezed
sealed class PaywayOutcome with _$PaywayOutcome {
  const factory PaywayOutcome.approved(BookingSummary confirmation) = PaywayOutcomeApproved;
  const factory PaywayOutcome.declined() = PaywayOutcomeDeclined;
  const factory PaywayOutcome.cancelled() = PaywayOutcomeCancelled;

  /// The customer closed the page; the transaction was closed.
  const factory PaywayOutcome.dismissed() = PaywayOutcomeDismissed;

  /// The hold ran out first; the transaction was closed.
  const factory PaywayOutcome.holdExpired() = PaywayOutcomeHoldExpired;
}

/// What the web view does with a navigation.
enum PaywayNavigation {
  /// Load it in the web view.
  allow,

  /// Hand it to ABA Mobile (`abapay_deeplink`).
  openApp,

  /// PayWay sent the customer back to CineKH (`return_deeplink`): stay and poll.
  returned,

  /// Cancel it; the KHQR page stays.
  block,
}

/// The app's own return scheme (`return_deeplink`).
const paywayReturnScheme = 'cinekh';

/// Decides a web view navigation. With ABA Mobile installed ([canOpenAba]) the
/// deeplink leaves for the app; without it, nothing leaves `https` on the PayWay host.
/// Sub-frame loads (the page's own widgets) are always allowed.
PaywayNavigation decidePaywayNavigation(
  String url, {
  required PaywaySession session,
  required bool canOpenAba,
  bool isMainFrame = true,
}) {
  if (!isMainFrame) return PaywayNavigation.allow;
  final uri = Uri.tryParse(url);
  if (uri == null) return PaywayNavigation.block;
  final scheme = uri.scheme.toLowerCase();

  final isAbaLink = (session.abaDeeplink.isNotEmpty && url == session.abaDeeplink) || scheme.startsWith('abamobile');
  if (isAbaLink) return canOpenAba ? PaywayNavigation.openApp : PaywayNavigation.block;
  if (scheme == paywayReturnScheme) return PaywayNavigation.returned;
  if (scheme == 'https' && _isPaywayHost(uri.host, session.checkoutUrl)) return PaywayNavigation.allow;
  if (scheme == 'about') return PaywayNavigation.allow;
  return PaywayNavigation.block;
}

bool _isPaywayHost(String host, String checkoutUrl) {
  final h = host.toLowerCase();
  final checkoutHost = Uri.tryParse(checkoutUrl)?.host.toLowerCase() ?? '';
  return h == checkoutHost || h == 'payway.com.kh' || h.endsWith('.payway.com.kh');
}
