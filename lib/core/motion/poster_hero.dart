import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import 'motion.dart';

/// Where a poster was opened from. The same movie can be on screen twice (e.g.
/// carousel and a rail), and Hero tags must be unique per screen.
enum HeroSource { carousel, nowShowing, explore, featured, showing, recent, search }

abstract final class HeroTags {
  static String poster(int movieId, HeroSource source) => 'poster-${source.name}-$movieId';
}

/// A movie image that flies between a card and the detail banner. Corners morph
/// from the card radius to square. Off under reduced motion.
class PosterHero extends StatelessWidget {
  const PosterHero({super.key, required this.tag, required this.child, this.radius = Radii.card});

  final String tag;

  /// Corner radius of this end (the detail banner uses 0).
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return HeroMode(
      enabled: !context.reduceMotion,
      child: Hero(
        tag: tag,
        flightShuttleBuilder: (_, animation, direction, fromContext, toContext) {
          // The shuttle shows the detail-side image; radius goes card → 0 on push.
          final destination = (direction == HeroFlightDirection.push ? toContext : fromContext).widget as Hero;
          return AnimatedBuilder(
            animation: CurvedAnimation(parent: animation, curve: Motion.emphasized),
            builder: (context, child) => ClipRRect(
              borderRadius: BorderRadius.circular(lerpDouble(Radii.card, 0, animation.value)!),
              child: child,
            ),
            child: destination.child,
          );
        },
        child: ClipRRect(borderRadius: BorderRadius.circular(radius), child: child),
      ),
    );
  }
}
