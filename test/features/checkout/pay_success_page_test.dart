import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/view/pay_success_page.dart';

import '../../helpers/localized_app.dart';
import '../auth/auth_fixtures.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  const confirmation = BookingSummary(
    reference: 'AB3DEF7H',
    bookingId: 99,
    status: BookingStatus.confirmed,
    movieTitle: 'Dune',
    hallName: 'Hall 1',
    showDate: '2026-10-07',
    showTime: '14:00:00',
    totalAmount: 12.5,
    tickets: [TicketPass(code: 'T-1', seatCode: 'D1', status: 'ACTIVE')],
  );

  Future<void> pump(WidgetTester tester, AuthState auth) async {
    final authBloc = _MockAuthBloc();
    whenListen(authBloc, const Stream<AuthState>.empty(), initialState: auth);
    await pumpLocalized(
      tester,
      BlocProvider<AuthBloc>.value(value: authBloc, child: const PaySuccessPage(confirmation: confirmation)),
    );
  }

  testWidgets('the booking reference is shown with how to use it', (tester) async {
    await pump(tester, const AuthState.guest());

    expect(find.byKey(const Key('pay.reference')), findsOneWidget);
    expect(find.text('AB3DEF7H'), findsOneWidget);
    expect(find.text('Keep this reference. With your phone number it finds your tickets under Bookings.'), findsOneWidget);
  });

  testWidgets('a signed-in user gets View tickets', (tester) async {
    await pump(tester, const AuthState.authenticated(testUser));

    expect(find.byKey(const Key('pay.viewTickets')), findsOneWidget);
    expect(find.byKey(const Key('ticket.T-1')), findsOneWidget);
  });

  testWidgets('a guest has no My bookings entry; the ticket codes are their view', (tester) async {
    await pump(tester, const AuthState.guest());

    expect(find.byKey(const Key('pay.viewTickets')), findsNothing);
    expect(find.byKey(const Key('ticket.T-1')), findsOneWidget);
  });
}
