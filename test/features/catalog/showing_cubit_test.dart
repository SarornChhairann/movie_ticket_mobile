import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/telemetry/journey_tracker.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

class _Recorder implements JourneyTracker {
  final events = <JourneyEvent>[];

  @override
  void track(JourneyEvent event) => events.add(event);
}

void main() {
  late _MockCatalogRepository repository;

  // 23:30 at the cinema on Oct 7.
  DateTime now() => DateTime(2026, 10, 7, 23, 30);
  final days = [for (var d = 7; d < 14; d++) DateTime(2026, 10, d)];
  const slot = ShowtimeSlot(id: 101, time: '23:45', hallName: 'Hall 3', cinemaName: 'Legend', dolby: false, screenX: false);
  const dune = ShowingMovie(movie: Movie(id: 1, title: 'Dune', comingSoon: false), slots: [slot]);

  setUpAll(() => registerFallbackValue(DateTime(2026)));
  setUp(() => repository = _MockCatalogRepository());

  void stub(DateTime date, Result<List<ShowingMovie>, ApiFailure> result) =>
      when(() => repository.fetchShowing(date)).thenAnswer((_) async => result);

  ShowingCubit build({JourneyTracker tracker = const NoopJourneyTracker()}) =>
      ShowingCubit(repository, tracker: tracker, now: now);

  test('the strip is today at the cinema plus six days', () {
    expect(build().stripDates(), days);
  });

  test('the strip follows the cinema clock, not the device zone', () {
    // 18:00 UTC on Oct 7 is already Oct 8 01:00 in Phnom Penh.
    final cubit = ShowingCubit(repository, now: () => DateTime.utc(2026, 10, 7, 18).add(const Duration(hours: 7)));
    expect(cubit.stripDates().first, DateTime(2026, 10, 8));
  });

  blocTest<ShowingCubit, ShowingState>(
    'load shows today',
    setUp: () => stub(days[0], const Ok([dune])),
    build: build,
    act: (c) => c.load(),
    expect: () => [
      ShowingState.loading(dates: days, date: days[0]),
      ShowingState.ready(dates: days, date: days[0], movies: const [dune]),
    ],
  );

  blocTest<ShowingCubit, ShowingState>(
    'picking a date loads that date',
    setUp: () => stub(days[2], const Ok([dune])),
    build: build,
    seed: () => ShowingState.ready(dates: days, date: days[0], movies: const [dune]),
    act: (c) => c.dateSelected(days[2]),
    expect: () => [
      ShowingState.loading(dates: days, date: days[2]),
      ShowingState.ready(dates: days, date: days[2], movies: const [dune]),
    ],
  );

  blocTest<ShowingCubit, ShowingState>(
    're-picking the shown date does nothing',
    build: build,
    seed: () => ShowingState.ready(dates: days, date: days[0], movies: const [dune]),
    act: (c) => c.dateSelected(days[0]),
    expect: () => <ShowingState>[],
    verify: (_) => verifyNever(() => repository.fetchShowing(any())),
  );

  blocTest<ShowingCubit, ShowingState>(
    'an empty day points at the next strip date with shows, skipping empty ones',
    setUp: () {
      stub(days[0], const Ok([]));
      stub(days[1], const Ok([]));
      stub(days[2], const Ok([dune]));
    },
    build: build,
    act: (c) => c.load(),
    expect: () => [
      ShowingState.loading(dates: days, date: days[0]),
      ShowingState.ready(dates: days, date: days[0], movies: const []),
      ShowingState.ready(dates: days, date: days[0], movies: const [], nextDate: days[2]),
    ],
    verify: (_) => verifyNever(() => repository.fetchShowing(days[3])),
  );

  blocTest<ShowingCubit, ShowingState>(
    'an empty week has no next date, and a failed look-ahead stops quietly',
    setUp: () {
      stub(days[0], const Ok([]));
      stub(days[1], const Err(ApiFailure.network()));
    },
    build: build,
    act: (c) => c.load(),
    expect: () => [
      ShowingState.loading(dates: days, date: days[0]),
      ShowingState.ready(dates: days, date: days[0], movies: const []),
    ],
  );

  blocTest<ShowingCubit, ShowingState>(
    'a failure keeps the strip and the chosen date',
    setUp: () => stub(days[1], const Err(ApiFailure.network())),
    build: build,
    seed: () => ShowingState.ready(dates: days, date: days[0], movies: const [dune]),
    act: (c) => c.dateSelected(days[1]),
    expect: () => [
      ShowingState.loading(dates: days, date: days[1]),
      ShowingState.failure(dates: days, date: days[1], failure: const ApiFailure.network()),
    ],
  );

  test('a slow answer for a date the user left is dropped', () async {
    final slow = Completer<Result<List<ShowingMovie>, ApiFailure>>();
    when(() => repository.fetchShowing(days[1])).thenAnswer((_) => slow.future);
    stub(days[2], const Ok([dune]));
    final cubit = build();

    unawaited(cubit.dateSelected(days[1]));
    await cubit.dateSelected(days[2]);
    slow.complete(const Ok([]));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, ShowingState.ready(dates: days, date: days[2], movies: const [dune]));
    await cubit.close();
  });

  test('load keeps a chosen date that is still on the strip', () async {
    stub(days[3], const Ok([dune]));
    final cubit = build()..emit(ShowingState.ready(dates: days, date: days[3], movies: const []));

    await cubit.load();

    expect(cubit.state.date, days[3]);
    await cubit.close();
  });

  test('a chosen time is tracked with the movie, showtime, and source showing', () {
    final recorder = _Recorder();
    build(tracker: recorder).showtimeChosen(dune, slot);

    expect(recorder.events.single.name, JourneyEventName.showtimeSelected);
    expect(recorder.events.single.props, {'movieId': 1, 'showtimeId': 101, 'source': 'showing'});
  });
}
