import 'package:flutter/widgets.dart';

import 'motion.dart';

/// Slides [child] down into place (and back up when it becomes null) — for
/// banners that appear above content. Key the child by its content so a new
/// message replaces the old one.
class Reveal extends StatelessWidget {
  const Reveal({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: context.motion(Motion.medium),
      switchInCurve: Motion.decelerate,
      switchOutCurve: Motion.accelerate,
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        alignment: Alignment.topCenter,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: child ?? const SizedBox(width: double.infinity),
    );
  }
}
