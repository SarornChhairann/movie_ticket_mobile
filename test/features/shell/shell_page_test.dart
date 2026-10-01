import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/l10n/app_locales.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_cubit.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_state.dart';
import 'package:movie_ticket_mobile/features/shell/model/home_summary.dart';
import 'package:movie_ticket_mobile/features/shell/view/shell_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockShellCubit extends MockCubit<ShellState> implements ShellCubit {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class _MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('renders the shell and the language toggle switches EN to Khmer', (tester) async {
    final authBloc = _MockAuthBloc();
    whenListen(authBloc, const Stream<AuthState>.empty(), initialState: const AuthState.guest());
    final movieListBloc = _MockMovieListBloc();
    whenListen(
      movieListBloc,
      const Stream<MovieListState>.empty(),
      initialState: const MovieListState.ready(
        tab: MovieTab.nowShowing,
        search: '',
        movies: [Movie(id: 1, title: 'Dune: Part Two', comingSoon: false, durationMinutes: 166)],
      ),
    );
    final cubit = _MockShellCubit();
    whenListen(
      cubit,
      const Stream<ShellState>.empty(),
      initialState: const ShellState.ready(
        HomeSummary(nowShowingCount: 3, comingSoonCount: 1, cinemaCount: 2),
      ),
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocales.supported,
        path: AppLocales.path,
        fallbackLocale: AppLocales.en,
        startLocale: AppLocales.en,
        saveLocale: false,
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>.value(value: authBloc),
                BlocProvider<ShellCubit>.value(value: cubit),
                BlocProvider<MovieListBloc>.value(value: movieListBloc),
              ],
              child: const ShellPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Movie Tickets'), findsOneWidget);
    expect(find.text('Now showing'), findsOneWidget);
    expect(find.text('Dune: Part Two'), findsOneWidget);
    expect(find.byKey(const Key('shell.signIn')), findsOneWidget);

    // setLocale reads the km asset from the bundle, which needs real async.
    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('languageToggle')));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    expect(find.text('សំបុត្រភាពយន្ត'), findsOneWidget);
    expect(find.text('កំពុងបញ្ចាំង'), findsOneWidget);
    expect(find.text('166 នាទី'), findsOneWidget);
  });
}
