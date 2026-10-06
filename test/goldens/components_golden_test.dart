import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/theme/app_colors.dart';
import 'package:movie_ticket_mobile/core/theme/spacing.dart';
import 'package:movie_ticket_mobile/core/widgets/app_button.dart';
import 'package:movie_ticket_mobile/core/widgets/app_chip.dart';
import 'package:movie_ticket_mobile/core/widgets/app_list_tile.dart';
import 'package:movie_ticket_mobile/core/widgets/countdown_pill.dart';
import 'package:movie_ticket_mobile/core/widgets/empty_state.dart';
import 'package:movie_ticket_mobile/core/widgets/error_state.dart';
import 'package:movie_ticket_mobile/core/widgets/inline_banner.dart';
import 'package:movie_ticket_mobile/core/widgets/status_chip.dart';

import '../helpers/localized_app.dart';
import '../helpers/screens.dart';

/// Sprint 15: every component, every state, in one golden per component (en),
/// plus Khmer for the text-heavy ones. Regenerate on purpose with
/// `flutter test --update-goldens test/goldens` and review the PNG diff.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    await loadGoldenFonts();
  });

  Future<void> golden(WidgetTester tester, String name, Widget child, {Locale locale = const Locale('en')}) async {
    tester.view.physicalSize = const Size(1170, 1200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(Space.x2),
              child: RepaintBoundary(
                key: const Key('golden'),
                // The capture has no backdrop of its own: paint the app surface.
                child: Material(color: AppColors.navy, child: child),
              ),
            ),
          ),
        ),
      ),
      locale: locale,
    );
    await tester.pump();
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('goldens/$name.png'));
  }

  void noop() {}

  testWidgets('AppButton: variants, disabled, loading', (tester) async {
    await golden(
      tester,
      'app_button',
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AppButton.primary(label: 'Continue', onPressed: noop),
        const SizedBox(height: Space.x1),
        const AppButton.primary(label: 'Disabled', onPressed: null),
        const SizedBox(height: Space.x1),
        AppButton.primary(label: 'Loading', onPressed: noop, loading: true),
        const SizedBox(height: Space.x1),
        Wrap(spacing: Space.x1, children: [
          AppButton.tonal(label: 'Tonal', onPressed: noop),
          AppButton.ghost(label: 'Ghost', onPressed: noop),
          AppButton.destructive(label: 'Release', onPressed: noop),
        ]),
      ]),
    );
  });

  testWidgets('AppChip: selected, unselected, disabled', (tester) async {
    await golden(
      tester,
      'app_chip',
      Wrap(spacing: Space.x1, children: [
        AppChip(label: 'Selected', selected: true, onSelected: noop),
        AppChip(label: 'Unselected', selected: false, onSelected: noop),
        const AppChip(label: 'Disabled', selected: false, onSelected: null),
      ]),
    );
  });

  testWidgets('StatusChip: every tone', (tester) async {
    await golden(
      tester,
      'status_chip',
      Wrap(spacing: Space.x1, runSpacing: Space.x1, children: [
        for (final tone in StatusTone.values) StatusChip(label: tone.name, tone: tone),
      ]),
    );
  });

  testWidgets('InlineBanner: error with action, warning dismissible, success', (tester) async {
    await golden(
      tester,
      'inline_banner',
      Column(children: [
        InlineBanner(message: 'You are offline.', actionLabel: 'Retry', onAction: noop),
        const SizedBox(height: Space.x1),
        InlineBanner(message: 'F7 was just taken.', tone: StatusTone.warning, onDismiss: noop),
        const SizedBox(height: Space.x1),
        const InlineBanner(message: 'Hold extended.', tone: StatusTone.success),
      ]),
    );
  });

  testWidgets('CountdownPill: calm and warning', (tester) async {
    await golden(
      tester,
      'countdown_pill',
      const Row(children: [CountdownPill(secondsLeft: 542), SizedBox(width: Space.x2), CountdownPill(secondsLeft: 45)]),
    );
  });

  testWidgets('AppListTile: tappable and static', (tester) async {
    await golden(
      tester,
      'app_list_tile',
      Column(children: [
        AppListTile(leading: const Icon(Icons.qr_code_2), title: const Text('D1'), subtitle: const Text('Ticket'), onTap: noop),
        const AppListTile(leading: Icon(Icons.info_outline), title: Text('Static')),
      ]),
    );
  });

  for (final locale in const [Locale('en'), Locale('km')]) {
    testWidgets('EmptyState and ErrorState (${locale.languageCode})', (tester) async {
      await golden(
        tester,
        'states_${locale.languageCode}',
        SizedBox(
          height: 600,
          child: Column(children: [
            Expanded(child: EmptyState(messageKey: 'tickets.guestEmpty', icon: Icons.local_activity_outlined, actionLabel: 'Browse', onAction: noop)),
            Expanded(child: ErrorState(message: 'Server message', onRetry: noop)),
          ]),
        ),
        locale: locale,
      );
    });
  }
}
