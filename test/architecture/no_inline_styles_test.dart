import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Sprint 15 lint guard: feature views take timing, colour, type, and haptics
/// from the design system (`core/motion`, `core/theme`, `core/haptics`), never
/// inline. A failure names the file, line, and pattern.
void main() {
  const forbidden = {
    'Duration(milliseconds': 'use a Motion token or a Debounce constant',
    'Color(0x': 'use AppColors / context.tokens',
    'fontSize:': 'use AppText / the theme textTheme',
    'HapticFeedback.': 'use AppHaptics',
  };

  test('no inline durations, colours, font sizes, or haptics in feature views', () {
    final views = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && f.path.contains('${Platform.pathSeparator}view${Platform.pathSeparator}'));
    final hits = <String>[];
    for (final file in views) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        for (final entry in forbidden.entries) {
          if (lines[i].contains(entry.key)) hits.add('${file.path}:${i + 1}: "${entry.key}" — ${entry.value}');
        }
      }
    }
    expect(views, isNotEmpty);
    expect(hits, isEmpty, reason: hits.join('\n'));
  });

  test('HapticFeedback is called only from AppHaptics', () {
    final offenders = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('app_haptics.dart'))
        .where((f) => f.readAsStringSync().contains('HapticFeedback.'))
        .map((f) => f.path)
        .toList();
    expect(offenders, isEmpty);
  });
}
