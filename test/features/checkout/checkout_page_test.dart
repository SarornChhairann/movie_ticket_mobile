import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/model/quote.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/checkout/view/checkout_page.dart';

import '../../helpers/localized_app.dart';
import 'checkout_fixtures.dart';

class _MockCheckoutBloc extends MockBloc<CheckoutEvent, CheckoutState> implements CheckoutBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  Future<void> pump(WidgetTester tester, CheckoutState state, {RouteFactory? onGenerateRoute}) async {
    final bloc = _MockCheckoutBloc();
    whenListen(bloc, const Stream<CheckoutState>.empty(), initialState: state);
    tester.view.physicalSize = const Size(1080, 4200);
    addTearDown(tester.view.resetPhysicalSize);
    await pumpLocalized(
      tester,
      BlocProvider<CheckoutBloc>.value(value: bloc, child: const CheckoutPage()),
      onGenerateRoute: onGenerateRoute,
    );
  }

  CheckoutReady ready({GuestInfo guest = const GuestInfo(), Quote? quote}) =>
      CheckoutReady(hold: testHold, quote: quote ?? testQuote(), guest: guest, secondsLeft: 600);

  FilledButton payButton(WidgetTester tester) => tester.widget<FilledButton>(find.byKey(const Key('checkout.pay')));

  testWidgets('pay is disabled for a guest until name and phone are filled', (tester) async {
    await pump(tester, ready());
    expect(payButton(tester).onPressed, isNull);
    expect(find.byKey(const Key('guest.name')), findsOneWidget);
  });

  testWidgets('pay is enabled for a guest with name and phone', (tester) async {
    await pump(tester, ready(guest: const GuestInfo(name: 'Dara', phone: '012')));
    expect(payButton(tester).onPressed, isNotNull);
  });

  testWidgets('price lines render in analytics order with server amounts', (tester) async {
    final quote = testQuote(promo: 'SAVE20', discount: 2, total: 16.5, foodTotal: 6).copyWith(
      morningDiscount: 1,
      weekendSurcharge: 0.9,
    );
    await pump(tester, ready(quote: quote, guest: const GuestInfo(name: 'Dara', phone: '012')));

    const order = [
      'line.base',
      'line.morningDiscount',
      'line.weekendSurcharge',
      'line.subtotal',
      'line.promoDiscount',
      'line.tax',
      'line.serviceFee',
      'line.food',
      'line.total',
    ];
    final ys = [for (final k in order) tester.getTopLeft(find.byKey(Key(k))).dy];
    expect(ys, [...ys]..sort(), reason: 'lines must appear top-to-bottom in this order');
    expect(find.text('\$16.50'), findsNWidgets(2), reason: 'total line and sticky total');
    expect(find.text('−\$2.00'), findsOneWidget);
  });

  testWidgets('zero discount and surcharge lines are hidden; signed-in user has no guest form', (tester) async {
    await pump(tester, ready(quote: testQuote(user: const QuoteUser(name: 'Dara'))));

    expect(find.byKey(const Key('line.morningDiscount')), findsNothing);
    expect(find.byKey(const Key('line.weekendSurcharge')), findsNothing);
    expect(find.byKey(const Key('line.promoDiscount')), findsNothing);
    expect(find.byKey(const Key('guest.name')), findsNothing);
    expect(payButton(tester).onPressed, isNotNull);
  });

  testWidgets('pay shows progress and is disabled while submitting', (tester) async {
    await pump(tester, ready(guest: const GuestInfo(name: 'Dara', phone: '012')).copyWith(submitting: true));

    expect(payButton(tester).onPressed, isNull);
    expect(find.descendant(of: find.byKey(const Key('checkout.pay')), matching: find.byType(CircularProgressIndicator)),
        findsOneWidget);
    expect(find.text('Processing…'), findsOneWidget);
  });

  testWidgets('empty cart: food card previews the menu and opens concessions with the same bloc', (tester) async {
    RouteSettings? pushed;
    await pump(
      tester,
      ready(),
      onGenerateRoute: (settings) {
        pushed = settings;
        return MaterialPageRoute<void>(settings: settings, builder: (_) => const Scaffold(body: Text('shop')));
      },
    );

    expect(find.byKey(const Key('food.7.plus')), findsNothing, reason: 'no stepper rows on checkout');
    expect(find.text('Browse'), findsOneWidget);
    expect(find.text('Add popcorn, drinks, or snacks to your order.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkout.foodCard')));
    await tester.pumpAndSettle();
    expect(pushed?.name, AppRoutes.concessions);
    expect(pushed?.arguments, isA<CheckoutBloc>());
    expect(find.text('shop'), findsOneWidget);
  });

  testWidgets('chosen food: card lists each line with quantity and the server line total', (tester) async {
    final quote = testQuote(foodTotal: 6, total: 18.5).copyWith(foodLines: const [
      FoodLine(foodItemId: 7, name: 'Popcorn', unitPrice: 3, quantity: 2, lineTotal: 6),
    ]);
    await pump(tester, ready(quote: quote).copyWith(food: {7: 2}));

    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);
    final line = find.byKey(const Key('food.7.line'));
    expect(line, findsOneWidget);
    expect(find.descendant(of: line, matching: find.text('×2')), findsOneWidget);
    expect(find.descendant(of: line, matching: find.text('\$6.00')), findsOneWidget);
    expect(find.byKey(const Key('food.8.line')), findsNothing);
    expect(find.byKey(const Key('line.food')), findsOneWidget, reason: 'price block shows the server food total');
  });

  testWidgets('food card is hidden when the menu is empty', (tester) async {
    await pump(tester, ready(quote: testQuote().copyWith(foodItems: const [])));
    expect(find.byKey(const Key('checkout.foodCard')), findsNothing);
  });
}
