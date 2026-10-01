import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';

/// First-load placeholders drawn in the final layout, so nothing jumps when data
/// arrives. One slow shimmer per [Skeleton] keeps all its boxes in sync; static
/// under reduced motion.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, required this.child});

  final Widget child;

  static const period = Duration(milliseconds: 1200);

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer = AnimationController(vsync: this, duration: Skeleton.period);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _shimmer.stop();
    } else if (!_shimmer.isAnimating) {
      _shimmer.repeat();
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      child: ExcludeSemantics(child: _ShimmerScope(animation: _shimmer, child: widget.child)),
    );
  }
}

class _ShimmerScope extends InheritedWidget {
  const _ShimmerScope({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_ShimmerScope old) => old.animation != animation;
}

/// One placeholder block. Inside a [Skeleton] it shimmers.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height, this.radius = Radii.card});

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final animation = context.dependOnInheritedWidgetOfExactType<_ShimmerScope>()?.animation;
    Widget box(double t) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-2.5 + 4 * t, 0),
              end: Alignment(-0.5 + 4 * t, 0),
              colors: const [AppColors.navyRaised, AppColors.navyHigh, AppColors.navyRaised],
            ),
          ),
        );
    if (animation == null) return box(0);
    return AnimatedBuilder(animation: animation, builder: (_, _) => box(animation.value));
  }
}

/// Poster card placeholder: 2:3 image plus two text lines.
class SkeletonPosterCard extends StatelessWidget {
  const SkeletonPosterCard({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 2 / 3, child: SkeletonBox()),
          SizedBox(height: Space.x1),
          SkeletonBox(height: 14, width: 110, radius: 4),
          SizedBox(height: Space.x0_5),
          SkeletonBox(height: 12, width: 60, radius: 4),
        ],
      ),
    );
  }
}

/// List-row placeholder (bookings).
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: Space.x1),
      child: SkeletonBox(height: 96),
    );
  }
}
