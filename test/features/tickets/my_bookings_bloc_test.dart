import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/my_bookings_bloc.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_failure.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_repository.dart';

import 'tickets_fixtures.dart';

class _MockTicketsRepository extends Mock implements TicketsRepository {}

void main() {
  late _MockTicketsRepository repository;

  final newest = testBooking(id: 3, bookedAt: '2026-10-03T09:00:00');
  final older = testBooking(id: 1, bookedAt: '2026-10-01T09:00:00');
  final cancelledNewest = testBooking(
    id: 3,
    status: BookingStatus.cancelled,
    ticketStatus: 'CANCELLED',
    bookedAt: '2026-10-03T09:00:00',
  );

  MyBookingsReady ready([List<BookingSummary>? bookings]) => MyBookingsReady(bookings: bookings ?? [newest, older]);

  setUp(() => repository = _MockTicketsRepository());

  blocTest<MyBookingsBloc, MyBookingsState>(
    'loads bookings and keeps the server order (newest first)',
    setUp: () => when(() => repository.myBookings()).thenAnswer((_) async => Ok((bookings: [newest, older], offline: false))),
    build: () => MyBookingsBloc(repository),
    act: (bloc) => bloc.add(const LoadRequested()),
    expect: () => [const MyBookingsState.loading(), ready()],
  );

  blocTest<MyBookingsBloc, MyBookingsState>(
    'a load failure is a failure state',
    setUp: () => when(() => repository.myBookings()).thenAnswer((_) async => const Err(TicketsFailure.network())),
    build: () => MyBookingsBloc(repository),
    act: (bloc) => bloc.add(const LoadRequested()),
    expect: () => [const MyBookingsState.loading(), const MyBookingsState.failure(TicketsFailure.network())],
  );

  blocTest<MyBookingsBloc, MyBookingsState>(
    'refresh keeps the list on screen while it reloads',
    setUp: () => when(() => repository.myBookings()).thenAnswer((_) async => Ok((bookings: [newest], offline: false))),
    build: () => MyBookingsBloc(repository),
    seed: ready,
    act: (bloc) => bloc.add(const RefreshRequested()),
    expect: () => [ready().copyWith(refreshing: true), ready([newest])],
  );

  group('CancelRequested', () {
    blocTest<MyBookingsBloc, MyBookingsState>(
      'success flips the booking to cancelled from the server copy',
      setUp: () {
        when(() => repository.cancel(3)).thenAnswer((_) async => const Ok('Booking #3 has been cancelled.'));
        when(() => repository.booking(3)).thenAnswer((_) async => Ok(cancelledNewest));
      },
      build: () => MyBookingsBloc(repository),
      seed: ready,
      act: (bloc) => bloc.add(const CancelRequested(3)),
      expect: () => [
        ready().copyWith(cancellingId: 3),
        MyBookingsState.ready(
          bookings: [cancelledNewest, older],
          effect: MyBookingsEffect.cancelled,
          message: 'Booking #3 has been cancelled.',
        ),
      ],
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      'success still flips the chip when the re-read fails',
      setUp: () {
        when(() => repository.cancel(3)).thenAnswer((_) async => const Ok(''));
        when(() => repository.booking(3)).thenAnswer((_) async => const Err(TicketsFailure.network()));
      },
      build: () => MyBookingsBloc(repository),
      seed: ready,
      act: (bloc) => bloc.add(const CancelRequested(3)),
      skip: 1,
      expect: () => [
        MyBookingsState.ready(bookings: [cancelledNewest, older], effect: MyBookingsEffect.cancelled, message: ''),
      ],
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      'CANCEL_WINDOW keeps the booking confirmed and sets the server message',
      setUp: () => when(() => repository.cancel(3)).thenAnswer(
        (_) async => const Err(TicketsFailure.cancelWindow('Cancellations are only allowed more than 2 hours before the showtime.')),
      ),
      build: () => MyBookingsBloc(repository),
      seed: ready,
      act: (bloc) => bloc.add(const CancelRequested(3)),
      expect: () => [
        ready().copyWith(cancellingId: 3),
        ready().copyWith(
          effect: MyBookingsEffect.error,
          message: 'Cancellations are only allowed more than 2 hours before the showtime.',
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.bookingById(3)!.status, BookingStatus.confirmed);
        verifyNever(() => repository.booking(any()));
      },
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      'a second cancel while one is in flight is ignored',
      build: () => MyBookingsBloc(repository),
      seed: () => ready().copyWith(cancellingId: 1),
      act: (bloc) => bloc.add(const CancelRequested(3)),
      expect: () => const <MyBookingsState>[],
      verify: (_) => verifyNever(() => repository.cancel(any())),
    );
  });

  group('guest list (sprint 13)', () {
    blocTest<MyBookingsBloc, MyBookingsState>(
      'loads the bookings saved on this phone, with the offline flag',
      setUp: () => when(() => repository.guestBookings())
          .thenAnswer((_) async => Ok((bookings: [newest], offline: true))),
      build: () => GuestBookingsBloc(repository),
      act: (bloc) => bloc.add(const LoadRequested()),
      expect: () => [const MyBookingsState.loading(), MyBookingsReady(bookings: [newest], offline: true)],
      verify: (_) => verifyNever(() => repository.myBookings()),
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      'a found booking goes first, replacing an older copy',
      build: () => GuestBookingsBloc(repository),
      seed: ready,
      act: (bloc) => bloc.add(BookingFound(cancelledNewest)),
      expect: () => [ready([cancelledNewest, older])],
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      'forget removes it from the phone and the list',
      setUp: () => when(() => repository.forget(1)).thenAnswer((_) async {}),
      build: () => GuestBookingsBloc(repository),
      seed: ready,
      act: (bloc) => bloc.add(const ForgetRequested(1)),
      expect: () => [ready([newest])],
      verify: (_) => verify(() => repository.forget(1)).called(1),
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      'a guest cannot cancel',
      build: () => GuestBookingsBloc(repository),
      seed: ready,
      act: (bloc) => bloc.add(const CancelRequested(3)),
      expect: () => const <MyBookingsState>[],
      verify: (_) => verifyNever(() => repository.cancel(any())),
    );
  });
}
