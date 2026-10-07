import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/genre_chip.dart';
import '../../../core/widgets/search_pill.dart';
import '../controller/hall_list_bloc.dart' as halls;
import '../controller/movie_list_bloc.dart';
import '../controller/search_results_bloc.dart';
import 'hall_list_section.dart';

/// Explore's search pill, bound to its [MovieListBloc]; starts from the bloc's
/// current query. The tune button opens [showCatalogFilterSheet]; its badge
/// counts active filters. [includeHalls] adds the hall filters from [halls.HallListBloc].
class CatalogSearch extends StatefulWidget {
  const CatalogSearch({super.key, this.includeHalls = false});

  final bool includeHalls;

  @override
  State<CatalogSearch> createState() => _CatalogSearchState();
}

class _CatalogSearchState extends State<CatalogSearch> {
  late final _controller = TextEditingController(text: context.read<MovieListBloc>().state.search);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieListBloc>();
    final movieFilters = context.select<MovieListBloc, int>((b) => b.state.activeFilterCount);
    final hallFilters =
        widget.includeHalls ? context.select<halls.HallListBloc, int>((b) => b.state.activeFilterCount) : 0;
    return SearchPill(
      fieldKey: const Key('catalog.search'),
      controller: _controller,
      hint: 'catalog.search'.tr(context: context),
      onChanged: (q) => bloc.add(SearchChanged(q)),
      filterTooltip: 'catalog.filter'.tr(context: context),
      filterCount: movieFilters + hallFilters,
      onFilter: () => showCatalogFilterSheet(context, includeHalls: widget.includeHalls),
    );
  }
}

/// Home's search pill (sprint 22): tapping it opens the search results view over
/// Home with what Home has loaded, so Home itself is never filtered by a search.
/// The tune button still opens the filter sheet with the hall filters.
class HomeSearchEntry extends StatelessWidget {
  const HomeSearchEntry({super.key});

  void _open(BuildContext context) {
    final movies = context.read<MovieListBloc>().state;
    final hallState = context.read<halls.HallListBloc>().state;
    Navigator.of(context).pushNamed(
      AppRoutes.search,
      arguments: SearchSeed(
        nowShowing: movies is MovieListReady ? movies.nowShowing : const [],
        comingSoon: movies is MovieListReady ? movies.comingSoon : const [],
        halls: hallState is halls.HallListReady ? hallState.halls : const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movieFilters = context.select<MovieListBloc, int>((b) => b.state.activeFilterCount);
    final hallFilters = context.select<halls.HallListBloc, int>((b) => b.state.activeFilterCount);
    return SearchPill(
      fieldKey: const Key('home.search'),
      hint: 'search.title'.tr(context: context),
      onTap: () => _open(context),
      filterTooltip: 'catalog.filter'.tr(context: context),
      filterCount: movieFilters + hallFilters,
      onFilter: () => showCatalogFilterSheet(context, includeHalls: true),
    );
  }
}

/// One filter sheet: movie genre, language, rating, and (on Home) hall city, type,
/// Dolby Atmos, ScreenX. Chips apply at once and keep the sheet open; nothing
/// here calls the API. **Clear** resets every filter but not the search.
Future<void> showCatalogFilterSheet(BuildContext context, {bool includeHalls = false}) {
  final movieBloc = context.read<MovieListBloc>();
  final hallBloc = includeHalls ? context.read<halls.HallListBloc>() : null;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: movieBloc),
        if (hallBloc != null) BlocProvider.value(value: hallBloc),
      ],
      child: _FilterSheet(includeHalls: hallBloc != null),
    ),
  );
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({required this.includeHalls});

  final bool includeHalls;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final all = 'catalog.allGenres'.tr(context: context);
    final movies = context.watch<MovieListBloc>();
    final m = movies.state;
    final hallBloc = includeHalls ? context.watch<halls.HallListBloc>() : null;
    final h = hallBloc?.state;

    Widget group(String titleKey, String id, List<String> values, String? selected, ValueChanged<String?> pick,
        {String Function(String)? label}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Space.x2),
        child: Column(
          key: Key('filter.$id'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titleKey.tr(context: context), style: textTheme.titleSmall),
            const SizedBox(height: Space.x1),
            Wrap(
              spacing: Space.x1,
              runSpacing: Space.x1,
              children: [
                for (final v in [null, ...values])
                  GenreChip(
                    key: Key('filter.$id.${v ?? 'all'}'),
                    label: v == null ? all : (label?.call(v) ?? v),
                    selected: selected == v,
                    onSelected: () => pick(v),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        child: Column(
          key: const Key('filter.sheet'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.screen, Space.screen, Space.screen, Space.x1),
              child: Text('catalog.filter'.tr(context: context), style: textTheme.titleMedium),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: Space.screen),
                children: [
                  group('catalog.genre', 'genre', m.genres, m.genre, (v) => movies.add(GenreSelected(v))),
                  group('catalog.language', 'language', m.languages, m.language,
                      (v) => movies.add(LanguageSelected(v))),
                  group('catalog.rating', 'rating', m.ratings, m.rating, (v) => movies.add(RatingSelected(v))),
                  if (hallBloc != null && h != null) ...[
                    const Divider(height: Space.x3),
                    group('catalog.city', 'city', h.cities, h.city, (v) => hallBloc.add(halls.HallCitySelected(v))),
                    group('catalog.hallType', 'type', h.types, h.type, (v) => hallBloc.add(halls.HallTypeSelected(v)),
                        label: (t) => hallTypeLabel(context, t)),
                    SwitchListTile(
                      key: const Key('filter.dolby'),
                      contentPadding: EdgeInsets.zero,
                      title: Text('home.halls.dolby'.tr(context: context)),
                      value: h.dolbyOnly,
                      onChanged: (_) => hallBloc.add(const halls.HallDolbyToggled()),
                    ),
                    SwitchListTile(
                      key: const Key('filter.screenX'),
                      contentPadding: EdgeInsets.zero,
                      title: Text('home.halls.screenX'.tr(context: context)),
                      value: h.screenXOnly,
                      onChanged: (_) => hallBloc.add(const halls.HallScreenXToggled()),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, Space.x2),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('filter.clear'),
                      onPressed: () {
                        movies.add(const MovieFiltersCleared());
                        hallBloc?.add(const halls.HallFiltersCleared());
                      },
                      child: Text('catalog.clear'.tr(context: context)),
                    ),
                  ),
                  const SizedBox(width: Space.x2),
                  Expanded(
                    child: FilledButton(
                      key: const Key('filter.done'),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('catalog.done'.tr(context: context)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal chips: All, then the distinct genres the API returned.
class GenreChipRow extends StatelessWidget {
  const GenreChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MovieListBloc>().state;
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
        children: [
          for (final g in [null, ...state.genres])
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.x1),
              child: GenreChip(
                key: Key('genre.${g ?? 'all'}'),
                label: g ?? 'catalog.allGenres'.tr(context: context),
                selected: state.genre == g,
                onSelected: () => context.read<MovieListBloc>().add(GenreSelected(g)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Failure / empty text shared by Home and Explore.
String catalogFailureText(BuildContext context, MovieListFailure state) => switch (state.failure) {
      ApiFailureServer(:final message) => message,
      ApiFailureNetwork() => 'shell.offline'.tr(context: context),
      ApiFailureUnknown(:final message) => message ?? '',
    };
