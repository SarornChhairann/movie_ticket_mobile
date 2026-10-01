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
