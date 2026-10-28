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
      expect(shown.bottom, greaterThanOrEqualTo(layout.size.height - 0.5));
      expect(m.getMaxScaleOnAxis(), lessThanOrEqualTo(1));
    });

    test('screenY follows rows under the fit', () {
      final m = SeatFocus.fit(viewport, layout.size);
      final rowE = layout.rowCentres[5]!;
      expect(SeatFocus.screenY(m, rowE), closeTo(rowE * m.storage[5] + m.getTranslation().y, 0.01));
    });
  });
}
