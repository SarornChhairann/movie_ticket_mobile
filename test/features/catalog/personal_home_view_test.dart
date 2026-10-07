import 'dart:ui' show Tristate;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/api_failure.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/favourite_halls_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' as halls;
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/recently_viewed_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/search_results_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/local_prefs_store.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_home_view.dart';
import 'package:movie_ticket_mobile/features/catalog/view/search_results_page.dart';

import '../../helpers/localized_app.dart';
import '../../helpers/memory_prefs.dart';
import '../../helpers/showing.dart';
import 'hall_fixtures.dart';

class _MovieList extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

class _HallList extends MockBloc<halls.HallListEvent, halls.HallListState> implements halls.HallListBloc {}

class _Halls extends Mock implements HallRepository {}

class _Catalog extends Mock implements CatalogRepository {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(MovieTab.nowShowing);
    registerFallbackValue(const RefreshRequested());
  });

  const dune = Movie(id: 1, title: 'Dune', comingSoon: false);
  const heat = Movie(id: 2, title: 'Heat', comingSoon: false);
  const avatar = Movie(id: 3, title: 'Avatar 3', comingSoon: true);
  const homeMovies =
      MovieListState.ready(tab: MovieTab.nowShowing, search: '', nowShowing: [dune, heat], comingSoon: [avatar]);

  late MemoryPrefs prefs;
  late _MovieList movieBloc;
  late _Catalog catalog;
  late List<RouteSettings> pushed;

  Future<void> pump(WidgetTester tester, {LocalPrefs initial = LocalPrefs.empty}) async {
    tester.view.physicalSize = const Size(1080, 8000);
    addTearDown(tester.view.resetPhysicalSize);
    prefs = MemoryPrefs(initial);
    final hallRepo = _Halls();
    when(() => hallRepo.fetchSchedule(any(), date: any(named: 'date')))
        .thenAnswer((_) async => const Err(ApiFailure.network()));
    final favourites = FavouriteHallsCubit(prefs, hallRepo)..load();
    final recent = RecentlyViewedCubit(prefs)..load();
    addTearDown(favourites.close);
    addTearDown(recent.close);
    movieBloc = _MovieList();
    whenListen(movieBloc, const Stream<MovieListState>.empty(), initialState: homeMovies);
    final hallBloc = _HallList();
    whenListen(hallBloc, const Stream<halls.HallListState>.empty(),
        initialState: const halls.HallListState.ready(testHalls));
    catalog = _Catalog();
    when(() => catalog.fetchMovies(any(), search: any(named: 'search'))).thenAnswer((_) async => const Ok([]));
    pushed = [];
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<MovieListBloc>.value(value: movieBloc),
          BlocProvider<halls.HallListBloc>.value(value: hallBloc),
          BlocProvider<ShowingCubit>.value(value: showingStub()),
          BlocProvider<FavouriteHallsCubit>.value(value: favourites),
          BlocProvider<RecentlyViewedCubit>.value(value: recent),
        ],
        child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {})),
      ),
      onGenerateRoute: (settings) {
        pushed.add(settings);
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => settings.name == AppRoutes.search
              ? BlocProvider(
                  create: (_) => SearchResultsBloc(catalog, prefs, settings.arguments! as SearchSeed)
                    ..add(const SearchOpened()),
                  child: const SearchResultsPage(),
                )
              : const Scaffold(),
        );
      },
    );
    await tester.pump(const Duration(seconds: 1));
  }

  group('favourite halls', () {
    testWidgets('the heart toggles and "Your halls" appears above the Halls list', (tester) async {
      await pump(tester);
      expect(find.byKey(const Key('home.yourHalls')), findsNothing);

      await tester.tap(find.byKey(const Key('hall.3.favourite')));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const Key('home.yourHalls')), findsOneWidget);
      expect(find.byKey(const Key('home.yourHalls.3')), findsOneWidget);
      expect((await prefs.read()).favouriteHalls, [3]);
      expect(
        tester.getTopLeft(find.byKey(const Key('home.yourHalls'))).dy,
        lessThan(tester.getTopLeft(find.text('Halls')).dy),
      );

      await tester.tap(find.byKey(const Key('home.yourHalls.3')));
      await tester.pump(const Duration(seconds: 1));
      expect(pushed.last.name, AppRoutes.hallSchedule);
      expect(pushed.last.arguments, 3);
    });

    testWidgets('hearts say what they do to a screen reader', (tester) async {
      await pump(tester, initial: const LocalPrefs(favouriteHalls: [1]));
      final semantics = tester.ensureSemantics();

      expect(find.byTooltip('Remove from your halls'), findsOneWidget);
      expect(find.byTooltip('Add to your halls'), findsNWidgets(2));
      final node = tester.getSemantics(find.byKey(const Key('hall.1.favourite')));
      expect(node.tooltip, 'Remove from your halls');
      expect(node.flagsCollection.isSelected, Tristate.isTrue);
      semantics.dispose();
    });

    testWidgets('a favourite that is no longer listed is not shown', (tester) async {
      await pump(tester, initial: const LocalPrefs(favouriteHalls: [99]));

      expect(find.byKey(const Key('home.yourHalls')), findsNothing);
    });
  });

  group('recently viewed', () {
    testWidgets('shows listed movies newest first, dropping missing ids', (tester) async {
      await pump(tester, initial: const LocalPrefs(recentMovies: [3, 42, 1]));

      final rail = find.byKey(const Key('rail.recent'));
      expect(rail, findsOneWidget);
      expect(find.descendant(of: rail, matching: find.text('Dune')), findsOneWidget);
      expect(find.descendant(of: rail, matching: find.text('Avatar 3')), findsOneWidget);
      expect(
        tester.getTopLeft(find.descendant(of: rail, matching: find.text('Avatar 3'))).dx,
        lessThan(tester.getTopLeft(find.descendant(of: rail, matching: find.text('Dune'))).dx),
      );
    });

    testWidgets('hides with fewer than two still listed', (tester) async {
      await pump(tester, initial: const LocalPrefs(recentMovies: [1, 42]));

      expect(find.byKey(const Key('section.recent')), findsNothing);
    });

    testWidgets('a poster there opens detail with source recent', (tester) async {
      await pump(tester, initial: const LocalPrefs(recentMovies: [2, 1]));

      await tester.tap(find.descendant(of: find.byKey(const Key('rail.recent')), matching: find.byKey(const Key('movie.2'))));
      await tester.pump(const Duration(seconds: 1));

      expect((pushed.last.arguments! as MovieDetailArgs).trackingSource, 'recent');
    });
  });

  group('search results view', () {
    Future<void> openSearch(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('home.search')));
      // The field waits out the double-tap window before its tap; then the route runs.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      // SearchOpened reads the recent searches.
      await tester.pump();
    }

    Future<void> type(WidgetTester tester, String q) async {
      await tester.enterText(find.byKey(const Key('search.field')), q);
      await tester.pump(MovieListBloc.searchDebounce);
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('groups Movies (now showing, then coming soon, with status) and Halls', (tester) async {
      await pump(tester);
      await openSearch(tester);
      expect(pushed.last.name, AppRoutes.search);
      when(() => catalog.fetchMovies(MovieTab.nowShowing, search: any(named: 'search')))
          .thenAnswer((_) async => const Ok([heat]));
      when(() => catalog.fetchMovies(MovieTab.comingSoon, search: any(named: 'search')))
          .thenAnswer((_) async => const Ok([avatar]));

      await type(tester, 'a');

      expect(find.byKey(const Key('search.group.movies')), findsOneWidget);
      expect(find.byKey(const Key('search.group.halls')), findsOneWidget);
      final heatY = tester.getTopLeft(find.byKey(const Key('search.movie.2'))).dy;
      expect(tester.getTopLeft(find.byKey(const Key('search.movie.3'))).dy, greaterThan(heatY));
      expect(find.text('Now showing'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
      expect(
        tester.getTopLeft(find.byKey(const Key('search.group.halls'))).dy,
        greaterThan(tester.getTopLeft(find.byKey(const Key('search.movie.3'))).dy),
      );
      verifyNever(() => movieBloc.add(any(that: isA<SearchChanged>())));
    });

    testWidgets('no match is one empty state whose Clear search shows recent searches', (tester) async {
      await pump(tester, initial: const LocalPrefs(recentSearches: ['heat']));
      await openSearch(tester);
      expect(find.byKey(const Key('search.recent.0')), findsOneWidget);

      await type(tester, 'zzz');
      expect(find.byKey(const Key('search.empty')), findsOneWidget);
      expect(find.byKey(const Key('search.group.movies')), findsNothing);

      await tester.tap(find.text('Clear search'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(const Key('search.empty')), findsNothing);
      expect(find.byKey(const Key('search.recent.0')), findsOneWidget);
    });

    testWidgets('a recent search re-runs on tap; clear-all removes them', (tester) async {
      await pump(tester, initial: const LocalPrefs(recentSearches: ['dune', 'heat']));
      await openSearch(tester);

      await tester.tap(find.byKey(const Key('search.recent.1')));
      await tester.pump(MovieListBloc.searchDebounce);
      await tester.pump(const Duration(seconds: 1));
      expect(tester.widget<TextField>(find.byKey(const Key('search.field'))).controller!.text, 'heat');
      verify(() => catalog.fetchMovies(MovieTab.nowShowing, search: 'heat')).called(1);

      await tester.tap(find.byKey(const Key('search.clear')));
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('search.clearRecent')));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(const Key('search.recent')), findsNothing);
      expect((await prefs.read()).recentSearches, isEmpty);
    });

    testWidgets('back returns to Home exactly as it was', (tester) async {
      await pump(tester);
      await openSearch(tester);
      await type(tester, 'zzz');

      await tester.pageBack();
      await tester.pump(const Duration(seconds: 1));

      final rail = find.byKey(const Key('rail.nowShowing'));
      expect(find.descendant(of: rail, matching: find.text('Dune')), findsOneWidget);
      expect(find.descendant(of: rail, matching: find.text('Heat')), findsOneWidget);
      for (final id in [1, 2, 3]) {
        expect(find.byKey(Key('hall.$id')), findsOneWidget);
      }
      verifyNever(() => movieBloc.add(any(that: isA<SearchChanged>())));
    });
  });
}
