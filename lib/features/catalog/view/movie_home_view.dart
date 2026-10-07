import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/entrance.dart';
import '../../../core/motion/motion.dart';
import '../../../core/motion/poster_hero.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/inline_banner.dart';
import '../../../core/widgets/skeleton.dart';
import '../controller/favourite_halls_cubit.dart';
import '../controller/hall_list_bloc.dart' as hall_list;
import '../controller/movie_list_bloc.dart';
import '../controller/recently_viewed_cubit.dart';
import '../controller/showing_cubit.dart';
import '../model/movie.dart';
import 'catalog_filters.dart';
import 'coming_soon_carousel.dart';
import 'favourite_halls.dart';
import 'hall_list_section.dart';
import 'home_section_header.dart';
import 'poster_card.dart';
import 'showing_rail.dart';

/// Home body below the greeting (sprint 20 order, bookable first): search, the
/// featured [hero], the date strip with the Showing rail, Recently viewed
/// (sprint 22), genre chips over the "Now in Cinemas" rail they filter, the
/// coming-soon carousel, then Your halls and the Halls list. The search pill
/// opens the results view; Home itself is never filtered by a search.
///
/// One scroll view of slivers (sprint 21): hall rows are built only as they
/// scroll in. Each section fails on its own with an inline Retry; pull to
/// refresh reloads every section and waits for all of them.
class MovieHomeView extends StatelessWidget {
  const MovieHomeView({
    super.key,
    required this.header,
    required this.onSeeAll,
    this.hero = const SizedBox.shrink(),
    this.onRefresh,
    this.today = DateTime.now,
  });

  /// Greeting row and banners, scrolled with the content.
  final Widget header;

  /// The featured movie; the shell builds it from `GET /`.
  final Widget hero;

  /// The shell's part of pull to refresh (connectivity + hero, Up next).
  final Future<void> Function()? onRefresh;

  /// "See all": switch to Explore on [tab] (genre stays selected).
  final ValueChanged<MovieTab> onSeeAll;

  /// Injected for tests (release countdown).
  final DateTime Function() today;

  Future<void> _refreshAll(BuildContext context) {
    final movies = Completer<void>();
    final halls = Completer<void>();
    context.read<MovieListBloc>().add(RefreshRequested(movies));
    context.read<hall_list.HallListBloc>().add(hall_list.RefreshRequested(halls));
    return Future.wait([
      movies.future,
      halls.future,
      context.read<ShowingCubit>().load(),
      if (maybeBloc<FavouriteHallsCubit>(context) case final favourites?) favourites.loadTimes(),
      if (onRefresh case final shell?) shell(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshAll(context),
      child: CustomScrollView(
        key: const Key('home.scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: header),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Space.screen),
              child: HomeSearchEntry(),
            ),
          ),
          SliverToBoxAdapter(child: hero),
          const SliverToBoxAdapter(child: ShowingSection()),
          // Sprint 22: the movies this shopper was considering.
          const SliverToBoxAdapter(child: _RecentlyViewed()),
          SliverToBoxAdapter(
            child: BlocBuilder<MovieListBloc, MovieListState>(
              builder: (context, state) => switch (state) {
                // Skeletons in the final layout: nothing jumps when data arrives.
                MovieListInitial() || MovieListLoading() => const Skeleton(
                    key: Key('home.skeleton'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Space.x2 + 40),
                        HomeSectionHeader(titleKey: 'catalog.nowInCinemas'),
                        _RailSkeleton(),
                        HomeSectionHeader(titleKey: 'home.comingSoon'),
                        ComingSoonCarouselSkeleton(),
                      ],
                    ),
                  ),
                MovieListFailure() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeSectionHeader(titleKey: 'catalog.nowInCinemas'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
                        child: InlineBanner(
                          key: const Key('home.movies.failure'),
                          message: catalogFailureText(context, state),
                          actionLabel: 'common.retry'.tr(context: context),
                          actionKey: const Key('home.movies.retry'),
                          onAction: () => context.read<MovieListBloc>().add(const RefreshRequested()),
                        ),
                      ),
                    ],
                  ),
                MovieListReady() => EntranceScope(child: _Loaded(state: state, onSeeAll: onSeeAll, today: today)),
              },
            ),
          ),
          // Its own builder, so a movie failure keeps the halls and the other way round.
          const HallListSection(),
          const SliverPadding(padding: EdgeInsets.only(bottom: Space.x3)),
        ],
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state, required this.onSeeAll, required this.today});

  final MovieListReady state;
  final ValueChanged<MovieTab> onSeeAll;
  final DateTime Function() today;

  @override
  Widget build(BuildContext context) {
    // The chips sit right above the rail they filter; the carousel below is
    // never filtered by them (sprint 20). Search never applies on Home (sprint 22).
    final comingSoon = state.comingSoon;
    final nowShowing = state.moviesFor(MovieTab.nowShowing);
    // Filter changes crossfade the rail instead of popping.
    final filterKey = '${state.genre}|${state.language}|${state.rating}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Space.x2),
        const GenreChipRow(),
        HomeSectionHeader(
          titleKey: 'catalog.nowInCinemas',
          seeAllKey: const Key('catalog.nowInCinemas.seeAll'),
          onSeeAll: () => onSeeAll(MovieTab.nowShowing),
        ),
        AnimatedSwitcher(
          duration: context.motion(Motion.medium),
          child: KeyedSubtree(
            key: ValueKey('rail|$filterKey'),
            child: _Rail(railKey: const Key('rail.nowShowing'), movies: nowShowing),
          ),
        ),
        AnimatedSize(
          duration: context.motion(Motion.medium),
          curve: Motion.decelerate,
          alignment: Alignment.topCenter,
          child: comingSoon.isEmpty
              ? const SizedBox(width: double.infinity)
              : Column(
                  key: const Key('section.comingSoon'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeSectionHeader(
                      titleKey: 'home.comingSoon',
                      seeAllKey: const Key('home.comingSoon.seeAll'),
                      onSeeAll: () => onSeeAll(MovieTab.comingSoon),
                    ),
                    ComingSoonCarousel(movies: comingSoon, today: today),
                  ],
                ),
        ),
      ],
    );
  }
}

/// "Recently viewed" (sprint 22, D6): the movies opened on this phone, newest
/// first, that are still in Home's lists; hidden below two.
class _RecentlyViewed extends StatelessWidget {
  const _RecentlyViewed();

  @override
  Widget build(BuildContext context) {
    final cubit = maybeBloc<RecentlyViewedCubit>(context);
    if (cubit == null) return const SizedBox.shrink();
    return BlocBuilder<RecentlyViewedCubit, List<int>>(
      bloc: cubit,
      builder: (context, ids) => BlocBuilder<MovieListBloc, MovieListState>(
        builder: (context, state) {
          final movies = state is MovieListReady ? recentMovies(ids, [...state.nowShowing, ...state.comingSoon]) : const <Movie>[];
          if (movies.isEmpty) return const SizedBox.shrink();
          return Column(
            key: const Key('section.recent'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeSectionHeader(titleKey: 'home.recent'),
              _Rail(railKey: const Key('rail.recent'), movies: movies, heroSource: HeroSource.recent),
            ],
          );
        },
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.railKey, required this.movies, this.heroSource = HeroSource.nowShowing});

  static const cardWidth = 140.0;

  /// Poster (2:3) plus three text lines (title, meta, genre), which grow with
  /// the text size so large text never overflows the rail.
  static double height(BuildContext context) => cardWidth * 3 / 2 + MediaQuery.textScalerOf(context).scale(76);

  final Key railKey;
  final List<Movie> movies;
  final HeroSource heroSource;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Padding(
        key: railKey,
        padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x2),
        child: Text('catalog.empty'.tr(context: context), style: Theme.of(context).textTheme.bodySmall),
      );
    }
    return SizedBox(
      key: railKey,
      height: height(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: Space.posterGap),
        itemBuilder: (context, i) => Entrance(
          key: ValueKey(movies[i].id),
          index: i,
          child: PosterCard(movie: movies[i], width: cardWidth, heroSource: heroSource),
        ),
      ),
    );
  }
}

class _RailSkeleton extends StatelessWidget {
  const _RailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('rail.skeleton'),
      height: _Rail.height(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: Space.posterGap),
        itemBuilder: (_, _) => const SkeletonPosterCard(width: _Rail.cardWidth),
      ),
    );
  }
}
