import 'catalog_mapper.dart';
import 'dto/hall_dtos.dart';
import 'hall.dart';

/// Hall DTO → entity. Pure; keeps the server's order.
abstract final class HallMapper {
  static Hall hall(HallDto dto) => Hall(
        id: dto.id,
        name: dto.name,
        type: _blankToNull(dto.type),
        city: _blankToNull(dto.city),
        address: _blankToNull(dto.address),
        totalSeats: dto.totalSeats,
        dolby: dto.hasDolbyAtmos,
        screenX: dto.hasScreenX,
        amenities: _blankToNull(dto.amenities),
        cinemaId: dto.cinemaId ?? '',
        cinemaName: dto.cinemaName ?? '',
        openingHours: _blankToNull(dto.openingHours),
      );

  /// Groups by `cinemaId` in first-appearance order; halls keep their order.
  static List<HallGroup> groupByCinema(List<Hall> halls) {
    final groups = <String, List<Hall>>{};
    for (final h in halls) {
      groups.putIfAbsent(h.cinemaId, () => []).add(h);
    }
    return [
      for (final entry in groups.entries)
        HallGroup(
          cinemaId: entry.key,
          cinemaName: entry.value.first.cinemaName,
          city: entry.value.map((h) => h.city).toSet().length == 1 ? entry.value.first.city : null,
          halls: entry.value,
        ),
    ];
  }

  static HallSchedule schedule(HallScheduleDto dto, String baseUrl) => HallSchedule(
        hall: hall(dto.hall),
        availableDates: dto.availableDates.map(DateTime.tryParse).whereType<DateTime>().toList(),
        selectedDate: dto.selectedDate == null ? null : DateTime.tryParse(dto.selectedDate!),
        showtimes: [
          for (final s in dto.showtimes)
            if (!s.blocked && DateTime.tryParse(s.showDate) != null)
              HallShowtime(
                id: s.id,
                date: DateTime.parse(s.showDate),
                time: _hhmm(s.showTime),
                movieId: s.movieId,
                movieTitle: s.movieTitle,
                posterUrl: CatalogMapper.imageUrl(s.imagePath, baseUrl),
                normalPrice: s.normalPrice,
                couplePrice: s.couplePrice,
              ),
        ],
      );

  /// `19:30:00` → `19:30`; never shifted by the device zone.
  static String _hhmm(String? time) =>
      (time == null || time.length < 5) ? (time ?? '') : time.substring(0, 5);

  static String? _blankToNull(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
}
