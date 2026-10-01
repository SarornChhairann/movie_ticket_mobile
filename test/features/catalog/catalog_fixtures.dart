Map<String, dynamic> movieJson({int id = 1, String status = 'NOW_SHOWING', String title = 'Dune'}) => {
      'id': id,
      'title': title,
      'description': 'Desert planet.',
      'genre': 'Sci-Fi',
      'director': 'Denis Villeneuve',
      'language': 'English',
      'format': '2D',
      'cast': 'Timothée Chalamet',
      'trailerUrl': 'https://example.com/t',
      'rating': 'PG-13',
      'releaseDate': '2026-09-20',
      'durationMinutes': 166,
      'status': status,
      'imagePath': '/uploads/movies/dune.jpg',
      'bannerPath': '',
      'createdAt': '2026-09-01T10:00:00',
    };

Map<String, dynamic> slotJson(
  int id,
  String time, {
  String cinema = 'Legend',
  String hall = 'Hall 1',
  bool blocked = false,
  bool dolby = false,
}) =>
    {
      'id': id,
      'showTime': time,
      'hallId': 1,
      'hallName': hall,
      'normalPrice': 6.5,
      'couplePrice': 12,
      'blocked': blocked,
      'cinemaName': cinema,
      'hasDolbyAtmos': dolby,
      'hasScreenX': false,
    };

Map<String, dynamic> detailJson() => {
      'movie': movieJson(),
      'showtimesByDate': {
        '2026-10-02': [
          slotJson(3, '21:00:00', hall: 'Hall 2'),
          slotJson(1, '19:30:00', dolby: true),
          slotJson(2, '13:00:00'),
          slotJson(4, '15:00:00', blocked: true),
          slotJson(5, '18:00:00', cinema: 'Aeon'),
        ],
      },
      'cities': ['Phnom Penh'],
      'selectedCity': null,
      'selectedCinemaId': null,
      'availableDates': ['2026-10-02', '2026-10-03'],
      'selectedDate': '2026-10-02',
      'availableHalls': [],
      'selectedHallId': null,
    };
