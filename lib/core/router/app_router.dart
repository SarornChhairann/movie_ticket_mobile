import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../motion/poster_hero.dart';
import '../motion/transitions.dart';

import '../model/booking_summary.dart';
import '../../features/auth/view/auth_gate.dart';
import '../../features/auth/view/blocked_page.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/register_page.dart';
import '../../features/auth/view/splash_page.dart';
import '../../features/catalog/controller/movie_detail_bloc.dart';
import '../../features/catalog/controller/movie_list_bloc.dart';
import '../../features/catalog/view/movie_detail_page.dart';
import '../../features/checkout/controller/checkout_bloc.dart';
import '../../features/checkout/view/checkout_page.dart';
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
import '../../features/tickets/controller/ticket_bloc.dart';
import '../../features/tickets/view/booking_detail_page.dart';
import '../../features/tickets/view/my_bookings_page.dart';
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

  /// Argument: the active `Hold`.
  static const checkout = '/checkout';

  /// Argument: the checkout route's `CheckoutBloc` (menu and cart for this hold).
  static const concessions = '/checkout/concessions';

  /// Argument: the confirmed `BookingSummary`.
  static const paySuccess = '/checkout/success';

  /// Signed-in only.
  static const myBookings = '/bookings';

  /// Argument: `(MyBookingsBloc, int bookingId)` — the list route's bloc and the booking.
  static const bookingDetail = '/bookings/detail';

  /// Argument: the `TicketPass`.
  static const ticketQr = '/tickets/qr';

  /// Bottom sheet. Argument: the coming-soon `Movie`; pops `true` when subscribed.
  static const reminderSheet = '/reminders/sheet';
  static const profile = '/profile';

  /// Argument: the [ProfileBloc] of the profile route.
  static const editProfile = '/profile/edit';

  /// Argument: the [ProfileBloc] of the profile route.
  static const changePassword = '/profile/password';
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
            BlocProvider(create: (_) => _getIt<MovieDetailBloc>()..add(DetailRequested(_detailArgs(settings).movieId))),
            // Used only by the coming-soon reminder form; created on first read.
            BlocProvider(create: (_) => _getIt<ReminderBloc>()),
          ],
          child: MovieDetailPage(heroSource: _detailArgs(settings).heroSource),
        ),
      AppRoutes.seatMap => switch (settings.arguments) {
          final SeatMapArgs args => BlocProvider(
              create: (_) => _getIt<SeatMapBloc>()..add(LoadRequested(args.showtimeId)),
              child: SeatMapPage(args: args),
            ),
          final id => BlocProvider(
              create: (_) => _getIt<SeatMapBloc>()..add(LoadRequested(id! as int)),
              child: const SeatMapPage(),
            ),
        },
      AppRoutes.checkout => BlocProvider(
          create: (_) => _getIt<CheckoutBloc>()..add(QuoteRequested(settings.arguments! as Hold)),
          child: const CheckoutPage(),
        ),
      AppRoutes.concessions => BlocProvider.value(
          value: settings.arguments! as CheckoutBloc,
          child: const ConcessionsPage(),
        ),
      AppRoutes.paySuccess => PaySuccessPage(confirmation: settings.arguments! as BookingSummary),
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
      AppRoutes.ticketQr => switch (settings.arguments! as TicketPass) {
          final ticket => BlocProvider(
              create: (_) => _getIt<TicketBloc>()..add(QrRequested(ticket.code)),
              child: TicketQrPage(ticket: ticket),
            ),
        },
      _ => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => _getIt<ShellCubit>()..pingRequested()),
            BlocProvider(create: (_) => _getIt<MovieListBloc>()..add(const RefreshRequested())),
            // Lazy: created (and loaded by the shell) only when a signed-in user
            // opens Bookings or Profile, so a guest never calls these endpoints.
            BlocProvider(create: (_) => _getIt<ProfileBloc>()),
            BlocProvider(create: (_) => _getIt<tickets.MyBookingsBloc>()),
          ],
          child: const ShellPage(),
        ),
    };
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
        AppRoutes.login => RouteMotion.sheet,
        // The poster Hero carries the continuity; the page itself fades.
        AppRoutes.movieDetail => RouteMotion.container,
        // An outcome, not a place.
        AppRoutes.paySuccess => RouteMotion.fadeThrough,
        // A closer look at the same ticket.
        AppRoutes.ticketQr => RouteMotion.sharedAxisY,
        // Steps forward in a sequence or hierarchy.
        _ => RouteMotion.sharedAxisX,
      };
}

/// Movie detail route argument.
class MovieDetailArgs {
  const MovieDetailArgs({required this.movieId, this.heroSource});

  final int movieId;

  /// The surface the poster was opened from; null means no hero flight.
  final HeroSource? heroSource;
}
