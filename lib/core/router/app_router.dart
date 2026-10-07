import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../motion/poster_hero.dart';
import '../motion/transitions.dart';

import '../model/booking_summary.dart';
import '../telemetry/journey_tracker.dart';
import '../navigation/shell_tabs.dart';
import '../session/pending_payment_store.dart';
import '../../features/_gallery/view/funnel_panel.dart';
import '../../features/_gallery/view/gallery_page.dart';
import '../../features/auth/view/auth_gate.dart';
import '../../features/auth/view/blocked_page.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/register_page.dart';
import '../../features/auth/view/splash_page.dart';
import '../../features/catalog/controller/movie_detail_bloc.dart';
import '../../features/catalog/controller/hall_list_bloc.dart' as hall_list;
import '../../features/catalog/controller/hall_schedule_bloc.dart' as hall_schedule;
import '../../features/catalog/controller/showing_cubit.dart';
import '../../features/catalog/controller/favourite_halls_cubit.dart';
import '../../features/catalog/controller/movie_list_bloc.dart';
import '../../features/catalog/controller/recently_viewed_cubit.dart';
import '../../features/catalog/controller/search_results_bloc.dart';
import '../../features/catalog/view/search_results_page.dart';
import '../../features/catalog/view/hall_schedule_page.dart';
import '../../features/catalog/view/movie_detail_page.dart';
import '../../features/checkout/controller/booking_flow_cubit.dart';
import '../../features/checkout/controller/checkout_bloc.dart';
import '../../features/checkout/model/checkout_args.dart';
import '../../features/checkout/controller/payment_resume_bloc.dart';
import '../../features/checkout/controller/payway_bloc.dart';
import '../../features/checkout/model/payway.dart';
import '../../features/checkout/view/checkout_page.dart';
import '../../features/checkout/view/payment_resume_page.dart';
import '../../features/checkout/view/payway_page.dart';
import '../../features/checkout/view/concessions_page.dart';
import '../../features/checkout/view/pay_success_page.dart';
import '../../features/catalog/model/movie.dart';
import '../../features/reminders/controller/reminder_bloc.dart';
import '../../features/reminders/view/reminder_sheet.dart';
import '../../features/seats/model/seat_map.dart';
import '../../features/seats/model/seat_map_args.dart';
import '../../features/profile/controller/profile_bloc.dart';
import '../../features/profile/view/change_password_page.dart';
import '../../features/profile/view/edit_profile_page.dart';
import '../../features/profile/view/profile_page.dart';
import '../../features/seats/controller/seat_map_bloc.dart';
import '../../features/seats/view/seat_map_page.dart';
import '../../features/shell/controller/shell_cubit.dart';
import '../../features/shell/view/shell_page.dart';
import '../../features/tickets/controller/my_bookings_bloc.dart' as tickets;
import '../../features/tickets/controller/booking_lookup_bloc.dart';
import '../../features/tickets/controller/ticket_bloc.dart';
import '../../features/tickets/view/booking_detail_page.dart';
import '../../features/tickets/view/booking_lookup_page.dart';
import '../../features/tickets/view/my_bookings_page.dart';
import '../../features/tickets/controller/up_next_cubit.dart';
import '../../features/tickets/view/ticket_wallet_page.dart';
import '../../features/tickets/view/ticket_qr_page.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  /// Pushed on demand by `requireSignIn`; argument: `LoginArgs`; pops an `AuthGateResult`.
  static const login = '/login';
  static const register = '/register';
  static const blocked = '/blocked';
  static const shell = '/';

  /// Argument: `MovieDetailArgs` (id + where the poster hero flies from) or a bare id (`int`).
  static const movieDetail = '/movies/detail';

  /// Argument: a `SeatMapArgs` (from movie detail) or a bare showtime id (`int`).
  static const seatMap = '/showtimes/seats';

  /// Home's search results view (sprint 22). Argument: the `SearchSeed` Home loaded.
  static const search = '/search';

  /// Argument: the hall id (`int`).
  static const hallSchedule = '/halls/schedule';

  /// Argument: the active `Hold`.
  static const checkout = '/checkout';

  /// Argument: the checkout route's `CheckoutBloc` (menu and cart for this hold).
  static const concessions = '/checkout/concessions';

  /// Argument: the confirmed `BookingSummary`.
  static const paySuccess = '/checkout/success';

  /// Argument: [PaywayLaunch]. Pops with a [PaywayOutcome].
  static const payway = '/checkout/payway';

  /// Argument: the [PendingPayment] the last run left open. Pushed by `App` over Home.
  static const paymentResume = '/checkout/resume';

  /// Guests: find a booking by reference + phone. Pops the found `BookingSummary`.
  static const bookingLookup = '/bookings/lookup';

  /// Signed-in only.
  static const myBookings = '/bookings';

  /// Argument: `(MyBookingsBloc, int bookingId)` — the list route's bloc and the booking.
  static const bookingDetail = '/bookings/detail';

  /// Argument: the `TicketPass`.
  static const ticketQr = '/tickets/qr';

  /// Argument: `TicketWalletArgs` — a booking's tickets as flip cards (sprint 18).
  static const ticketWallet = '/tickets/wallet';

  /// Bottom sheet. Argument: the coming-soon `Movie`; pops `true` when subscribed.
  static const reminderSheet = '/reminders/sheet';
  static const profile = '/profile';

  /// Argument: the [ProfileBloc] of the profile route.
  static const editProfile = '/profile/edit';

  /// Argument: the [ProfileBloc] of the profile route.
  static const changePassword = '/profile/password';

  /// Debug builds only: the component gallery (sprint 15).
  static const gallery = '/_gallery';
}

/// Builds routes and creates each screen's bloc from GetIt, so widgets never
/// touch the container.
class AppRouter {
  AppRouter(this._getIt);

  final GetIt _getIt;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.reminderSheet) {
      return ModalBottomSheetRoute<bool>(
        settings: settings,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => BlocProvider(
          create: (_) => _getIt<ReminderBloc>(),
          child: ReminderSheet(movie: settings.arguments! as Movie),
        ),
      );
    }
    final Widget page = switch (settings.name) {
      AppRoutes.splash => const SplashPage(),
      AppRoutes.login => LoginPage(args: settings.arguments as LoginArgs? ?? const LoginArgs()),
      AppRoutes.register => const RegisterPage(),
      AppRoutes.blocked => const BlockedPage(),
      AppRoutes.profile => MultiBlocProvider(
          providers: [
            // Re-reads GET /profile on every open, so points are current.
            BlocProvider(create: (_) => _getIt<ProfileBloc>()..add(const ProfileLoaded())),
            // Feeds the last-booking shortcut.
            BlocProvider(create: (_) => _getIt<tickets.MyBookingsBloc>()..add(const tickets.LoadRequested())),
          ],
          child: const ProfilePage(),
        ),
      AppRoutes.editProfile => BlocProvider.value(
          value: settings.arguments! as ProfileBloc,
          child: const EditProfilePage(),
        ),
      AppRoutes.changePassword => BlocProvider.value(
          value: settings.arguments! as ProfileBloc,
          child: const ChangePasswordPage(),
        ),
      AppRoutes.movieDetail => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => _getIt<MovieDetailBloc>()
                ..add(DetailRequested(_detailArgs(settings).movieId, source: _detailArgs(settings).trackingSource)),
            ),
            // Used only by the coming-soon reminder form; created on first read.
            BlocProvider(create: (_) => _getIt<ReminderBloc>()),
            // Sprint 22: each open is remembered for Home's Recently viewed.
            BlocProvider(
              lazy: false,
              create: (_) => _getIt<RecentlyViewedCubit>()..viewed(_detailArgs(settings).movieId),
            ),
          ],
          child: MovieDetailPage(heroSource: _detailArgs(settings).heroSource),
        ),
      AppRoutes.hallSchedule => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => _getIt<hall_schedule.HallScheduleBloc>()
                ..add(hall_schedule.ScheduleRequested(settings.arguments! as int)),
            ),
            // The heart in the app bar (sprint 22).
            BlocProvider(create: (_) => _getIt<FavouriteHallsCubit>()..load()),
          ],
          child: const HallSchedulePage(),
        ),
      AppRoutes.search => BlocProvider(
          create: (_) => _getIt<SearchResultsBloc>(param1: settings.arguments as SearchSeed? ?? const SearchSeed())
            ..add(const SearchOpened()),
          child: const SearchResultsPage(),
        ),
      // A booking flow starts here: the flow cubit lives as long as the seat map
      // and is handed to checkout through its arguments (sprint 16).
      AppRoutes.seatMap => switch (settings.arguments) {
          final SeatMapArgs args => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => _getIt<SeatMapBloc>()..add(LoadRequested(args.showtimeId))),
                BlocProvider(create: (_) => BookingFlowCubit(posterUrl: args.posterUrl, tracker: _getIt())),
              ],
              child: SeatMapPage(args: args),
            ),
          final id => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => _getIt<SeatMapBloc>()..add(LoadRequested(id! as int))),
                BlocProvider(create: (_) => BookingFlowCubit(tracker: _getIt())),
              ],
              child: const SeatMapPage(),
            ),
        },
      AppRoutes.checkout => switch (settings.arguments) {
          CheckoutArgs(:final hold, :final flow) when flow != null => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => _getIt<CheckoutBloc>()..add(QuoteRequested(hold))),
                BlocProvider<BookingFlowCubit>.value(value: flow),
              ],
              child: const CheckoutPage(),
            ),
          final args => BlocProvider(
              create: (_) => _getIt<CheckoutBloc>()
                ..add(QuoteRequested(args is CheckoutArgs ? args.hold : args! as Hold)),
              child: const CheckoutPage(),
            ),
        },
      AppRoutes.concessions => BlocProvider.value(
          value: settings.arguments! as CheckoutBloc,
          child: const ConcessionsPage(),
        ),
      AppRoutes.payway => switch (settings.arguments! as PaywayLaunch) {
          final launch => BlocProvider(
              create: (_) => _getIt<PaywayBloc>(param1: launch)..add(const PaywayOpened()),
              child: const PaywayPage(),
            ),
        },
      AppRoutes.gallery when kDebugMode => GalleryPage(extraSections: [FunnelPanel(tracker: _getIt<JourneyTracker>())]),
      AppRoutes.paymentResume => BlocProvider(
          create: (_) =>
              _getIt<PaymentResumeBloc>(param1: settings.arguments! as PendingPayment)..add(const ResumeStarted()),
          child: const PaymentResumePage(),
        ),
      AppRoutes.bookingLookup => BlocProvider(
          create: (_) => _getIt<BookingLookupBloc>(),
          child: const BookingLookupPage(),
        ),
      AppRoutes.paySuccess => PaySuccessPage(confirmation: settings.arguments! as BookingSummary, tabs: _getIt<ShellTabs>()),
      AppRoutes.myBookings => BlocProvider(
          create: (_) => _getIt<tickets.MyBookingsBloc>()..add(const tickets.LoadRequested()),
          child: const MyBookingsPage(),
        ),
      AppRoutes.bookingDetail => switch (settings.arguments! as (tickets.MyBookingsBloc, int)) {
          (final bloc, final bookingId) => BlocProvider.value(
              value: bloc,
              child: BookingDetailPage(bookingId: bookingId),
            ),
        },
      AppRoutes.ticketWallet => TicketWalletPage(
          args: settings.arguments! as TicketWalletArgs,
          qrBloc: () => _getIt<TicketBloc>(),
        ),
      AppRoutes.ticketQr => switch (settings.arguments! as TicketPass) {
          final ticket => BlocProvider(
              create: (_) => _getIt<TicketBloc>()..add(QrRequested(ticket.code, source: 'success')),
              child: TicketQrPage(ticket: ticket),
            ),
        },
      _ => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => _getIt<ShellCubit>()..pingRequested()),
            BlocProvider(create: (_) => _getIt<MovieListBloc>()..add(const RefreshRequested())),
            // Explore's own list and search (sprint 22); loads on the first visit.
            BlocProvider(create: (_) => _getIt<ExploreMovieListBloc>()..add(const RefreshRequested())),
            // Home's "Your halls" and "Recently viewed" (sprint 22), on this phone only.
            BlocProvider(create: (_) => _getIt<FavouriteHallsCubit>()..load(withTimes: true)),
            BlocProvider(create: (_) => _getIt<RecentlyViewedCubit>()..load()),
            // Home's Halls section; loads and fails apart from the movies.
            BlocProvider(create: (_) => _getIt<hall_list.HallListBloc>()..add(const hall_list.LoadRequested())),
            // Home's date strip and Showing rail (sprint 20).
            BlocProvider(create: (_) => _getIt<ShowingCubit>()..load()),
            // Lazy: created (and loaded by the shell) only when a signed-in user
            // opens Bookings or Profile, so a guest never calls these endpoints.
            BlocProvider(create: (_) => _getIt<ProfileBloc>()),
            BlocProvider(create: (_) => _getIt<tickets.MyBookingsBloc>()),
            // The guest Bookings tab: bookings made or found on this phone.
            BlocProvider(create: (_) => _getIt<tickets.GuestBookingsBloc>()),
            // Home's Up next card; the shell loads it for the current session.
            BlocProvider(create: (_) => _getIt<UpNextCubit>()),
          ],
          child: ShellPage(tabs: _getIt<ShellTabs>()),
        ),
    };
    if (settings.name == AppRoutes.payway) {
      return buildMotionRoute<PaywayOutcome>(settings, motionFor(settings.name), (_) => page);
    }
    if (settings.name == AppRoutes.bookingLookup) {
      return buildMotionRoute<BookingSummary>(settings, motionFor(settings.name), (_) => page);
    }
    if (settings.name == AppRoutes.login) {
      // Login opens over the current screen like a sheet; closing it returns to
      // exactly where the shopper was.
      return buildMotionRoute<AuthGateResult>(settings, RouteMotion.sheet, (_) => page);
    }
    return buildMotionRoute<void>(settings, motionFor(settings.name), (_) => page);
  }

  static MovieDetailArgs _detailArgs(RouteSettings settings) => switch (settings.arguments) {
        final MovieDetailArgs args => args,
        final id => MovieDetailArgs(movieId: id! as int),
      };

  /// The journey table (sprint 8, 1.2): how each screen enters and leaves.
  static RouteMotion motionFor(String? name) => switch (name) {
        AppRoutes.splash || AppRoutes.blocked || AppRoutes.shell || null => RouteMotion.fade,
        // Over the current screen; closing returns exactly there.
        AppRoutes.login || AppRoutes.payway => RouteMotion.sheet,
        // The poster Hero carries the continuity; the page itself fades.
        AppRoutes.movieDetail => RouteMotion.container,
        // An outcome, not a place.
        AppRoutes.paySuccess || AppRoutes.paymentResume => RouteMotion.fadeThrough,
        // A view over Home, not a step away from it.
        AppRoutes.search => RouteMotion.sharedAxisZ,
        // A closer look at the same ticket.
        AppRoutes.ticketQr || AppRoutes.ticketWallet => RouteMotion.sharedAxisY,
        // Steps forward in a sequence or hierarchy.
        _ => RouteMotion.sharedAxisX,
      };
}

/// Movie detail route argument.
class MovieDetailArgs {
  const MovieDetailArgs({required this.movieId, this.heroSource, this.source});

  final int movieId;

  /// The surface the poster was opened from; null means no hero flight.
  final HeroSource? heroSource;

  /// Telemetry `source` when there is no [heroSource] (e.g. `hall`).
  final String? source;

  /// The `source` of `movie_opened` (sprint 21): which surface the movie was opened from.
  String? get trackingSource =>
      source ??
      switch (heroSource) {
        HeroSource.featured => 'hero',
        HeroSource.showing => 'showing',
        HeroSource.nowShowing => 'now',
        HeroSource.carousel => 'comingSoon',
        HeroSource.explore => 'explore',
        HeroSource.recent => 'recent',
        HeroSource.search => 'search',
        null => null,
      };
}
