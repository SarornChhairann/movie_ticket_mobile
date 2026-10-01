import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/reminders/controller/reminder_bloc.dart';
import 'package:movie_ticket_mobile/features/reminders/view/reminder_sheet.dart';

import '../../helpers/localized_app.dart';

class _Auth extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class _Reminder extends MockBloc<ReminderEvent, ReminderState> implements ReminderBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
  });

  const movie = Movie(id: 2, title: 'Avatar 3', comingSoon: true);

  /// Opens the sheet over a page and returns the value it closes with.
  Future<List<bool?>> open(WidgetTester tester, Stream<ReminderState> states) async {
    final auth = _Auth();
    whenListen(auth, const Stream<AuthState>.empty(), initialState: const AuthState.guest());
    final reminder = _Reminder();
    whenListen(reminder, states, initialState: const ReminderState.idle());
    final results = <bool?>[];
    await pumpLocalized(
      tester,
      BlocProvider<AuthBloc>.value(
        value: auth,
        child: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              key: const Key('open'),
              onPressed: () async => results.add(await showModalBottomSheet<bool>(
                context: context,
                // In the app AuthBloc sits above MaterialApp; here it must reach the sheet's route.
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<AuthBloc>.value(value: auth),
                    BlocProvider<ReminderBloc>.value(value: reminder),
                  ],
                  child: const ReminderSheet(movie: movie),
                ),
              )),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('open')));
    await tester.pumpAndSettle();
    return results;
  }

  testWidgets('shows the movie and the reminder form', (tester) async {
    await open(tester, const Stream.empty());

    expect(find.text('Avatar 3'), findsOneWidget);
    expect(find.byKey(const Key('reminders.email')), findsOneWidget);
  });

  testWidgets('closes with true shortly after subscribing, so the confirmation is seen', (tester) async {
    final controller = Stream<ReminderState>.fromIterable(const [ReminderState.submitting(), ReminderState.success()]);
    final results = await open(tester, controller);

    expect(find.text("You're subscribed. We'll email you when tickets open."), findsOneWidget);
    expect(results, isEmpty, reason: 'held for a moment');

    await tester.pump(ReminderSheet.confirmHold);
    await tester.pumpAndSettle();
    expect(results, [true]);
  });

  testWidgets('already subscribed also closes with true', (tester) async {
    final results = await open(tester, Stream.value(const ReminderState.alreadySubscribed()));
    await tester.pump(ReminderSheet.confirmHold);
    await tester.pumpAndSettle();

    expect(results, [true]);
  });
}
