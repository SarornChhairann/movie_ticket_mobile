import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/motion/motion.dart';
import 'package:movie_ticket_mobile/core/motion/transitions.dart';
import 'package:movie_ticket_mobile/core/theme/app_theme.dart';

/// Sprint 15: routes are `MaterialPageRoute`s drawn by the theme's
/// [AppPageTransitions], which is what lets Android 14+ show predictive back.
void main() {
  test('every platform uses the app transitions builder', () {
    final builders = AppTheme.dark.pageTransitionsTheme.builders;
    for (final platform in TargetPlatform.values) {
      expect(builders[platform], isA<AppPageTransitions>(), reason: platform.name);
    }
  });

  test('routes are MaterialPageRoutes with the sprint-8 timing per motion', () {
    final settings = const RouteSettings(name: '/x');
    Widget page(BuildContext _) => const SizedBox();

    final axis = buildMotionRoute<void>(settings, RouteMotion.sharedAxisX, page) as MotionPageRoute<void>;
    expect(axis, isA<MaterialPageRoute<void>>());
    expect(axis.transitionDuration, Motion.long);
    expect(axis.reverseTransitionDuration, Motion.exitOf(Motion.long));

    final container = buildMotionRoute<void>(settings, RouteMotion.container, page);
    expect((container as PageRoute).transitionDuration, Motion.extraLong);

    final sheet = buildMotionRoute<void>(settings, RouteMotion.sheet, page) as MotionPageRoute<void>;
    expect(sheet.fullscreenDialog, isTrue);
  });
}
