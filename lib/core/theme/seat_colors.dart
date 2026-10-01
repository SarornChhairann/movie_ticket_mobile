import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Seat map tokens. "held" is a UI state from `seat_holds`, not a seat status; the
/// only seat statuses are `AVAILABLE` and `BOOKED`. Couple seats use the same
/// states and are drawn wider.
@immutable
class SeatColors extends ThemeExtension<SeatColors> {
  const SeatColors({
    required this.outline,
    required this.selected,
    required this.booked,
    required this.heldFill,
    required this.heldOutline,
  });

  /// Available: white outline on navy. Selected: blue fill. Booked: muted white
  /// fill. Held by others: dim fill plus a dimmer outline (distinct from booked).
  static const dark = SeatColors(
    outline: AppColors.white,
    selected: AppColors.blue,
    booked: Color(0x66F5F5F5),
    heldFill: Color(0x26F5F5F5),
    heldOutline: Color(0x80F5F5F5),
  );

  final Color outline;
  final Color selected;
  final Color booked;
  final Color heldFill;
  final Color heldOutline;

  @override
  SeatColors copyWith({Color? outline, Color? selected, Color? booked, Color? heldFill, Color? heldOutline}) =>
      SeatColors(
        outline: outline ?? this.outline,
        selected: selected ?? this.selected,
        booked: booked ?? this.booked,
        heldFill: heldFill ?? this.heldFill,
        heldOutline: heldOutline ?? this.heldOutline,
      );

  @override
  SeatColors lerp(ThemeExtension<SeatColors>? other, double t) {
    if (other is! SeatColors) return this;
    return SeatColors(
      outline: Color.lerp(outline, other.outline, t)!,
      selected: Color.lerp(selected, other.selected, t)!,
      booked: Color.lerp(booked, other.booked, t)!,
      heldFill: Color.lerp(heldFill, other.heldFill, t)!,
      heldOutline: Color.lerp(heldOutline, other.heldOutline, t)!,
    );
  }
}
