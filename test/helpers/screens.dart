import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/showing_cubit.dart';
import 'package:movie_ticket_mobile/core/model/booking_summary.dart';
import 'package:movie_ticket_mobile/features/auth/controller/auth_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/hall_list_bloc.dart' hide RefreshRequested;
import 'package:movie_ticket_mobile/features/catalog/controller/movie_detail_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/movie_list_bloc.dart';
import 'package:movie_ticket_mobile/features/catalog/model/hall.dart';
import 'package:movie_ticket_mobile/features/catalog/model/movie.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_detail_page.dart';
import 'package:movie_ticket_mobile/features/catalog/view/movie_home_view.dart';
import 'package:movie_ticket_mobile/features/catalog/view/search_results_page.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/favourite_halls_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/recently_viewed_cubit.dart';
import 'package:movie_ticket_mobile/features/catalog/controller/search_results_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/controller/checkout_bloc.dart';
import 'package:movie_ticket_mobile/features/checkout/view/checkout_page.dart';
import 'package:movie_ticket_mobile/features/checkout/view/pay_success_page.dart';
import 'package:movie_ticket_mobile/features/profile/controller/profile_bloc.dart';
import 'package:movie_ticket_mobile/features/profile/view/profile_page.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/ticket_bloc.dart';
import 'package:movie_ticket_mobile/features/tickets/view/ticket_wallet_page.dart';
import 'package:movie_ticket_mobile/features/seats/controller/seat_map_bloc.dart';
import 'package:movie_ticket_mobile/features/seats/view/seat_map_page.dart';
import 'package:movie_ticket_mobile/features/tickets/controller/my_bookings_bloc.dart' as tickets;
import 'package:movie_ticket_mobile/features/tickets/view/my_bookings_page.dart';

import '../features/auth/auth_fixtures.dart';
import '../features/checkout/checkout_fixtures.dart';
import '../features/seats/seat_fixtures.dart';
import '../features/tickets/tickets_fixtures.dart';
import 'localized_app.dart';
import 'showing.dart';

/// Seeded main screens for goldens (sprint 15) and accessibility guideline checks
/// (sprint 19): each is a real page over mock blocs in a fixed state.

class MockAuth extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockMovieList extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

class MockHalls extends MockBloc<HallListEvent, HallListState> implements HallListBloc {}

class MockFavourites extends MockCubit<FavouriteHallsState> implements FavouriteHallsCubit {}

class MockRecent extends MockCubit<List<int>> implements RecentlyViewedCubit {}

class MockSearch extends MockBloc<SearchResultsEvent, SearchResultsState> implements SearchResultsBloc {}

class MockDetail extends MockBloc<MovieDetailEvent, MovieDetailState> implements MovieDetailBloc {}

class MockSeats extends MockBloc<SeatMapEvent, SeatMapState> implements SeatMapBloc {}

class MockCheckout extends MockBloc<CheckoutEvent, CheckoutState> implements CheckoutBloc {}

class MockProfile extends MockBloc<ProfileEvent, ProfileState> implements ProfileBloc {}

class MockTicket extends MockBloc<TicketEvent, TicketState> implements TicketBloc {}

class MockBookings extends MockBloc<tickets.MyBookingsEvent, tickets.MyBookingsState>
    implements tickets.MyBookingsBloc {
  @override
  bool get guest => false;
}

B seeded<B extends BlocBase<S>, S>(B bloc, S state) {
  whenListen(bloc, Stream<S>.empty(), initialState: state);
  return bloc;
}

final _comingSoon = [
  for (final id in [2, 5, 9]) Movie(id: id, title: 'Soon $id', comingSoon: true, releaseDate: DateTime(2026, 12, 1)),
];
const _nowShowing = [Movie(id: 1, title: 'Dune', comingSoon: false), Movie(id: 3, title: 'Heat', comingSoon: false)];
const _halls = [
  Hall(id: 1, name: 'Legend Sen Sok · Atmos', type: 'ATMOS', totalSeats: 60, dolby: true, cinemaId: 'c1', cinemaName: 'Legend'),
];

/// The main screens by name, each a function building it over seeded blocs.
Map<String, Widget Function()> mainScreens() => {
      'home': () => BlocProvider<MovieListBloc>.value(
            value: seeded(
              MockMovieList(),
              MovieListState.ready(tab: MovieTab.nowShowing, search: '', nowShowing: _nowShowing, comingSoon: _comingSoon),
            ),
            child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {})),
          ),
      // Sprint 22: a regular's Home (a favourite hall with its next time, recently viewed).
      'homePersonal': () => MultiBlocProvider(
            providers: [
              BlocProvider<MovieListBloc>.value(
                value: seeded(
                  MockMovieList(),
                  MovieListState.ready(
                      tab: MovieTab.nowShowing, search: '', nowShowing: _nowShowing, comingSoon: _comingSoon),
                ),
              ),
              BlocProvider<FavouriteHallsCubit>.value(
                value: seeded(MockFavourites(), const FavouriteHallsState(ids: [1], nextTimes: {1: '19:30'})),
              ),
              BlocProvider<RecentlyViewedCubit>.value(value: seeded(MockRecent(), const [3, 2, 1])),
            ],
            child: Scaffold(body: MovieHomeView(header: const SizedBox(), onSeeAll: (_) {})),
          ),
      // Sprint 22: the search results view over Home.
      'search': () => BlocProvider<SearchResultsBloc>.value(
            value: seeded(
              MockSearch(),
              SearchResultsState(
                query: 'e',
                nowShowing: const [Movie(id: 3, title: 'Heat', comingSoon: false)],
                comingSoon: [_comingSoon.first],
                halls: _halls,
              ),
            ),
            child: const SearchResultsPage(),
          ),
      'detail': () {
        final date = DateTime(2026, 10, 2);
        return BlocProvider<MovieDetailBloc>.value(
          value: seeded(
            MockDetail(),
            MovieDetailState.ready(MovieDetail(
              movie: const Movie(id: 1, title: 'Dune', comingSoon: false, genre: 'Sci-Fi', durationMinutes: 155),
              availableDates: [date],
              selectedDate: date,
              cinemas: const [],
            )),
          ),
          child: const MovieDetailPage(),
        );
      },
      'seats': () => BlocProvider<SeatMapBloc>.value(
            value: seeded<MockSeats, SeatMapState>(
              MockSeats(),
              SeatMapReady(
                data: seatMap(heldByOthers: {2}),
                heldByOthers: const {2},
                booked: const {3},
                selected: const {1},
              ),
            ),
            child: const SeatMapPage(),
          ),
      'checkout': () => BlocProvider<CheckoutBloc>.value(
            value: seeded<MockCheckout, CheckoutState>(
              MockCheckout(),
              CheckoutReady(hold: testHold, quote: testQuote(), secondsLeft: 600),
            ),
            child: const CheckoutPage(),
          ),
      'success': () => PaySuccessPage(confirmation: testBooking().copyWith(reference: 'AB3DEF7H')),
      'bookings': () => BlocProvider<tickets.MyBookingsBloc>.value(
            value: seeded(
              MockBookings(),
              tickets.MyBookingsState.ready(bookings: [
                testBooking(id: 3),
                testBooking(id: 1, status: BookingStatus.cancelled, ticketStatus: 'CANCELLED'),
              ]),
            ),
            // A fixed cinema clock keeps Upcoming vs Past stable over time.
            child: MyBookingsPage(clock: () => DateTime(2026, 10, 7, 12)),
          ),
      'wallet': () => TicketWalletPage(
            args: TicketWalletArgs(booking: testBooking().copyWith(reference: 'AB3DEF7H'), doorMode: true),
            qrBloc: () => seeded<MockTicket, TicketState>(MockTicket(), const TicketState.loading('T-99-1')),
          ),
      'profile': () => MultiBlocProvider(
            providers: [
              BlocProvider<ProfileBloc>.value(value: seeded(MockProfile(), const ProfileState.ready(testUser))),
              BlocProvider<tickets.MyBookingsBloc>.value(
                value: seeded(MockBookings(), tickets.MyBookingsState.ready(bookings: [testBooking()])),
              ),
            ],
            child: const ProfilePage(),
          ),
    };

/// Pumps [screen] at a phone size (390 × 844 dp) with the shared blocs, in
/// [locale], at [textScale], with animations off so a frame is final.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Locale locale = const Locale('en'),
  double textScale = 1,
  bool screenReader = false,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await pumpLocalized(
    tester,
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: seeded(MockAuth(), const AuthState.guest())),
        BlocProvider<HallListBloc>.value(value: seeded(MockHalls(), const HallListState.ready(_halls))),
        BlocProvider<ShowingCubit>.value(value: showingStub(movies: showingMovies)),
      ],
      child: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: true,
            textScaler: TextScaler.linear(textScale),
            accessibleNavigation: screenReader,
          ),
          child: screen,
        ),
      ),
    ),
    locale: locale,
  );
  await tester.pump();
}

/// Loads Poppins, the Material icon font, and (on macOS) a system Khmer font so
/// goldens show real glyphs rather than the test font's boxes. The Khmer font
/// comes from the OS, so Khmer goldens are only stable on macOS.
Future<void> loadGoldenFonts() async {
  final poppins = FontLoader('Poppins');
  for (final f in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    poppins.addFont(rootBundle.load('assets/fonts/Poppins-$f.ttf'));
  }
  await poppins.load();
  // Khmer: the macOS system font, under one of the theme's fallback names.
  final khmer = File('/System/Library/Fonts/Supplemental/Khmer Sangam MN.ttf');
  if (khmer.existsSync()) {
    final loader = FontLoader('Khmer Sangam MN')..addFont(Future.value(ByteData.sublistView(khmer.readAsBytesSync())));
    await loader.load();
  }
  final root = Platform.environment['FLUTTER_ROOT'];
  final icons = File('$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
  if (root != null && icons.existsSync()) {
    final loader = FontLoader('MaterialIcons')..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync())));
    await loader.load();
  }
}
