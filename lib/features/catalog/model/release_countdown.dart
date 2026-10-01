/// How far away a coming-soon release is, for the carousel badge. Pure, so it is
/// unit-tested; the view turns it into localized text.
sealed class ReleaseCountdown {
  const ReleaseCountdown();

  /// More than this many days away shows the date instead of a count.
  static const maxCountdownDays = 60;

  /// Compares calendar dates only (the release date is a cinema-local date, so
  /// time of day and time zone offsets must not shift it by a day). Null when
  /// the release date is unknown.
  static ReleaseCountdown? of(DateTime? releaseDate, DateTime today) {
    if (releaseDate == null) return null;
    final release = DateTime.utc(releaseDate.year, releaseDate.month, releaseDate.day);
    final now = DateTime.utc(today.year, today.month, today.day);
    final days = release.difference(now).inDays;
    if (days <= 0) return const ReleaseOutNow();
    if (days == 1) return const ReleaseTomorrow();
    if (days <= maxCountdownDays) return ReleaseInDays(days);
    return ReleaseOn(releaseDate);
  }
}

final class ReleaseOutNow extends ReleaseCountdown {
  const ReleaseOutNow();
}

final class ReleaseTomorrow extends ReleaseCountdown {
  const ReleaseTomorrow();
}

final class ReleaseInDays extends ReleaseCountdown {
  const ReleaseInDays(this.days);

  final int days;

  @override
  bool operator ==(Object other) => other is ReleaseInDays && other.days == days;

  @override
  int get hashCode => days.hashCode;
}

final class ReleaseOn extends ReleaseCountdown {
  const ReleaseOn(this.date);

  final DateTime date;

  @override
  bool operator ==(Object other) => other is ReleaseOn && other.date == date;

  @override
  int get hashCode => date.hashCode;
}
