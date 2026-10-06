import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/entrance.dart';
import '../../../core/motion/motion.dart';
import '../../../core/motion/poster_hero.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../controller/hall_list_bloc.dart' as hall_list;
import '../controller/movie_list_bloc.dart';
import '../model/movie.dart';
import 'catalog_filters.dart';
import 'coming_soon_carousel.dart';
import 'hall_list_section.dart';
import 'home_section_header.dart';
import 'poster_card.dart';

/// Home body below the greeting: search, the coming-soon carousel, genre chips,
/// the "Now in Cinemas" rail, and the Halls list.
class MovieHomeView extends StatelessWidget {
  const MovieHomeView({super.key, required this.header, required this.onSeeAll, this.today = DateTime.now});

  /// Greeting row and banners, scrolled with the content.
  final Widget header;

  /// "See all": switch to Explore on [tab] (genre stays selected).
  final ValueChanged<MovieTab> onSeeAll;

  /// Injected for tests (release countdown).
  final DateTime Function() today;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieListBloc>();
    final halls = context.read<hall_list.HallListBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(const RefreshRequested());
        halls.add(const hall_list.RefreshRequested());
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: Space.x3),
        children: [
          header,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Space.screen),
            child: CatalogSearch(includeHalls: true),
          ),
          BlocBuilder<MovieListBloc, MovieListState>(
            builder: (context, state) => switch (state) {
              // Skeletons in the final layout: nothing jumps when data arrives.
              MovieListInitial() || MovieListLoading() => const Skeleton(
                  key: Key('home.skeleton'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeSectionHeader(titleKey: 'home.comingSoon'),
                      ComingSoonCarouselSkeleton(),
                      SizedBox(height: Space.x2 + 40),
                      HomeSectionHeader(titleKey: 'catalog.nowInCinemas'),
                      _RailSkeleton(),
                    ],
                  ),
                ),
              MovieListFailure() => ErrorView(
                  message: catalogFailureText(context, state),
                  onRetry: () => bloc.add(const RefreshRequested()),
                ),
              MovieListReady() => EntranceScope(child: _Loaded(state: state, onSeeAll: onSeeAll, today: today)),
            },
          ),
          // Its own builder, so a movie failure keeps the halls and the other way round.
          const HallListSection(),
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
    final comingSoon = state.moviesFor(MovieTab.comingSoon);
    final nowShowing = state.moviesFor(MovieTab.nowShowing);
    // Filter or search changes crossfade the sections instead of popping.
    final filterKey = '${state.genre}|${state.search}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    AnimatedSwitcher(
                      duration: context.motion(Motion.medium),
                      child: ComingSoonCarousel(key: ValueKey('carousel|$filterKey'), movies: comingSoon, today: today),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: Space.x2),
        const GenreChipRow(),
        const SizedBox(height: Space.x1),
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
      ],
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.railKey, required this.movies});

  static const cardWidth = 140.0;

  /// Poster (2:3) plus two text lines.
  static const height = cardWidth * 3 / 2 + 56;

  final Key railKey;
  final List<Movie> movies;

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
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: Space.posterGap),
        itemBuilder: (context, i) => Entrance(
          key: ValueKey(movies[i].id),
          index: i,
          child: PosterCard(movie: movies[i], width: cardWidth, heroSource: HeroSource.nowShowing),
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
      height: _Rail.height,
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
