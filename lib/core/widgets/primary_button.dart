import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// Full-width pill action. Shows a spinner and ignores taps while [loading].
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox.square(dimension: Space.x2 + 4, child: CircularProgressIndicator(strokeWidth: 2.5))
        : Text(label);
    return SizedBox(
      width: double.infinity,
      child: icon == null || loading
          ? FilledButton(onPressed: loading ? null : onPressed, child: child)
          : FilledButton.icon(onPressed: onPressed, icon: icon!, label: child),
    );
  }
}
