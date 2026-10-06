import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';
import 'spacing.dart';

/// Every design token in one `ThemeExtension` (sprint 15): views read
/// `context.tokens` instead of reaching for constants, so a theme change flows
/// everywhere and the gallery can show the whole system.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.success,
    required this.warning,
    required this.info,
    required this.onSurfaceMuted,
    required this.scrim,
    required this.actionFill,
    required this.link,
    required this.elevation,
  });

  static const dark = AppTokens(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    onSurfaceMuted: AppColors.onSurfaceMuted,
    scrim: AppColors.scrim,
    actionFill: AppColors.actionFill,
    link: AppColors.link,
    elevation: [AppColors.navy, AppColors.navyRaised, AppColors.navyHigh, AppColors.navyTop],
  );

  final Color success;
  final Color warning;
  final Color info;
  final Color onSurfaceMuted;
  final Color scrim;
  final Color actionFill;
  final Color link;

  /// Surface levels 0–3 as navy tints: on a dark theme depth is shown by a lighter
  /// surface, never a drop shadow.
  final List<Color> elevation;

  Color surface(int level) => elevation[level.clamp(0, elevation.length - 1)];

  // Static scales, exposed here so a view needs only one import.
  static const radii = (sm: Radii.sm, card: Radii.card, button: Radii.button, sheet: Radii.sheet, pill: Radii.pill);
  TextStyle get numeric => AppText.numeric;
  TextStyle get numericLarge => AppText.numericLarge;

  @override
  AppTokens copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? onSurfaceMuted,
    Color? scrim,
    Color? actionFill,
    Color? link,
    List<Color>? elevation,
  }) =>
      AppTokens(
        success: success ?? this.success,
        warning: warning ?? this.warning,
        info: info ?? this.info,
        onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
        scrim: scrim ?? this.scrim,
        actionFill: actionFill ?? this.actionFill,
        link: link ?? this.link,
        elevation: elevation ?? this.elevation,
      );

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      actionFill: Color.lerp(actionFill, other.actionFill, t)!,
      link: Color.lerp(link, other.link, t)!,
      elevation: [for (var i = 0; i < elevation.length; i++) Color.lerp(elevation[i], other.elevation[i], t)!],
    );
  }
}

extension TokensContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>() ?? AppTokens.dark;
}
