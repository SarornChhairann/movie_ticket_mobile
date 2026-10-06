import 'package:flutter/services.dart';

/// What a haptic means (sprint 15). One table, so every tap of the same kind
/// feels the same.
enum HapticKind {
  /// Chips, seats, steppers, toggles.
  selection,

  /// Primary actions (Continue, Pay).
  light,

  /// A good outcome (ticket issued, hold extended).
  success,

  /// Something to notice (hold ending, a seat just taken).
  warning,

  /// Something failed.
  error,
}

/// The only place the app calls `HapticFeedback` (the lint test enforces it).
abstract final class AppHaptics {
  static Future<void> play(HapticKind kind) => switch (kind) {
        HapticKind.selection => HapticFeedback.selectionClick(),
        HapticKind.light => HapticFeedback.lightImpact(),
        HapticKind.success => HapticFeedback.mediumImpact(),
        HapticKind.warning => HapticFeedback.heavyImpact(),
        HapticKind.error => HapticFeedback.vibrate(),
      };

  static Future<void> selection() => play(HapticKind.selection);
  static Future<void> light() => play(HapticKind.light);
  static Future<void> success() => play(HapticKind.success);
  static Future<void> warning() => play(HapticKind.warning);
  static Future<void> error() => play(HapticKind.error);
}
