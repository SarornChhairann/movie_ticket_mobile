import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// An ABA payment whose web view was open. Written before the web view loads and
/// removed once the payment settles, so a run killed during the ABA hand-off can
/// pick it up again on the next start.
class PendingPayment {
  const PendingPayment({
    required this.tranId,
    required this.bookingId,
    required this.reference,
    required this.sessionId,
    required this.startedAt,
    required this.holdExpiresAt,
    this.guestPhone,
  });

  final String tranId;
  final int bookingId;
  final String reference;

  /// The `X-Session-Id` that started the payment; the next run reuses it.
  final String sessionId;
  final DateTime startedAt;
  final DateTime holdExpiresAt;

  /// The guest's phone, so a paid guest booking can be saved for lookup; null when signed in.
  final String? guestPhone;

  Map<String, dynamic> toJson() => {
        'tranId': tranId,
        'bookingId': bookingId,
        'reference': reference,
        'sessionId': sessionId,
        'startedAt': startedAt.toIso8601String(),
        'holdExpiresAt': holdExpiresAt.toIso8601String(),
        'guestPhone': guestPhone,
      };

  static PendingPayment? tryFromJson(Map<String, dynamic> json) {
    final startedAt = DateTime.tryParse(json['startedAt'] as String? ?? '');
    final holdExpiresAt = DateTime.tryParse(json['holdExpiresAt'] as String? ?? '');
    final tranId = json['tranId'];
    final bookingId = json['bookingId'];
    final sessionId = json['sessionId'];
    if (startedAt == null || holdExpiresAt == null || tranId is! String || bookingId is! int || sessionId is! String) {
      return null;
    }
    return PendingPayment(
      tranId: tranId,
      bookingId: bookingId,
      reference: json['reference'] as String? ?? '',
      sessionId: sessionId,
      startedAt: startedAt,
      holdExpiresAt: holdExpiresAt,
      guestPhone: json['guestPhone'] as String?,
    );
  }
}

/// The one [PendingPayment] slot in secure storage.
class PendingPaymentStore {
  PendingPaymentStore(this._storage);

  static const _key = 'payway.pending';

  /// Older records are dropped on start: by then the hold is long gone and the
  /// server has settled the payment either way.
  static const maxAge = Duration(minutes: 30);

  final FlutterSecureStorage _storage;

  Future<void> write(PendingPayment payment) => _storage.write(key: _key, value: jsonEncode(payment.toJson()));

  Future<void> clear() => _storage.delete(key: _key);

  Future<PendingPayment?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    try {
      return PendingPayment.tryFromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    }
  }

  /// The record to resume at start-up, or null. A stale or unreadable record is cleared.
  Future<PendingPayment?> readResumable(DateTime now) async {
    final payment = await read();
    if (payment != null && now.difference(payment.startedAt) < maxAge) return payment;
    await clear();
    return null;
  }
}
