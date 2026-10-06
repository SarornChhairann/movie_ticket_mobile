import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/haptics/app_haptics.dart';
import '../../../core/motion/motion.dart';

/// A card with two faces (sprint 18): tap turns it over with a 3D Y rotation
/// (`Motion.extraLong`); under reduced motion the faces swap at once. The face
/// that is away is removed from the semantics tree.
class TicketFlip extends StatefulWidget {
  const TicketFlip({super.key, required this.front, required this.back, this.showBack = false, this.onFlip});

  final Widget front;
  final Widget back;

  /// Start on the back (door mode).
  final bool showBack;
  final ValueChanged<bool>? onFlip;

  @override
  State<TicketFlip> createState() => TicketFlipState();
}

class TicketFlipState extends State<TicketFlip> with SingleTickerProviderStateMixin {
  late final AnimationController _turn =
      AnimationController(vsync: this, duration: Motion.extraLong, value: widget.showBack ? 1 : 0);

  bool get showingBack => _turn.value >= 0.5;

  /// Turns the card over (used by the tap and by the face's own button).
  void flip() {
    AppHaptics.selection();
    final toBack = !showingBack;
    if (context.reduceMotion) {
      setState(() => _turn.value = toBack ? 1 : 0);
    } else {
      toBack ? _turn.forward() : _turn.reverse();
    }
    widget.onFlip?.call(toBack);
  }

  @override
  void dispose() {
    _turn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flip,
      child: AnimatedBuilder(
        animation: _turn,
        builder: (context, _) {
          final t = Motion.emphasized.transform(_turn.value);
          final back = t >= 0.5;
          final angle = t * math.pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: back
                // The back is drawn mirrored by the rotation; turn it the right way round.
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: KeyedSubtree(key: const ValueKey('back'), child: widget.back),
                  )
                : KeyedSubtree(key: const ValueKey('front'), child: widget.front),
          );
        },
      ),
    );
  }
}
