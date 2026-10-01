import 'package:flutter/material.dart';

import 'seat_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFB3261E),
      surface: const Color(0xFFFAFAFA),
    );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: const [SeatColors.light],
    );
  }
}
