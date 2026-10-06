import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_schedule_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_repository.dart';

import 'hall_fixtures.dart';

class _MockHallRepository extends Mock implements HallRepository {}

void main() {
  late _MockHallRepository repository;
  setUp(() => repository = _MockHallRepository());

  const failure = ApiFailure.network();

  group('HallListBloc', () {
    blocTest<HallListBloc, HallListState>(
      'loads the halls',
      setUp: () => when(() => repository.fetchHalls()).thenAnswer((_) async => const Ok(testHalls)),
      build: () => HallListBloc(repository),
      act: (bloc) => bloc.add(const LoadRequested()),
      expect: () => const [HallListState.loading(), HallListState.ready(testHalls)],
    );

    blocTest<HallListBloc, HallListState>(
      'a failed first load is a failure',
      setUp: () => when(() => repository.fetchHalls()).thenAnswer((_) async => const Err(failure)),
      build: () => HallListBloc(repository),
      act: (bloc) => bloc.add(const LoadRequested()),
      expect: () => const [HallListState.loading(), HallListState.failure(failure)],
    );

    blocTest<HallListBloc, HallListState>(
      'refresh keeps the rows on screen, even when it fails',
      setUp: () => when(() => repository.fetchHalls()).thenAnswer((_) async => const Err(failure)),
      build: () => HallListBloc(repository),
      seed: () => const HallListState.ready(testHalls),
      act: (bloc) => bloc.add(const RefreshRequested()),
      expect: () => const <HallListState>[],
    );
  });

  group('HallScheduleBloc', () {
    HallSchedule schedule(DateTime selected) => HallSchedule(
          hall: senSokAtmos,
          availableDates: [DateTime(2026, 10, 7), DateTime(2026, 10, 8)],
          selectedDate: selected,
          showtimes: const [],
        );
    final day1 = schedule(DateTime(2026, 10, 7));
    final day2 = schedule(DateTime(2026, 10, 8));

    blocTest<HallScheduleBloc, HallScheduleState>(
      'opens on the server-selected date',
      setUp: () => when(() => repository.fetchSchedule(1)).thenAnswer((_) async => Ok(day1)),
      build: () => HallScheduleBloc(repository),
      act: (bloc) => bloc.add(const ScheduleRequested(1)),
      expect: () => [const HallScheduleState.loading(1), HallScheduleState.ready(hallId: 1, schedule: day1)],
    );

    blocTest<HallScheduleBloc, HallScheduleState>(
      'a date change requests that date and keeps the old one on screen meanwhile',
      setUp: () => when(() => repository.fetchSchedule(1, date: DateTime(2026, 10, 8))).thenAnswer((_) async => Ok(day2)),
      build: () => HallScheduleBloc(repository),
      seed: () => HallScheduleState.ready(hallId: 1, schedule: day1),
      act: (bloc) => bloc.add(DateSelected(DateTime(2026, 10, 8))),
      expect: () => [
        HallScheduleState.ready(hallId: 1, schedule: day1, refreshing: true),
        HallScheduleState.ready(hallId: 1, schedule: day2),
      ],
      verify: (_) => verify(() => repository.fetchSchedule(1, date: DateTime(2026, 10, 8))).called(1),
    );

    blocTest<HallScheduleBloc, HallScheduleState>(
      'a missing hall is a failure with a retry',
      setUp: () => when(() => repository.fetchSchedule(9))
          .thenAnswer((_) async => const Err(ApiFailure.server(status: 404, message: 'Hall not found: 9'))),
      build: () => HallScheduleBloc(repository),
      act: (bloc) => bloc.add(const ScheduleRequested(9)),
      expect: () => [
        const HallScheduleState.loading(9),
        const HallScheduleState.failure(9, ApiFailure.server(status: 404, message: 'Hall not found: 9')),
      ],
    );
  });
}
