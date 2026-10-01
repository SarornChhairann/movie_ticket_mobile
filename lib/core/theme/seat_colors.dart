import 'package:flutter/material.dart';

/// Seat map color tokens. "held" is a UI state from `seat_holds`, not a seat
/// status; the only seat statuses are `AVAILABLE` and `BOOKED`.
@immutable
class SeatColors extends ThemeExtension<SeatColors> {
  const SeatColors({
    required this.available,
    required this.held,
    required this.selected,
    required this.booked,
    required this.couple,
  });

  static const light = SeatColors(
    available: Color(0xFFE0E4EA),
    held: Color(0xFFF2B84B),
    selected: Color(0xFF2E7D5B),
    booked: Color(0xFF9AA0A6),
    couple: Color(0xFFD9467A),
  );

  final Color available;
  final Color held;
  final Color selected;
  final Color booked;
  final Color couple;

  @override
  SeatColors copyWith({
    Color? available,
    Color? held,
    Color? selected,
    Color? booked,
    Color? couple,
  }) =>
      SeatColors(
        available: available ?? this.available,
        held: held ?? this.held,
        selected: selected ?? this.selected,
        booked: booked ?? this.booked,
        couple: couple ?? this.couple,
      );

  @override
  SeatColors lerp(ThemeExtension<SeatColors>? other, double t) {
    if (other is! SeatColors) {
      return this;
    }
    return SeatColors(
      available: Color.lerp(available, other.available, t)!,
      held: Color.lerp(held, other.held, t)!,
      selected: Color.lerp(selected, other.selected, t)!,
      booked: Color.lerp(booked, other.booked, t)!,
      couple: Color.lerp(couple, other.couple, t)!,
    );
  }
}
