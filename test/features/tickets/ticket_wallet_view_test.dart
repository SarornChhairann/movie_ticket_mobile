import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/my_bookings_bloc.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/ticket_bloc.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/up_next_cubit.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_failure.dart';
import 'package:movie_ticket_mobile/features/tickets/model/tickets_repository.dart';
import 'package:movie_ticket_mobile/features/tickets/view/booking_detail_page.dart';
import 'package:movie_ticket_mobile/features/tickets/view/my_bookings_page.dart';
import 'package:movie_ticket_mobile/features/tickets/view/ticket_wallet_page.dart';
import 'package:movie_ticket_mobile/features/tickets/view/up_next_card.dart';

import '../../helpers/localized_app.dart';
import 'tickets_fixtures.dart';

class _MockRepository extends Mock implements TicketsRepository {}

class _MockTicketBloc extends MockBloc<TicketEvent, TicketState> implements TicketBloc {}

class _MockMyBookingsBloc extends MockBloc<MyBookingsEvent, MyBookingsState> implements MyBookingsBloc {
  @override
  bool get guest => false;
}

/// Sprint 18: Up next, the ticket card and its flip, door mode, the timeline.
void main() {
  final now = DateTime(2026, 10, 20, 17, 20); // cinema wall clock; testBooking shows at 19:30
  // A real 1×1 PNG: the QR side decodes it.
  final png = Uint8List.fromList(const [137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 11, 73, 68, 65, 84, 120, 156, 99, 248, 15, 4, 0, 9, 251, 3, 253, 251, 94, 107, 43, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130]);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(const QrRequested(''));
  });

  group('UpNextCubit', () {
    late _MockRepository repository;
    setUp(() => repository = _MockRepository());

    test('signed in: the account list; the show hides once it starts', () async {
      var clock = now;
      when(() => repository.myBookings()).thenAnswer((_) async => Ok((bookings: [testBooking(id: 3)], offline: false)));
      final cubit = UpNextCubit(repository, clock: () => clock, tick: const Duration(hours: 1));

      await cubit.load(signedIn: true);
      expect(cubit.state.booking!.bookingId, 3);

      clock = DateTime(2026, 10, 20, 19, 31);
      await cubit.load(signedIn: true);
      expect(cubit.state.booking, isNull);
      verifyNever(() => repository.savedGuestBookings());
      await cubit.close();
    });

    test('guest: only the bookings saved on this phone, no network', () async {
      when(() => repository.savedGuestBookings()).thenAnswer((_) async => [testBooking(id: 7)]);
      final cubit = UpNextCubit(repository, clock: () => now);

      await cubit.load(signedIn: false);

      expect(cubit.state.booking!.bookingId, 7);
      verifyNever(() => repository.myBookings());
      await cubit.close();
    });
  });

  testWidgets('Up next: when, where, countdown; Show ticket opens the QR side', (tester) async {
    final repository = _MockRepository();
    when(() => repository.savedGuestBookings()).thenAnswer((_) async => [testBooking(id: 7)]);
    final cubit = UpNextCubit(repository, clock: () => now, tick: const Duration(hours: 1));
    await cubit.load(signedIn: false);
    RouteSettings? pushed;
    await pumpLocalized(
      tester,
      BlocProvider.value(value: cubit, child: const Scaffold(body: UpNextCard())),
      onGenerateRoute: (settings) {
        pushed = settings;
        return MaterialPageRoute<void>(builder: (_) => const SizedBox());
      },
    );

    expect(find.text('Today 19:30 · Hall 1'), findsOneWidget);
    expect(find.text('in 2h 10m'), findsOneWidget);
    await tester.tap(find.byKey(const Key('upNext.show')));
    await tester.pumpAndSettle();
    expect(pushed!.name, AppRoutes.ticketWallet);
    expect((pushed!.arguments! as TicketWalletArgs).doorMode, isTrue);
    await cubit.close();
  });

  Future<_MockTicketBloc> pumpWallet(WidgetTester tester, BookingSummary booking, TicketState qr,
      {bool reduceMotion = false}) async {
    final qrBloc = _MockTicketBloc();
    whenListen(qrBloc, const Stream<TicketState>.empty(), initialState: qr);
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
          child: TicketWalletPage(args: TicketWalletArgs(booking: booking), qrBloc: () => qrBloc),
        ),
      ),
    );
    return qrBloc;
  }

  testWidgets('a tap turns the card to the QR; two tickets get a pager with dots', (tester) async {
    await pumpWallet(tester, testBooking().copyWith(reference: 'AB3DEF7H'), TicketState.ready(code: 'T-99-1', png: png));

    expect(find.byKey(const Key('ticket.front.seat')), findsOneWidget);
    expect(find.byKey(const Key('wallet.dots')), findsOneWidget);
    await tester.tap(find.byKey(const Key('ticket.front.seat')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ticket.back.qr')), findsOneWidget);
    expect(find.text('AB3DEF7H'), findsOneWidget);
  });

  testWidgets('reduced motion: the card swaps faces at once', (tester) async {
    await pumpWallet(tester, testBooking(), TicketState.ready(code: 'T-99-1', png: png), reduceMotion: true);

    await tester.tap(find.byKey(const Key('ticket.front.seat')));
    await tester.pump();
    expect(find.byKey(const Key('ticket.back.qr')), findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('offline: the saved copy says when it was saved', (tester) async {
    await pumpWallet(
      tester,
      testBooking(),
      TicketState.ready(code: 'T-99-1', png: png, offline: true, savedAt: DateTime(2026, 10, 20, 18, 40)),
    );

    expect(find.text('Saved on this phone · updated 18:40'), findsOneWidget);
  });

  testWidgets('a cancelled ticket never shows a scannable QR or asks for one', (tester) async {
    final qrBloc = await pumpWallet(
      tester,
      testBooking(status: BookingStatus.cancelled, ticketStatus: 'CANCELLED'),
      const TicketState.failure(code: 'x', failure: TicketsFailure.network()),
    );

    await tester.tap(find.byKey(const Key('ticket.front.seat')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ticket.back.cancelled')), findsOneWidget);
    expect(find.byKey(const Key('ticket.back.qr')), findsNothing);
    verifyNever(() => qrBloc.add(any()));
  });

  Future<void> pumpList(WidgetTester tester, Widget page, MyBookingsState state) async {
    final bloc = _MockMyBookingsBloc();
    whenListen(bloc, const Stream<MyBookingsState>.empty(), initialState: state);
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(tester, BlocProvider<MyBookingsBloc>.value(value: bloc, child: page));
  }

  testWidgets('Bookings tab: Upcoming and Past', (tester) async {
    await pumpList(
      tester,
      MyBookingsPage(clock: () => now),
      MyBookingsState.ready(bookings: [testBooking(id: 3), testBooking(id: 1, showDate: '2026-10-01')]),
    );

    expect(find.byKey(const Key('bookings.upcoming')), findsOneWidget);
    expect(find.byKey(const Key('bookings.past')), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const Key('booking.3'))).dy,
      lessThan(tester.getTopLeft(find.byKey(const Key('booking.1'))).dy),
    );
  });

  testWidgets('empty Bookings offers Browse movies', (tester) async {
    var browsed = false;
    await pumpList(tester, MyBookingsPage(onBrowse: () => browsed = true), const MyBookingsState.ready(bookings: []));

    await tester.tap(find.text('Browse movies'));
    expect(browsed, isTrue);
  });

  testWidgets('booking detail shows the timeline at Paid', (tester) async {
    await pumpList(
      tester,
      BookingDetailPage(bookingId: 99, clock: () => now),
      MyBookingsState.ready(bookings: [testBooking()]),
    );

    expect(find.byKey(const Key('tickets.timeline')), findsOneWidget);
    final paid = tester.widget<Text>(find.byKey(const Key('tickets.timeline.paid')));
    expect(paid.style?.fontWeight, FontWeight.w600, reason: 'the current step is highlighted');
  });
}
