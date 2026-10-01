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
}

/// Corner radii: 16 on search and cards, 24 on primary buttons; chips are pills.
abstract final class Radii {
  static const double card = 16;
  static const double button = 24;
}
