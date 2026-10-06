import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/my_bookings_bloc.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_failure.dart';
import 'package:movie_ticket_mobile/features/tickets/view/booking_detail_page.dart';
import 'package:movie_ticket_mobile/features/tickets/view/my_bookings_page.dart';

import '../../helpers/localized_app.dart';
import 'tickets_fixtures.dart';

class _MockMyBookingsBloc extends MockBloc<MyBookingsEvent, MyBookingsState> implements MyBookingsBloc {
  @override
  bool get guest => false;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const LoadRequested());
    await initTestLocalization();
  });

  final now = DateTime(2026, 10, 7, 12);

  Future<_MockMyBookingsBloc> pump(WidgetTester tester, Widget page, MyBookingsState state) async {
    final bloc = _MockMyBookingsBloc();
    whenListen(bloc, const Stream<MyBookingsState>.empty(), initialState: state);
    await pumpLocalized(tester, BlocProvider<MyBookingsBloc>.value(value: bloc, child: page));
    return bloc;
  }

  Future<void> pumpDetail(WidgetTester tester, BookingSummary booking, {int? cancellingId}) => pump(
        tester,
        BookingDetailPage(bookingId: booking.bookingId, clock: () => now),
        MyBookingsState.ready(bookings: [booking], cancellingId: cancellingId),
      );

  testWidgets('a confirmed upcoming booking offers cancel', (tester) async {
    await pumpDetail(tester, testBooking());

    expect(find.byKey(const Key('tickets.cancel')), findsOneWidget);
    expect(find.byKey(const Key('tickets.chip.confirmed')), findsOneWidget);
    expect(find.byKey(const Key('ticket.T-99-1')), findsOneWidget);
  });

  testWidgets('a cancelled booking hides the cancel button', (tester) async {
    await pumpDetail(tester, testBooking(status: BookingStatus.cancelled, ticketStatus: 'CANCELLED'));

    expect(find.byKey(const Key('tickets.cancel')), findsNothing);
    expect(find.byKey(const Key('tickets.chip.cancelled')), findsWidgets);
  });

  testWidgets('a show that already started hides the cancel button', (tester) async {
    await pumpDetail(tester, testBooking(showDate: '2026-10-06'));

    expect(find.byKey(const Key('tickets.cancel')), findsNothing);
  });

  testWidgets('cancel asks for confirmation before sending', (tester) async {
    final bloc = _MockMyBookingsBloc();
    whenListen(bloc, const Stream<MyBookingsState>.empty(),
        initialState: MyBookingsState.ready(bookings: [testBooking()]));
    await pumpLocalized(
      tester,
      BlocProvider<MyBookingsBloc>.value(value: bloc, child: BookingDetailPage(bookingId: 99, clock: () => now)),
    );

    await tester.tap(find.byKey(const Key('tickets.cancel')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tickets.cancelDialog')), findsOneWidget);

    await tester.tap(find.byKey(const Key('tickets.cancelConfirmButton')));
    await tester.pumpAndSettle();
    verify(() => bloc.add(any(that: isA<CancelRequested>().having((e) => e.bookingId, 'id', 99)))).called(1);
  });

  testWidgets('cancel shows progress and ignores taps while in flight', (tester) async {
    await pumpDetail(tester, testBooking(), cancellingId: 99);

    final button = tester.widget<OutlinedButton>(find.byKey(const Key('tickets.cancel')));
    expect(button.onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('the detail shows the reference; offline it says so and hides cancel', (tester) async {
    final booking = testBooking(id: 7).copyWith(reference: 'AB3DEF7H');
    await pump(
      tester,
      BookingDetailPage(bookingId: 7, clock: () => now),
      MyBookingsState.ready(bookings: [booking], offline: true),
    );

    expect(find.text('Booking reference: AB3DEF7H'), findsOneWidget);
    expect(find.byKey(const Key('tickets.offline')), findsOneWidget);
    expect(find.byKey(const Key('tickets.cancel')), findsNothing);
  });

  testWidgets('my bookings lists each booking with chip, seats, and total', (tester) async {
    await pump(
      tester,
      const MyBookingsPage(),
      MyBookingsState.ready(bookings: [
        testBooking(id: 3),
        testBooking(id: 1, status: BookingStatus.cancelled, ticketStatus: 'CANCELLED'),
      ]),
    );

    expect(find.byKey(const Key('booking.3')), findsOneWidget);
    expect(find.byKey(const Key('booking.1')), findsOneWidget);
    expect(find.byKey(const Key('tickets.chip.confirmed')), findsOneWidget);
    expect(find.byKey(const Key('tickets.chip.cancelled')), findsOneWidget);
    expect(find.text('D1, D2'), findsNWidgets(2));
    expect(find.text('\$12.50'), findsNWidgets(2));
    expect(
      tester.getTopLeft(find.byKey(const Key('booking.3'))).dy,
      lessThan(tester.getTopLeft(find.byKey(const Key('booking.1'))).dy),
      reason: 'server order (newest first) is kept',
    );
  });

  testWidgets('a cancelled paid booking shows refund pending, then refunded', (tester) async {
    await pump(
      tester,
      const MyBookingsPage(),
      MyBookingsState.ready(bookings: [
        testBooking(id: 2, status: BookingStatus.cancelled, ticketStatus: 'CANCELLED', refund: RefundState.pending),
        testBooking(id: 1, status: BookingStatus.cancelled, ticketStatus: 'CANCELLED', refund: RefundState.refunded),
      ]),
    );

    expect(find.byKey(const Key('tickets.chip.refund.pending')), findsOneWidget);
    expect(find.text('Refund pending'), findsOneWidget);
    expect(find.byKey(const Key('tickets.chip.refund.refunded')), findsOneWidget);
    expect(find.text('Refunded'), findsOneWidget);
    expect(find.byKey(const Key('tickets.chip.cancelled')), findsNothing);
  });

  testWidgets('a not-found failure shows the localized copy, not the server text', (tester) async {
    await pump(tester, const MyBookingsPage(),
        const MyBookingsState.failure(TicketsFailure.notFound('Booking not found.')));

    expect(find.text("We couldn't find this booking."), findsOneWidget);
  });

  testWidgets('an empty list shows the empty copy', (tester) async {
    await pump(tester, const MyBookingsPage(), const MyBookingsState.ready(bookings: []));

    expect(find.text('No bookings yet. Your tickets will appear here after you pay.'), findsOneWidget);
  });
}
