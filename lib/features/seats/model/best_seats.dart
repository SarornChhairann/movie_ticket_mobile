import 'couple_pairing.dart';
import 'seat_map.dart';

/// "Best seats" (sprint 14): [count] side-by-side seats in one row, none booked or
/// held ([unavailable]), as close to the middle row and the row's centre as possible.
///
/// Normal seats are tried first. Only when no row has a normal block, an even
/// [count] may use couple seats, and only as whole `(odd, odd+1)` pairs. Returns the
/// showtime seat ids, or null when nothing fits in one row. A suggestion only: the
/// server hold decides.
List<int>? bestSeats(List<SeatView> seats, {required int count, required Set<int> unavailable}) {
  if (count < 1) return null;
  final normal = _bestBlock(seats.where((s) => !s.couple).toList(), seats, count, unavailable, couple: false);
  if (normal != null) return normal;
  if (count.isOdd) return null;
  return _bestBlock(seats.where((s) => s.couple).toList(), seats, count, unavailable, couple: true);
}

List<int>? _bestBlock(
  List<SeatView> candidates,
  List<SeatView> all,
  int count,
  Set<int> unavailable, {
  required bool couple,
}) {
  if (all.isEmpty) return null;
  final rows = {for (final s in all) s.row}.toList()..sort();
  final middleRow = (rows.first + rows.last) / 2;

  List<int>? best;
  (double, double)? bestScore;
  for (final row in rows) {
    final inRow = all.where((s) => s.row == row).toList();
    final rowNumbers = inRow.map((s) => s.number);
    final rowCentre = (rowNumbers.reduce((a, b) => a < b ? a : b) + rowNumbers.reduce((a, b) => a > b ? a : b)) / 2;
    final free = candidates.where((s) => s.row == row && !unavailable.contains(s.id)).toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    for (var i = 0; i + count <= free.length; i++) {
      final block = free.sublist(i, i + count);
      final adjacent = [for (var j = 1; j < block.length; j++) block[j].number - block[j - 1].number == 1].every((x) => x);
      if (!adjacent) continue;
      if (couple && !CouplePairing.validPairs(block.map((s) => s.code))) continue;
      final blockCentre = (block.first.number + block.last.number) / 2;
      final score = ((row - middleRow).abs(), (blockCentre - rowCentre).abs());
      if (bestScore == null || score.$1 < bestScore.$1 || (score.$1 == bestScore.$1 && score.$2 < bestScore.$2)) {
        best = [for (final s in block) s.id];
        bestScore = score;
      }
    }
  }
  return best;
}
