import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import 'status_chip.dart';

/// A full-width strip above content that is still usable (sprint 15): offline,
/// a lost hold, a seat just taken. One optional action and an optional close.
class InlineBanner extends StatelessWidget {
  const InlineBanner({
    super.key,
    required this.message,
    this.tone = StatusTone.error,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.actionKey,
  });

  final String message;
  final StatusTone tone;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final Key? actionKey;

  static IconData _iconOf(StatusTone tone) => switch (tone) {
        StatusTone.error => Icons.warning_amber_rounded,
        StatusTone.warning => Icons.timer_outlined,
        StatusTone.success => Icons.check_circle_outline,
        StatusTone.info || StatusTone.neutral => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (tone) {
      StatusTone.error => (scheme.errorContainer, scheme.onErrorContainer),
      StatusTone.warning || StatusTone.info => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
      _ => StatusChip.colorsOf(context, tone),
    };
    return Material(
      color: background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Insets.banner),
        child: Row(
          children: [
            ExcludeSemantics(child: Icon(icon ?? _iconOf(tone), color: foreground)),
            const SizedBox(width: Space.x1),
            Expanded(
              child: Semantics(liveRegion: true, child: Text(message, style: TextStyle(color: foreground))),
            ),
            if (actionLabel != null && onAction != null)
              Theme(
                data: Theme.of(context).copyWith(
                  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: foreground)),
                ),
                child: TextButton(key: actionKey, onPressed: onAction, child: Text(actionLabel!)),
              ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close),
                color: foreground,
                tooltip: 'common.dismiss'.tr(context: context),
                onPressed: onDismiss,
              ),
          ],
        ),
      ),
    );
  }
}

