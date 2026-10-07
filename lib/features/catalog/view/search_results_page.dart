import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/poster_hero.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/app_list_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_chip.dart';
import '../controller/search_results_bloc.dart';
import '../model/hall.dart';
import '../model/movie.dart';
import 'hall_list_section.dart';
import 'poster_image.dart';

/// Home's search results (sprint 22, H4): one full-height view over Home with
/// **Movies** (now showing, then coming soon, each with its status) and
/// **Halls**. An empty query shows the recent searches. Back returns to Home as
/// it was: this view has its own bloc.
class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String query) {
    setState(() {
      _controller.value = TextEditingValue(text: query, selection: TextSelection.collapsed(offset: query.length));
    });
    context.read<SearchResultsBloc>().add(SearchQueryChanged(query));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchResultsBloc>();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          key: const Key('search.field'),
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: AppColors.white),
          onChanged: (q) {
            setState(() {});
            bloc.add(SearchQueryChanged(q));
          },
          onSubmitted: (_) => bloc.add(const SearchCommitted()),
          decoration: InputDecoration(
            hintText: 'search.title'.tr(context: context),
            isDense: true,
            prefixIcon: const Icon(Icons.search, color: AppColors.mist),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    key: const Key('search.clear'),
                    tooltip: 'catalog.clear'.tr(context: context),
                    icon: const Icon(Icons.close),
                    onPressed: () => _setQuery(''),
                  ),
          ),
        ),
        actions: const [SizedBox(width: Space.screen)],
      ),
      body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
        builder: (context, state) {
          if (!state.hasQuery) return _Recent(recent: state.recent, onPick: _pickRecent);
          if (state.isEmpty) {
            return EmptyState(
              key: const Key('search.empty'),
              icon: Icons.search_off,
              messageKey: 'search.empty',
              actionLabel: 'search.clearSearch'.tr(context: context),
              onAction: () => _setQuery(''),
            );
          }
          return _Results(state: state);
        },
      ),
    );
  }

  void _pickRecent(String query) {
    _setQuery(query);
    context.read<SearchResultsBloc>().add(const SearchCommitted());
  }
}

class _Recent extends StatelessWidget {
  const _Recent({required this.recent, required this.onPick});

  final List<String> recent;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    if (recent.isEmpty) return const SizedBox.shrink();
    return ListView(
      key: const Key('search.recent'),
      padding: const EdgeInsets.only(bottom: Space.x3),
      children: [
        _GroupHeader(
          titleKey: 'search.recent',
          trailing: TextButton(
            key: const Key('search.clearRecent'),
            onPressed: () => context.read<SearchResultsBloc>().add(const RecentSearchesCleared()),
            child: Text('search.clearRecent'.tr(context: context)),
          ),
        ),
        for (final (i, q) in recent.indexed)
          AppListTile(
            key: Key('search.recent.$i'),
            leading: const Icon(Icons.history),
            title: Text(q),
            onTap: () => onPick(q),
          ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    final movies = state.movies;
    return ListView(
      key: const Key('search.results'),
      padding: const EdgeInsets.only(bottom: Space.x3),
      children: [
        if (state.searching) const LinearProgressIndicator(key: Key('search.searching')),
        if (movies.isNotEmpty) ...[
          const _GroupHeader(titleKey: 'search.movies', key: Key('search.group.movies')),
          for (final m in movies) _MovieResult(movie: m),
        ],
        if (state.halls.isNotEmpty) ...[
          const _GroupHeader(titleKey: 'search.halls', key: Key('search.group.halls')),
          for (final h in state.halls) _HallResult(hall: h),
        ],
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({super.key, required this.titleKey, this.trailing});

  final String titleKey;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.x1, Space.x1),
      child: SizedBox(
        height: Space.minTarget,
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(titleKey.tr(context: context), style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _MovieResult extends StatelessWidget {
  const _MovieResult({required this.movie});

  static const posterWidth = 48.0;

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      key: Key('search.movie.${movie.id}'),
      leading: SizedBox(
        width: posterWidth,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: PosterHero(
            tag: HeroTags.poster(movie.id, HeroSource.search),
            radius: Radii.sm,
            child: PosterImage(url: movie.posterUrl, cacheWidth: 144),
          ),
        ),
      ),
      title: Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Align(
        alignment: AlignmentDirectional.centerStart,
        child: StatusChip(
          label: (movie.comingSoon ? 'catalog.comingSoon' : 'catalog.nowShowing').tr(context: context),
          tone: movie.comingSoon ? StatusTone.info : StatusTone.success,
        ),
      ),
      onTap: () {
        context.read<SearchResultsBloc>().add(const SearchCommitted());
        Navigator.of(context).pushNamed(
          AppRoutes.movieDetail,
          arguments: MovieDetailArgs(movieId: movie.id, heroSource: HeroSource.search),
        );
      },
    );
  }
}

class _HallResult extends StatelessWidget {
  const _HallResult({required this.hall});

  final Hall hall;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      key: Key('search.hall.${hall.id}'),
      leading: const Icon(Icons.theaters_outlined),
      title: Text(hall.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [hall.cinemaName, ?hall.city].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: hall.type == null ? null : Text(hallTypeLabel(context, hall.type!)),
      onTap: () {
        context.read<SearchResultsBloc>().add(const SearchCommitted());
        Navigator.of(context).pushNamed(AppRoutes.hallSchedule, arguments: hall.id);
      },
    );
  }
}
