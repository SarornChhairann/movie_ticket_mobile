import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';

class MockShowing extends MockCubit<ShowingState> implements ShowingCubit {}

final showingDates = [for (var d = 7; d < 14; d++) DateTime(2026, 10, d)];

/// Home's Showing rail in a fixed state; [movies] empty shows the "No shows" note.
ShowingCubit showingStub({List<ShowingMovie> movies = const [], ShowingState? state}) {
  registerFallbackValue(DateTime(2026));
  final cubit = MockShowing();
  whenListen(
    cubit,
    const Stream<ShowingState>.empty(),
    initialState: state ?? ShowingState.ready(dates: showingDates, date: showingDates.first, movies: movies),
  );
  when(cubit.load).thenAnswer((_) async {});
  when(() => cubit.dateSelected(any())).thenAnswer((_) async {});
  return cubit;
}

/// Two movies with times, one in a Dolby hall.
const showingMovies = [
  ShowingMovie(
    movie: Movie(id: 1, title: 'Dune', comingSoon: false, durationMinutes: 155, rating: 'PG-13', genre: 'Sci-Fi'),
    slots: [
      ShowtimeSlot(id: 101, time: '19:30', hallName: 'Hall 3', cinemaName: 'Legend', dolby: true, screenX: false),
      ShowtimeSlot(id: 102, time: '21:45', hallName: 'Hall 3', cinemaName: 'Legend', dolby: true, screenX: false),
    ],
  ),
  ShowingMovie(
    movie: Movie(id: 3, title: 'Heat', comingSoon: false, durationMinutes: 170, rating: 'R'),
    slots: [ShowtimeSlot(id: 301, time: '20:00', hallName: 'Hall 1', cinemaName: 'Legend', dolby: false, screenX: false)],
  ),
];
