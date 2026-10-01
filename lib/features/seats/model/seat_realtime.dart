import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'dto/seat_dtos.dart';
import 'seat_map.dart';

/// Live seat changes for one showtime: STOMP on `/topic/showtimes/{id}/seats`,
/// falling back to polling [pollState] every [pollInterval] while the socket is
/// down.
class SeatRealtime {
  SeatRealtime({required String baseUrl, this.pollInterval = const Duration(seconds: 5)})
      : _wsUrl = webSocketUrl(baseUrl);

  final String _wsUrl;
  final Duration pollInterval;

  /// `http://host:8010` → `ws://host:8010/ws/websocket` (SockJS raw transport).
  static String webSocketUrl(String baseUrl) {
    final uri = Uri.parse(baseUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final path = uri.path.endsWith('/') ? uri.path.substring(0, uri.path.length - 1) : uri.path;
    return uri.replace(scheme: scheme, path: '$path/ws/websocket').toString();
  }

  Stream<SeatEvent> watch(int showtimeId, Future<Set<int>?> Function() pollState) {
    late final StreamController<SeatEvent> controller;
    StompClient? client;
    Timer? poller;

    void startPolling() {
      poller ??= Timer.periodic(pollInterval, (_) async {
        final heldByOthers = await pollState();
        if (heldByOthers != null && !controller.isClosed) {
          controller.add(SeatEvent.snapshot(heldByOthers: heldByOthers));
        }
      });
    }

    void stopPolling() {
      poller?.cancel();
      poller = null;
    }

    controller = StreamController<SeatEvent>(
      onListen: () {
        client = StompClient(
          config: StompConfig(
            url: _wsUrl,
            onConnect: (_) {
              stopPolling();
              client?.subscribe(
                destination: '/topic/showtimes/$showtimeId/seats',
                callback: (frame) {
                  final body = frame.body;
                  if (body == null || controller.isClosed) {
                    return;
                  }
                  final event = SeatEvent.fromDto(
                    SeatEventDto.fromJson(jsonDecode(body) as Map<String, dynamic>),
                  );
                  if (event != null) {
                    controller.add(event);
                  }
                },
              );
            },
            onWebSocketError: (_) => startPolling(),
            onWebSocketDone: startPolling,
            onStompError: (_) => startPolling(),
            onDisconnect: (_) => startPolling(),
          ),
        )..activate();
      },
      onCancel: () {
        stopPolling();
        client?.deactivate();
      },
    );
    return controller.stream;
  }
}
