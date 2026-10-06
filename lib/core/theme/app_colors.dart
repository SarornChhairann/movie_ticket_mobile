import 'package:flutter/material.dart';

/// The four tokens of the visual system, plus tints and semantic roles derived
/// from them (sprint 15). Every text pair here meets WCAG AA on the navy
/// surfaces (`test/core/theme/contrast_test.dart`).
abstract final class AppColors {
  static const navy = Color(0xFF1A2543);
  static const blue = Color(0xFF368DBD);
  static const mist = Color(0xFFF5F5F5);
  static const white = Color(0xFFFFFFFF);

  /// Raised navy for cards, fields, and the bottom bar.
  static const navyRaised = Color(0xFF243156);
  static const navyHigh = Color(0xFF2E3C66);

  /// Elevation level 3: menus and the top of a stack of sheets.
  static const navyTop = Color(0xFF39497A);

  static const error = Color(0xFFFF8A8A);

  /// Fill behind white text (filled buttons, selected chips): brand blue deepened
  /// so white labels reach 4.5:1. The brand [blue] stays for non-text accents.
  static const actionFill = Color(0xFF2A7AA8);

  /// Blue as a text colour on navy (text buttons, links): lightened to 6.6:1.
  static const link = Color(0xFF6CB4E0);

  static const success = Color(0xFF4CC98A);
  static const warning = Color(0xFFF2B84B);
  static const info = Color(0xFF6CB4E0);

  /// Secondary text: mist at 70% over navy.
  static const onSurfaceMuted = Color(0xB3F5F5F5);

  /// Behind dialogs and sheets.
  static const scrim = Color(0x99000000);

  /// Gradient stops over poster art (detail header).
  static const posterShadeTop = Color(0x66000000);
  static const posterShadeClear = Color(0x00000000);
  static const posterShadeBottom = Color(0xCC1A2543);

  /// Icon buttons floating over poster art.
  static const overlayButton = Color(0x661A2543);

  /// KHQR brand red on the payment tile (brand mark, not a UI role).
  static const khqrRed = Color(0xFFE1232E);
}
