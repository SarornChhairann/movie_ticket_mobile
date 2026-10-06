import 'package:flutter/material.dart';

import '../haptics/app_haptics.dart';
import '../motion/pressable.dart';
import '../theme/spacing.dart';
import '../theme/tokens.dart';

enum AppButtonVariant {
  /// The one main action on a screen (filled).
  primary,

  /// A secondary action that still needs weight (outlined).
  tonal,

  /// Low-emphasis (text only): Skip, Browse, Edit.
  ghost,

  /// Irreversible: Release seats, Cancel booking.
  destructive,
}

/// The app's button (sprint 15). Presses scale ([Pressable]) and buzz
/// ([AppHaptics.light] for primary and destructive); [loading] shows a spinner
/// and ignores taps; null [onPressed] is disabled.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.expand = false,
  });

  const AppButton.primary({super.key, required this.label, required this.onPressed, this.loading = false, this.icon, this.expand = true})
      : variant = AppButtonVariant.primary;

  const AppButton.tonal({super.key, required this.label, required this.onPressed, this.loading = false, this.icon, this.expand = false})
      : variant = AppButtonVariant.tonal;

  const AppButton.ghost({super.key, required this.label, required this.onPressed, this.loading = false, this.icon, this.expand = false})
      : variant = AppButtonVariant.ghost;

  const AppButton.destructive({super.key, required this.label, required this.onPressed, this.loading = false, this.icon, this.expand = false})
      : variant = AppButtonVariant.destructive;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final Widget? icon;

  /// Full width.
  final bool expand;

  void _press() {
    if (variant == AppButtonVariant.primary || variant == AppButtonVariant.destructive) AppHaptics.light();
    onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null && !loading;
    final tap = enabled ? _press : null;
    final Widget content = loading
        ? const SizedBox.square(dimension: Space.x2 + 4, child: CircularProgressIndicator(strokeWidth: 2.5))
        : Text(label, overflow: TextOverflow.ellipsis);

    Widget button = switch (variant) {
      AppButtonVariant.primary => icon == null || loading
          ? FilledButton(onPressed: tap, child: content)
          : FilledButton.icon(onPressed: tap, icon: icon!, label: content),
      AppButtonVariant.destructive => FilledButton(
          onPressed: tap,
          style: FilledButton.styleFrom(backgroundColor: scheme.errorContainer, foregroundColor: scheme.onErrorContainer),
          child: content,
        ),
      AppButtonVariant.tonal => icon == null || loading
          ? OutlinedButton(onPressed: tap, child: content)
          : OutlinedButton.icon(onPressed: tap, icon: icon!, label: content),
      AppButtonVariant.ghost => icon == null || loading
          ? TextButton(onPressed: tap, style: TextButton.styleFrom(foregroundColor: context.tokens.link), child: content)
          : TextButton.icon(
              onPressed: tap,
              style: TextButton.styleFrom(foregroundColor: context.tokens.link),
              icon: icon!,
              label: content,
            ),
    };
    if (expand) button = SizedBox(width: double.infinity, child: button);
    return Semantics(
      button: true,
      enabled: enabled,
      child: enabled ? Pressable(child: button) : button,
    );
  }
}
