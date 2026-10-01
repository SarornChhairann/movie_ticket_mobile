/// Client copy of the couple-seat rule (analytics 3.4): couple seats sell only
/// as same-row `(odd, odd+1)` pairs such as `A1+A2`. This is a view guard; the
/// server result wins.
class SeatCode {
  const SeatCode(this.row, this.number);

  static final _pattern = RegExp(r'^([A-Za-z]+)(\d+)$');

  final String row;
  final int number;

  static SeatCode? tryParse(String code) {
    final m = _pattern.firstMatch(code.trim());
    return m == null ? null : SeatCode(m.group(1)!.toUpperCase(), int.parse(m.group(2)!));
  }

  @override
  String toString() => '$row$number';
}

abstract final class CouplePairing {
  /// The code of [code]'s partner: `A1` → `A2`, `A2` → `A1`. Null if unparsable.
  static String? partnerCode(String code) {
    final c = SeatCode.tryParse(code);
    if (c == null || c.number < 1) {
      return null;
    }
    final partner = c.number.isOdd ? c.number + 1 : c.number - 1;
    return '${c.row}$partner';
  }

  /// Whether [coupleCodes] form complete `(odd, odd+1)` pairs within each row.
  static bool validPairs(Iterable<String> coupleCodes) {
    final byRow = <String, List<int>>{};
    for (final code in coupleCodes) {
      final c = SeatCode.tryParse(code);
      if (c == null) {
        return false;
      }
      byRow.putIfAbsent(c.row, () => []).add(c.number);
    }
    for (final numbers in byRow.values) {
      numbers.sort();
      if (numbers.length.isOdd) {
        return false;
      }
      for (var i = 0; i < numbers.length; i += 2) {
        if (numbers[i].isEven || numbers[i + 1] != numbers[i] + 1) {
          return false;
        }
      }
    }
    return true;
  }
}
