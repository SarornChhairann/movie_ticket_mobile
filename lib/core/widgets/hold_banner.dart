import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// "Your seats are held for 0:59 more" with **Extend** (sprint 14), shared by the
/// seat map and checkout. [onExtend] null hides the button (already used, or busy).
/// [message] replaces the text, e.g. checkout's "too short to pay".
class HoldBanner extends StatelessWidget {
  const HoldBanner({super.key, required this.secondsLeft, this.onExtend, this.extending = false, this.message});

  final int secondsLeft;
  final VoidCallback? onExtend;
  final bool extending;
  final String? message;

  static String mmss(int seconds) {
    final s = seconds < 0 ? 0 : seconds;
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      key: const Key('hold.banner'),
      color: scheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.x1),
        child: Row(
          children: [
            Icon(Icons.timer_outlined, color: scheme.onTertiaryContainer),
            const SizedBox(width: Space.x1),
            Expanded(
              // Not a live region: its text changes every second. The countdown
              // speaks at 60 s and 10 s instead (CountdownPill, sprint 19).
              child: Semantics(
                child: Text(
                  message ?? 'seats.holdEnding'.tr(context: context, namedArgs: {'time': mmss(secondsLeft)}),
                  style: TextStyle(color: scheme.onTertiaryContainer),
                ),
              ),
            ),
            if (onExtend != null || extending)
              TextButton(
                key: const Key('hold.extend'),
                onPressed: extending ? null : onExtend,
                child: extending
                    ? const SizedBox.square(dimension: Space.x2, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('seats.extend'.tr(context: context)),
              ),
          ],
        ),
      ),
    );
  }
}
