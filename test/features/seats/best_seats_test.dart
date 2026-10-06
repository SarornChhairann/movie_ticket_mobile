import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/seats/model/best_seats.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map.dart';

/// Rows A–E (rows 1–5) of 8 normal seats, ids `row * 100 + number`, plus an optional couple row 6 (F1–F4).
List<SeatView> hall({bool coupleRow = false}) => [
      for (var row = 1; row <= 5; row++)
        for (var n = 1; n <= 8; n++)
          SeatView(id: row * 100 + n, code: '${'ABCDE'[row - 1]}$n', row: row, number: n, couple: false, booked: false),
      if (coupleRow)
        for (var n = 1; n <= 4; n++)
          SeatView(id: 600 + n, code: 'F$n', row: 6, number: n, couple: true, booked: false),
    ];

void main() {
  test('an empty hall gives the middle row, centred', () {
    expect(bestSeats(hall(), count: 2, unavailable: const {}), [304, 305]);
    expect(bestSeats(hall(), count: 3, unavailable: const {}), [303, 304, 305]);
  });

  test('taken seats are skipped: the block moves along the row, then to the next best row', () {
    expect(bestSeats(hall(), count: 2, unavailable: const {304}), [305, 306]);
    final middleRowFull = {for (var n = 1; n <= 8; n++) 300 + n};
    expect(bestSeats(hall(), count: 2, unavailable: middleRowFull), [204, 205]);
  });

  test('seats are side by side: a gap breaks the block', () {
    final gaps = {for (var row = 1; row <= 5; row++) for (final n in [3, 6]) row * 100 + n};
    // Every row is now 1-2, 4-5, 7-8: no three in a row anywhere.
    expect(bestSeats(hall(), count: 3, unavailable: gaps), isNull);
    expect(bestSeats(hall(), count: 2, unavailable: gaps), [304, 305]);
  });

  test('couple seats only when no normal block fits, and only as whole odd-even pairs', () {
    final allNormalTaken = {for (final s in hall()) s.id};
    expect(bestSeats(hall(coupleRow: true), count: 2, unavailable: allNormalTaken), [601, 602]);
    expect(bestSeats(hall(coupleRow: true), count: 2, unavailable: {...allNormalTaken, 601}), [603, 604],
        reason: 'F2+F3 is not a pair');
    expect(bestSeats(hall(coupleRow: true), count: 3, unavailable: allNormalTaken), isNull, reason: 'odd count');
    expect(bestSeats(hall(coupleRow: true), count: 2, unavailable: const {}), [304, 305], reason: 'normal first');
  });

  test('more than a row holds is no block', () {
    expect(bestSeats(hall(), count: 9, unavailable: const {}), isNull);
    expect(bestSeats(const [], count: 1, unavailable: const {}), isNull);
  });
}
