import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../controller/movie_list_bloc.dart';
import '../model/movie.dart';
import 'poster_image.dart';

/// Now showing / coming soon tabs with server-side search.
class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieListBloc>();
    return DefaultTabController(
      length: MovieTab.values.length,
      child: Column(
        children: [
          TabBar(
            onTap: (i) => bloc.add(TabChanged(MovieTab.values[i])),
            tabs: [
              Tab(text: 'catalog.nowShowing'.tr(context: context)),
              Tab(text: 'catalog.comingSoon'.tr(context: context)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.x2, Space.x2, Space.x2, Space.x1),
            child: TextField(
              key: const Key('catalog.search'),
              onChanged: (q) => bloc.add(SearchChanged(q)),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'catalog.search'.tr(context: context),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieListBloc, MovieListState>(
              builder: (context, state) => switch (state) {
                MovieListInitial() || MovieListLoading() => const LoadingView(),
                MovieListReady(:final movies) when movies.isEmpty =>
                  const EmptyView(messageKey: 'catalog.empty'),
                MovieListReady(:final movies) => RefreshIndicator(
                    onRefresh: () async => bloc.add(const RefreshRequested()),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(Space.x2),
                      itemCount: movies.length,
                      separatorBuilder: (_, _) => const SizedBox(height: Space.x2),
                      itemBuilder: (context, i) => MovieCard(movie: movies[i]),
                    ),
                  ),
                MovieListFailure(:final failure) => ErrorView(
                    message: switch (failure) {
                      ApiFailureServer(:final message) => message,
                      ApiFailureNetwork() => 'shell.offline'.tr(context: context),
                      ApiFailureUnknown(:final message) => message ?? '',
                    },
                    onRetry: () => bloc.add(const RefreshRequested()),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final meta = [
      if (movie.genre != null) movie.genre!,
      if (movie.durationMinutes != null)
        'catalog.duration'.tr(context: context, namedArgs: {'minutes': '${movie.durationMinutes}'}),
    ].join(' · ');
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('movie.${movie.id}'),
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.movieDetail, arguments: movie.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosterImage(url: movie.posterUrl, width: 90, height: 130),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Space.x2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textTheme.titleMedium),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: Space.x0_5),
                      Text(meta, style: textTheme.bodySmall),
                    ],
                    if (movie.rating != null) ...[
                      const SizedBox(height: Space.x1),
                      Chip(label: Text(movie.rating!), visualDensity: VisualDensity.compact),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
