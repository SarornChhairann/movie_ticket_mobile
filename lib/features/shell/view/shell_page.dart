import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../_gallery/view/gallery_entry.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/navigation/shell_tabs.dart';
import '../../../core/motion/motion.dart';
import '../../../core/haptics/app_haptics.dart';
import '../../../core/widgets/app_list_tile.dart';
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
import '../../catalog/view/featured_hero.dart';
import '../../catalog/view/movie_home_view.dart';
import '../../catalog/view/movie_list_view.dart';
import '../../profile/controller/profile_bloc.dart';
import '../../profile/view/profile_page.dart';
import '../../tickets/controller/my_bookings_bloc.dart' as tickets;
import '../../tickets/controller/up_next_cubit.dart';
import '../../tickets/view/up_next_card.dart';
import '../../tickets/view/my_bookings_page.dart';
import '../../tickets/view/offline_note.dart';
import '../controller/shell_cubit.dart';
import '../controller/shell_state.dart';
import '../model/greeting.dart';
import 'account_action.dart';
import 'ticket_landing.dart';
import 'language_toggle.dart';

enum ShellTab { home, explore, bookings, profile }

/// Bottom-bar shell. Anyone can browse Home and Explore. Bookings shows the
/// account's list when signed in, and for guests the bookings made or found on
/// this phone with Find my booking and a sign-in button. The Account tab is open
/// to guests (language, sign-in) and becomes Profile once signed in.
class ShellPage extends StatefulWidget {
  const ShellPage({super.key, this.tabs, this.clock = DateTime.now});

  /// Tab requests from screens above the shell (Success → Bookings).
  final ShellTabs? tabs;

  /// For the greeting's time of day; injected for tests.
  final DateTime Function() clock;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  ShellTab _tab = ShellTab.home;
  final _bookingsIconKey = GlobalKey();
  StreamSubscription<ShellTabRequest>? _requests;

  /// A new ticket landed in Bookings; cleared when the user leaves that tab.
  bool _bookingsBadge = false;

  @override
  void initState() {
    super.initState();
    _requests = widget.tabs?.requests.listen(_onTabRequest);
    _loadUpNext();
    _homeViewed();
  }

  /// One `home_viewed` per visit: cold start or switching to Home (sprint 21).
  void _homeViewed() {
    try {
      context.read<ShellCubit>().homeViewed();
    } on Object {
      // No shell cubit above (some tests).
    }
  }

  /// The shell's part of Home's pull to refresh: connectivity + hero, and Up next.
  Future<void> _refreshShell() async {
    final signedIn = context.read<AuthBloc>().state is AuthAuthenticated;
    await Future.wait([
      context.read<ShellCubit>().pingRequested(),
      if (_maybeUpNext() case final upNext?) upNext.load(signedIn: signedIn),
    ]);
  }

  /// Up next follows the session: the account's bookings, or the guest's on this phone.
  void _loadUpNext() {
    final upNext = _maybeUpNext();
    upNext?.load(signedIn: context.read<AuthBloc>().state is AuthAuthenticated);
  }

  UpNextCubit? _maybeUpNext() {
    try {
      return context.read<UpNextCubit>();
    } on Object {
      return null;
    }
  }

  @override
  void dispose() {
    _requests?.cancel();
    super.dispose();
  }

  /// Success → Bookings: the ticket flies into the tab icon, the badge pops,
  /// then the tab opens. Reduced motion: the tab opens at once, with the badge.
  Future<void> _onTabRequest(ShellTabRequest request) async {
    final tab = ShellTab.values[request.index];
    final from = request.flightFrom;
    final icon = _bookingsIconKey.currentContext?.findRenderObject() as RenderBox?;
    final animate = !context.reduceMotion && tab == ShellTab.bookings && from != null && icon != null && icon.hasSize;
    if (animate) {
      await flyTicket(context, from: from, to: icon.localToGlobal(Offset.zero) & icon.size);
      if (!mounted) return;
      AppHaptics.success();
      setState(() => _bookingsBadge = true);
      await Future<void>.delayed(context.motion(Motion.medium));
      if (!mounted) return;
    } else if (tab == ShellTab.bookings) {
      setState(() => _bookingsBadge = true);
    }
    _loadUpNext();
    await _select(tab);
  }

  Future<void> _select(ShellTab tab) async {
    if (tab != ShellTab.bookings && _bookingsBadge) _bookingsBadge = false;
    if (tab == ShellTab.home && _tab != ShellTab.home) _homeViewed();
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

  /// Explore has its own list (sprint 22); Home's filters go along with "See all".
  void _seeAll(MovieTab tab) {
    final home = context.read<MovieListBloc>().state;
    context.read<ExploreMovieListBloc>()
      ..add(TabChanged(tab))
      ..add(GenreSelected(home.genre))
      ..add(LanguageSelected(home.language))
      ..add(RatingSelected(home.rating));
    _select(ShellTab.explore);
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = context.watch<AuthBloc>().state is AuthAuthenticated;
    final body = switch (_tab) {
      ShellTab.home => SafeArea(
          bottom: false,
          child: MovieHomeView(
            header: _HomeHeader(onAccount: _openAccount, clock: widget.clock),
            hero: BlocBuilder<ShellCubit, ShellState>(
              buildWhen: (a, b) => b is! ShellLoading,
              builder: (context, state) => switch (state) {
                ShellReady(:final summary) when summary.featured != null => FeaturedHero(movie: summary.featured!),
                _ => const SizedBox.shrink(),
              },
            ),
            onRefresh: _refreshShell,
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
              Expanded(
                child: BlocProvider<MovieListBloc>.value(
                  value: context.read<ExploreMovieListBloc>(),
                  child: const MovieListView(),
                ),
              ),
            ],
          ),
        ),
      ShellTab.bookings => signedIn
          ? MyBookingsPage(onBrowse: () => _select(ShellTab.explore))
          : BlocProvider<tickets.MyBookingsBloc>.value(
              value: context.read<tickets.GuestBookingsBloc>(),
              child: MyBookingsPage(onSignIn: _openBookingsSignIn, onBrowse: () => _select(ShellTab.explore)),
            ),
      ShellTab.profile => signedIn ? const ProfilePage() : _GuestProfile(onSignIn: _openAccount),
    };
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (a, b) => (a is AuthAuthenticated) != (b is AuthAuthenticated),
      listener: (context, _) => _loadUpNext(),
      child: Scaffold(
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
            icon: _BadgeIcon(key: _bookingsIconKey, icon: Icons.confirmation_number_outlined, badge: _bookingsBadge),
            selectedIcon: _BadgeIcon(icon: Icons.confirmation_number, badge: _bookingsBadge),
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
      ),
    );
  }
}

/// Greeting, avatar, and the connectivity banner.
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onAccount, required this.clock});

  final VoidCallback onAccount;
  final DateTime Function() clock;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ShellCubit, ShellState>(
          builder: (context, state) => Reveal(
            child: switch (state) {
              // Saved copy: the server could not be reached (sprint 21).
              ShellReady(:final savedAt?) => KeyedSubtree(
                  key: const Key('home.offline'),
                  child: OfflineNote(savedAt: savedAt),
                ),
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
          padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, Space.x1),
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (a, b) => _name(a) != _name(b),
                  builder: (context, auth) {
                    // The name the session already loaded; no extra call (sprint 22).
                    final name = _name(auth);
                    return Text(
                      greetingKey(dayPartAt(clock()), named: name != null)
                          .tr(context: context, namedArgs: {'name': ?name}),
                      key: const Key('home.greeting'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  },
                ),
              ),
              const SizedBox(width: Space.x2),
              AccountAction(onTap: onAccount),
            ],
          ),
        ),
        // Sprint 18: the next show, one tap from its ticket.
        const UpNextCard(),
        const SizedBox(height: Space.x1),
      ],
    );
  }
}

String? _name(AuthState state) => state is AuthAuthenticated ? firstName(state.user.name) : null;

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
          AppListTile(
            leading: const Icon(Icons.person_outline),
            title: Text('profile.guest'.tr(context: context)),
            subtitle: Text('profile.guestHint'.tr(context: context)),
          ),
          AppListTile(
            leading: const Icon(Icons.translate),
            title: Text('shell.language'.tr(context: context)),
            trailing: const LanguageToggle(),
          ),
          const GalleryEntry(),
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

/// A tab icon with a dot that pops in when a ticket lands (sprint 16).
class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({super.key, required this.icon, required this.badge});

  final IconData icon;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: badge ? 1 : 0),
      duration: context.motion(Motion.medium),
      curve: Motion.overshoot,
      builder: (context, v, child) => Badge(
        key: badge ? const Key('nav.bookings.badge') : null,
        isLabelVisible: v > 0,
        smallSize: 8 * v.clamp(0, 1.3),
        backgroundColor: context.tokens.warning,
        child: child,
      ),
      child: Icon(icon),
    );
  }
}

