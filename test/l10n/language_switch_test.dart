import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/format/money.dart';
import 'package:movie_ticket_mobile/core/format/show_time.dart';
import 'package:movie_ticket_mobile/core/l10n/app_locales.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/view/pay_success_page.dart';

import '../helpers/localized_app.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  test('money keeps two decimals and the dollar sign in both languages', () {
    expect(formatMoney(1234.5), r'$1,234.50');
    expect(formatMoney(12.5, locale: 'km'), contains('12.50'));
    expect(formatMoney(12.5, locale: 'km'), contains(r'$'));
  });

  test('show time is trimmed to HH:mm and a bad date falls back to the raw value', () {
    expect(formatShowTime('19:30:00'), '19:30');
    expect(formatShowDate('not-a-date'), 'not-a-date');
  });

  testWidgets('switching language re-renders the current screen: copy, date, and money', (tester) async {
    final authBloc = _MockAuthBloc();
    whenListen(authBloc, const Stream<AuthState>.empty(), initialState: const AuthState.guest());
    const booking = BookingSummary(
      bookingId: 99,
      status: BookingStatus.confirmed,
      movieTitle: 'Dune',
      hallName: 'Hall 1',
      showDate: '2026-10-07',
      showTime: '14:00:00',
      totalAmount: 1234.5,
      tickets: [TicketPass(code: 'T-1', seatCode: 'D1', status: 'ACTIVE')],
    );
    await pumpLocalized(
      tester,
      BlocProvider<AuthBloc>.value(value: authBloc, child: const PaySuccessPage(confirmation: booking)),
    );

    expect(find.text('Booking confirmed'), findsOneWidget);
    expect(find.text('Hall 1 · Wed, Oct 7, 2026 · 14:00'), findsOneWidget);
    expect(find.text(r'$1,234.50'), findsOneWidget);

    final context = tester.element(find.byType(PaySuccessPage));
    await tester.runAsync(() async {
      await context.setLocale(AppLocales.km);
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
    });
    await tester.pump();

    expect(find.text('ការកក់បានបញ្ជាក់'), findsOneWidget);
    expect(find.text('Hall 1 · Wed, Oct 7, 2026 · 14:00'), findsNothing);
    expect(find.text('Hall 1 · ${DateFormat.yMMMEd('km').format(DateTime(2026, 10, 7))} · 14:00'), findsOneWidget);
    expect(find.text(formatMoney(1234.5, locale: 'km')), findsOneWidget);
  });
}
