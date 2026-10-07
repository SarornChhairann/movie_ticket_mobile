import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/core/navigation/shell_tabs.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/motion/motion.dart';
import 'package:movie_ticket_mobile/core/motion/poster_hero.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/auth/view/auth_gate.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' hide RefreshRequested;
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/profile/controller/profile_bloc.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_cubit.dart';
import 'package:movie_ticket_mobile/features/shell/controller/shell_state.dart';
import 'package:movie_ticket_mobile/features/shell/model/home_summary.dart';
import 'package:movie_ticket_mobile/features/shell/view/shell_page.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/my_bookings_bloc.dart' as tickets;

import '../../helpers/localized_app.dart';
import '../auth/auth_fixtures.dart';
import '../../helpers/showing.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class _MockShellCubit extends MockCubit<ShellState> implements ShellCubit {}

class _MockProfileBloc extends MockBloc<ProfileEvent, ProfileState> implements ProfileBloc {}

class _MockMyBookingsBloc extends MockBloc<tickets.MyBookingsEvent, tickets.MyBookingsState>
    implements tickets.MyBookingsBloc {
  @override
  bool get guest => false;
}

class _MockGuestBookingsBloc extends MockBloc<tickets.MyBookingsEvent, tickets.MyBookingsState>
    implements tickets.GuestBookingsBloc {
  @override
  bool get guest => true;
}

class _MockHallListBloc extends MockBloc<HallListEvent, HallListState> implements HallListBloc {}

class _MockCatalogRepository extends Mock implements CatalogRepository {}

class _RouteRecorder extends NavigatorObserver {
  final pushed = <RouteSettings>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => pushed.add(route.settings);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(MovieTab.nowShowing);
    registerFallbackValue(const tickets.LoadRequested());
    registerFallbackValue(const ProfileLoaded());
    await initTestLocalization();
  });

  const dune = Movie(id: 1, title: 'Dune', comingSoon: false, genre: 'Science fiction', rating: 'PG-13');
  const heat = Movie(id: 3, title: 'Heat', comingSoon: false, genre: 'Crime');
  const avatar = Movie(id: 2, title: 'Avatar 3', comingSoon: true, genre: 'Science fiction');

  late MovieListBloc movieListBloc;
  late ExploreMovieListBloc exploreBloc;
  late _RouteRecorder recorder;
  late _MockProfileBloc profileBloc;
  late _MockMyBookingsBloc myBookingsBloc;
  late _MockGuestBookingsBloc guestBookingsBloc;
  late _MockShellCubit shellCubit;

  Future<void> pump(
    WidgetTester tester, {
    AuthState auth = const AuthState.guest(),
    ShellTabs? tabs,
    // 12:00 UTC is 19:00 at the cinema: evening.
    DateTime Function()? clock,
    ShellState shellState = const ShellState.ready(HomeSummary(nowShowingCount: 2, comingSoonCount: 1, cinemaCount: 1)),
  }) async {
    final repository = _MockCatalogRepository();
    when(() => repository.fetchMovies(MovieTab.nowShowing, search: any(named: 'search')))
        .thenAnswer((_) async => const Ok([dune, heat]));
    when(() => repository.fetchMovies(MovieTab.comingSoon, search: any(named: 'search')))
        .thenAnswer((_) async => const Ok([avatar]));
    movieListBloc = MovieListBloc(repository)..add(const RefreshRequested());
    addTearDown(movieListBloc.close);
    exploreBloc = ExploreMovieListBloc(repository)..add(const RefreshRequested());
    addTearDown(exploreBloc.close);

    final authBloc = _MockAuthBloc();
    whenListen(authBloc, const Stream<AuthState>.empty(), initialState: auth);
    final hallListBloc = _MockHallListBloc();
    whenListen(hallListBloc, const Stream<HallListState>.empty(), initialState: const HallListState.ready([]));
    final cubit = shellCubit = _MockShellCubit();
    whenListen(cubit, const Stream<ShellState>.empty(), initialState: shellState);
    profileBloc = _MockProfileBloc();
    whenListen(profileBloc, const Stream<ProfileState>.empty(), initialState: const ProfileState.ready(testUser));
    myBookingsBloc = _MockMyBookingsBloc();
    whenListen(myBookingsBloc, const Stream<tickets.MyBookingsState>.empty(),
        initialState: const tickets.MyBookingsState.ready(bookings: []));
    guestBookingsBloc = _MockGuestBookingsBloc();
    whenListen(guestBookingsBloc, const Stream<tickets.MyBookingsState>.empty(),
        initialState: const tickets.MyBookingsState.ready(bookings: []));
    recorder = _RouteRecorder();

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<ShellCubit>.value(value: cubit),
          BlocProvider<MovieListBloc>.value(value: movieListBloc),
          BlocProvider<ExploreMovieListBloc>.value(value: exploreBloc),
          BlocProvider<HallListBloc>.value(value: hallListBloc),
          BlocProvider<ShowingCubit>.value(value: showingStub()),
          BlocProvider<ProfileBloc>.value(value: profileBloc),
          BlocProvider<tickets.MyBookingsBloc>.value(value: myBookingsBloc),
          BlocProvider<tickets.GuestBookingsBloc>.value(value: guestBookingsBloc),
        ],
        child: Navigator(
          observers: [recorder],
          onGenerateRoute: (settings) => switch (settings.name) {
            '/' => MaterialPageRoute<void>(settings: settings, builder: (_) => ShellPage(tabs: tabs, clock: clock ?? () => DateTime.utc(2026, 10, 7, 12))),
            // Stand-in login sheet; closing it is a dismiss.
            AppRoutes.login => MaterialPageRoute<AuthGateResult>(
                settings: settings,
                builder: (context) => Scaffold(
                  body: TextButton(
                    key: const Key('fakeLogin.close'),
                    onPressed: () => Navigator.of(context).pop(AuthGateResult.dismissed),
                    child: const Text('close'),
                  ),
                ),
              ),
            AppRoutes.bookingLookup =>
              MaterialPageRoute<BookingSummary>(settings: settings, builder: (_) => const Scaffold()),
            _ => MaterialPageRoute<void>(settings: settings, builder: (_) => const Scaffold()),
          },
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump();
  }

  testWidgets('cold start shows the greeting, both rails, and genre chips from the API', (tester) async {
    await pump(tester);

    expect(find.text('Good evening'), findsOneWidget);
    expect(find.text('Now in Cinemas'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('rail.nowShowing')), matching: find.text('Dune')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('carousel')), matching: find.text('Avatar 3')), findsOneWidget);
    expect(find.byKey(const Key('genre.all')), findsOneWidget);
    expect(find.byKey(const Key('genre.Crime')), findsOneWidget);
    expect(find.byKey(const Key('genre.Drama')), findsNothing, reason: 'genres are not hard-coded');
    expect(find.text('PG-13'), findsOneWidget);
    expect(Theme.of(tester.element(find.byType(ShellPage))).brightness, Brightness.dark);
  });

  testWidgets('a genre chip hides non-matching titles in the rail below it, never the carousel', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('genre.Crime')));
    await tester.pump();
    // Let the crossfade finish (not pumpAndSettle: carousel auto-advance never settles).
    await tester.pump(Motion.long + Motion.medium);

    final rail = find.byKey(const Key('rail.nowShowing'));
    expect(find.descendant(of: rail, matching: find.text('Heat')), findsOneWidget);
    expect(find.descendant(of: rail, matching: find.text('Dune')), findsNothing);
    // Sprint 20: the coming-soon carousel is not filtered by the chips above the rail.
    expect(find.text('Avatar 3'), findsOneWidget);
  });

  testWidgets('opening a poster routes to movie detail with its id', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('movie.1')));
    await tester.pumpAndSettle();

    expect(recorder.pushed.last.name, AppRoutes.movieDetail);
    final args = recorder.pushed.last.arguments! as MovieDetailArgs;
    expect(args.movieId, 1);
    expect(args.heroSource, HeroSource.nowShowing, reason: 'the poster flies from the rail it was tapped on');
  });

  testWidgets('See all switches to Explore on that tab', (tester) async {
    await pump(tester);

    // Sprint 20: Coming soon sits below the bookable sections.
    await tester.scrollUntilVisible(find.byKey(const Key('home.comingSoon.seeAll')), 300,
        scrollable: find.byType(Scrollable).first);
    // Centre it so the tap does not land on the bottom bar.
    await Scrollable.ensureVisible(tester.element(find.byKey(const Key('home.comingSoon.seeAll'))), alignment: 0.5);
    await tester.pump();
    await tester.tap(find.byKey(const Key('home.comingSoon.seeAll')));
    await tester.pump();
    // Let the crossfade finish (not pumpAndSettle: carousel auto-advance never settles).
    await tester.pump(Motion.long + Motion.medium);

    expect(exploreBloc.state.tab, MovieTab.comingSoon, reason: 'Explore has its own list (sprint 22)');
    final chip = tester.widget<ChoiceChip>(
      find.descendant(of: find.byKey(const Key('explore.tab.comingSoon')), matching: find.byType(ChoiceChip)),
    );
    expect(chip.selected, isTrue);
    expect(find.text('Avatar 3'), findsOneWidget);
    expect(find.text('Dune'), findsNothing);
  });

  testWidgets('the app opens on Home for a signed-out shopper — no login wall', (tester) async {
    await pump(tester);

    expect(find.byKey(const Key('home.greeting')), findsOneWidget);
    expect(recorder.pushed.where((r) => r.name == AppRoutes.login), isEmpty);
  });

  testWidgets('a guest opens Bookings on this phone: Find my booking, and sign-in with a reason', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('nav.bookings')));
    await tester.pumpAndSettle();

    expect(tester.widget<NavigationBar>(find.byKey(const Key('shell.nav'))).selectedIndex, ShellTab.bookings.index);
    expect(find.byKey(const Key('tickets.find')), findsOneWidget);
    expect(find.text('Bookings you make or find on this phone appear here.'), findsOneWidget);
    verify(() => guestBookingsBloc.add(any(that: isA<tickets.RefreshRequested>()))).called(1);
    verifyNever(() => myBookingsBloc.add(any()));

    await tester.tap(find.byKey(const Key('tickets.signIn')));
    await tester.pumpAndSettle();

    final login = recorder.pushed.last;
    expect(login.name, AppRoutes.login);
    expect((login.arguments! as LoginArgs).reasonKey, 'auth.reason.bookings');
    expect((login.arguments! as LoginArgs).allowGuest, isFalse);
  });

  testWidgets('a guest taps Find my booking: the lookup screen opens', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('nav.bookings')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('tickets.find')));
    await tester.pumpAndSettle();

    expect(recorder.pushed.last.name, AppRoutes.bookingLookup);
  });

  testWidgets('the guest avatar asks for sign-in for the account', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('shell.signIn')));
    await tester.pumpAndSettle();

    expect(recorder.pushed.last.name, AppRoutes.login);
    expect((recorder.pushed.last.arguments! as LoginArgs).reasonKey, 'auth.reason.account');
  });

  testWidgets('the guest Account tab stays open for settings and switches language', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('nav.profile')));
    await tester.pump();
    expect(find.byKey(const Key('profile.signIn')), findsOneWidget);
    expect(find.byKey(const Key('languageToggle')), findsOneWidget);
    expect(recorder.pushed.where((r) => r.name == AppRoutes.login), isEmpty);

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('languageToggle')));
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
    });
    await tester.pump();
    expect(find.text('ទំព័រដើម'), findsOneWidget);
  });

  testWidgets('signed in: avatar opens Profile, and Bookings reloads on open', (tester) async {
    await pump(tester, auth: const AuthState.authenticated(testUser));

    await tester.tap(find.byKey(const Key('shell.profile')));
    await tester.pump();
    expect(find.byKey(const Key('profile.points')), findsOneWidget);
    verify(() => profileBloc.add(any(that: isA<ProfileLoaded>()))).called(1);

    await tester.tap(find.byKey(const Key('nav.bookings')));
    await tester.pump();
    verify(() => myBookingsBloc.add(any(that: isA<tickets.RefreshRequested>()))).called(2);
  });

  testWidgets('a ticket landing opens Bookings with the badge (no flight without a source rect)', (tester) async {
    final tabs = ShellTabs();
    addTearDown(tabs.dispose);
    await pump(tester, tabs: tabs);

    tabs.open(ShellTabIndex.bookings);
    await tester.pumpAndSettle();

    expect(tester.widget<NavigationBar>(find.byKey(const Key('shell.nav'))).selectedIndex, ShellTab.bookings.index);
    expect(find.byKey(const Key('nav.bookings.badge')), findsWidgets);

    await tester.tap(find.byKey(const Key('nav.home')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('nav.bookings.badge')), findsNothing, reason: 'the badge clears on leaving');
  });

  testWidgets('home_viewed: once on arrival and once per return to Home, never on re-tapping it', (tester) async {
    await pump(tester);
    verify(() => shellCubit.homeViewed()).called(1);

    await tester.tap(find.byKey(const Key('nav.home')));
    await tester.pump(const Duration(seconds: 1));
    verifyNever(() => shellCubit.homeViewed());

    await tester.tap(find.byKey(const Key('nav.explore')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('nav.home')));
    await tester.pump(const Duration(seconds: 1));
    verify(() => shellCubit.homeViewed()).called(1);
  });

  testWidgets('a saved Home says so, with when it was saved', (tester) async {
    await pump(
      tester,
      shellState: ShellState.ready(
        const HomeSummary(nowShowingCount: 0, comingSoonCount: 0, cinemaCount: 0),
        savedAt: DateTime(2026, 10, 7, 18, 40),
      ),
    );

    expect(find.byKey(const Key('home.offline')), findsOneWidget);
    expect(find.textContaining('18:40'), findsOneWidget);
    expect(find.byKey(const Key('shell.offlineBanner')), findsNothing);
  });

  group('greeting (sprint 22)', () {
    testWidgets('signed in: the time of day and the first name from the session', (tester) async {
      await pump(tester, auth: const AuthState.authenticated(testUser));

      expect(find.text('Good evening, Dara'), findsOneWidget);
    });

    testWidgets('by the cinema clock, not the phone zone', (tester) async {
      // 02:00 UTC is 09:00 in Phnom Penh, whatever zone the phone is in.
      await pump(tester, clock: () => DateTime.utc(2026, 10, 7, 2));

      expect(find.text('Good morning'), findsOneWidget);
    });
  });

  testWidgets('See all carries Home\'s genre to Explore', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('genre.Crime')));
    await tester.pump(Motion.long + Motion.medium);

    await tester.tap(find.byKey(const Key('catalog.nowInCinemas.seeAll')));
    await tester.pump();
    await tester.pump(Motion.long + Motion.medium);

    expect(exploreBloc.state.genre, 'Crime');
    expect(exploreBloc.state.tab, MovieTab.nowShowing);
  });

  testWidgets('an Explore search leaves Home\'s rails unfiltered', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('nav.explore')));
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byKey(const Key('catalog.search')), 'dune');
    await tester.pump(MovieListBloc.searchDebounce);
    await tester.pump(const Duration(seconds: 1));
    expect(exploreBloc.state.search, 'dune');

    await tester.tap(find.byKey(const Key('nav.home')));
    await tester.pump(const Duration(seconds: 1));

    expect(movieListBloc.state.search, '');
    final rail = find.byKey(const Key('rail.nowShowing'));
    expect(find.descendant(of: rail, matching: find.text('Dune')), findsOneWidget);
    expect(find.descendant(of: rail, matching: find.text('Heat')), findsOneWidget);
  });
}
