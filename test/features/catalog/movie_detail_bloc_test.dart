import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_detail_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late _MockCatalogRepository repository;
  final day1 = DateTime(2026, 10, 2);
  final day2 = DateTime(2026, 10, 3);

  MovieDetail detail(DateTime day, int slotId) => MovieDetail(
        movie: const Movie(id: 1, title: 'Dune', comingSoon: false),
        availableDates: [day1, day2],
        selectedDate: day,
        cinemas: [
          CinemaGroup(cinemaName: 'Legend', halls: [
            HallGroup(hallName: 'Hall 1', dolby: false, screenX: false, slots: [
              ShowtimeSlot(id: slotId, time: '19:30', hallName: 'Hall 1', cinemaName: 'Legend', dolby: false, screenX: false),
            ]),
          ]),
        ],
      );

  setUp(() => repository = _MockCatalogRepository());

  blocTest<MovieDetailBloc, MovieDetailState>(
    'selects a real showtime and ignores an unknown id',
    build: () => MovieDetailBloc(repository),
    seed: () => MovieDetailState.ready(detail(day1, 42)),
    act: (bloc) => bloc
      ..add(const ShowtimeSelected(999))
      ..add(const ShowtimeSelected(42)),
    expect: () => [MovieDetailState.ready(detail(day1, 42), selectedShowtimeId: 42)],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'a new date clears the selection',
    setUp: () {
      when(() => repository.fetchDetail(1)).thenAnswer((_) async => Ok(detail(day1, 42)));
      when(() => repository.fetchDetail(1, date: day2)).thenAnswer((_) async => Ok(detail(day2, 43)));
    },
    build: () => MovieDetailBloc(repository),
    act: (bloc) async {
      bloc.add(const DetailRequested(1));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const ShowtimeSelected(42));
      await Future<void>.delayed(Duration.zero);
      bloc.add(DateSelected(day2));
    },
    skip: 2,
    expect: () => [
      MovieDetailState.ready(detail(day1, 42), selectedShowtimeId: 42),
      MovieDetailState.ready(detail(day1, 42), refreshing: true),
      MovieDetailState.ready(detail(day2, 43)),
    ],
  );
}
