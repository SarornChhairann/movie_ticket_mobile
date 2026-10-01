import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/motion/motion.dart';
import 'package:movie_ticket_mobile/core/motion/poster_hero.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/coming_soon_carousel.dart';

import '../../helpers/localized_app.dart';

class _RouteRecorder extends NavigatorObserver {
  final pushed = <RouteSettings>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => pushed.add(route.settings);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  final today = DateTime(2026, 10, 2);
  final movies = [
    Movie(id: 2, title: 'Avatar 3', comingSoon: true, genre: 'Science fiction', releaseDate: DateTime(2026, 10, 14)),
    Movie(id: 5, title: 'Dune: Messiah', comingSoon: true, releaseDate: DateTime(2026, 10, 3)),
    Movie(id: 9, title: 'Heat 2', comingSoon: true, releaseDate: DateTime(2027, 3, 1)),
  ];
  late _RouteRecorder recorder;

  Future<void> pump(
    WidgetTester tester, {
    bool reduceMotion = false,
    bool screenReader = false,
    bool subscribe = true,
  }) async {
    recorder = _RouteRecorder();
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion, accessibleNavigation: screenReader),
          child: Navigator(
            observers: [recorder],
            onGenerateRoute: (settings) => switch (settings.name) {
              // Stand-in sheet: closes at once with the subscription result.
              AppRoutes.reminderSheet => MaterialPageRoute<bool>(
                  settings: settings,
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop(subscribe));
                    return const Scaffold();
                  },
                ),
              AppRoutes.movieDetail => MaterialPageRoute<void>(settings: settings, builder: (_) => const Scaffold()),
              _ => MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => Scaffold(body: ComingSoonCarousel(movies: movies, today: () => today)),
                ),
            },
          ),
        ),
      ),
    );
    await tester.pump();
  }

  /// The focused card, read from the dots: the active one is the widest pill.
  int focused(WidgetTester tester) {
    var best = 0;
    var bestWidth = 0.0;
    for (var i = 0; i < movies.length; i++) {
      final dot = find.descendant(of: find.byKey(Key('carousel.dot.$i')), matching: find.byType(AnimatedContainer));
      final width = tester.getSize(dot).width;
      if (width > bestWidth) (best, bestWidth) = (i, width);
    }
    return best;
  }

  /// The page animation, then the dot animation. The first pump starts the
  /// scroll animation's ticker (it counts from the next frame).
  Future<void> settlePage(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(Motion.extraLong);
    await tester.pump(Motion.medium);
    await tester.pump(Motion.medium);
  }

  testWidgets('shows coming-soon cards with a release countdown and dots', (tester) async {
    await pump(tester);

    expect(find.text('Avatar 3'), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('carousel.release.2')), matching: find.text('In 12 days')),
        findsOneWidget);
    expect(focused(tester), 0);
  });

  testWidgets('each card is one accessible button with position and release', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, screenReader: true);

    expect(
      find.bySemanticsLabel('Coming soon, 1 of 3, Avatar 3, In 12 days. Double-tap to open.'),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('auto-advances every 5 s', (tester) async {
    await pump(tester);

    await tester.pump(const Duration(seconds: 4));
    expect(focused(tester), 0, reason: 'not before the interval');
    await tester.pump(const Duration(milliseconds: 1500));
    await settlePage(tester);
    expect(focused(tester), 1);

    await tester.pump(const Duration(seconds: 5));
    await settlePage(tester);
    expect(focused(tester), 2);
  });

  testWidgets('a touch pauses it; it resumes 8 s after the finger lifts', (tester) async {
    await pump(tester);

    // Touch and hold with a small drag (a plain tap would open the movie).
    final finger = await tester.startGesture(tester.getCenter(find.byKey(const Key('carousel'))));
    await finger.moveBy(const Offset(-30, 0)); // past the touch slop: a drag, not a tap
    await tester.pump(const Duration(seconds: 6));
    expect(focused(tester), 0, reason: 'held: no advance');
    await finger.up();
    await tester.pump(); // the resume timer starts counting from this frame

    await tester.pump(const Duration(seconds: 7));
    expect(focused(tester), 0, reason: 'still inside the resume delay');
    await tester.pump(const Duration(milliseconds: 1500));
    await settlePage(tester);
    expect(focused(tester), 1);
  });

  testWidgets('never auto-advances under reduced motion', (tester) async {
    await pump(tester, reduceMotion: true);

    await tester.pump(const Duration(seconds: 12));
    expect(focused(tester), 0);
  });

  testWidgets('never auto-advances with a screen reader on', (tester) async {
    await pump(tester, screenReader: true);

    await tester.pump(const Duration(seconds: 12));
    expect(focused(tester), 0);
  });

  testWidgets('from the last card it fades back to the first without scrolling through', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('carousel.dot.2')));
    await settlePage(tester);
    expect(focused(tester), 2);

    final seen = <int>{};
    // Resume delay after the dot tap, then the jump.
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 200));
      seen.add(focused(tester));
    }
    expect(focused(tester), 0);
    expect(seen, isNot(contains(1)), reason: 'jumped, did not scroll back across card 2 → 1 → 0');
  });

  testWidgets('tapping a card opens detail with the carousel hero', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('carousel.open.2')));
    await tester.pump();

    final args = recorder.pushed.last.arguments! as MovieDetailArgs;
    expect(args.movieId, 2);
    expect(args.heroSource, HeroSource.carousel);
  });

  testWidgets('Remind me opens the reminder sheet and marks the card subscribed', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('carousel.remind.2')));
    await tester.pump();
    expect(recorder.pushed.last.name, AppRoutes.reminderSheet);
    expect((recorder.pushed.last.arguments! as Movie).id, 2);

    await tester.pump();
    await tester.pump(Motion.long);
    await tester.pump(Motion.medium);
    expect(find.byKey(const Key('carousel.subscribed.2')), findsOneWidget);
    expect(find.text('Subscribed'), findsOneWidget);
  });
}
