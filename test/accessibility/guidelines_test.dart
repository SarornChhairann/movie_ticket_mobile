import 'package:flutter_test/flutter_test.dart';

import '../helpers/localized_app.dart';
import '../helpers/screens.dart';

/// Sprint 19: Flutter's accessibility guidelines on every main screen — 48 dp
/// (Android) and 44 dp (iOS) tap targets, labelled tap targets, and WCAG text
/// contrast. Seats are checked in list mode, the screen-reader path (seat
/// tiles on the map are smaller than 48 dp by design).
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  const guidelines = {
    'android tap targets': androidTapTargetGuideline,
    'iOS tap targets': iOSTapTargetGuideline,
    'labelled tap targets': labeledTapTargetGuideline,
    'text contrast': textContrastGuideline,
  };

  for (final screen in mainScreens().entries) {
    for (final g in guidelines.entries) {
      testWidgets('${screen.key}: ${g.key}', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreen(tester, screen.value(), screenReader: screen.key == 'seats');
        await expectLater(tester, meetsGuideline(g.value));
        handle.dispose();
      });
    }
  }
}
