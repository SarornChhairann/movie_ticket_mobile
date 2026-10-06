/// 8px spacing scale.
abstract final class Space {
  static const double x0_5 = 4;
  static const double x1 = 8;
  static const double x2 = 16;
  static const double x3 = 24;
  static const double x4 = 32;
  static const double x6 = 48;

  /// Side margin of full screens.
  static const double screen = 20;

  /// Gap between poster cards in rails and grids.
  static const double posterGap = 16;

  /// Smallest touch target on any platform (WCAG 2.2 / Material).
  static const double minTarget = 48;
}

/// Corner radii (sprint 15): sm 8, card 16, button 24, sheet 28; chips are pills.
abstract final class Radii {
  static const double sm = 8;
  static const double card = 16;
  static const double button = 24;
  static const double sheet = 28;
  static const double pill = 999;
}

/// Padding presets so views do not re-decide them.
abstract final class Insets {
  static const double screen = Space.screen;
  static const double card = Space.x2;
  static const double tileH = Space.x2;
  static const double tileV = Space.x1 + Space.x0_5;
  static const double banner = Space.x1;
}
