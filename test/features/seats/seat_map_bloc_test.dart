import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/seats/controller/seat_map_bloc.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_repository.dart';

import 'seat_fixtures.dart';

class _MockSeatRepository extends Mock implements SeatRepository {}

void main() {
  late _MockSeatRepository repository;
  late StreamController<SeatEvent> events;
  late StreamController<Hold> holdChanges;
  final now = DateTime(2026, 10, 2, 19);
  final hold = Hold(showtimeId: 50, seatIds: {1, 2}, expiresAt: now.add(const Duration(minutes: 10)));

  /// [dataHeld] is what the last `loadMap` reported; [heldByOthers] is the live set.
  SeatMapReady ready({
    Set<int> selected = const {},
    Set<int> heldByOthers = const {},
    Set<int> dataHeld = const {},
    Hold? hold,
    int maxSeats = 0,
  }) =>
      SeatMapReady(
        data: seatMap(heldByOthers: dataHeld, maxSeats: maxSeats),
        heldByOthers: heldByOthers,
        booked: const {3, 14},
        selected: selected,
        hold: hold,
      );

  SeatMapBloc build() => SeatMapBloc(repository, clock: () => now, tick: const Duration(hours: 1));

  setUpAll(() => registerFallbackValue(<int>{}));

  setUp(() {
    repository = _MockSeatRepository();
    events = StreamController<SeatEvent>.broadcast();
    holdChanges = StreamController<Hold>.broadcast();
    when(() => repository.sessionId).thenReturn('me');
    when(() => repository.watch(any())).thenAnswer((_) => events.stream);
    when(() => repository.loadMap(any())).thenAnswer((_) async => Ok(seatMap()));
    when(() => repository.release(any(), any())).thenAnswer((_) async {});
    when(() => repository.holdChanges).thenAnswer((_) => holdChanges.stream);
  });

  tearDown(() async {
    await events.close();
    await holdChanges.close();
  });

  blocTest<SeatMapBloc, SeatMapState>(
    'loads the map and marks booked seats',
    build: build,
    act: (bloc) => bloc.add(const LoadRequested(50)),
    expect: () => [const SeatMapState.loading(), ready()],
    verify: (_) => verify(() => repository.watch(50)).called(1),
  );

  group('SeatToggled', () {
    blocTest<SeatMapBloc, SeatMapState>(
      'toggles a normal seat on and off',
      build: build,
      seed: ready,
      act: (bloc) => bloc
        ..add(const SeatToggled(1))
        ..add(const SeatToggled(1)),
      expect: () => [ready(selected: {1}), ready()],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'tapping a couple seat selects its partner',
      build: build,
      seed: ready,
      act: (bloc) => bloc.add(const SeatToggled(12)),
      expect: () => [ready(selected: {11, 12})],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'a couple seat whose partner is booked shows the pair error and selects nothing',
      build: build,
      seed: ready,
      act: (bloc) => bloc.add(const SeatToggled(13)),
      expect: () => [ready().copyWith(effect: SeatMapEffect.pairError)],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'at the seat cap a new seat is refused with the limit effect, and deselecting still works',
      build: build,
      seed: () => ready(selected: {1, 2}, maxSeats: 2),
      act: (bloc) => bloc
        ..add(const SeatToggled(11))
        ..add(const SeatToggled(1)),
      expect: () => [
        ready(selected: {1, 2}, maxSeats: 2).copyWith(effect: SeatMapEffect.limit),
        ready(selected: {2}, maxSeats: 2),
      ],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'a couple pair counts as two seats against the cap',
      build: build,
      seed: () => ready(selected: {1, 2}, maxSeats: 3),
      act: (bloc) => bloc.add(const SeatToggled(12)),
      expect: () => [ready(selected: {1, 2}, maxSeats: 3).copyWith(effect: SeatMapEffect.limit)],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'with no cap from the server any number of seats can be picked',
      build: build,
      seed: () => ready(selected: {1, 2}),
      act: (bloc) => bloc.add(const SeatToggled(12)),
      expect: () => [ready(selected: {1, 2, 11, 12})],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'booked and held-by-others seats ignore taps',
      build: build,
      seed: () => ready(heldByOthers: {2}),
      act: (bloc) => bloc
        ..add(const SeatToggled(3))
        ..add(const SeatToggled(2)),
      expect: () => const <SeatMapState>[],
    );
  });

  group('HoldRequested', () {
    blocTest<SeatMapBloc, SeatMapState>(
      'holds the selection and proceeds with a countdown',
      setUp: () => when(() => repository.hold(50, {1, 2})).thenAnswer((_) async => Ok(hold)),
      build: build,
      seed: () => ready(selected: {1, 2}),
      act: (bloc) => bloc.add(const HoldRequested()),
      expect: () => [
        ready(selected: {1, 2}).copyWith(holding: true),
        ready(selected: {1, 2}, hold: hold).copyWith(secondsLeft: 600, effect: SeatMapEffect.proceed),
      ],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'an invalid couple selection never calls hold',
      build: build,
      seed: () => ready(selected: {13}),
      act: (bloc) => bloc.add(const HoldRequested()),
      expect: () => [ready(selected: {13}).copyWith(effect: SeatMapEffect.pairError)],
      verify: (_) => verifyNever(() => repository.hold(any(), any())),
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'releases seats dropped since the previous hold',
      setUp: () => when(() => repository.hold(50, {1})).thenAnswer(
        (_) async => Ok(Hold(showtimeId: 50, seatIds: {1}, expiresAt: hold.expiresAt)),
      ),
      build: build,
      seed: () => ready(selected: {1}, hold: hold),
      act: (bloc) => bloc.add(const HoldRequested()),
      verify: (_) => verify(() => repository.release(50, {2})).called(1),
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'SEAT_LIMIT from the server shows the limit with its message and keeps the selection',
      setUp: () => when(() => repository.hold(any(), any())).thenAnswer((_) async => const Err(
            ApiFailure.server(status: 400, code: 'SEAT_LIMIT', message: 'You can book at most 8 seats at a time.'),
          )),
      build: build,
      seed: () => ready(selected: {1, 2}),
      act: (bloc) => bloc.add(const HoldRequested()),
      skip: 1,
      expect: () => [
        ready(selected: {1, 2})
            .copyWith(effect: SeatMapEffect.limit, message: 'You can book at most 8 seats at a time.'),
      ],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'a seat conflict reloads the map and shows the server message',
      setUp: () {
        when(() => repository.hold(any(), any())).thenAnswer((_) async => const Err(
              ApiFailure.server(status: 409, code: 'SEAT_HELD', message: 'Held by another user.'),
            ));
        when(() => repository.loadMap(50)).thenAnswer((_) async => Ok(seatMap(heldByOthers: {2})));
      },
      build: build,
      seed: () => ready(selected: {1, 2}),
      act: (bloc) => bloc.add(const HoldRequested()),
      skip: 1,
      expect: () => [
        ready(selected: {1}, heldByOthers: {2}, dataHeld: {2}),
        ready(selected: {1}, heldByOthers: {2}, dataHeld: {2})
            .copyWith(effect: SeatMapEffect.conflict, message: 'Held by another user.'),
      ],
    );
  });

  group('RemoteSeatChanged', () {
    blocTest<SeatMapBloc, SeatMapState>(
      'another session holding a seat disables it and drops it from my selection',
      build: build,
      seed: () => ready(selected: {1}),
      act: (bloc) => bloc.add(const RemoteSeatChanged(
        SeatEvent.change(type: SeatEventType.held, seatIds: {1}, sessionId: 'other'),
      )),
      expect: () => [ready(heldByOthers: {1})],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'our own echoed hold is ignored',
      build: build,
      seed: () => ready(selected: {1}),
      act: (bloc) => bloc.add(const RemoteSeatChanged(
        SeatEvent.change(type: SeatEventType.held, seatIds: {1}, sessionId: 'me'),
      )),
      expect: () => const <SeatMapState>[],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'a release frees the seat and a booking marks it booked',
      build: build,
      seed: () => ready(heldByOthers: {1, 2}),
      act: (bloc) => bloc
        ..add(const RemoteSeatChanged(SeatEvent.change(type: SeatEventType.released, seatIds: {1})))
        ..add(const RemoteSeatChanged(SeatEvent.change(type: SeatEventType.booked, seatIds: {2}))),
      expect: () => [
        ready(heldByOthers: {2}),
        ready().copyWith(booked: {3, 14, 2}),
      ],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'a cancelled booking releasing its seats makes them available again',
      build: build,
      seed: ready,
      act: (bloc) => bloc.add(const RemoteSeatChanged(SeatEvent.change(type: SeatEventType.released, seatIds: {3}))),
      expect: () => [ready().copyWith(booked: {14})],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'a polling snapshot replaces held-by-others',
      build: build,
      seed: () => ready(heldByOthers: {1}),
      act: (bloc) => bloc.add(const RemoteSeatChanged(SeatEvent.snapshot(heldByOthers: {2}))),
      expect: () => [ready(heldByOthers: {2})],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'pushed events from the repository stream reach the bloc',
      build: build,
      act: (bloc) async {
        bloc.add(const LoadRequested(50));
        await Future<void>.delayed(Duration.zero);
        events.add(const SeatEvent.change(type: SeatEventType.held, seatIds: {1}, sessionId: 'other'));
      },
      skip: 2,
      expect: () => [ready(heldByOthers: {1})],
    );
  });

  blocTest<SeatMapBloc, SeatMapState>(
    'expiry clears the selection, reloads, and signals expired',
    build: build,
    seed: () => ready(selected: {1, 2}, hold: hold),
    act: (bloc) => bloc.add(const HoldExpired()),
    expect: () => [ready(), ready().copyWith(effect: SeatMapEffect.expired)],
  );

  test('closing the screen releases an active hold', () async {
    final bloc = build()..emit(ready(selected: {1, 2}, hold: hold));

    await bloc.close();

    verify(() => repository.release(50, {1, 2})).called(1);
  });

  group('party size and best seats (sprint 14)', () {
    blocTest<SeatMapBloc, SeatMapState>(
      'a party size caps the selection and trims what no longer fits',
      build: build,
      seed: () => ready(selected: {1, 2}),
      act: (bloc) => bloc
        ..add(const PartySizeChosen(1))
        ..add(const SeatToggled(2)),
      expect: () => [
        ready(selected: {1}).copyWith(partySize: 1, partyAsked: true),
        ready(selected: {1}).copyWith(partySize: 1, partyAsked: true, effect: SeatMapEffect.limit),
      ],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'skip keeps the server cap and does not ask again',
      build: build,
      seed: ready,
      act: (bloc) => bloc.add(const PartySizeChosen(null)),
      expect: () => [ready().copyWith(partyAsked: true)],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'best seats holds the block without leaving the map',
      setUp: () => when(() => repository.hold(50, {1, 2})).thenAnswer((_) async => Ok(hold)),
      build: build,
      seed: () => ready().copyWith(partySize: 2, partyAsked: true),
      act: (bloc) => bloc.add(const BestSeatsRequested()),
      expect: () => [
        ready(selected: {1, 2}).copyWith(partySize: 2, partyAsked: true, holding: true),
        ready(selected: {1, 2}, hold: hold).copyWith(partySize: 2, partyAsked: true, secondsLeft: 600),
      ],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'no block in one row says so and holds nothing',
      build: build,
      seed: () => ready().copyWith(partySize: 3, partyAsked: true),
      act: (bloc) => bloc.add(const BestSeatsRequested()),
      expect: () => [ready().copyWith(partySize: 3, partyAsked: true, effect: SeatMapEffect.noBlock)],
      verify: (_) => verifyNever(() => repository.hold(any(), any())),
    );
  });

  group('extend (sprint 14)', () {
    final extended = hold.copyWith(expiresAt: hold.expiresAt.add(const Duration(minutes: 5)), extended: true);
    SeatMapReady held() => ready(selected: {1, 2}, hold: hold).copyWith(secondsLeft: 45);

    setUpAll(() => registerFallbackValue(hold));

    blocTest<SeatMapBloc, SeatMapState>(
      'extends once: the countdown follows the new expiry and Extend goes away',
      setUp: () => when(() => repository.extend(hold)).thenAnswer((_) async => Ok(extended)),
      build: build,
      seed: held,
      act: (bloc) => bloc.add(const HoldExtendRequested()),
      expect: () => [
        held().copyWith(extending: true),
        held().copyWith(hold: extended, secondsLeft: 900, effect: SeatMapEffect.extended),
      ],
      verify: (bloc) => expect((bloc.state as SeatMapReady).canExtend, isFalse),
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'HOLD_EXTEND_LIMIT marks it used and shows the server message',
      setUp: () => when(() => repository.extend(any())).thenAnswer((_) async => const Err(
            ApiFailure.server(status: 409, code: 'HOLD_EXTEND_LIMIT', message: 'Already extended once.'),
          )),
      build: build,
      seed: held,
      act: (bloc) => bloc.add(const HoldExtendRequested()),
      expect: () => [
        held().copyWith(extending: true),
        held().copyWith(
          hold: hold.copyWith(extended: true),
          effect: SeatMapEffect.conflict,
          message: 'Already extended once.',
        ),
      ],
    );

    blocTest<SeatMapBloc, SeatMapState>(
      'an extend made in checkout reaches the map',
      build: build,
      seed: held,
      act: (bloc) => bloc.add(HoldChanged(extended)),
      expect: () => [held().copyWith(hold: extended, secondsLeft: 900)],
    );
  });
}
