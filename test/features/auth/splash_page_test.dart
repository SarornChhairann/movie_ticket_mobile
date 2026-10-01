import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/l10n/app_locales.dart';
import 'package:movie_ticket_mobile/core/widgets/ticket_emblem.dart';
import 'package:movie_ticket_mobile/features/auth/view/splash_page.dart';

import '../../helpers/localized_app.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  TicketEmblem emblem(WidgetTester tester) => tester.widget<TicketEmblem>(find.byKey(const Key('splash.emblem')));

  testWidgets('a fast start shows the brand and never flashes a progress bar', (tester) async {
    await pumpLocalized(tester, const SplashPage());

    expect(find.text('Movie Tickets'), findsWidgets);
    expect(find.text('Your seat is waiting.'), findsOneWidget);
    expect(find.byKey(const Key('splash.progress')), findsNothing);

    await tester.pump(SplashPage.progressDelay - const Duration(milliseconds: 100));
    expect(find.byKey(const Key('splash.progress')), findsNothing);
  });

  testWidgets('the ticket draws, then fills, over the intro', (tester) async {
    await pumpLocalized(tester, const SplashPage());
    final start = emblem(tester);
    expect(start.fill, lessThan(1));

    await tester.pump(SplashPage.introDuration);
    final end = emblem(tester);
    expect(end.draw, 1);
    expect(end.fill, 1);
  });

  testWidgets('a slow session restore shows the progress hint after the delay', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpLocalized(tester, const SplashPage());

    await tester.pump(SplashPage.progressDelay);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('splash.progress')), findsOneWidget);
    expect(find.bySemanticsLabel('Getting things ready…'), findsOneWidget);
    // The name is announced once, as a header, not merged with the rest of the screen.
    expect(find.bySemanticsLabel('Movie Tickets'), findsOneWidget);
    expect(tester.getSemantics(find.byKey(const Key('splash.title'))).flagsCollection.isHeader, isTrue);
    semantics.dispose();
  });

  testWidgets('reduced motion shows the finished frame at once', (tester) async {
    await pumpLocalized(
      tester,
      const MediaQuery(data: MediaQueryData(disableAnimations: true), child: SplashPage()),
    );

    final e = emblem(tester);
    expect(e.draw, 1);
    expect(e.fill, 1);
  });

  testWidgets('Khmer tagline', (tester) async {
    await pumpLocalized(tester, const SplashPage(), locale: AppLocales.km);

    expect(find.text('កៅអីរបស់អ្នកកំពុងរង់ចាំ។'), findsOneWidget);
  });
}
