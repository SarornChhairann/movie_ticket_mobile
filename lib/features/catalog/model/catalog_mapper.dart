import 'dto/catalog_response_dtos.dart';
import 'dto/movie_dto.dart';
import 'movie.dart';

/// DTO → entity. Pure functions; [baseUrl] turns the API's relative upload
/// paths (`/uploads/movies/...`) into absolute image URLs.
abstract final class CatalogMapper {
  static Movie movie(MovieDto dto, String baseUrl) => Movie(
        id: dto.id,
        title: dto.title,
        description: _blankToNull(dto.description),
        genre: _blankToNull(dto.genre),
        director: _blankToNull(dto.director),
        language: _blankToNull(dto.language),
        format: _blankToNull(dto.format),
        cast: _blankToNull(dto.cast),
        trailerUrl: _blankToNull(dto.trailerUrl),
        rating: _blankToNull(dto.rating),
        releaseDate: dto.releaseDate == null ? null : DateTime.tryParse(dto.releaseDate!),
        durationMinutes: dto.durationMinutes,
        comingSoon: dto.status == 'COMING_SOON',
        posterUrl: imageUrl(dto.imagePath, baseUrl),
        bannerUrl: imageUrl(dto.bannerPath, baseUrl),
      );

  static String? imageUrl(String? path, String baseUrl) {
    final p = _blankToNull(path);
    if (p == null) {
      return null;
    }
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return p;
    }
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    return p.startsWith('/') ? '$base$p' : '$base/$p';
  }

  static MovieDetail detail(MovieDetailResponseDto dto, String baseUrl) {
    final selected = dto.selectedDate == null ? null : DateTime.tryParse(dto.selectedDate!);
    final slots = selected == null
        ? const <ShowtimeSummaryDto>[]
        : dto.showtimesByDate[_isoDate(selected)] ?? const <ShowtimeSummaryDto>[];
    return MovieDetail(
      movie: movie(dto.movie, baseUrl),
      availableDates: dto.availableDates.map(DateTime.tryParse).whereType<DateTime>().toList(),
      selectedDate: selected,
      cinemas: groupByCinema(slots),
    );
  }

  /// Cinema → hall → slots, each sorted, blocked slots dropped.
  static List<CinemaGroup> groupByCinema(List<ShowtimeSummaryDto> dtos) {
    final byCinema = <String, Map<String, List<ShowtimeSummaryDto>>>{};
    for (final s in dtos.where((s) => !s.blocked)) {
      byCinema
          .putIfAbsent(s.cinemaName ?? '', () => {})
          .putIfAbsent(s.hallName ?? '', () => [])
          .add(s);
    }
    final cinemas = byCinema.entries.map((cinema) {
      final halls = cinema.value.entries.map((hall) {
        final slots = hall.value.map(_slot).toList()..sort((a, b) => a.time.compareTo(b.time));
        return HallGroup(
          hallName: hall.key,
          dolby: hall.value.first.hasDolbyAtmos,
          screenX: hall.value.first.hasScreenX,
          slots: slots,
        );
      }).toList()
        ..sort((a, b) => a.hallName.compareTo(b.hallName));
      return CinemaGroup(cinemaName: cinema.key, halls: halls);
    }).toList()
      ..sort((a, b) => a.cinemaName.compareTo(b.cinemaName));
    return cinemas;
  }

  static ShowtimeSlot _slot(ShowtimeSummaryDto s) => ShowtimeSlot(
        id: s.id,
        time: _hhmm(s.showTime),
        hallName: s.hallName ?? '',
        cinemaName: s.cinemaName ?? '',
        dolby: s.hasDolbyAtmos,
        screenX: s.hasScreenX,
        normalPrice: s.normalPrice,
      );

  /// `19:30:00` → `19:30`.
  static String _hhmm(String? time) =>
      (time == null || time.length < 5) ? (time ?? '') : time.substring(0, 5);

  static String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static String isoDate(DateTime d) => _isoDate(d);

  static String? _blankToNull(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
}
