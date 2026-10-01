import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Flattens nested JSON into dotted keys (`tickets.status.cancelled`).
Set<String> _keys(Map<String, dynamic> json, [String prefix = '']) => {
      for (final e in json.entries)
        if (e.value is Map<String, dynamic>)
          ..._keys(e.value as Map<String, dynamic>, '$prefix${e.key}.')
        else
          '$prefix${e.key}',
    };

Set<String> _load(String lang) =>
    _keys(jsonDecode(File('assets/translations/$lang.json').readAsStringSync()) as Map<String, dynamic>);

void main() {
  final en = _load('en');
  final km = _load('km');

  test('en and km have exactly the same keys', () {
    expect(en.difference(km), isEmpty, reason: 'missing in km.json');
    expect(km.difference(en), isEmpty, reason: 'missing in en.json');
  });

  test('no translation is blank', () {
    for (final lang in ['en', 'km']) {
      final json = File('assets/translations/$lang.json').readAsStringSync();
      expect(json.contains('""'), isFalse, reason: '$lang.json has an empty value');
    }
  });

  test("every literal 'key'.tr( used in lib/ exists", () {
    final literalTr = RegExp(r"""'([A-Za-z0-9_]+(?:\.[A-Za-z0-9_]+)+)'\s*\.tr\(""");
    final used = <String>{};
    for (final file in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart') || file.path.endsWith('.g.dart') || file.path.endsWith('.freezed.dart')) {
        continue;
      }
      used.addAll(literalTr.allMatches(file.readAsStringSync()).map((m) => m.group(1)!));
    }
    expect(used, isNotEmpty);
    expect(used.difference(en), isEmpty, reason: 'keys used in code but missing from the translations');
  });

  test('sprint 7 keys exist', () {
    expect(en, containsAll(<String>[
      'loyalty.points',
      'loyalty.lastBooking',
      'reminders.email',
      'reminders.submit',
      'reminders.success',
      'reminders.exists',
    ]));
  });
}
