import 'dart:math';

/// One UUID v4 per app run, shared by guests and signed-in users.
///
/// Sent as `X-Session-Id` so the API can tie seat holds, release, and confirm
/// to the same client without a servlet session.
class SessionIdProvider {
  SessionIdProvider({Random? random})
      : sessionId = _uuidV4(random ?? Random.secure());

  final String sessionId;

  static String _uuidV4(Random random) {
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // RFC 4122 variant
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
