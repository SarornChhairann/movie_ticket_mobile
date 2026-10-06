import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/model/quote.dart';
import 'package:movie_ticket_mobile/features/checkout/view/concessions_page.dart';

import '../../helpers/localized_app.dart';
import 'checkout_fixtures.dart';

class _MockCheckoutBloc extends MockBloc<CheckoutEvent, CheckoutState> implements CheckoutBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const FoodChanged(0, 0));
    await initTestLocalization();
  });

  CheckoutReady ready({Map<int, int> food = const {}, Quote? quote}) =>
      CheckoutReady(hold: testHold, quote: quote ?? testQuote(), food: food, secondsLeft: 600);

  Future<_MockCheckoutBloc> pump(WidgetTester tester, CheckoutState state) async {
    final bloc = _MockCheckoutBloc();
    whenListen(bloc, const Stream<CheckoutState>.empty(), initialState: state);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(tester, BlocProvider<CheckoutBloc>.value(value: bloc, child: const ConcessionsPage()));
    return bloc;
  }

  testWidgets('quantity 0 shows Add, which sends FoodChanged(id, 1)', (tester) async {
    final bloc = await pump(tester, ready());

    expect(find.byKey(const Key('food.7.add')), findsOneWidget);
    expect(find.byKey(const Key('food.7.plus')), findsNothing);
    await tester.tap(find.byKey(const Key('food.7.add')));
    verify(() => bloc.add(any(that: isA<FoodChanged>()
        .having((e) => e.foodItemId, 'id', 7)
        .having((e) => e.quantity, 'quantity', 1)))).called(1);
  });

  testWidgets('a chosen item shows − n +; plus is disabled at the stock cap; minus at 1 sends 0', (tester) async {
    final bloc = await pump(tester, ready(food: {7: 2, 8: 1}));

    expect(find.byKey(const Key('food.7.add')), findsNothing);
    expect(tester.widget<Text>(find.byKey(const Key('food.7.qty'))).data, '2');
    expect(tester.widget<IconButton>(find.byKey(const Key('food.7.plus'))).onPressed, isNull,
        reason: 'popcorn stock is 2');
    expect(tester.widget<IconButton>(find.byKey(const Key('food.8.plus'))).onPressed, isNotNull,
        reason: 'water is unlimited');

    await tester.tap(find.byKey(const Key('food.8.minus')));
    verify(() => bloc.add(any(that: isA<FoodChanged>()
        .having((e) => e.foodItemId, 'id', 8)
        .having((e) => e.quantity, 'quantity', 0)))).called(1);
  });

  testWidgets('search narrows the grid after the debounce and never touches the cart', (tester) async {
    final bloc = await pump(tester, ready(food: {8: 1}));

    await tester.enterText(find.byKey(const Key('concessions.search')), 'WAT');
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byKey(const Key('food.7.card')), findsOneWidget, reason: 'not applied before the debounce');

    await tester.pump(ConcessionsPage.searchDebounce);
    expect(find.byKey(const Key('food.7.card')), findsNothing);
    expect(find.byKey(const Key('food.8.card')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('concessions.search')), 'pizza');
    await tester.pump(ConcessionsPage.searchDebounce);
    expect(find.byKey(const Key('concessions.empty')), findsOneWidget);
    expect(find.byKey(const Key('concessions.tab.all')), findsOneWidget, reason: 'tabs stay on a search miss');

    await tester.enterText(find.byKey(const Key('concessions.search')), '');
    await tester.pump(ConcessionsPage.searchDebounce);
    expect(find.byKey(const Key('food.7.card')), findsOneWidget);

    verifyNever(() => bloc.add(any()));
  });

  testWidgets('tabs group the menu and empty groups are hidden', (tester) async {
    await pump(tester, ready());

    // Popcorn → Popcorn, Water → Snacks; no drinks keyword in the fixture menu.
    expect(find.byKey(const Key('concessions.tab.popcorn')), findsOneWidget);
    expect(find.byKey(const Key('concessions.tab.snacks')), findsOneWidget);
    expect(find.byKey(const Key('concessions.tab.drinks')), findsNothing);

    await tester.tap(find.byKey(const Key('concessions.tab.popcorn')));
    await tester.pump();
    expect(find.byKey(const Key('food.7.card')), findsOneWidget);
    expect(find.byKey(const Key('food.8.card')), findsNothing);
  });

  testWidgets('bottom bar shows units and the server food total, with the hold countdown', (tester) async {
    final quote = testQuote(foodTotal: 7, total: 19.5).copyWith(foodLines: const [
      FoodLine(foodItemId: 7, name: 'Popcorn', unitPrice: 3, quantity: 2, lineTotal: 6),
      FoodLine(foodItemId: 8, name: 'Water', unitPrice: 1, quantity: 1, lineTotal: 1),
    ]);
    await pump(tester, ready(food: {7: 2, 8: 1}, quote: quote).copyWith(quoting: true));

    expect(find.text('3 items'), findsOneWidget);
    expect(find.text('\$7.00'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Hold expires in 10:00'), findsOneWidget);
    expect(find.byKey(const Key('checkout.pay')), findsNothing, reason: 'Pay stays on checkout');
  });

  testWidgets('Done pops back', (tester) async {
    final bloc = _MockCheckoutBloc();
    whenListen(bloc, const Stream<CheckoutState>.empty(), initialState: ready());
    await pumpLocalized(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            key: const Key('open'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => BlocProvider<CheckoutBloc>.value(value: bloc, child: const ConcessionsPage()),
            )),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('open')));
    await tester.pumpAndSettle();
    expect(find.byType(ConcessionsPage), findsOneWidget);

    await tester.tap(find.byKey(const Key('concessions.done')));
    await tester.pumpAndSettle();
    expect(find.byType(ConcessionsPage), findsNothing);
    verifyNever(() => bloc.add(any()));
  });
}
