import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/motion/motion.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/ticket_emblem.dart';

/// The pay-success moment: the ticket rises out of a slot with a small overshoot,
/// settles into the brand tilt, and a check badge pops. One success haptic.
/// [duration] at most 900 ms; under reduced motion the final frame shows at once.
class TicketIssuedAnimation extends StatefulWidget {
  const TicketIssuedAnimation({super.key, this.size = 132});

  static const duration = Duration(milliseconds: 900);

  /// Ticket width.
  final double size;

  @override
  State<TicketIssuedAnimation> createState() => _TicketIssuedAnimationState();
}

class _TicketIssuedAnimationState extends State<TicketIssuedAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: TicketIssuedAnimation.duration);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    HapticFeedback.mediumImpact();
    if (context.reduceMotion) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.size;
    final ticketH = w * TicketEmblem.aspect;
    final slotWidth = w * 1.15;
    final areaHeight = ticketH * 1.6;

    // Phases: rise 0–0.6 (overshoot), tilt 0.45–0.8, badge 0.7–1.
    final rise = CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Motion.overshoot));
    final tilt = CurvedAnimation(parent: _controller, curve: const Interval(0.45, 0.8, curve: Motion.decelerate));
    final badge = CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1, curve: Motion.pop));

    return Semantics(
      container: true,
      image: true,
      child: SizedBox(
        key: const Key('pay.issued'),
        width: slotWidth,
        height: areaHeight + 12,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            // The ticket starts fully below the slot line and rises above it.
            final startY = areaHeight;
            final endY = (areaHeight - ticketH) / 2;
            final y = startY + (endY - startY) * rise.value;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Only what has come out of the slot is visible.
                Positioned.fill(
                  bottom: 12,
                  child: ClipRect(
                    child: Stack(
                      children: [
                        Positioned(
                          left: (slotWidth - w) / 2,
                          top: y,
                          child: Transform.rotate(
                            angle: -12 * math.pi / 180 * tilt.value,
                            child: TicketEmblem(width: w, shadow: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // The slot.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 6,
                  child: Container(
                    height: 6,
                    decoration: const ShapeDecoration(shape: StadiumBorder(), color: AppColors.navyHigh),
                  ),
                ),
                // Success badge on the ticket's corner.
                Positioned(
                  right: (slotWidth - w) / 2 - 10,
                  top: endY - 14,
                  child: Transform.scale(
                    scale: badge.value,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                      child: Icon(Icons.check_circle, color: Color(0xFF3DBE7A), size: 36),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
