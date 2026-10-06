import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/reveal.dart';
import '../../../core/motion/transitions.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/controller/auth_bloc.dart';
import '../../auth/view/auth_gate.dart';
import '../../catalog/controller/movie_list_bloc.dart';
import '../../catalog/model/movie.dart';
import '../../catalog/view/movie_home_view.dart';
import '../../catalog/view/movie_list_view.dart';
import '../../profile/controller/profile_bloc.dart';
import '../../profile/view/profile_page.dart';
import '../../tickets/controller/my_bookings_bloc.dart' as tickets;
import '../../tickets/view/my_bookings_page.dart';
import '../controller/shell_cubit.dart';
import '../controller/shell_state.dart';
import 'account_action.dart';
import 'language_toggle.dart';

enum ShellTab { home, explore, bookings, profile }

/// Bottom-bar shell. Anyone can browse Home and Explore. Bookings shows the
/// account's list when signed in, and for guests the bookings made or found on
/// this phone with Find my booking and a sign-in button. The Account tab is open
/// to guests (language, sign-in) and becomes Profile once signed in.
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  ShellTab _tab = ShellTab.home;

  Future<void> _select(ShellTab tab) async {
    final signedIn = context.read<AuthBloc>().state is AuthAuthenticated;
    // Guests get the bookings saved on this phone and Find my booking (sprint 13).
    if (tab == ShellTab.bookings && !signedIn) context.read<tickets.GuestBookingsBloc>().add(const tickets.RefreshRequested());
    if (signedIn) {
      // Re-read on every visit so bookings and points are current.
      if (tab == ShellTab.bookings) context.read<tickets.MyBookingsBloc>().add(const tickets.RefreshRequested());
      if (tab == ShellTab.profile) {
        context.read<ProfileBloc>().add(const ProfileLoaded());
        context.read<tickets.MyBookingsBloc>().add(const tickets.RefreshRequested());
      }
    }
    setState(() => _tab = tab);
  }

  /// The guest Bookings tab's sign-in: on success it shows the account's list.
  Future<void> _openBookingsSignIn() async {
    if (await requireSignIn(context, reasonKey: 'auth.reason.bookings') == AuthGateResult.signedIn && mounted) {
      context.read<tickets.MyBookingsBloc>().add(const tickets.RefreshRequested());
    }
  }

  /// Avatar and the guest Account tab's sign-in button.
  Future<void> _openAccount() async {
    if (await requireSignIn(context, reasonKey: 'auth.reason.account') == AuthGateResult.signedIn && mounted) {
      await _select(ShellTab.profile);
    }
  }

  void _seeAll(MovieTab tab) {
    context.read<MovieListBloc>().add(TabChanged(tab));
    _select(ShellTab.explore);
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = context.watch<AuthBloc>().state is AuthAuthenticated;
    final body = switch (_tab) {
      ShellTab.home => SafeArea(
          bottom: false,
          child: MovieHomeView(
            header: _HomeHeader(onAccount: _openAccount),
            onSeeAll: _seeAll,
          ),
        ),
      ShellTab.explore => SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, 0),
                child: Text('nav.explore'.tr(context: context), style: Theme.of(context).textTheme.headlineSmall),
              ),
              const Expanded(child: MovieListView()),
            ],
          ),
        ),
      ShellTab.bookings => signedIn
          ? const MyBookingsPage()
          : BlocProvider<tickets.MyBookingsBloc>.value(
              value: context.read<tickets.GuestBookingsBloc>(),
              child: MyBookingsPage(onSignIn: _openBookingsSignIn),
            ),
      ShellTab.profile => signedIn ? const ProfilePage() : _GuestProfile(onSignIn: _openAccount),
    };
    return Scaffold(
      // Tabs are peers: fade-through between them.
      body: FadeThroughSwitcher(child: KeyedSubtree(key: ValueKey(_tab), child: body)),
      bottomNavigationBar: NavigationBar(
        key: const Key('shell.nav'),
        selectedIndex: _tab.index,
        onDestinationSelected: (i) => _select(ShellTab.values[i]),
        destinations: [
          NavigationDestination(
            key: const Key('nav.home'),
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: 'nav.home'.tr(context: context),
          ),
          NavigationDestination(
            key: const Key('nav.explore'),
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: 'nav.explore'.tr(context: context),
          ),
          NavigationDestination(
            key: const Key('nav.bookings'),
            icon: const Icon(Icons.confirmation_number_outlined),
            selectedIcon: const Icon(Icons.confirmation_number),
            label: 'nav.bookings'.tr(context: context),
          ),
          NavigationDestination(
            key: const Key('nav.profile'),
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: 'nav.profile'.tr(context: context),
          ),
        ],
      ),
    );
  }
}

/// Greeting, avatar, and the connectivity banner.
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onAccount});

  final VoidCallback onAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ShellCubit, ShellState>(
          builder: (context, state) => Reveal(
            child: switch (state) {
              ShellFailure(:final failure) => ErrorBanner(
                  key: const Key('shell.offlineBanner'),
                  message: switch (failure) {
                    ApiFailureServer(:final message) => message,
                    ApiFailureNetwork() => 'shell.offline'.tr(context: context),
                    ApiFailureUnknown(:final message) => message ?? '',
                  },
                  onDismiss: () => context.read<ShellCubit>().pingRequested(),
                ),
              _ => null,
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, Space.x3),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'catalog.greeting'.tr(context: context),
                  key: const Key('home.greeting'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: Space.x2),
              AccountAction(onTap: onAccount),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuestProfile extends StatelessWidget {
  const _GuestProfile({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile.title'.tr(context: context))),
      body: ListView(
        padding: const EdgeInsets.all(Space.screen),
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text('profile.guest'.tr(context: context)),
            subtitle: Text('profile.guestHint'.tr(context: context)),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text('shell.language'.tr(context: context)),
            trailing: const LanguageToggle(),
          ),
          const SizedBox(height: Space.x3),
          PrimaryButton(
            key: const Key('profile.signIn'),
            label: 'auth.signIn'.tr(context: context),
            onPressed: onSignIn,
          ),
        ],
      ),
    );
  }
}
