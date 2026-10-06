import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/ticket_bloc.dart';
import 'package:movie_ticket_mobile/features/tickets/view/ticket_card.dart';

import '../features/tickets/tickets_fixtures.dart';
import '../helpers/localized_app.dart';
import '../helpers/screens.dart';

class _MockTicketBloc extends MockBloc<TicketEvent, TicketState> implements TicketBloc {}

/// Sprint 18: the ticket card's front and its door-mode back, English and Khmer.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    await loadGoldenFonts();
  });

  final booking = testBooking().copyWith(reference: 'AB3DEF7H', showtimeId: 50);
  final ticket = booking.tickets.first;

  for (final locale in const [Locale('en'), Locale('km')]) {
    for (final side in const ['front', 'back']) {
      testWidgets('ticket $side (${locale.languageCode})', (tester) async {
        final qr = (await rootBundle.load('assets/images/brand/logo_mono.png')).buffer.asUint8List();
        final bloc = _MockTicketBloc();
        whenListen(bloc, const Stream<TicketState>.empty(), initialState: TicketState.ready(code: ticket.code, png: qr));
        tester.view.physicalSize = const Size(1170, 2000);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        await pumpLocalized(
          tester,
          Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: RepaintBoundary(
                key: const Key('golden'),
                child: BlocProvider<TicketBloc>.value(
                  value: bloc,
                  child: side == 'front'
                      ? TicketFront(booking: booking, ticket: ticket)
                      : TicketBack(booking: booking, ticket: ticket),
                ),
              ),
            ),
          ),
          locale: locale,
        );
        await tester.pump();
        await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('goldens/ticket_${side}_${locale.languageCode}.png'));
      });
    }
  }
}
