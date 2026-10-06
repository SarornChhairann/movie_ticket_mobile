import 'dart:ui';

import 'couple_pairing.dart';
import 'seat_map.dart';

/// Where every seat sits on the seat canvas, computed — not measured — from
/// the same sizes the tiles use (sprint 17). Rows are centred under the screen,
/// couple halves sit flush, the canvas is at least as wide as the viewport.
class SeatLayout {
  SeatLayout._(this.size, this.seatRects, this.rowCentres, this.rowLetters);

  static const normalWidth = 30.0;
  static const coupleWidth = 40.0;
  static const seatHeight = 30.0;
  static const gap = 3.0;
  static const padding = 16.0;
  static const rowHeight = seatHeight + gap * 2;

  /// The whole canvas.
  final Size size;

  /// Seat id → its rect on the canvas (the chair, without the gap).
  final Map<int, Rect> seatRects;

  /// Row number → the vertical centre of that row on the canvas.
  final Map<int, double> rowCentres;

  /// Row number → its letter (from the seat codes), for the sticky labels.
  final Map<int, String> rowLetters;

  /// Rows of [seats] in row order, each sorted by number.
  static List<List<SeatView>> rowsOf(List<SeatView> seats) {
    final rows = <int, List<SeatView>>{};
    for (final seat in seats) {
      rows.putIfAbsent(seat.row, () => []).add(seat);
    }
    final keys = rows.keys.toList()..sort();
    return [for (final k in keys) rows[k]!..sort((a, b) => a.number.compareTo(b.number))];
  }

  static double _slot(SeatView seat) => seat.couple ? coupleWidth + gap : normalWidth + gap * 2;

  factory SeatLayout.of(List<SeatView> seats, {double minWidth = 0}) {
    final rows = rowsOf(seats);
    final widths = [for (final row in rows) row.fold(0.0, (w, s) => w + _slot(s))];
    final widest = widths.isEmpty ? 0.0 : widths.reduce((a, b) => a > b ? a : b);
    final width = (widest + padding * 2) < minWidth ? minWidth : widest + padding * 2;
    final height = rows.length * rowHeight + padding * 2;
    final rects = <int, Rect>{};
    final centres = <int, double>{};
    final letters = <int, String>{};
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final top = padding + i * rowHeight;
      var x = (width - widths[i]) / 2;
      for (final seat in row) {
        final slot = _slot(seat);
        final chairWidth = seat.couple ? coupleWidth : normalWidth;
        // A left couple half has its gap on the left; a right half on the right.
        final left = seat.couple ? (seat.number.isOdd ? x + gap : x) : x + gap;
        rects[seat.id] = Rect.fromLTWH(left, top + gap, chairWidth, seatHeight);
        x += slot;
      }
      if (row.isNotEmpty) {
        centres[row.first.row] = top + rowHeight / 2;
        letters[row.first.row] = SeatCode.tryParse(row.first.code)?.row ?? '${row.first.row}';
      }
    }
    return SeatLayout._(Size(width, height), rects, centres, letters);
  }

  /// The smallest rect around [ids], or null when none are laid out.
  Rect? boundsOf(Iterable<int> ids) {
    Rect? bounds;
    for (final id in ids) {
      final r = seatRects[id];
      if (r == null) continue;
      bounds = bounds == null ? r : bounds.expandToInclude(r);
    }
    return bounds;
  }
}
