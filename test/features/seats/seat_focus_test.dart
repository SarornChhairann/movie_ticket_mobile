import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_layout.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map.dart';
import 'package:movie_ticket_mobile/features/seats/view/seat_focus_controller.dart';

/// Rows A–J (1–10) of 20 normal seats, ids `row * 100 + n`; row K (11) has 4 couple seats.
List<SeatView> hall() => [
      for (var row = 1; row <= 10; row++)
        for (var n = 1; n <= 20; n++)
          SeatView(id: row * 100 + n, code: '${'ABCDEFGHIJ'[row - 1]}$n', row: row, number: n, couple: false, booked: false),
      for (var n = 1; n <= 4; n++) SeatView(id: 1100 + n, code: 'K$n', row: 11, number: n, couple: true, booked: false),
    ];

void main() {
  const viewport = Size(390, 420);
  final layout = SeatLayout.of(hall(), minWidth: viewport.width);

  group('SeatLayout', () {
    test('rows stack top to bottom; seats in a row are side by side', () {
      final a1 = layout.seatRects[101]!;
      final a2 = layout.seatRects[102]!;
      final b1 = layout.seatRects[201]!;
      expect(a2.left - a1.right, SeatLayout.gap * 2);
      expect(b1.top - a1.top, SeatLayout.rowHeight);
      expect(layout.rowLetters[1], 'A');
      expect(layout.rowLetters[11], 'K');
    });

    test('a short row is centred under the widest', () {
      final first = layout.seatRects[1101]!;
      final last = layout.seatRects[1104]!;
      expect((first.left + last.right) / 2, closeTo(layout.size.width / 2, 0.01));
    });

    test('couple halves sit flush into one loveseat', () {
      expect(layout.seatRects[1102]!.left, layout.seatRects[1101]!.right);
    });

    test('a small hall is at least viewport wide', () {
      final small = SeatLayout.of(hall().take(3).toList(), minWidth: 390);
      expect(small.size.width, 390);
    });
  });

  group('SeatFocus', () {
    test('fit shows the whole hall, centred, never enlarged', () {
      final m = SeatFocus.fit(viewport, layout.size);
      final shown = SeatFocus.visible(m, viewport);
      expect(shown.contains(Offset.zero), isTrue);
      expect(shown.right, greaterThanOrEqualTo(layout.size.width - 0.5));
      expect(m.getMaxScaleOnAxis(), lessThanOrEqualTo(1));
      expect(SeatFocus.zoomedIn(m, viewport, layout.size), isFalse);
    });

    test('a single seat is framed at the comfortable zoom, centred', () {
      final seat = layout.seatRects[310]!;
      final m = SeatFocus.focus(viewport, layout.size, seat);
      expect(m.getMaxScaleOnAxis(), SeatFocus.comfortableScale);
      final shown = SeatFocus.visible(m, viewport);
      expect(shown.center.dx, closeTo(seat.center.dx, 1));
      expect(shown.contains(seat.topLeft) && shown.contains(seat.bottomRight), isTrue);
      expect(SeatFocus.zoomedIn(m, viewport, layout.size), isTrue);
    });

    test('a block stays fully in view', () {
      final block = layout.boundsOf([505, 506, 507, 508, 509, 510])!;
      final shown = SeatFocus.visible(SeatFocus.focus(viewport, layout.size, block), viewport);
      expect(shown.contains(block.topLeft) && shown.contains(block.bottomRight), isTrue);
    });

    test('a seat at the row end is not centred past the canvas edge', () {
      final end = layout.seatRects[120]!;
      final shown = SeatFocus.visible(SeatFocus.focus(viewport, layout.size, end), viewport);
      expect(shown.right, lessThanOrEqualTo(layout.size.width + 0.5));
      expect(shown.contains(end.center), isTrue);
    });

    test('a couple pair is framed as one', () {
      final pair = layout.boundsOf([1101, 1102])!;
      final shown = SeatFocus.visible(SeatFocus.focus(viewport, layout.size, pair), viewport);
      expect(shown.contains(pair.topLeft) && shown.contains(pair.bottomRight), isTrue);
    });

    test('centreOn keeps the zoom and moves to the tapped point; screenY follows rows', () {
      final zoomed = SeatFocus.focus(viewport, layout.size, layout.seatRects[101]!);
      final moved = SeatFocus.centreOn(zoomed, viewport, layout.size, layout.seatRects[910]!.center);
      expect(moved.getMaxScaleOnAxis(), zoomed.getMaxScaleOnAxis());
      expect(SeatFocus.visible(moved, viewport).contains(layout.seatRects[910]!.center), isTrue);
      final rowE = layout.rowCentres[5]!;
      expect(SeatFocus.screenY(moved, rowE), closeTo(rowE * moved.getMaxScaleOnAxis() + moved.getTranslation().y, 0.01));
    });
  });
}
