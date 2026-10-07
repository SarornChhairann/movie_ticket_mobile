import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/entrance.dart';
import '../../../core/motion/motion.dart';
import '../../../core/motion/poster_hero.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/genre_chip.dart';
import '../../../core/widgets/skeleton.dart';
import '../controller/movie_list_bloc.dart';
import '../model/movie.dart';
import 'catalog_filters.dart';
import 'poster_card.dart';

/// Explore: the full list for the active tab, genre, and search, as a two-column grid.
class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieListBloc>();
    final state = context.watch<MovieListBloc>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, Space.x2),
          child: CatalogSearch(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.screen),
          child: Wrap(
            spacing: Space.x1,
            children: [
              for (final tab in MovieTab.values)
                GenreChip(
                  key: Key('explore.tab.${tab.name}'),
                  label: switch (tab) {
                    MovieTab.nowShowing => 'catalog.nowShowing'.tr(context: context),
                    MovieTab.comingSoon => 'catalog.comingSoon'.tr(context: context),
                  },
                  selected: state.tab == tab,
                  onSelected: () => bloc.add(TabChanged(tab)),
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.x1),
        const GenreChipRow(),
        const SizedBox(height: Space.x1),
        Expanded(
          child: switch (state) {
            MovieListInitial() || MovieListLoading() => const Skeleton(
                key: Key('explore.skeleton'),
                child: _Grid(itemCount: 6, itemBuilder: _skeletonCard),
              ),
            MovieListFailure() => ErrorView(
                message: catalogFailureText(context, state),
                onRetry: () => bloc.add(const RefreshRequested()),
              ),
            MovieListReady() => RefreshIndicator(
                onRefresh: () async => bloc.add(const RefreshRequested()),
                // Tab, genre, or search changes crossfade the whole grid.
                child: AnimatedSwitcher(
                  duration: context.motion(Motion.medium),
                  child: KeyedSubtree(
                    key: ValueKey('${state.tab}|${state.genre}|${state.search}'),
                    child: state.visible.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [SizedBox(height: Space.x6), EmptyView(messageKey: 'catalog.empty')],
                          )
                        : EntranceScope(
                            child: _Grid(
                              itemCount: state.visible.length,
                              itemBuilder: (context, i) => Entrance(
                                key: ValueKey(state.visible[i].id),
                                index: i,
                                child: PosterCard(movie: state.visible[i], heroSource: HeroSource.explore),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
          },
        ),
      ],
    );
  }
}

Widget _skeletonCard(BuildContext context, int index) => const SkeletonPosterCard();

/// Two-column poster grid shared by the loaded and loading states.
class _Grid extends StatelessWidget {
  const _Grid({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, Space.x3),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Space.posterGap,
        mainAxisSpacing: Space.posterGap,
        childAspectRatio: 0.48,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
