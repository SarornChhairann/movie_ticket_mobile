import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';

const senSokAtmos = Hall(
  id: 1,
  name: 'Legend Sen Sok · Atmos',
  type: 'ATMOS',
  city: 'ភ្នំពេញ',
  totalSeats: 60,
  dolby: true,
  amenities: 'Dolby Atmos, អេក្រង់ 4K',
  cinemaId: 'c-legend',
  cinemaName: 'រោងភាពយន្ត Legend Aeon Sen Sok',
  openingHours: '09:00 - 23:00',
);
const senSokStandard = Hall(
  id: 2,
  name: 'Legend Sen Sok · Standard',
  type: 'STANDARD',
  city: 'ភ្នំពេញ',
  totalSeats: 80,
  cinemaId: 'c-legend',
  cinemaName: 'រោងភាពយន្ត Legend Aeon Sen Sok',
);
const majorSiemReap = Hall(
  id: 3,
  name: 'Major Siem Reap · IMAX',
  type: 'IMAX',
  city: 'សៀមរាប',
  totalSeats: 120,
  screenX: true,
  cinemaId: 'c-major',
  cinemaName: 'Major Cineplex Siem Reap',
);

const testHalls = [senSokAtmos, senSokStandard, majorSiemReap];

Map<String, dynamic> hallJson({int id = 1, String cinemaId = 'c-legend', String name = 'Legend Sen Sok · Atmos'}) => {
      'id': id,
      'name': name,
      'type': 'ATMOS',
      'city': 'ភ្នំពេញ',
      'address': 'Sen Sok',
      'totalSeats': 60,
      'hasDolbyAtmos': true,
      'hasScreenX': false,
      'amenities': 'Dolby Atmos, អេក្រង់ 4K',
      'cinemaId': cinemaId,
      'cinemaName': 'Cinema $cinemaId',
      'openingHours': '09:00 - 23:00',
    };

Map<String, dynamic> scheduleJson() => {
      'hall': hallJson(),
      'availableDates': ['2026-10-07', '2026-10-08'],
      'selectedDate': '2026-10-07',
      'showtimes': [
        {
          'id': 11,
          'showDate': '2026-10-07',
          'showTime': '10:00:00',
          'movieId': 5,
          'movieTitle': 'Dune',
          'imagePath': '/uploads/movies/dune.jpg',
          'normalPrice': 5.0,
          'couplePrice': 8.5,
        },
        {
          'id': 12,
          'showDate': '2026-10-07',
          'showTime': '13:30:00',
          'movieId': 6,
          'movieTitle': 'Tenet',
          'imagePath': null,
          'normalPrice': 6,
          'couplePrice': 10,
        },
        {
          'id': 13,
          'showDate': '2026-10-07',
          'showTime': '19:15:00',
          'movieId': 5,
          'movieTitle': 'Dune',
          'imagePath': '/uploads/movies/dune.jpg',
          'normalPrice': 5.0,
          'couplePrice': 8.5,
        },
        {
          'id': 14,
          'showDate': '2026-10-07',
          'showTime': '21:00:00',
          'movieId': 5,
          'movieTitle': 'Dune',
          'blocked': true,
        },
      ],
    };
