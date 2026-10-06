import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/theme/app_colors.dart';
import 'package:movie_ticket_mobile/core/theme/app_theme.dart';
import 'package:movie_ticket_mobile/core/theme/tokens.dart';

/// WCAG 2.x contrast of [fg] drawn over [bg] (alpha composited first).
double contrast(Color fg, Color bg) {
  final over = Color.alphaBlend(fg, bg);
  final a = over.computeLuminance();
  final b = bg.computeLuminance();
  final hi = a > b ? a : b;
  final lo = a > b ? b : a;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  const body = 4.5;
  const nonText = 3.0;
  final scheme = AppTheme.dark.colorScheme;
  const surfaces = {
    'navy': AppColors.navy,
    'navyRaised': AppColors.navyRaised,
    'navyHigh': AppColors.navyHigh,
  };

  test('text on every surface level meets AA for body text', () {
    final texts = {
      'white': AppColors.white,
      'onSurfaceMuted': AppColors.onSurfaceMuted,
      'link': AppColors.link,
      'success': AppColors.success,
      'warning': AppColors.warning,
      'info': AppColors.info,
      'error': AppColors.error,
    };
    for (final s in surfaces.entries) {
      for (final t in texts.entries) {
        expect(contrast(t.value, s.value), greaterThanOrEqualTo(body), reason: '${t.key} on ${s.key}');
      }
    }
  });

  test('labels on filled and container colours meet AA', () {
    final pairs = {
      'onPrimary/primary': (scheme.onPrimary, scheme.primary),
      'white/actionFill': (AppColors.white, AppColors.actionFill),
      'onError/error': (scheme.onError, scheme.error),
      'onErrorContainer/errorContainer': (scheme.onErrorContainer, scheme.errorContainer),
      'onPrimaryContainer/primaryContainer': (scheme.onPrimaryContainer, scheme.primaryContainer),
      'onTertiaryContainer/tertiaryContainer': (scheme.onTertiaryContainer, scheme.tertiaryContainer),
      'navy/warning': (AppColors.navy, AppColors.warning),
      'navy/success': (AppColors.navy, AppColors.success),
    };
    for (final p in pairs.entries) {
      expect(contrast(p.value.$1, p.value.$2), greaterThanOrEqualTo(body), reason: p.key);
    }
  });

  test('non-text accents (focus ring, indicator, outline) reach 3:1 on navy', () {
    expect(contrast(AppColors.blue, AppColors.navy), greaterThanOrEqualTo(nonText));
    expect(contrast(AppColors.onSurfaceMuted, AppColors.navy), greaterThanOrEqualTo(nonText));
  });

  test('the theme carries the tokens', () {
    expect(AppTheme.dark.extension<AppTokens>(), AppTokens.dark);
    expect(AppTokens.dark.surface(9), AppColors.navyTop, reason: 'levels clamp');
  });
}
