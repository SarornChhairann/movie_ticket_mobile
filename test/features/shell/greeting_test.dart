import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/shell/model/greeting.dart';

void main() {
  group('time of day by the cinema clock (UTC+7)', () {
    // Cinema hour → expected part; the instant is that hour in UTC minus 7.
    const table = {
      0: DayPart.morning,
      6: DayPart.morning,
      11: DayPart.morning,
      12: DayPart.afternoon,
      17: DayPart.afternoon,
      18: DayPart.evening,
      23: DayPart.evening,
    };
    for (final MapEntry(key: hour, value: part) in table.entries) {
      test('$hour:00 at the cinema is ${part.name}', () {
        final instant = DateTime.utc(2026, 10, 7, hour).subtract(const Duration(hours: 7));
        expect(dayPartAt(instant), part);
      });
    }

    test('the phone zone does not matter: the same instant from another offset', () {
      // 11:59 at the cinema, written as an instant in UTC-5 terms (the same moment).
      final cinemaMorning = DateTime.utc(2026, 10, 7, 4, 59);
      expect(dayPartAt(cinemaMorning), DayPart.morning);
      expect(dayPartAt(cinemaMorning.toLocal()), DayPart.morning, reason: 'toLocal is the same instant');
      // 12:00 UTC is 19:00 at the cinema even where the device says noon.
      expect(dayPartAt(DateTime.utc(2026, 10, 7, 12)), DayPart.evening);
    });
  });

  group('keys', () {
    for (final signedIn in [true, false]) {
      for (final part in DayPart.values) {
        test('${part.name}, ${signedIn ? 'signed in' : 'guest'}', () {
          expect(
            greetingKey(part, named: signedIn),
            'home.greeting.${part.name}.${signedIn ? 'named' : 'plain'}',
          );
        });
      }
    }
  });

  test('first name is the first word of the profile name', () {
    expect(firstName('Dara Sok'), 'Dara');
    expect(firstName('  Sophea  '), 'Sophea');
    expect(firstName(''), isNull);
    expect(firstName(null), isNull);
  });
}
