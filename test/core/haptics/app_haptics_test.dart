import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/haptics/app_haptics.dart';
import 'package:movie_ticket_mobile/core/widgets/app_button.dart';
import 'package:movie_ticket_mobile/core/widgets/app_chip.dart';
import 'package:movie_ticket_mobile/features/checkout/view/ticket_issued_animation.dart';
import 'package:movie_ticket_mobile/features/seats/controller/seat_map_bloc.dart';
import 'package:movie_ticket_mobile/features/seats/view/seat_map_page.dart';

import '../../features/seats/seat_fixtures.dart';
import '../../helpers/localized_app.dart';

class _MockSeatMapBloc extends MockBloc<SeatMapEvent, SeatMapState> implements SeatMapBloc {}

/// Sprint 15 interaction contract: each kind of tap plays its haptic from the table.
void main() {
  final played = <String>[];

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(const HoldRequested());
  });

  setUp(() {
    played.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform,
        (call) async {
      if (call.method == 'HapticFeedback.vibrate') played.add(call.arguments as String? ?? 'vibrate');
      return null;
    });
  });

  tearDown(() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, null));

  test('the table: one platform haptic per kind', () async {
    for (final kind in HapticKind.values) {
      await AppHaptics.play(kind);
    }
    expect(played, [
      'HapticFeedbackType.selectionClick',
      'HapticFeedbackType.lightImpact',
      'HapticFeedbackType.mediumImpact',
      'HapticFeedbackType.heavyImpact',
      'vibrate',
    ]);
  });

  testWidgets('a chip is a selection, a primary button is light', (tester) async {
    await pumpLocalized(
      tester,
      Scaffold(
        body: Column(children: [
          AppChip(key: const Key('chip'), label: 'Drama', selected: false, onSelected: () {}),
          AppButton.primary(key: const Key('pay'), label: 'Pay', onPressed: () {}),
        ]),
      ),
    );

    await tester.tap(find.byKey(const Key('chip')));
    await tester.tap(find.byKey(const Key('pay')));
    await tester.pump();

    expect(played, ['HapticFeedbackType.selectionClick', 'HapticFeedbackType.lightImpact']);
  });

  testWidgets('a seat tap is a selection', (tester) async {
    final bloc = _MockSeatMapBloc();
    whenListen(bloc, const Stream<SeatMapState>.empty(),
        initialState: SeatMapReady(data: seatMap(), heldByOthers: const {}, booked: const {3, 14}));
    await pumpLocalized(tester, BlocProvider<SeatMapBloc>.value(value: bloc, child: const SeatMapPage()));

    await tester.tap(find.text('A1'));
    await tester.pump();

    expect(played, contains('HapticFeedbackType.selectionClick'));
  });

  testWidgets('the ticket issued on success is a success haptic', (tester) async {
    await pumpLocalized(tester, const Scaffold(body: TicketIssuedAnimation()));
    await tester.pump(TicketIssuedAnimation.duration);

    expect(played, contains('HapticFeedbackType.mediumImpact'));
  });
}
