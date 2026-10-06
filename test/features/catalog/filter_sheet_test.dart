import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/network/result.dart';
import 'package:movie_ticket_mobile/core/widgets/genre_chip.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' as halls;
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/catalog_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall_repository.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_home_view.dart';

import '../../helpers/localized_app.dart';
import 'hall_fixtures.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

class _MockHallRepository extends Mock implements HallRepository {}

void main() {
  const dune = Movie(id: 1, title: 'Dune', comingSoon: false, genre: 'Sci-Fi', language: 'English', rating: 'PG-13');
  const heat = Movie(id: 2, title: 'Heat', comingSoon: false, genre: 'Crime', language: 'English', rating: 'R');
  const tum = Movie(id: 3, title: 'Tum', comingSoon: false, genre: 'Sci-Fi', language: 'Khmer', rating: 'PG-13');

  late _MockCatalogRepository movieRepo;
  late _MockHallRepository hallRepo;
  late MovieListBloc movieBloc;
  late halls.HallListBloc hallBloc;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestLocalization();
    registerFallbackValue(MovieTab.nowShowing);
  });

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 6000);
    addTearDown(tester.view.resetPhysicalSize);
    movieRepo = _MockCatalogRepository();
    hallRepo = _MockHallRepository();
    when(() => movieRepo.fetchMovies(MovieTab.nowShowing, search: any(named: 'search')))
        .thenAnswer((_) async => const Ok([dune, heat, tum]));
    when(() => movieRepo.fetchMovies(MovieTab.comingSoon, search: any(named: 'search')))
        .thenAnswer((_) async => const Ok(<Movie>[]));
    when(() => hallRepo.fetchHalls()).thenAnswer((_) async => const Ok(testHalls));
    movieBloc = MovieListBloc(movieRepo)..add(const RefreshRequested());
    hallBloc = halls.HallListBloc(hallRepo)..add(const halls.LoadRequested());
    addTearDown(movieBloc.close);
    addTearDown(hallBloc.close);
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<MovieListBloc>.value(value: movieBloc),
          BlocProvider<halls.HallListBloc>.value(value: hallBloc),
        ],
        child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {})),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openSheet(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('search.filter')));
    await tester.pumpAndSettle();
  }

  Future<void> tapInSheet(WidgetTester tester, String key) async {
    final target = find.byKey(Key(key));
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Finder inRail(String title) =>
      find.descendant(of: find.byKey(const Key('rail.nowShowing')), matching: find.text(title));

  bool selected(WidgetTester tester, String key) => tester.widget<GenreChip>(find.byKey(Key(key))).selected;

  testWidgets('tune opens one sheet with every group; a chip keeps it open; Done closes it', (tester) async {
    await pump(tester);
    await openSheet(tester);

    expect(find.byKey(const Key('filter.sheet')), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
    for (final group in ['genre', 'language', 'rating', 'city', 'type']) {
      expect(find.byKey(Key('filter.$group.all')), findsOneWidget, reason: '$group starts with All');
    }
    expect(find.byKey(const Key('filter.language.Khmer')), findsOneWidget);
    expect(find.byKey(const Key('filter.type.ATMOS')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('filter.type')), matching: find.text('Atmos')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('filter.type')), matching: find.text('IMAX')), findsOneWidget);

    await tapInSheet(tester, 'filter.language.Khmer');
    expect(find.byKey(const Key('filter.sheet')), findsOneWidget, reason: 'a chip tap does not pop');
    expect(selected(tester, 'filter.language.Khmer'), isTrue);

    await tapInSheet(tester, 'filter.done');
    expect(find.byKey(const Key('filter.sheet')), findsNothing);
  });

  testWidgets('the genre row and the sheet are one selection', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('genre.Crime')));
    await tester.pumpAndSettle();
    await openSheet(tester);
    expect(selected(tester, 'filter.genre.Crime'), isTrue);

    await tapInSheet(tester, 'filter.genre.all');
    await tapInSheet(tester, 'filter.done');
    expect(selected(tester, 'genre.all'), isTrue);
    expect(selected(tester, 'genre.Crime'), isFalse);
  });

  testWidgets('the badge counts active filters and is absent at zero', (tester) async {
    await pump(tester);
    expect(find.byKey(const Key('search.filter.count')), findsNothing);

    await openSheet(tester);
    await tapInSheet(tester, 'filter.language.English');
    await tapInSheet(tester, 'filter.dolby');
    await tapInSheet(tester, 'filter.done');

    final badge = find.byKey(const Key('search.filter.count'));
    expect(badge, findsOneWidget);
    expect(find.descendant(of: badge, matching: find.text('2')), findsOneWidget);
  });

  testWidgets('a language chip hides a movie and leaves the halls', (tester) async {
    await pump(tester);
    expect(inRail('Dune'), findsOneWidget);

    await openSheet(tester);
    await tapInSheet(tester, 'filter.language.Khmer');
    await tapInSheet(tester, 'filter.done');

    expect(inRail('Dune'), findsNothing);
    expect(inRail('Tum'), findsOneWidget);
    for (final id in [1, 2, 3]) {
      expect(find.byKey(Key('hall.$id')), findsOneWidget);
    }
  });

  testWidgets('a city chip hides a hall and leaves the movie rail', (tester) async {
    await pump(tester);

    await openSheet(tester);
    await tapInSheet(tester, 'filter.city.សៀមរាប');
    await tapInSheet(tester, 'filter.done');

    expect(find.byKey(const Key('hall.3')), findsOneWidget);
    expect(find.byKey(const Key('hall.1')), findsNothing);
    expect(inRail('Dune'), findsOneWidget);
    expect(inRail('Heat'), findsOneWidget);
  });

  testWidgets('filters never call the API; Clear resets them and keeps the search', (tester) async {
    await pump(tester);
    await tester.enterText(find.byKey(const Key('catalog.search')), 'e');
    await tester.pump(MovieListBloc.searchDebounce);
    await tester.pumpAndSettle();
    clearInteractions(movieRepo);
    clearInteractions(hallRepo);

    await openSheet(tester);
    await tapInSheet(tester, 'filter.rating.PG-13');
    await tapInSheet(tester, 'filter.type.STANDARD');
    await tapInSheet(tester, 'filter.screenX');
    expect(find.text('No halls match these filters'), findsOneWidget, reason: 'Standard + ScreenX matches no hall');

    await tapInSheet(tester, 'filter.clear');
    await tapInSheet(tester, 'filter.done');

    expect(movieBloc.state.activeFilterCount, 0);
    expect(hallBloc.state.activeFilterCount, 0);
    expect(movieBloc.state.search, 'e');
    expect(find.byKey(const Key('search.filter.count')), findsNothing);
    verifyZeroInteractions(movieRepo);
    verifyZeroInteractions(hallRepo);
  });
}
