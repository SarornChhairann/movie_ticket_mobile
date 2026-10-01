import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'seat_colors.dart';
import 'spacing.dart';

/// The app's only theme: navy surfaces, blue actions, Poppins.
abstract final class AppTheme {
  static const fontFamily = 'Poppins';

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.blue,
      onPrimary: AppColors.white,
      primaryContainer: Color(0xFF244A6B),
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.blue,
      onSecondary: AppColors.white,
      surface: AppColors.navy,
      onSurface: AppColors.white,
      onSurfaceVariant: Color(0xB3F5F5F5), // mist, 70%
      surfaceContainerLowest: AppColors.navy,
      surfaceContainerLow: AppColors.navy,
      surfaceContainer: AppColors.navyRaised,
      surfaceContainerHigh: AppColors.navyRaised,
      surfaceContainerHighest: AppColors.navyHigh,
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
    final text = base.textTheme.apply(
      fontFamily: fontFamily,
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    );
    const pill = StadiumBorder();
    const buttonRadius = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Radii.button)));
    const buttonSize = Size(64, 52);
    final buttonText = text.labelLarge?.copyWith(fontWeight: FontWeight.w600);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.navy,
      textTheme: text.copyWith(
        headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodySmall: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
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
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: buttonRadius,
          minimumSize: buttonSize,
          textStyle: buttonText,
          foregroundColor: AppColors.white,
          side: const BorderSide(color: Color(0x66FFFFFF)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.blue, textStyle: buttonText),
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
        selectedColor: AppColors.blue,
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
      extensions: const [SeatColors.dark],
    );
  }
}
