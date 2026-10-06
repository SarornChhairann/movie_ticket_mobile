import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/localized_app.dart';
import '../helpers/screens.dart';

/// Sprint 19: every main screen at 200% text, English and Khmer, lays out with
/// no overflow (a RenderFlex overflow fails the test) — and is recorded as a
/// golden. Seats are in list mode, the large-text path.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    await loadGoldenFonts();
  });

  for (final locale in const [Locale('en'), Locale('km')]) {
    for (final screen in mainScreens().entries) {
      testWidgets('${screen.key} at 200% (${locale.languageCode})', (tester) async {
        await pumpScreen(tester, screen.value(), locale: locale, textScale: 2, screenReader: screen.key == 'seats');
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/text200_${screen.key}_${locale.languageCode}.png'),
        );
      });
    }
  }
}
