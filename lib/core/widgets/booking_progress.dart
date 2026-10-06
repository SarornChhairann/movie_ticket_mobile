import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../theme/spacing.dart';
import '../theme/tokens.dart';

/// The steps of a booking, in order (sprint 16).
enum FlowStep { seats, snacks, pay, tickets }

/// "Seats · Snacks · Pay · Tickets" with the current step labelled and filled.
/// Done steps can be tapped to go back; a skipped step (Snacks) is drawn hollow.
/// Screen readers hear "Step 2 of 4, Snacks".
class BookingProgress extends StatelessWidget {
  const BookingProgress({super.key, required this.current, this.snacksSkipped = false, this.onStepTap});

  final FlowStep current;
  final bool snacksSkipped;

  /// Called with a done step; null makes the header read-only.
  final ValueChanged<FlowStep>? onStepTap;

  static String labelOf(BuildContext context, FlowStep step) => 'flow.step.${step.name}'.tr(context: context);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = context.tokens;
    final total = FlowStep.values.length;
    final index = current.index;
    return Semantics(
      key: const Key('flow.progress'),
      container: true,
      label: 'flow.stepOf'.tr(
        context: context,
        namedArgs: {'n': '${index + 1}', 'total': '$total', 'name': labelOf(context, current)},
      ),
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x1),
          child: Row(
            children: [
              for (final step in FlowStep.values) ...[
                if (step.index > 0) const SizedBox(width: Space.x0_5),
                Expanded(
                  child: _Segment(
                    key: Key('flow.step.${step.name}'),
                    label: labelOf(context, step),
                    done: step.index < index,
                    current: step == current,
                    skipped: step == FlowStep.snacks && snacksSkipped && step.index < index,
                    fill: scheme.primary,
                    track: tokens.surface(2),
                    muted: tokens.onSurfaceMuted,
                    onTap: step.index < index && onStepTap != null ? () => onStepTap!(step) : null,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    super.key,
    required this.label,
    required this.done,
    required this.current,
    required this.skipped,
    required this.fill,
    required this.track,
    required this.muted,
    this.onTap,
  });

  final String label;
  final bool done;
  final bool current;
  final bool skipped;
  final Color fill;
  final Color track;
  final Color muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme.labelSmall;
    final target = done || current ? 1.0 : 0.0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Space.x1),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: Space.minTarget),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Space.x0_5),
              child: SizedBox(
                height: Space.x0_5,
                child: Stack(fit: StackFit.expand, children: [
                  ColoredBox(color: track),
                  if (skipped)
                    DecoratedBox(decoration: BoxDecoration(border: Border.all(color: fill)))
                  else
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: target),
                      duration: context.motion(Motion.medium),
                      curve: Motion.decelerate,
                      builder: (context, v, _) => FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: v,
                        child: ColoredBox(color: fill),
                      ),
                    ),
                ]),
              ),
            ),
            const SizedBox(height: Space.x0_5),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text?.copyWith(
                color: current ? null : muted,
                fontWeight: current ? FontWeight.w700 : null,
                decoration: skipped ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
