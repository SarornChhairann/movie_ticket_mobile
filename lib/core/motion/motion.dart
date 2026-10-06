import 'package:flutter/widgets.dart';

/// Motion tokens (sprint 8). Feature views use these — never an inline duration
/// or curve — so timing stays consistent and reduced motion works everywhere.
abstract final class Motion {
  /// Press feedback, chip select, icon swaps.
  static const short = Duration(milliseconds: 150);

  /// Fades, crossfades, small size changes.
  static const medium = Duration(milliseconds: 250);

  /// Route transitions (enter).
  static const long = Duration(milliseconds: 350);

  /// Hero / container transform, carousel paging.
  static const extraLong = Duration(milliseconds: 500);

  /// Fade-through routes run this much longer than [medium] so the outgoing page
  /// has gone before the new one scales in.
  static const fadeThroughExtra = Duration(milliseconds: 50);

  /// One pulse of an attention cue (countdown at 60 s, a seat just taken).
  static const pulse = Duration(milliseconds: 600);

  /// The breathing glow on selected seats (one cycle).
  static const seatGlow = Duration(milliseconds: 1400);

  /// The ticket-issued animation on the success screen.
  static const ticketIssue = Duration(milliseconds: 900);

  /// How long a confirmation stays before a sheet closes itself.
  static const confirmHold = Duration(milliseconds: 900);

  /// Splash: the logo draws in, then holds; the loading bar waits; the glow breathes.
  static const splashIntro = Duration(milliseconds: 1400);
  static const splashMinDisplay = Duration(milliseconds: 2000);
  static const splashProgressDelay = Duration(milliseconds: 2400);
  static const splashGlow = Duration(milliseconds: 2600);

  /// Route enter and hero.
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Elements entering.
  static const Curve decelerate = Curves.easeOutCubic;

  /// Elements leaving.
  static const Curve accelerate = Curves.easeInCubic;

  /// Something arriving with a small overshoot (a ticket landing).
  static const Curve overshoot = Curves.easeOutBack;

  /// A playful pop (success badge). Use sparingly.
  static const Curve pop = Curves.elasticOut;

  /// First-load list entrance: delay per item, and how many items get one.
  static const staggerStep = Duration(milliseconds: 40);
  static const staggerMax = 6;

  /// Exit runs at 70% of the enter duration.
  static Duration exitOf(Duration enter) => enter * 0.7;
}

extension MotionContext on BuildContext {
  /// The OS "reduce motion" setting. When true: no transitions beyond an instant
  /// swap, nothing auto-advances, nothing loops.
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  /// [duration], or zero under reduced motion.
  Duration motion(Duration duration) => reduceMotion ? Duration.zero : duration;
}
