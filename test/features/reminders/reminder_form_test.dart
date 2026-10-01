import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_detail_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_detail_page.dart';
import 'package:movie_ticket_mobile/features/reminders/controller/reminder_bloc.dart';

import '../../helpers/localized_app.dart';
import '../auth/auth_fixtures.dart';

class _MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState> implements MovieDetailBloc {}

class _MockReminderBloc extends MockBloc<ReminderEvent, ReminderState> implements ReminderBloc {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  Future<void> pump(
    WidgetTester tester, {
    required bool comingSoon,
    AuthState auth = const AuthState.guest(),
    ReminderState reminder = const ReminderState.idle(),
  }) async {
    final detail = _MockMovieDetailBloc();
    whenListen(
      detail,
      const Stream<MovieDetailState>.empty(),
      initialState: MovieDetailState.ready(MovieDetail(
        movie: Movie(id: 7, title: 'Dune 3', comingSoon: comingSoon),
        availableDates: const [],
        cinemas: const [],
      )),
    );
    final reminders = _MockReminderBloc();
    whenListen(reminders, const Stream<ReminderState>.empty(), initialState: reminder);
    final authBloc = _MockAuthBloc();
    whenListen(authBloc, const Stream<AuthState>.empty(), initialState: auth);
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<MovieDetailBloc>.value(value: detail),
          BlocProvider<ReminderBloc>.value(value: reminders),
        ],
        child: const MovieDetailPage(),
      ),
    );
  }

  testWidgets('coming-soon detail offers the reminder with the signed-in email prefilled', (tester) async {
    await pump(tester, comingSoon: true, auth: const AuthState.authenticated(testUser));

    expect(find.byKey(const Key('reminders.submit')), findsOneWidget);
    expect(tester.widget<TextFormField>(find.byKey(const Key('reminders.email'))).controller!.text, testUser.email);
  });

  testWidgets('a guest starts with an empty email', (tester) async {
    await pump(tester, comingSoon: true);

    expect(tester.widget<TextFormField>(find.byKey(const Key('reminders.email'))).controller!.text, isEmpty);
  });

  testWidgets('now-showing detail has no reminder form', (tester) async {
    await pump(tester, comingSoon: false);

    expect(find.byKey(const Key('reminders.submit')), findsNothing);
  });

  testWidgets('already subscribed shows the friendly notice', (tester) async {
    await pump(tester, comingSoon: true, reminder: const ReminderState.alreadySubscribed());

    expect(find.text("You're already subscribed for this movie."), findsOneWidget);
  });
}
