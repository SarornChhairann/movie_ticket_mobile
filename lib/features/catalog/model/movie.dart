import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';

enum MovieTab { nowShowing, comingSoon }

extension MovieTabApi on MovieTab {
  /// The `tab` query value `GET /movies` expects.
  String get apiValue => switch (this) {
        MovieTab.nowShowing => 'NOW_SHOWING',
        MovieTab.comingSoon => 'COMING_SOON',
      };
}

@freezed
abstract class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    String? description,
    String? genre,
    String? director,
    String? language,
    String? format,
    String? cast,
    String? trailerUrl,
    String? rating,
    DateTime? releaseDate,
    int? durationMinutes,
    required bool comingSoon,
    String? posterUrl,
    String? bannerUrl,
  }) = _Movie;
}

@freezed
abstract class ShowtimeSlot with _$ShowtimeSlot {
  const factory ShowtimeSlot({
    required int id,

    /// `HH:mm`, cinema local time.
    required String time,
    required String hallName,
    required String cinemaName,
    required bool dolby,
    required bool screenX,

    /// Hint only; the quote is computed by the server.
    num? normalPrice,
  }) = _ShowtimeSlot;
}

/// A now-showing movie with its showtimes on one date (Home's Showing rail).
@freezed
abstract class ShowingMovie with _$ShowingMovie {
  const ShowingMovie._();

  const factory ShowingMovie({required Movie movie, required List<ShowtimeSlot> slots}) = _ShowingMovie;

  bool get dolby => slots.any((s) => s.dolby);

  bool get screenX => slots.any((s) => s.screenX);
}

@freezed
abstract class HallGroup with _$HallGroup {
  const factory HallGroup({
    required String hallName,
    required bool dolby,
    required bool screenX,
    required List<ShowtimeSlot> slots,
  }) = _HallGroup;
}

@freezed
abstract class CinemaGroup with _$CinemaGroup {
  const factory CinemaGroup({required String cinemaName, required List<HallGroup> halls}) =
      _CinemaGroup;
}

@freezed
abstract class MovieDetail with _$MovieDetail {
  const factory MovieDetail({
    required Movie movie,
    required List<DateTime> availableDates,
    DateTime? selectedDate,
    required List<CinemaGroup> cinemas,
  }) = _MovieDetail;
}
