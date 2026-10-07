import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_ticket_mobile/core/widgets/booking_progress.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/booking_flow_cubit.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/view/checkout_page.dart';
import '../features/checkout/checkout_fixtures.dart';
import '../helpers/localized_app.dart';
import '../helpers/screens.dart';

/// Sprint 15: the main screens over seeded blocs, at a phone size, English.
/// Regenerate on purpose with `flutter test --update-goldens test/goldens`.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    await loadGoldenFonts();
  });

  for (final entry in mainScreens().entries) {
    testWidgets('${entry.key} screen', (tester) async {
      await pumpScreen(tester, entry.value());
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/screen_${entry.key}.png'));
    });
  }

  // Sprint 22: the personal Home and the search results, in Khmer too.
  for (final name in const ['homePersonal', 'search']) {
    testWidgets('$name screen (km)', (tester) async {
      await pumpScreen(tester, mainScreens()[name]!(), locale: const Locale('km'));
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/screen_${name}_km.png'));
    });
  }

  // Sprint 16: each step of the booking flow, with progress and capsule.
  for (final step in const [FlowStep.snacks, FlowStep.pay]) {
    testWidgets('checkout flow step ${step.name}', (tester) async {
      final flow = BookingFlowCubit()
        ..seatsChanged(
          showtimeId: 50,
          title: 'Dune',
          hallName: 'Hall 1',
          showDate: '2026-10-07',
          showTime: '14:00:00',
          seatCodes: const ['D1', 'D2'],
          holdExpiresAt: DateTime.now().add(const Duration(minutes: 9)),
        )
        ..enteredCheckout(hasMenu: true);
      if (step == FlowStep.pay) flow.snacksDone(skipped: true);
      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<CheckoutBloc>.value(
              value: seeded<MockCheckout, CheckoutState>(
                MockCheckout(),
                CheckoutReady(hold: testHold, quote: testQuote(), secondsLeft: 540),
              ),
            ),
            BlocProvider<BookingFlowCubit>.value(value: flow),
          ],
          child: const CheckoutPage(),
        ),
      );
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/flow_${step.name}.png'));
    });
  }
}
