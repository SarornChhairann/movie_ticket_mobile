import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/format/locale_format.dart';
import 'package:movie_ticket_mobile/core/widgets/booking_capsule.dart';
import 'package:movie_ticket_mobile/core/widgets/booking_progress.dart';
import 'package:movie_ticket_mobile/core/widgets/leave_guard.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/booking_flow_cubit.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/view/checkout_page.dart';

import '../../helpers/localized_app.dart';
import 'checkout_fixtures.dart';

class _MockCheckoutBloc extends MockBloc<CheckoutEvent, CheckoutState> implements CheckoutBloc {}

/// Sprint 16: one booking flow across Seats → Snacks → Pay → Tickets.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  group('BookingFlowCubit', () {
    BookingFlowCubit seeded() => BookingFlowCubit(posterUrl: '/p.jpg')
      ..seatsChanged(
        showtimeId: 50,
        title: 'Dune',
        hallName: 'Hall 1',
        showDate: '2026-10-07',
        showTime: '14:00:00',
        seatCodes: const ['D1', 'D2'],
        holdExpiresAt: testHold.expiresAt,
      );

    test('the seat map feeds the capsule; nothing is computed here', () {
      final flow = seeded();
      expect(flow.state.step, FlowStep.seats);
      expect(flow.state.title, 'Dune');
      expect(flow.state.seatCodes, ['D1', 'D2']);
      expect(flow.state.posterUrl, '/p.jpg');
      expect(flow.secondsLeft(testNow), 600);
      expect(flow.secondsLeft(testHold.expiresAt.add(const Duration(minutes: 1))), 0);
    });

    test('checkout opens on Snacks when there is a menu, else Pay with Snacks skipped', () {
      final withMenu = seeded()..enteredCheckout(hasMenu: true);
      expect(withMenu.state.step, FlowStep.snacks);
      expect(withMenu.state.snacksSkipped, isFalse);
      withMenu.enteredCheckout(hasMenu: false);
      expect(withMenu.state.step, FlowStep.snacks, reason: 'only decided once, on arrival');

      final noMenu = seeded()..enteredCheckout(hasMenu: false);
      expect(noMenu.state.step, FlowStep.pay);
      expect(noMenu.state.snacksSkipped, isTrue);
    });

    test('skip snacks marks it skipped, not done; continuing with food does not', () {
      final flow = seeded()
        ..enteredCheckout(hasMenu: true)
        ..snacksDone(skipped: true);
      expect(flow.state.step, FlowStep.pay);
      expect(flow.state.snacksSkipped, isTrue);
      flow
        ..stepTo(FlowStep.snacks)
        ..snacksDone(skipped: false);
      expect(flow.state.snacksSkipped, isFalse);
    });

    test('the quote fills in the server total; back to seats drops it', () {
      final flow = seeded()..quoteChanged(foodCount: 2, totalAmount: 16.5, holdExpiresAt: testHold.expiresAt);
      expect(flow.state.totalAmount, 16.5);
      expect(flow.state.foodCount, 2);
      flow.backToSeats();
      expect(flow.state.step, FlowStep.seats);
      expect(flow.state.totalAmount, isNull);
    });

    test('a lost hold clears the seats and the timer; paid moves to Tickets', () {
      final flow = seeded()..holdLost();
      expect(flow.state.seatCodes, isEmpty);
      expect(flow.secondsLeft(testNow), isNull);
      flow.paid();
      expect(flow.state.step, FlowStep.tickets);
    });
  });

  group('widgets', () {
    testWidgets('progress tells a screen reader the step', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpLocalized(tester, const Scaffold(body: BookingProgress(current: FlowStep.snacks)));

      expect(find.bySemanticsLabel('Step 2 of 4, Snacks'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('done steps are tappable; later ones are not', (tester) async {
      final tapped = <FlowStep>[];
      await pumpLocalized(
        tester,
        Scaffold(body: BookingProgress(current: FlowStep.pay, onStepTap: tapped.add)),
      );

      await tester.tap(find.byKey(const Key('flow.step.seats')));
      await tester.tap(find.byKey(const Key('flow.step.tickets')));
      expect(tapped, [FlowStep.seats]);
    });

    test('capsule hero tags are one per showtime', () {
      expect(BookingCapsule.heroTag(1), BookingCapsule.heroTag(1));
      expect(BookingCapsule.heroTag(1), isNot(BookingCapsule.heroTag(2)));
    });

    Future<void> pumpGuard(WidgetTester tester, int held, VoidCallback onRelease) async {
      await pumpLocalized(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              key: const Key('open'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => LeaveGuard(
                  heldSeats: held,
                  onRelease: onRelease,
                  child: const Scaffold(body: Text('seats page')),
                ),
              )),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('open')));
      await tester.pumpAndSettle();
    }

    testWidgets('nothing held: back leaves without asking', (tester) async {
      var released = false;
      await pumpGuard(tester, 0, () => released = true);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('seats page'), findsNothing);
      expect(find.byKey(const Key('flow.leaveDialog')), findsNothing);
      expect(released, isFalse);
    });

    testWidgets('a live hold asks first; Keep seats stays', (tester) async {
      var released = false;
      await pumpGuard(tester, 3, () => released = true);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Release 3 seats?'), findsOneWidget);

      await tester.tap(find.byKey(const Key('flow.leave.keep')));
      await tester.pumpAndSettle();
      expect(find.text('seats page'), findsOneWidget);
      expect(released, isFalse);
    });

    testWidgets('Release gives the seats back and leaves', (tester) async {
      var released = false;
      await pumpGuard(tester, 1, () => released = true);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Release 1 seat?'), findsOneWidget);
      await tester.tap(find.byKey(const Key('flow.leave.release')));
      await tester.pumpAndSettle();

      expect(released, isTrue);
      expect(find.text('seats page'), findsNothing);
    });
  });

  group('checkout inside a flow', () {
    late _MockCheckoutBloc bloc;
    late BookingFlowCubit flow;

    Future<void> pump(WidgetTester tester, CheckoutReady ready) async {
      bloc = _MockCheckoutBloc();
      flow = BookingFlowCubit()
        ..seatsChanged(
          showtimeId: 50,
          title: 'Dune',
          hallName: 'Hall 1',
          seatCodes: const ['D1', 'D2'],
          holdExpiresAt: testHold.expiresAt,
        );
      whenListen(bloc, Stream<CheckoutState>.fromIterable([ready]), initialState: CheckoutState.loading(testHold));
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await pumpLocalized(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<CheckoutBloc>.value(value: bloc),
            BlocProvider<BookingFlowCubit>.value(value: flow),
          ],
          child: const CheckoutPage(),
        ),
      );
      await tester.pump();
      await tester.pump();
    }

    CheckoutReady ready({Map<int, int> food = const {}}) =>
        CheckoutReady(hold: testHold, quote: testQuote(), food: food, secondsLeft: 600);

    testWidgets('a menu opens on Snacks; Skip snacks goes to Pay and marks it skipped', (tester) async {
      await pump(tester, ready());

      expect(flow.state.step, FlowStep.snacks);
      expect(find.byKey(const Key('concessions.grid')), findsOneWidget);
      expect(find.byKey(const Key('flow.capsule')), findsOneWidget);
      expect(find.byKey(const Key('checkout.pay')), findsNothing);

      await tester.tap(find.byKey(const Key('flow.skipSnacks')));
      await tester.pumpAndSettle();

      expect(flow.state.step, FlowStep.pay);
      expect(flow.state.snacksSkipped, isTrue);
      expect(find.byKey(const Key('checkout.pay')), findsOneWidget);
    });

    testWidgets('back on Pay returns to Snacks, not out of checkout', (tester) async {
      await pump(tester, ready());
      flow.snacksDone(skipped: true);
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(flow.state.step, FlowStep.snacks);
      expect(find.byKey(const Key('concessions.grid')), findsOneWidget);
    });

    testWidgets('Pay shows the server total and nothing else', (tester) async {
      // Food picked but not yet re-quoted: the label keeps the last server total.
      await pump(tester, ready(food: {7: 2}));
      flow.snacksDone(skipped: false);
      await tester.pumpAndSettle();

      final total = tester.element(find.byType(CheckoutPage)).money(testQuote().totalAmount);
      expect(find.text('Pay $total'), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('checkout.stickyTotal'))).data, total);
    });
  });
}
