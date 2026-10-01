import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/catalog/model/release_countdown.dart';

void main() {
  final today = DateTime(2026, 10, 2, 23, 30); // late evening: time of day must not matter

  ReleaseCountdown? of(DateTime? d) => ReleaseCountdown.of(d, today);

  test('unknown release date shows nothing', () => expect(of(null), isNull));

  test('released today or earlier is out now', () {
    expect(of(DateTime(2026, 10, 2)), const ReleaseOutNow());
    expect(of(DateTime(2026, 9, 20)), const ReleaseOutNow());
  });

  test('the next calendar day is tomorrow, even 30 minutes away', () {
    expect(of(DateTime(2026, 10, 3)), const ReleaseTomorrow());
  });

  test('counts days up to the limit, then shows the date', () {
    expect(of(DateTime(2026, 10, 4)), const ReleaseInDays(2));
    expect(of(DateTime(2026, 10, 14)), const ReleaseInDays(12));
    expect(of(DateTime(2026, 12, 1)), const ReleaseInDays(60));
    expect(of(DateTime(2026, 12, 2)), ReleaseOn(DateTime(2026, 12, 2)));
  });

  test('compares calendar dates across a daylight-saving change', () {
    // A UTC-midnight release vs a local "today" still lands on whole days.
    expect(ReleaseCountdown.of(DateTime.utc(2026, 11, 3), DateTime(2026, 10, 30)), const ReleaseInDays(4));
  });
}
