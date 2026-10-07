import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_realtime.dart';

/// The polling fallback must stop for good when the seat map stops listening:
/// tearing the socket down fires its "done"/"disconnect" callbacks, which used
/// to start a new poller that nobody cancelled (one leaked per seat map visit).
void main() {
  // Real sockets: flutter_test otherwise fakes every HTTP connection.
  setUpAll(() => HttpOverrides.global = null);

  Future<String> deadPort() async {
    // A port with nothing listening: the socket fails, so the fallback polls.
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final port = server.port;
    await server.close();
    return 'http://127.0.0.1:$port';
  }

  test('polls while the socket is down, and never again after cancel', () async {
    final realtime = SeatRealtime(baseUrl: await deadPort(), pollInterval: const Duration(milliseconds: 50));
    var polls = 0;
    final sub = realtime.watch(1, () async {
      polls++;
      return <int>{};
    }).listen((_) {});

    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(polls, greaterThan(0), reason: 'the fallback runs while there is no socket');

    await sub.cancel();
    // Let the client's teardown callbacks fire.
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final afterCancel = polls;
    await Future<void>.delayed(const Duration(milliseconds: 500));

    expect(polls, afterCancel, reason: 'no poller survives the seat map');
  });

  test('leaving while the socket is still connecting never starts polling (the leak)', () async {
    // Accepts the TCP connection but never answers the WebSocket handshake, like a
    // slow network: the seat map is left while connect() is still pending.
    final held = <Socket>[];
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    server.listen(held.add);
    addTearDown(server.close);
    final realtime = SeatRealtime(
      baseUrl: 'http://127.0.0.1:${server.port}',
      pollInterval: const Duration(milliseconds: 50),
    );
    var polls = 0;
    final sub = realtime.watch(1, () async {
      polls++;
      return <int>{};
    }).listen((_) {});
    await Future<void>.delayed(const Duration(milliseconds: 100));

    await sub.cancel();
    // Now the pending connect fails, after the seat map has gone.
    for (final s in held) {
      s.destroy();
    }
    await Future<void>.delayed(const Duration(milliseconds: 600));

    expect(polls, 0, reason: 'a poller started after cancel would run forever');
  });
}
