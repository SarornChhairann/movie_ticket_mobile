import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The type scale (sprint 15). Views take styles from here or from the theme's
/// `textTheme` (which is built from it) — never an inline `fontSize`.
abstract final class AppText {
  static const fontFamily = 'Poppins';

  /// Khmer script has tall stacked subscripts: lines need more room (sprint 19).
  static const khmerHeight = 1.6;

  /// Poppins has no Khmer glyphs. Phones fall back to their system Khmer font
  /// on their own; naming the common ones keeps that choice predictable.
  static const fallback = ['Noto Sans Khmer', 'Khmer Sangam MN', 'Khmer OS'];

  static const _tabular = [FontFeature.tabularFigures()];

  static const display = TextStyle(fontSize: 32, height: 1.2, fontWeight: FontWeight.w700);
  static const headline = TextStyle(fontSize: 24, height: 1.25, fontWeight: FontWeight.w600);
  static const title = TextStyle(fontSize: 18, height: 1.3, fontWeight: FontWeight.w600);
  static const titleSmall = TextStyle(fontSize: 15, height: 1.3, fontWeight: FontWeight.w600);
  static const body = TextStyle(fontSize: 15, height: 1.45, fontWeight: FontWeight.w400);
  static const bodySmall = TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.w400, color: AppColors.onSurfaceMuted);
  static const label = TextStyle(fontSize: 14, height: 1.2, fontWeight: FontWeight.w600);
  static const labelSmall = TextStyle(fontSize: 11, height: 1.2, fontWeight: FontWeight.w500, letterSpacing: 0.3);

  /// Seat codes inside a seat cell: the one place text is this small.
  static const seatCode = TextStyle(fontSize: 9, height: 1, fontWeight: FontWeight.w500);

  /// Times, money, countdowns, references: digits do not jump as they change.
  static const numeric = TextStyle(fontSize: 15, height: 1.3, fontWeight: FontWeight.w600, fontFeatures: _tabular);
  static const numericLarge = TextStyle(fontSize: 24, height: 1.2, fontWeight: FontWeight.w600, fontFeatures: _tabular);

  /// A `TextTheme` with the Material roles mapped onto the scale.
  static TextTheme textTheme({required Color color}) => TextTheme(
        displaySmall: display.copyWith(color: color),
        headlineMedium: headline.copyWith(fontSize: 28, color: color),
        headlineSmall: headline.copyWith(color: color),
        titleLarge: title.copyWith(fontSize: 20, color: color),
        titleMedium: title.copyWith(fontSize: 16, color: color),
        titleSmall: titleSmall.copyWith(fontSize: 14, color: color),
        bodyLarge: body.copyWith(fontSize: 16, color: color),
        bodyMedium: body.copyWith(fontSize: 14, color: color),
        bodySmall: bodySmall,
        labelLarge: label.copyWith(color: color),
        labelMedium: label.copyWith(fontSize: 12, color: color),
        labelSmall: labelSmall.copyWith(color: color),
      ).apply(fontFamily: fontFamily, fontFamilyFallback: fallback);

  /// [theme] with Khmer line heights, for `km`.
  static TextTheme khmer(TextTheme theme) => theme.apply(heightFactor: 1).copyWith(
        bodyLarge: theme.bodyLarge?.copyWith(height: khmerHeight),
        bodyMedium: theme.bodyMedium?.copyWith(height: khmerHeight),
        bodySmall: theme.bodySmall?.copyWith(height: khmerHeight),
        titleMedium: theme.titleMedium?.copyWith(height: khmerHeight),
        titleSmall: theme.titleSmall?.copyWith(height: khmerHeight),
        labelLarge: theme.labelLarge?.copyWith(height: khmerHeight),
        labelMedium: theme.labelMedium?.copyWith(height: khmerHeight),
        labelSmall: theme.labelSmall?.copyWith(height: khmerHeight),
      );
}
