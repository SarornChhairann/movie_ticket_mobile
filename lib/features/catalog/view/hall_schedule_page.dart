import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/genre_chip.dart';
import '../../../core/widgets/skeleton.dart';
import '../../seats/model/seat_map_args.dart';
import '../controller/hall_schedule_bloc.dart';
import '../model/catalog_mapper.dart';
import '../model/hall.dart';
import 'favourite_halls.dart';
import 'hall_list_section.dart';
import 'poster_image.dart';

/// One hall's bookable schedule: date chips, then that date's movies and times.
/// A time opens the seat map; this page holds nothing and adds no prices.
class HallSchedulePage extends StatelessWidget {
  const HallSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HallScheduleBloc, HallScheduleState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(switch (state) {
            HallScheduleReady(:final schedule) => schedule.hall.name,
            _ => '',
          }),
          actions: [
            // Sprint 22: keep this hall on Home's "Your halls".
            if (state case HallScheduleReady(:final hallId) || HallScheduleFailure(:final hallId)) FavouriteHeart(hallId: hallId),
          ],
        ),
        body: KeyedSubtree(
          key: const Key('hall.schedule'),
          child: switch (state) {
            HallScheduleInitial() || HallScheduleLoading() => const _ScheduleSkeleton(),
            HallScheduleFailure(:final hallId, :final failure) => ErrorView(
                message: apiFailureText(context, failure),
                onRetry: () => context.read<HallScheduleBloc>().add(ScheduleRequested(hallId)),
              ),
            HallScheduleReady() => _Ready(state: state),
          },
        ),
      ),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.state});

  final HallScheduleReady state;

  @override
  Widget build(BuildContext context) {
    final schedule = state.schedule;
    final textTheme = Theme.of(context).textTheme;
    final locale = context.locale.toString();
    final bloc = context.read<HallScheduleBloc>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, Space.x3),
      children: [
        _HallHeader(hall: schedule.hall),
        const Divider(height: Space.x4),
        if (schedule.availableDates.isEmpty)
          Text('hall.schedule.empty'.tr(context: context), key: const Key('hall.schedule.empty'))
        else ...[
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final date in schedule.availableDates)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: Space.x1),
                    child: GenreChip(
                      key: Key('hall.date.${CatalogMapper.isoDate(date)}'),
                      label: DateFormat.MMMEd(locale).format(date),
                      selected: date == schedule.selectedDate,
                      onSelected: () => bloc.add(DateSelected(date)),
                    ),
                  ),
              ],
            ),
          ),
          if (state.refreshing) const LinearProgressIndicator(),
          const SizedBox(height: Space.x2),
          if (schedule.showtimes.isEmpty)
            Text('hall.schedule.empty'.tr(context: context), key: const Key('hall.schedule.empty'))
          else
            for (final showings in schedule.byMovie) _MovieTimes(schedule: schedule, showings: showings),
        ],
        if (schedule.hall.amenities != null) ...[
          const Divider(height: Space.x4),
          Text('hall.schedule.amenities'.tr(context: context), style: textTheme.titleSmall),
          const SizedBox(height: Space.x0_5),
          Text(schedule.hall.amenities!, key: const Key('hall.amenities'), style: textTheme.bodyMedium),
        ],
      ],
    );
  }
}

class _HallHeader extends StatelessWidget {
  const _HallHeader({required this.hall});

  final Hall hall;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.bodySmall?.copyWith(color: AppColors.mist);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hall.cinemaName, style: textTheme.titleMedium),
        if (hall.city != null) Text(hall.city!, style: muted),
        if (hall.openingHours != null) Text(hall.openingHours!, style: muted),
        const SizedBox(height: Space.x1),
        HallFacts(hall: hall),
      ],
    );
  }
}

/// One movie on the selected date: poster and title (→ movie detail), the
/// showtime's own prices as sent, and its time chips (→ seat map).
class _MovieTimes extends StatelessWidget {
  const _MovieTimes({required this.schedule, required this.showings});

  final HallSchedule schedule;
  final List<HallShowtime> showings;

  void _openSeatMap(BuildContext context, HallShowtime showing) {
    context.read<HallScheduleBloc>().add(ShowtimeChosen(movieId: showing.movieId, showtimeId: showing.id));
    Navigator.of(context).pushNamed(
      AppRoutes.seatMap,
      arguments: SeatMapArgs(
        showtimeId: showing.id,
        posterUrl: showings.first.posterUrl,
        date: schedule.selectedDate,
        options: [
          for (final s in schedule.showtimes) ShowtimeOption(id: s.id, time: s.time, hallName: schedule.hall.name),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final first = showings.first;
    final textTheme = Theme.of(context).textTheme;
    void openMovie() =>
        Navigator.of(context).pushNamed(AppRoutes.movieDetail, arguments: MovieDetailArgs(movieId: first.movieId, source: 'hall'));
    return Padding(
      key: Key('hall.movie.${first.movieId}'),
      padding: const EdgeInsets.only(bottom: Space.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: openMovie,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Space.x1),
              child: PosterImage(url: first.posterUrl, width: 64, height: 96, cacheWidth: 128),
            ),
          ),
          const SizedBox(width: Space.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: openMovie,
                  child: Text(first.movieTitle, key: Key('hall.movieTitle.${first.movieId}'), style: textTheme.titleMedium),
                ),
                const SizedBox(height: Space.x1),
                Wrap(
                  spacing: Space.x1,
                  runSpacing: Space.x1,
                  children: [
                    for (final s in showings)
                      GenreChip(
                        key: Key('hall.showtime.${s.id}'),
                        label: s.time,
                        selected: false,
                        onSelected: () => _openSeatMap(context, s),
                      ),
                  ],
                ),
                if (first.normalPrice != null || first.couplePrice != null) ...[
                  const SizedBox(height: Space.x1),
                  Text(
                    [
                      if (first.normalPrice != null)
                        'hall.schedule.normalPrice'.tr(context: context, namedArgs: {'price': context.money(first.normalPrice!)}),
                      if (first.couplePrice != null)
                        'hall.schedule.couplePrice'.tr(context: context, namedArgs: {'price': context.money(first.couplePrice!)}),
                    ].join(' · '),
                    key: Key('hall.prices.${first.movieId}'),
                    style: textTheme.bodySmall?.copyWith(color: AppColors.mist),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleSkeleton extends StatelessWidget {
  const _ScheduleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Skeleton(
      key: Key('hall.schedule.skeleton'),
      child: Padding(
        padding: EdgeInsets.all(Space.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(height: 18, width: 220, radius: 4),
            SizedBox(height: Space.x1),
            SkeletonBox(height: 14, width: 120, radius: 4),
            SizedBox(height: Space.x3),
            SkeletonBox(height: 40),
            SizedBox(height: Space.x2),
            SkeletonBox(height: 96),
            SizedBox(height: Space.x2),
            SkeletonBox(height: 96),
          ],
        ),
      ),
    );
  }
}
