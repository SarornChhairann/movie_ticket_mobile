import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../controller/movie_detail_bloc.dart';
import '../model/movie.dart';
import 'poster_image.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) => switch (state) {
          MovieDetailInitial() || MovieDetailLoading() =>
            Scaffold(appBar: AppBar(), body: const LoadingView()),
          MovieDetailReady(:final detail, :final refreshing) =>
            _DetailBody(detail: detail, refreshing: refreshing),
          MovieDetailFailure(:final failure) => Scaffold(
              appBar: AppBar(),
              body: ErrorView(
                message: switch (failure) {
                  ApiFailureServer(:final message) => message,
                  ApiFailureNetwork() => 'shell.offline'.tr(context: context),
                  ApiFailureUnknown(:final message) => message ?? '',
                },
              ),
            ),
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail, required this.refreshing});

  final MovieDetail detail;
  final bool refreshing;

  @override
  Widget build(BuildContext context) {
    final movie = detail.movie;
    final textTheme = Theme.of(context).textTheme;
    final locale = context.locale.toString();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            background: PosterImage(url: movie.bannerUrl ?? movie.posterUrl),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Space.x2),
          sliver: SliverList.list(
            children: [
              Wrap(
                spacing: Space.x1,
                runSpacing: Space.x1,
                children: [
                  for (final v in [movie.genre, movie.rating, movie.language, movie.format])
                    if (v != null) Chip(label: Text(v), visualDensity: VisualDensity.compact),
                  if (movie.durationMinutes != null)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text('catalog.duration'.tr(
                        context: context,
                        namedArgs: {'minutes': '${movie.durationMinutes}'},
                      )),
                    ),
                ],
              ),
              if (movie.director != null) _Labeled('catalog.director', movie.director!),
              if (movie.cast != null) _Labeled('catalog.cast', movie.cast!),
              if (movie.releaseDate != null)
                _Labeled(
                  'catalog.releaseDate',
                  DateFormat.yMMMd(locale).format(movie.releaseDate!),
                ),
              if (movie.description != null) ...[
                const SizedBox(height: Space.x2),
                Text(movie.description!, style: textTheme.bodyMedium),
              ],
              if (movie.trailerUrl != null) ...[
                const SizedBox(height: Space.x1),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    icon: const Icon(Icons.copy),
                    label: Text('catalog.trailer'.tr(context: context)),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: movie.trailerUrl!));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('catalog.trailerCopied'.tr(context: context))),
                        );
                      }
                    },
                  ),
                ),
              ],
              const Divider(height: Space.x4),
              if (!movie.comingSoon) ..._showtimes(context, locale),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _showtimes(BuildContext context, String locale) {
    final textTheme = Theme.of(context).textTheme;
    if (detail.availableDates.isEmpty) {
      return [Text('catalog.noShowtimes'.tr(context: context))];
    }
    return [
      Text('catalog.showtimes'.tr(context: context), style: textTheme.titleMedium),
      const SizedBox(height: Space.x1),
      SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final date in detail.availableDates)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: Space.x1),
                child: ChoiceChip(
                  label: Text(DateFormat.MMMEd(locale).format(date)),
                  selected: date == detail.selectedDate,
                  onSelected: refreshing
                      ? null
                      : (_) => context.read<MovieDetailBloc>().add(DateSelected(date)),
                ),
              ),
          ],
        ),
      ),
      if (refreshing) const LinearProgressIndicator(),
      for (final cinema in detail.cinemas) ...[
        const SizedBox(height: Space.x2),
        Text(cinema.cinemaName, style: textTheme.titleSmall),
        for (final hall in cinema.halls) ...[
          const SizedBox(height: Space.x1),
          Text(
            [
              hall.hallName,
              if (hall.dolby) 'Dolby Atmos',
              if (hall.screenX) 'ScreenX',
            ].join(' · '),
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: Space.x0_5),
          Wrap(
            spacing: Space.x1,
            runSpacing: Space.x1,
            children: [
              for (final slot in hall.slots)
                ActionChip(
                  key: Key('showtime.${slot.id}'),
                  label: Text(
                    slot.normalPrice == null
                        ? slot.time
                        : '${slot.time} · ${formatMoney(slot.normalPrice!)}',
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.seatMap, arguments: slot.id),
                ),
            ],
          ),
        ],
      ],
    ];
  }
}

class _Labeled extends StatelessWidget {
  const _Labeled(this.labelKey, this.value);

  final String labelKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Space.x1),
      child: Text.rich(TextSpan(children: [
        TextSpan(
          text: '${labelKey.tr(context: context)}: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        TextSpan(text: value),
      ])),
    );
  }
}
