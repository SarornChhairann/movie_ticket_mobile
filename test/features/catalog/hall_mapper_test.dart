import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/catalog/model/dto/hall_dtos.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_mapper.dart';

import 'hall_fixtures.dart';

void main() {
  test('groups by cinema in server order and keeps hall order', () {
    final groups = HallMapper.groupByCinema(testHalls);

    expect(groups.map((g) => g.cinemaId), ['c-legend', 'c-major']);
    expect(groups.first.halls.map((h) => h.id), [1, 2]);
    expect(groups.first.cinemaName, 'រោងភាពយន្ត Legend Aeon Sen Sok');
  });

  test('city sits on the group only when every hall shares it', () {
    final mixed = HallMapper.groupByCinema([senSokAtmos, senSokStandard.copyWith(city: 'កណ្ដាល')]);
    expect(HallMapper.groupByCinema(testHalls).first.city, 'ភ្នំពេញ');
    expect(mixed.single.city, isNull);
  });

  test('a list row keeps every field as sent', () {
    final hall = HallMapper.hall(HallDto.fromJson(hallJson()));

    expect(hall.name, 'Legend Sen Sok · Atmos');
    expect(hall.dolby, isTrue);
    expect(hall.screenX, isFalse);
    expect(hall.totalSeats, 60);
    expect(hall.openingHours, '09:00 - 23:00');
    expect(hall.amenities, 'Dolby Atmos, អេក្រង់ 4K');
  });

  test('schedule: absolute poster URL, HH:mm times, blocked row dropped', () {
    final schedule = HallMapper.schedule(HallScheduleDto.fromJson(scheduleJson()), 'http://api.test/');

    expect(schedule.selectedDate, DateTime(2026, 10, 7));
    expect(schedule.availableDates, [DateTime(2026, 10, 7), DateTime(2026, 10, 8)]);
    expect(schedule.showtimes.map((s) => s.id), [11, 12, 13]);
    expect(schedule.showtimes.first.posterUrl, 'http://api.test/uploads/movies/dune.jpg');
    expect(schedule.showtimes.map((s) => s.time), ['10:00', '13:30', '19:15']);
    expect(schedule.byMovie.map((g) => g.map((s) => s.id).toList()), [
      [11, 13],
      [12],
    ]);
  });

  test('search matches hall name, cinema name, or city, ignoring case', () {
    expect(filterHalls(testHalls, 'atmos').map((h) => h.id), [1]);
    expect(filterHalls(testHalls, 'MAJOR').map((h) => h.id), [3]);
    expect(filterHalls(testHalls, 'ភ្នំពេញ').map((h) => h.id), [1, 2]);
    expect(filterHalls(testHalls, '  '), testHalls);
    expect(filterHalls(testHalls, 'nowhere'), isEmpty);
  });
}
