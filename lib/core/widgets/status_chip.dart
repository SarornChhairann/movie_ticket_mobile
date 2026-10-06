import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Meaning of a status colour.
enum StatusTone { neutral, success, warning, error, info }

/// A small read-only status pill (sprint 15): booking state, refund, offline.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.tone = StatusTone.neutral, this.icon});

  final String label;
  final StatusTone tone;
  final IconData? icon;

  /// Background and text colours for [tone]; every pair meets AA.
  static (Color, Color) colorsOf(BuildContext context, StatusTone tone) {
    final scheme = Theme.of(context).colorScheme;
    final t = context.tokens;
    return switch (tone) {
      StatusTone.neutral => (scheme.surfaceContainerHighest, scheme.onSurface),
      StatusTone.success => (t.success, scheme.surface),
      StatusTone.warning => (t.warning, scheme.surface),
      StatusTone.error => (scheme.errorContainer, scheme.onErrorContainer),
      StatusTone.info => (scheme.primaryContainer, scheme.onPrimaryContainer),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = colorsOf(context, tone);
    return Chip(
      avatar: icon == null ? null : Icon(icon, size: 16, color: foreground),
      label: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: foreground)),
      backgroundColor: background,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}
