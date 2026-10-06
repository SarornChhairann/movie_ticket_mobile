import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
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

/// One builder for every route so all screens move the same way. Every route is
/// a [MotionPageRoute] (a `MaterialPageRoute`), so the theme's [AppPageTransitions]
/// draws it and Android 14+ gets the predictive back preview (sprint 15).
Route<T> buildMotionRoute<T>(RouteSettings settings, RouteMotion motion, WidgetBuilder builder) =>
    MotionPageRoute<T>(settings: settings, motion: motion, builder: builder);

/// A `MaterialPageRoute` that knows its [RouteMotion] and its sprint-8 timing.
class MotionPageRoute<T> extends MaterialPageRoute<T> {
  MotionPageRoute({required super.settings, required this.motion, required super.builder})
      : super(fullscreenDialog: motion == RouteMotion.sheet);

  final RouteMotion motion;

  /// Enter time per motion; exit is [Motion.exitOf] it.
  static Duration enterOf(RouteMotion motion) => switch (motion) {
        RouteMotion.container => Motion.extraLong,
        RouteMotion.fadeThrough || RouteMotion.fade => Motion.medium + Motion.fadeThroughExtra,
        _ => Motion.long,
      };

  @override
  Duration get transitionDuration => motion == RouteMotion.sheet ? super.transitionDuration : enterOf(motion);

  @override
  Duration get reverseTransitionDuration =>
      motion == RouteMotion.sheet ? super.reverseTransitionDuration : Motion.exitOf(enterOf(motion));
}

/// The app's `PageTransitionsBuilder`, set on every platform in `AppTheme`.
///
/// A [MotionPageRoute] moves the sprint-8 way. While an Android back gesture is in
/// progress the platform's predictive back preview takes over, so the user sees
/// the previous screen before letting go. Sheets keep the platform's own motion.
class AppPageTransitions extends PageTransitionsBuilder {
  const AppPageTransitions();

  static const _predictive = PredictiveBackPageTransitionsBuilder();
  static const _cupertino = CupertinoPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final motion = route is MotionPageRoute<T> ? route.motion : RouteMotion.sharedAxisX;
    final android = Theme.of(context).platform == TargetPlatform.android;
    if (motion == RouteMotion.sheet || route.fullscreenDialog) {
      return (android ? _predictive : _cupertino).buildTransitions(route, context, animation, secondaryAnimation, child);
    }
    if (android) {
      // The predictive-back detector must always be in the tree to catch the
      // gesture start. While dragging it animates the real values; otherwise it is
      // handed settled animations and our own transition does the moving.
      if (route.popGestureInProgress) {
        return _predictive.buildTransitions(route, context, animation, secondaryAnimation, child);
      }
      return _predictive.buildTransitions(
        route,
        context,
        kAlwaysCompleteAnimation,
        kAlwaysDismissedAnimation,
        _motion(context, motion, animation, secondaryAnimation, child),
      );
    }
    return _motion(context, motion, animation, secondaryAnimation, child);
  }

  static Widget _motion(
    BuildContext context,
    RouteMotion motion,
    Animation<double> animation,
    Animation<double> secondary,
    Widget child,
  ) =>
      context.reduceMotion ? child : _transition(motion, animation, secondary, child);
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
