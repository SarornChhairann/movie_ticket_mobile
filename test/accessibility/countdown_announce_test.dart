import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/theme/app_theme.dart';
import 'package:movie_ticket_mobile/core/widgets/countdown_pill.dart';

/// Sprint 19: a screen reader hears the hold countdown at 60 s and 10 s only.
void main() {
  testWidgets('counting down from 62 s to 9 s speaks exactly twice', (tester) async {
    final spoken = <String>[];
    tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<dynamic>(
      SystemChannels.accessibility,
      (message) async {
        final data = (message as Map)['data'] as Map?;
        if (message['type'] == 'announce') spoken.add(data!['message'] as String);
        return null;
      },
    );
    addTearDown(() =>
        tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<dynamic>(SystemChannels.accessibility, null));

    for (var s = 62; s >= 9; s--) {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: CountdownPill(secondsLeft: s, announce: (left) => '$left seconds left')),
      ));
    }

    expect(spoken, ['60 seconds left', '10 seconds left']);
  });
}
