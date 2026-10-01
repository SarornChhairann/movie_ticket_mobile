import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/session/session_id_provider.dart';

void main() {
  test('generates a UUID v4 that stays stable for the provider lifetime', () {
    final provider = SessionIdProvider();

    expect(
      provider.sessionId,
      matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')),
    );
    expect(provider.sessionId, provider.sessionId);
    expect(SessionIdProvider().sessionId, isNot(provider.sessionId));
  });
}
