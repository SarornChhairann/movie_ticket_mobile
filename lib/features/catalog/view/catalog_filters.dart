import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/genre_chip.dart';
import '../../../core/widgets/search_pill.dart';
import '../controller/movie_list_bloc.dart';

/// Search pill bound to [MovieListBloc]; starts from the bloc's current query.
class CatalogSearch extends StatefulWidget {
  const CatalogSearch({super.key});

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
    return SearchPill(
      fieldKey: const Key('catalog.search'),
      controller: _controller,
      hint: 'catalog.search'.tr(context: context),
      onChanged: (q) => bloc.add(SearchChanged(q)),
      filterTooltip: 'catalog.filter'.tr(context: context),
      onFilter: () => showGenreSheet(context),
    );
  }
}

/// Bottom sheet of the genres already on the loaded movies. No API call.
Future<void> showGenreSheet(BuildContext context) {
  final bloc = context.read<MovieListBloc>();
  return showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => BlocProvider.value(
      value: bloc,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.screen),
          child: BlocBuilder<MovieListBloc, MovieListState>(
            builder: (context, state) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('catalog.filter'.tr(context: context), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: Space.x2),
                Wrap(
                  spacing: Space.x1,
                  runSpacing: Space.x1,
                  children: [
                    for (final g in [null, ...state.genres])
                      GenreChip(
                        label: g ?? 'catalog.allGenres'.tr(context: context),
                        selected: state.genre == g,
                        onSelected: () {
                          bloc.add(GenreSelected(g));
                          Navigator.of(sheetContext).pop();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
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
