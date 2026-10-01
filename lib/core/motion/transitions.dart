import 'package:flutter/material.dart';

import 'motion.dart';

/// How a route enters and leaves (sprint 8, journey table 1.2).
enum RouteMotion {
  /// Root swaps: splash → Home, sign-out, blocked.
  fade,

  /// Peers / outcomes (e.g. pay → success): out quickly, in with a slight zoom.
  fadeThrough,

  /// Next step in a sequence (detail → seats → checkout): slide + fade on X.
  sharedAxisX,

  /// Closer look at the same thing (ticket → QR): rise + fade on Y.
  sharedAxisY,

  /// The page fades while a poster Hero carries continuity (card → detail).
  container,

  /// Full-screen sheet from the bottom (login).
  sheet,
}

/// One builder for every route so all screens move the same way.
Route<T> buildMotionRoute<T>(RouteSettings settings, RouteMotion motion, WidgetBuilder builder) {
  if (motion == RouteMotion.sheet) {
    return MaterialPageRoute<T>(settings: settings, fullscreenDialog: true, builder: builder);
  }
  final enter = switch (motion) {
    RouteMotion.container => Motion.extraLong,
    RouteMotion.fadeThrough || RouteMotion.fade => Motion.medium + const Duration(milliseconds: 50),
    _ => Motion.long,
  };
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: enter,
    reverseTransitionDuration: Motion.exitOf(enter),
    pageBuilder: (context, _, _) => builder(context),
    transitionsBuilder: (context, animation, secondary, child) {
      if (context.reduceMotion) return child;
      return _transition(motion, animation, secondary, child);
    },
  );
}

Widget _transition(RouteMotion motion, Animation<double> animation, Animation<double> secondary, Widget child) {
  switch (motion) {
    case RouteMotion.fade:
    case RouteMotion.container:
      return FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Motion.decelerate), child: child);
    case RouteMotion.fadeThrough:
      return _FadeThrough(animation: animation, child: child);
    case RouteMotion.sharedAxisX:
    case RouteMotion.sharedAxisY:
      return _SharedAxis(
        animation: animation,
        secondary: secondary,
        horizontal: motion == RouteMotion.sharedAxisX,
        child: child,
      );
    case RouteMotion.sheet:
      return child;
  }
}

/// Material shared axis: the incoming page slides in 30 dp and fades in after the
/// outgoing one has mostly faded; the covered page slides the other way.
class _SharedAxis extends StatelessWidget {
  const _SharedAxis({required this.animation, required this.secondary, required this.horizontal, required this.child});

  final Animation<double> animation;
  final Animation<double> secondary;
  final bool horizontal;
  final Widget child;

  static const _distance = 30.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([animation, secondary]),
      child: child,
      builder: (context, child) {
        final inT = Motion.emphasized.transform(animation.value);
        final outT = Motion.emphasized.transform(secondary.value);
        // In: fade over the last 70%; out (covered by the next page): fade over the first 30%.
        final inOpacity = const Interval(0.3, 1).transform(animation.value);
        final outOpacity = 1 - const Interval(0, 0.3).transform(secondary.value);
        final shift = _distance * (1 - inT) - _distance * outT;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        final offset = horizontal ? Offset(rtl ? -shift : shift, 0) : Offset(0, shift);
        return Opacity(
          opacity: (inOpacity * outOpacity).clamp(0, 1),
          child: Transform.translate(offset: offset, child: child),
        );
      },
    );
  }
}

/// Material fade-through for one animation: invisible for the first 35% (the
/// old content fades out), then fades in while scaling 0.92 → 1. In reverse,
/// it fades out within the first 35% of the time.
class _FadeThrough extends StatelessWidget {
  const _FadeThrough({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final reversing = animation.status == AnimationStatus.reverse;
        final v = animation.value;
        final opacity = reversing ? const Interval(0.65, 1).transform(v) : const Interval(0.35, 1, curve: Motion.decelerate).transform(v);
        final scale = reversing ? 1.0 : 0.92 + 0.08 * Motion.decelerate.transform(const Interval(0.35, 1).transform(v));
        return Opacity(opacity: opacity, child: Transform.scale(scale: scale, child: child));
      },
    );
  }
}

/// Swaps [child] with a fade-through (bottom-bar tabs). Give each child a key.
class FadeThroughSwitcher extends StatelessWidget {
  const FadeThroughSwitcher({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: context.motion(Motion.long),
      reverseDuration: context.motion(Motion.long),
      // Stack the outgoing tab under the incoming one, both full size.
      layoutBuilder: (current, previous) => Stack(fit: StackFit.expand, children: [...previous, ?current]),
      transitionBuilder: (child, animation) => _FadeThrough(animation: animation, child: child),
      child: child,
    );
  }
}
