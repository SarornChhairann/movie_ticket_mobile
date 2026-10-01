import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/seats/model/couple_pairing.dart';

void main() {
  test('partner of an odd seat is the next one, of an even seat the previous one', () {
    expect(CouplePairing.partnerCode('A1'), 'A2');
    expect(CouplePairing.partnerCode('A2'), 'A1');
    expect(CouplePairing.partnerCode('c13'), 'C14');
    expect(CouplePairing.partnerCode('??'), isNull);
  });

  test('valid pairs are (odd, odd+1) in the same row', () {
    expect(CouplePairing.validPairs(['A1', 'A2']), isTrue);
    expect(CouplePairing.validPairs(['A3', 'A4', 'B1', 'B2']), isTrue);
    expect(CouplePairing.validPairs(<String>[]), isTrue);
  });

  test('lone seats, even-start pairs, and cross-row pairs are invalid', () {
    expect(CouplePairing.validPairs(['A1']), isFalse);
    expect(CouplePairing.validPairs(['A2', 'A3']), isFalse);
    expect(CouplePairing.validPairs(['A1', 'B2']), isFalse);
    expect(CouplePairing.validPairs(['A1', 'A3']), isFalse);
  });
}
