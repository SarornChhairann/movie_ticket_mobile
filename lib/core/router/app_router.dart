import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/view/blocked_page.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/register_page.dart';
import '../../features/auth/view/splash_page.dart';
import '../../features/catalog/controller/movie_detail_bloc.dart';
import '../../features/catalog/controller/movie_list_bloc.dart';
import '../../features/catalog/view/movie_detail_page.dart';
import '../../features/checkout/controller/checkout_bloc.dart';
import '../../features/checkout/model/confirmation.dart';
import '../../features/checkout/view/checkout_page.dart';
import '../../features/checkout/view/pay_success_page.dart';
import '../../features/seats/model/seat_map.dart';
import '../../features/profile/controller/profile_bloc.dart';
import '../../features/profile/view/change_password_page.dart';
import '../../features/profile/view/edit_profile_page.dart';
import '../../features/profile/view/profile_page.dart';
import '../../features/seats/controller/seat_map_bloc.dart';
import '../../features/seats/view/seat_map_page.dart';
import '../../features/shell/controller/shell_cubit.dart';
import '../../features/shell/view/shell_page.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const blocked = '/blocked';
  static const shell = '/';

  /// Argument: the movie id (`int`).
  static const movieDetail = '/movies/detail';

  /// Argument: the showtime id (`int`).
  static const seatMap = '/showtimes/seats';

  /// Argument: the active `Hold`.
  static const checkout = '/checkout';

  /// Argument: the `Confirmation`.
  static const paySuccess = '/checkout/success';
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
    final Widget page = switch (settings.name) {
      AppRoutes.splash => const SplashPage(),
      AppRoutes.login => const LoginPage(),
      AppRoutes.register => const RegisterPage(),
      AppRoutes.blocked => const BlockedPage(),
      AppRoutes.profile => BlocProvider(
          create: (_) => _getIt<ProfileBloc>()..add(const ProfileLoaded()),
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
      AppRoutes.movieDetail => BlocProvider(
          create: (_) => _getIt<MovieDetailBloc>()..add(DetailRequested(settings.arguments! as int)),
          child: const MovieDetailPage(),
        ),
      AppRoutes.seatMap => BlocProvider(
          create: (_) => _getIt<SeatMapBloc>()..add(LoadRequested(settings.arguments! as int)),
          child: const SeatMapPage(),
        ),
      AppRoutes.checkout => BlocProvider(
          create: (_) => _getIt<CheckoutBloc>()..add(QuoteRequested(settings.arguments! as Hold)),
          child: const CheckoutPage(),
        ),
      AppRoutes.paySuccess => PaySuccessPage(confirmation: settings.arguments! as Confirmation),
      _ => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => _getIt<ShellCubit>()..pingRequested()),
            BlocProvider(create: (_) => _getIt<MovieListBloc>()..add(const RefreshRequested())),
          ],
          child: const ShellPage(),
        ),
    };
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
