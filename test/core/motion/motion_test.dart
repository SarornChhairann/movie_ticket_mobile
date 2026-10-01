import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/motion/crossfade_text.dart';
import 'package:movie_ticket_mobile/core/motion/motion.dart';
import 'package:movie_ticket_mobile/core/motion/poster_hero.dart';
import 'package:movie_ticket_mobile/core/motion/transitions.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';

void main() {
  group('Motion.of', () {
    Future<Duration> resolve(WidgetTester tester, {required bool reduce}) async {
      late Duration resolved;
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: Builder(builder: (context) {
          resolved = context.motion(Motion.long);
          return const SizedBox();
        }),
      ));
      return resolved;
    }

    testWidgets('returns the token normally and zero under reduced motion', (tester) async {
      expect(await resolve(tester, reduce: false), Motion.long);
      expect(await resolve(tester, reduce: true), Duration.zero);
    });
  });

  test('the same movie on two surfaces gets two hero tags', () {
    final tags = {for (final s in HeroSource.values) HeroTags.poster(7, s)};
    expect(tags, hasLength(HeroSource.values.length));
    expect(HeroTags.poster(7, HeroSource.carousel), isNot(HeroTags.poster(8, HeroSource.carousel)));
  });

  test('every route follows the journey table (sprint 8, 1.2)', () {
    const expected = {
      AppRoutes.splash: RouteMotion.fade,
      AppRoutes.shell: RouteMotion.fade,
      AppRoutes.blocked: RouteMotion.fade,
      AppRoutes.login: RouteMotion.sheet,
      AppRoutes.movieDetail: RouteMotion.container,
      AppRoutes.seatMap: RouteMotion.sharedAxisX,
      AppRoutes.checkout: RouteMotion.sharedAxisX,
      AppRoutes.paySuccess: RouteMotion.fadeThrough,
      AppRoutes.myBookings: RouteMotion.sharedAxisX,
      AppRoutes.bookingDetail: RouteMotion.sharedAxisX,
      AppRoutes.ticketQr: RouteMotion.sharedAxisY,
      AppRoutes.profile: RouteMotion.sharedAxisX,
      AppRoutes.register: RouteMotion.sharedAxisX,
    };
    for (final MapEntry(key: route, value: motion) in expected.entries) {
      expect(AppRouter.motionFor(route), motion, reason: route);
    }
  });

  testWidgets('money crossfades between the two server amounts only — no count-up', (tester) async {
    Widget total(String text) => Directionality(
          textDirection: TextDirection.ltr,
          child: CrossfadeText(text, textKey: const Key('total')),
        );
    await tester.pumpWidget(total(r'$12.50'));
    await tester.pumpWidget(total(r'$16.50'));

    for (var i = 0; i < 10; i++) {
      await tester.pump(Motion.medium ~/ 10);
      final shown = tester.widgetList<Text>(find.byKey(const Key('total'))).map((t) => t.data).toSet();
      expect(shown.difference({r'$12.50', r'$16.50'}), isEmpty, reason: 'frame $i showed $shown');
    }
    await tester.pumpAndSettle();
    expect(tester.widgetList<Text>(find.byKey(const Key('total'))).map((t) => t.data), [r'$16.50']);
  });
}
