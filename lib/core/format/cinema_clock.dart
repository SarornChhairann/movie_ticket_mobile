/// The cinema's wall clock (contract 4): show dates and times are
/// `Asia/Phnom_Penh` wall-clock values and are never converted through the
/// device's time zone. Cambodia is UTC+7 all year (no daylight saving), so "now
/// at the cinema" is UTC + 7 h, compared as a plain wall-clock value.
abstract final class CinemaClock {
  static const offset = Duration(hours: 7);

  /// Now at the cinema, as a wall-clock `DateTime` comparable with
  /// `BookingSummary.showStart`.
  static DateTime now([DateTime? instant]) {
    final utc = (instant ?? DateTime.now()).toUtc().add(offset);
    return DateTime(utc.year, utc.month, utc.day, utc.hour, utc.minute, utc.second);
  }
}
