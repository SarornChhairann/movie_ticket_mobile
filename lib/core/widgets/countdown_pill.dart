import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../motion/motion.dart';
import '../theme/spacing.dart';
import '../theme/tokens.dart';

/// A hold countdown `m:ss` (sprint 15) in tabular figures. Turns warning at
/// [warnAt] seconds and pulses once when it crosses it — never loops.
class CountdownPill extends StatefulWidget {
  const CountdownPill({
    super.key,
    required this.secondsLeft,
    this.warnAt = 60,
    this.semanticsLabel,
    this.announce,
  });

  final int secondsLeft;
  final int warnAt;

  /// What a screen reader reads when it focuses the pill.
  final String? semanticsLabel;

  /// The sentence spoken (without focus) at [announceAt] seconds — never every
  /// second (sprint 19). Null speaks nothing.
  final String Function(int seconds)? announce;

  /// The only moments the countdown is spoken.
  static const announceAt = [60, 10];

  static String mmss(int seconds) {
    final s = seconds < 0 ? 0 : seconds;
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  State<CountdownPill> createState() => _CountdownPillState();
}

class _CountdownPillState extends State<CountdownPill> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: Motion.pulse);

  bool get _warning => widget.secondsLeft <= widget.warnAt;

  @override
  void didUpdateWidget(CountdownPill old) {
    super.didUpdateWidget(old);
    final crossed = old.secondsLeft > widget.warnAt && _warning;
    if (crossed && !context.reduceMotion) _pulse.forward(from: 0);
    final speak = widget.announce;
    if (speak == null) return;
    for (final at in CountdownPill.announceAt) {
      if (old.secondsLeft > at && widget.secondsLeft <= at) {
        // ignore: deprecated_member_use
        SemanticsService.announce(speak(widget.secondsLeft), Directionality.of(context));
        break;
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final scheme = Theme.of(context).colorScheme;
    final background = _warning ? t.warning : scheme.surfaceContainerHighest;
    final foreground = _warning ? scheme.surface : scheme.onSurface;
    return Semantics(
      label: widget.semanticsLabel,
      excludeSemantics: widget.semanticsLabel != null,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          // 1 → 1.12 → 1 over one pulse.
          final v = _pulse.value;
          final scale = 1 + 0.12 * (v < 0.5 ? v * 2 : (1 - v) * 2);
          return Transform.scale(scale: scale, child: child);
        },
        child: AnimatedContainer(
          key: const Key('countdown.pill'),
          duration: context.motion(Motion.medium),
          padding: const EdgeInsets.symmetric(horizontal: Space.x1 + Space.x0_5, vertical: Space.x0_5),
          decoration: ShapeDecoration(shape: const StadiumBorder(), color: background),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: Space.x2, color: foreground),
              const SizedBox(width: Space.x0_5),
              Text(CountdownPill.mmss(widget.secondsLeft), style: t.numeric.copyWith(color: foreground)),
            ],
          ),
        ),
      ),
    );
  }
}
