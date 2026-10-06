import 'package:flutter/material.dart';

import '../haptics/app_haptics.dart';
import '../motion/motion.dart';
import '../theme/spacing.dart';

/// The bar at the bottom of Seats, Snacks, and Checkout (sprint 16): what is in
/// the basket on the left, the next step on the right. The action keeps its
/// place and morphs its label (Continue → Pay $12.50) instead of being swapped.
/// Amounts in [summary] must come from the server (the caller formats them).
class StickySummaryBar extends StatelessWidget {
  const StickySummaryBar({
    super.key,
    required this.summary,
    required this.actionLabel,
    required this.onAction,
    this.actionKey,
    this.loading = false,
    this.loadingLabel,
    this.busy = false,
    this.top,
  });

  final Widget summary;
  final String actionLabel;

  /// Null disables the action.
  final VoidCallback? onAction;
  final Key? actionKey;

  /// The action is running: spinner, no taps.
  final bool loading;

  /// Said next to the spinner while [loading] (e.g. "Processing…"), so the state
  /// is not shown by a spinner alone.
  final String? loadingLabel;

  /// Something above is refreshing (a re-quote): a thin bar along the top edge.
  final bool busy;

  /// Optional row above the summary (e.g. party size and Best seats).
  final Widget? top;

  /// Text scale above which the summary stacks over a full-width action.
  static const stackAboveScale = 1.3;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      key: const Key('flow.summaryBar'),
      color: scheme.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.button))),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2, child: busy ? const LinearProgressIndicator() : null),
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1 + Space.x0_5, Space.screen, Space.x2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (top != null) ...[top!, const SizedBox(height: Space.x1)],
                  _SideBySide(
                    stacked: MediaQuery.textScalerOf(context).scale(1) > stackAboveScale,
                    summary: summary,
                    action: FilledButton(
                          key: actionKey,
                          onPressed: onAction == null || loading
                              ? null
                              : () {
                                  AppHaptics.light();
                                  onAction!();
                                },
                          child: loading
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox.square(
                                      dimension: Space.x2,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    if (loadingLabel != null) ...[
                                      const SizedBox(width: Space.x1),
                                      Flexible(child: Text(loadingLabel!, overflow: TextOverflow.ellipsis)),
                                    ],
                                  ],
                                )
                              : AnimatedSwitcher(
                                  duration: context.motion(Motion.medium),
                                  child: Text(
                                    actionLabel,
                                    key: ValueKey(actionLabel),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Summary and action side by side; at large text sizes the summary goes on top
/// and the action takes the full width, so an amount on it is never cut off.
class _SideBySide extends StatelessWidget {
  const _SideBySide({required this.stacked, required this.summary, required this.action});

  final bool stacked;
  final Widget summary;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [summary, const SizedBox(height: Space.x1), action],
      );
    }
    return Row(
      children: [
        Expanded(child: summary),
        const SizedBox(width: Space.x2),
        Flexible(child: action),
      ],
    );
  }
}
