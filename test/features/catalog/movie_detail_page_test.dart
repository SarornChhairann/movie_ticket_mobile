import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_ticket_mobile/core/platform/link_opener.dart';
import 'package:movie_ticket_mobile/core/router/app_router.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/auth/view/auth_gate.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_detail_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_detail_page.dart';
import 'package:movie_ticket_mobile/features/seats/model/seat_map_args.dart';

import '../../helpers/finders.dart';
import '../../helpers/localized_app.dart';
import '../auth/auth_fixtures.dart';

class _MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState> implements MovieDetailBloc {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class _RouteRecorder extends NavigatorObserver {
  final pushed = <RouteSettings>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => pushed.add(route.settings);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const ShowtimeSelected(0));
    await initTestLocalization();
  });

  final date = DateTime(2026, 10, 2);
  MovieDetail detail({String? trailerUrl}) => MovieDetail(
        movie: Movie(
          id: 1,
          title: 'Dune',
          comingSoon: false,
          trailerUrl: trailerUrl,
          description: 'A long synopsis. ' * 30,
        ),
        availableDates: [date],
        selectedDate: date,
        cinemas: const [
          CinemaGroup(cinemaName: 'Legend', halls: [
            HallGroup(hallName: 'Hall 1', dolby: true, screenX: false, slots: [
              ShowtimeSlot(
                id: 42,
                time: '19:30',
                hallName: 'Hall 1',
                cinemaName: 'Legend',
                dolby: true,
                screenX: false,
                normalPrice: 6.5,
              ),
            ]),
          ]),
        ],
      );

  Future<(_MockMovieDetailBloc, _RouteRecorder)> pump(
    WidgetTester tester,
    MovieDetailState state, {
    OpenLink? openLink,
    AuthState auth = const AuthState.authenticated(testUser),
  }) async {
    final authBloc = _MockAuthBloc();
    whenListen(authBloc, const Stream<AuthState>.empty(), initialState: auth);
    final bloc = _MockMovieDetailBloc();
    whenListen(bloc, const Stream<MovieDetailState>.empty(), initialState: state);
    final recorder = _RouteRecorder();
    tester.view.physicalSize = const Size(1080, 4000);
    addTearDown(tester.view.resetPhysicalSize);
    await pumpLocalized(
      tester,
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: Navigator(
          observers: [recorder],
          onGenerateRoute: (settings) => switch (settings.name) {
            AppRoutes.login => MaterialPageRoute<AuthGateResult>(
                settings: settings,
                builder: (_) => const Scaffold(body: Text('login')),
              ),
            AppRoutes.seatMap => MaterialPageRoute<void>(settings: settings, builder: (_) => const Scaffold()),
            _ => MaterialPageRoute<void>(
                settings: settings,
                builder: (_) => BlocProvider<MovieDetailBloc>.value(
                  value: bloc,
                  child: MovieDetailPage(openLink: openLink ?? (_) async => true),
                ),
              ),
          },
        ),
      ),
    );
    return (bloc, recorder);
  }

  testWidgets('time chips carry the hall; Book Ticket stays disabled until one is picked', (tester) async {
    final (bloc, _) = await pump(tester, MovieDetailState.ready(detail()));

    expect(find.text('Legend'), findsOneWidget);
    expect(find.text('19:30 · Hall 1 · Dolby Atmos'), findsOneWidget);
    expect(filledButtonIn(tester, const Key('detail.book')).onPressed, isNull);
    expect(find.textContaining(r'$'), findsNothing, reason: 'price is a server quote, not shown here');

    await tester.tap(find.byKey(const Key('showtime.42')));
    verify(() => bloc.add(any(that: isA<ShowtimeSelected>().having((e) => e.showtimeId, 'id', 42)))).called(1);
  });

  testWidgets('Book Ticket pushes the seat map with the selected showtime id', (tester) async {
    final (_, recorder) = await pump(tester, MovieDetailState.ready(detail(), selectedShowtimeId: 42));

    await tester.tap(find.byKey(const Key('detail.book')));
    await tester.pumpAndSettle();

    final seatRoute = recorder.pushed.last;
    expect(seatRoute.name, AppRoutes.seatMap);
    final args = seatRoute.arguments! as SeatMapArgs;
    expect(args.showtimeId, 42);
    expect(args.date, date);
    expect(args.options.map((o) => '${o.time} ${o.hallName}'), ['19:30 Hall 1']);
  });

  testWidgets('a signed-out shopper is asked to sign in or continue as guest before booking', (tester) async {
    final (_, recorder) = await pump(
      tester,
      MovieDetailState.ready(detail(), selectedShowtimeId: 42),
      auth: const AuthState.guest(),
    );

    await tester.tap(find.byKey(const Key('detail.book')));
    await tester.pumpAndSettle();

    final login = recorder.pushed.last;
    expect(login.name, AppRoutes.login);
    final args = login.arguments! as LoginArgs;
    expect(args.allowGuest, isTrue, reason: 'guest checkout is supported');
    expect(args.reasonKey, 'auth.reason.checkout');
    expect(recorder.pushed.where((r) => r.name == AppRoutes.seatMap), isEmpty);
  });

  testWidgets('a guest who chose guest checkout goes straight to seats', (tester) async {
    final (_, recorder) = await pump(
      tester,
      MovieDetailState.ready(detail(), selectedShowtimeId: 42),
      auth: const AuthState.guest(guestCheckout: true),
    );

    await tester.tap(find.byKey(const Key('detail.book')));
    await tester.pumpAndSettle();

    expect(recorder.pushed.last.name, AppRoutes.seatMap);
  });

  testWidgets('play button only when there is a trailer', (tester) async {
    await pump(tester, MovieDetailState.ready(detail()));
    expect(find.byKey(const Key('detail.trailer')), findsNothing);
  });

  testWidgets('play button shows with a trailer; long synopsis expands', (tester) async {
    await pump(tester, MovieDetailState.ready(detail(trailerUrl: 'https://example.com/t')));
    expect(find.byKey(const Key('detail.trailer')), findsOneWidget);

    expect(find.text('Read more'), findsOneWidget);
    await tester.tap(find.byKey(const Key('detail.readMore')));
    await tester.pump();
    expect(find.text('Show less'), findsOneWidget);
  });

  testWidgets('the play button opens the trailer link', (tester) async {
    final opened = <String>[];
    await pump(
      tester,
      MovieDetailState.ready(detail(trailerUrl: 'https://youtu.be/abc')),
      openLink: (url) async {
        opened.add(url);
        return true;
      },
    );

    await tester.tap(find.byKey(const Key('detail.trailer')));
    await tester.pump();

    expect(opened, ['https://youtu.be/abc']);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('if the link cannot be opened it is copied and the user is told', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String?;
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    await pump(tester, MovieDetailState.ready(detail(trailerUrl: 'https://youtu.be/abc')), openLink: (_) async => false);

    await tester.tap(find.byKey(const Key('detail.trailer')));
    await tester.pump();

    expect(copied, 'https://youtu.be/abc');
    expect(find.text("Couldn't open the trailer. The link was copied instead."), findsOneWidget);
  });
}
