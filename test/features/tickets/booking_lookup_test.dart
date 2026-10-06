import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/booking_lookup_bloc.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_failure.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_repository.dart';
import 'package:movie_ticket_mobile/features/tickets/view/booking_lookup_page.dart';

import '../../helpers/localized_app.dart';
import 'tickets_fixtures.dart';

class _MockTicketsRepository extends Mock implements TicketsRepository {}

void main() {
  late _MockTicketsRepository repository;
  final found = testBooking(id: 5);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  setUp(() => repository = _MockTicketsRepository());

  blocTest<BookingLookupBloc, BookingLookupState>(
    'a hit carries the booking; a second submit while in flight is ignored',
    setUp: () => when(() => repository.lookup('AB3DEF7H', '012')).thenAnswer((_) async => Ok(found)),
    build: () => BookingLookupBloc(repository),
    act: (bloc) => bloc
      ..add(const LookupSubmitted(reference: 'AB3DEF7H', phone: '012'))
      ..add(const LookupSubmitted(reference: 'AB3DEF7H', phone: '012')),
    expect: () => [const BookingLookupState(submitting: true), BookingLookupState(found: found)],
    verify: (_) => verify(() => repository.lookup(any(), any())).called(1),
  );

  blocTest<BookingLookupBloc, BookingLookupState>(
    'a miss keeps the form with the failure',
    setUp: () => when(() => repository.lookup(any(), any()))
        .thenAnswer((_) async => const Err(TicketsFailure.notFound('Booking not found.'))),
    build: () => BookingLookupBloc(repository),
    act: (bloc) => bloc.add(const LookupSubmitted(reference: 'ZZ', phone: '012')),
    expect: () => const [
      BookingLookupState(submitting: true),
      BookingLookupState(failure: TicketsFailure.notFound('Booking not found.')),
    ],
  );

  testWidgets('the form needs both fields, and a miss shows the localized copy', (tester) async {
    when(() => repository.lookup(any(), any()))
        .thenAnswer((_) async => const Err(TicketsFailure.notFound('Booking not found.')));
    await pumpLocalized(
      tester,
      BlocProvider(create: (_) => BookingLookupBloc(repository), child: const BookingLookupPage()),
    );

    await tester.tap(find.byKey(const Key('lookup.submit')));
    await tester.pump();
    verifyNever(() => repository.lookup(any(), any()));

    await tester.enterText(find.byKey(const Key('lookup.reference')), 'ZZZZZZZZ');
    await tester.enterText(find.byKey(const Key('lookup.phone')), '012');
    await tester.tap(find.byKey(const Key('lookup.submit')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump();

    expect(find.text('No booking matches that reference and phone number.'), findsOneWidget);
  });
}
