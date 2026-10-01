import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_mapper.dart';
import 'package:movie_ticket_mobile/features/catalog/model/dto/catalog_response_dtos.dart';
import 'package:movie_ticket_mobile/features/catalog/model/dto/movie_dto.dart';

import 'catalog_fixtures.dart';

void main() {
  const base = 'http://10.0.2.2:8010';

  test('movie maps fields and builds an absolute poster URL', () {
    final movie = CatalogMapper.movie(MovieDto.fromJson(movieJson()), base);

    expect(movie.posterUrl, 'http://10.0.2.2:8010/uploads/movies/dune.jpg');
    expect(movie.bannerUrl, isNull);
    expect(movie.releaseDate, DateTime(2026, 9, 20));
    expect(movie.comingSoon, isFalse);
  });

  test('imageUrl keeps absolute URLs and handles a trailing slash on the base', () {
    expect(CatalogMapper.imageUrl('https://cdn/x.jpg', base), 'https://cdn/x.jpg');
    expect(CatalogMapper.imageUrl('uploads/a.jpg', '$base/'), '$base/uploads/a.jpg');
  });

  test('detail groups the selected date by cinema then hall, sorted, without blocked slots', () {
    final detail = CatalogMapper.detail(MovieDetailResponseDto.fromJson(detailJson()), base);

    expect(detail.availableDates, [DateTime(2026, 10, 2), DateTime(2026, 10, 3)]);
    expect(detail.cinemas.map((c) => c.cinemaName), ['Aeon', 'Legend']);

    final legend = detail.cinemas[1];
    expect(legend.halls.map((h) => h.hallName), ['Hall 1', 'Hall 2']);
    expect(legend.halls[0].slots.map((s) => s.time), ['13:00', '19:30']);
    expect(legend.halls[0].slots.map((s) => s.id), isNot(contains(4)));
  });
}
