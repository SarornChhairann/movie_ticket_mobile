import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/motion/motion.dart';
import '../../../core/theme/tokens.dart';

/// The issued ticket flying from the success screen into the Bookings tab icon
/// (sprint 16). Drawn in the root overlay above everything; completes when it
/// lands. Callers skip it under reduced motion.
Future<void> flyTicket(BuildContext context, {required Rect from, required Rect to}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final landed = Completer<void>();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _TicketFlight(
      from: from,
      to: to,
      onDone: () {
        entry.remove();
        landed.complete();
      },
    ),
  );
  overlay.insert(entry);
  return landed.future;
}

class _TicketFlight extends StatefulWidget {
  const _TicketFlight({required this.from, required this.to, required this.onDone});

  final Rect from;
  final Rect to;
  final VoidCallback onDone;

  @override
  State<_TicketFlight> createState() => _TicketFlightState();
}

class _TicketFlightState extends State<_TicketFlight> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Motion.extraLong)..forward().whenComplete(widget.onDone);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _controller, curve: Motion.emphasized);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: curve,
        builder: (context, _) {
          final rect = Rect.lerp(widget.from, widget.to, curve.value)!;
          return Stack(children: [
            Positioned.fromRect(
              rect: rect,
              child: Opacity(
                opacity: 1 - 0.4 * curve.value,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.tokens.actionFill,
                    borderRadius: BorderRadius.circular(AppTokens.radii.sm),
                  ),
                  child: const FittedBox(child: Icon(Icons.confirmation_number)),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
