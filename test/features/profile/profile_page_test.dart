import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/l10n/app_locales.dart';
import 'package:movie_ticket_mobile/features/profile/controller/profile_bloc.dart';
import 'package:movie_ticket_mobile/features/profile/view/profile_page.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/my_bookings_bloc.dart';

import '../../helpers/localized_app.dart';
import '../auth/auth_fixtures.dart';
import '../tickets/tickets_fixtures.dart';

class _MockProfileBloc extends MockBloc<ProfileEvent, ProfileState> implements ProfileBloc {}

class _MockMyBookingsBloc extends MockBloc<MyBookingsEvent, MyBookingsState> implements MyBookingsBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  Future<void> pump(WidgetTester tester, {Locale locale = AppLocales.en, MyBookingsState? bookings}) async {
    final profile = _MockProfileBloc();
    whenListen(profile, const Stream<ProfileState>.empty(),
        initialState: ProfileState.ready(testUser.copyWith(points: 42)));
    final myBookings = _MockMyBookingsBloc();
    whenListen(myBookings, const Stream<MyBookingsState>.empty(),
        initialState: bookings ?? const MyBookingsState.loading());
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>.value(value: profile),
          BlocProvider<MyBookingsBloc>.value(value: myBookings),
        ],
        child: const ProfilePage(),
      ),
      locale: locale,
    );
  }

  testWidgets('shows the server points with the English label', (tester) async {
    await pump(tester);

    expect(find.text('Loyalty points'), findsOneWidget);
    expect(find.byKey(const Key('profile.points')), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('km locale shows the Khmer points label', (tester) async {
    await pump(tester, locale: AppLocales.km);

    expect(find.text('ពិន្ទុសមាជិក'), findsOneWidget);
    expect(find.text('Loyalty points'), findsNothing);
  });

  testWidgets('last booking shortcut is the first (newest) booking', (tester) async {
    await pump(tester, bookings: MyBookingsState.ready(bookings: [testBooking(id: 3), testBooking(id: 1)]));

    expect(find.byKey(const Key('loyalty.lastBooking')), findsOneWidget);
    expect(find.text('Last booking'), findsOneWidget);
  });

  testWidgets('no bookings, no shortcut', (tester) async {
    await pump(tester, bookings: const MyBookingsState.ready(bookings: []));

    expect(find.byKey(const Key('loyalty.lastBooking')), findsNothing);
  });
}
