import 'package:flutter/material.dart';

import '../motion/pressable.dart';
import '../motion/transitions.dart';
import 'app_colors.dart';
import 'app_text.dart';
import 'seat_colors.dart';
import 'spacing.dart';
import 'tokens.dart';

/// The app's only theme: navy surfaces, blue actions, Poppins. Built from the
/// sprint-15 tokens ([AppTokens], [AppText]); every text pair meets WCAG AA.
abstract final class AppTheme {
  static const fontFamily = AppText.fontFamily;

  /// [dark] with Khmer line heights when [locale] is Khmer (sprint 19).
  static ThemeData forLocale(Locale locale) {
    final theme = dark;
    return locale.languageCode == 'km' ? theme.copyWith(textTheme: AppText.khmer(theme.textTheme)) : theme;
  }

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      // Fills carry white labels, so primary is the AA action fill; brand blue
      // stays for accents (indicator, focus ring, progress).
      primary: AppColors.actionFill,
      onPrimary: AppColors.white,
      primaryContainer: Color(0xFF244A6B),
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.blue,
      onSecondary: AppColors.white,
      surface: AppColors.navy,
      onSurface: AppColors.white,
      onSurfaceVariant: AppColors.onSurfaceMuted,
      surfaceContainerLowest: AppColors.navy,
      surfaceContainerLow: AppColors.navy,
      surfaceContainer: AppColors.navyRaised,
      surfaceContainerHigh: AppColors.navyRaised,
      surfaceContainerHighest: AppColors.navyHigh,
      // Tonal buttons and chips: a raised navy with white text (AA, sprint 19).
      secondaryContainer: AppColors.navyTop,
      onSecondaryContainer: AppColors.white,
      tertiary: AppColors.warning,
      onTertiary: AppColors.navy,
      tertiaryContainer: AppColors.navyTop,
      onTertiaryContainer: AppColors.white,
      outline: Color(0x66FFFFFF),
      outlineVariant: Color(0x33FFFFFF),
      error: AppColors.error,
      onError: AppColors.navy,
      errorContainer: Color(0xFF5A2333),
      onErrorContainer: Color(0xFFFFDAD9),
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: fontFamily,
    );
    final text = base.textTheme.merge(AppText.textTheme(color: AppColors.white));
    const pill = StadiumBorder();
    const buttonRadius = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Radii.button)));
    const buttonSize = Size(64, 52);
    final buttonText = text.labelLarge?.copyWith(fontWeight: FontWeight.w600);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.navy,
      textTheme: text,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: AppPageTransitions(),
          TargetPlatform.iOS: AppPageTransitions(),
          TargetPlatform.macOS: AppPageTransitions(),
          TargetPlatform.linux: AppPageTransitions(),
          TargetPlatform.windows: AppPageTransitions(),
          TargetPlatform.fuchsia: AppPageTransitions(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.navyRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Radii.card))),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: buttonRadius,
          minimumSize: buttonSize,
          textStyle: buttonText,
          disabledBackgroundColor: AppColors.navyHigh,
          disabledForegroundColor: scheme.onSurfaceVariant,
          backgroundBuilder: pressScaleBuilder,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: buttonRadius,
          minimumSize: buttonSize,
          textStyle: buttonText,
          foregroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.onSurfaceMuted),
          backgroundBuilder: pressScaleBuilder,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.link,
          textStyle: buttonText,
          minimumSize: const Size(Space.minTarget, Space.minTarget),
          backgroundBuilder: pressScaleBuilder,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size.square(Space.minTarget))
            .copyWith(backgroundBuilder: pressScaleBuilder),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.navyRaised,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.x2),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.card)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.card)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.card)),
          borderSide: BorderSide(color: AppColors.blue, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.card)),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.card)),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: pill,
        side: BorderSide.none,
        backgroundColor: AppColors.navyRaised,
        selectedColor: AppColors.actionFill,
        disabledColor: AppColors.navyRaised,
        labelStyle: text.labelLarge?.copyWith(color: AppColors.white),
        secondaryLabelStyle: text.labelLarge?.copyWith(color: AppColors.white),
        checkmarkColor: AppColors.white,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: Space.x1, vertical: Space.x0_5),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.navyRaised,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.blue,
        labelTextStyle: WidgetStatePropertyAll(text.labelSmall?.copyWith(color: AppColors.white)),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? AppColors.white : scheme.onSurfaceVariant,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(iconColor: scheme.onSurfaceVariant, textColor: AppColors.white),
      dividerTheme: const DividerThemeData(color: Color(0x1FFFFFFF)),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navyHigh,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Radii.card))),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.navyRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Radii.card))),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.navyRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.button))),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.blue),
      extensions: const [SeatColors.dark, AppTokens.dark],
    );
  }
}
