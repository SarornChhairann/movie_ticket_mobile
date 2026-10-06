import 'package:freezed_annotation/freezed_annotation.dart';

part 'hall.freezed.dart';

/// A hall as the customer sees it. Names, cities, and amenities stay as stored.
@freezed
abstract class Hall with _$Hall {
  const factory Hall({
    required int id,
    required String name,

    /// `ATMOS`, `STANDARD`, or whatever the server sent.
    String? type,
    String? city,
    String? address,
    int? totalSeats,
    @Default(false) bool dolby,
    @Default(false) bool screenX,
    String? amenities,
    required String cinemaId,
    required String cinemaName,
    String? openingHours,
  }) = _Hall;
}

/// One cinema's halls on Home. [city] is set only when every hall shares it;
/// otherwise each row shows its own city.
@freezed
abstract class HallGroup with _$HallGroup {
  const factory HallGroup({
    required String cinemaId,
    required String cinemaName,
    String? city,
    required List<Hall> halls,
  }) = _HallGroup;
}

/// One bookable showtime at a hall. [time] is `HH:mm`, cinema-local as sent.
@freezed
abstract class HallShowtime with _$HallShowtime {
  const factory HallShowtime({
    required int id,
    required DateTime date,
    required String time,
    required int movieId,
    required String movieTitle,
    String? posterUrl,
    num? normalPrice,
    num? couplePrice,
  }) = _HallShowtime;
}

@freezed
abstract class HallSchedule with _$HallSchedule {
  const HallSchedule._();

  const factory HallSchedule({
    required Hall hall,
    required List<DateTime> availableDates,
    DateTime? selectedDate,
    required List<HallShowtime> showtimes,
  }) = _HallSchedule;

  /// The selected date's showtimes grouped by movie, in first-showing order.
  List<List<HallShowtime>> get byMovie {
    final groups = <int, List<HallShowtime>>{};
    for (final s in showtimes) {
      groups.putIfAbsent(s.movieId, () => []).add(s);
    }
    return groups.values.toList();
  }
}

/// Home hall filter: the search text matches hall name, cinema name, or city
/// (case-insensitive), and every selected hall filter matches: [city] exact
/// trim match, [type] exact match, [dolbyOnly] / [screenXOnly] when on.
/// Movie filters are not inputs here, so they never hide halls.
List<Hall> filterHalls(
  List<Hall> halls,
  String query, {
  String? city,
  String? type,
  bool dolbyOnly = false,
  bool screenXOnly = false,
}) {
  final q = query.trim().toLowerCase();
  bool has(String? v) => v != null && v.toLowerCase().contains(q);
  return [
    for (final h in halls)
      if ((q.isEmpty || has(h.name) || has(h.cinemaName) || has(h.city)) &&
          (city == null || h.city?.trim() == city) &&
          (type == null || h.type == type) &&
          (!dolbyOnly || h.dolby) &&
          (!screenXOnly || h.screenX))
        h,
  ];
}
