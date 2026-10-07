import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/motion/entrance.dart';
import '../../../core/motion/motion.dart';
import '../../../core/motion/poster_hero.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/inline_banner.dart';
import '../../../core/widgets/skeleton.dart';
import '../../seats/model/seat_map_args.dart';
import '../controller/showing_cubit.dart';
import '../model/movie.dart';
import 'hall_list_section.dart' show apiFailureText;
import 'home_section_header.dart';
import 'poster_card.dart';
import 'poster_image.dart';

/// Home's "Showing {date}" (sprint 20): a date strip, then one card per movie
/// with its next showtimes that day. A time chip opens the seat map directly;
/// the rest of the card opens the movie.
class ShowingSection extends StatelessWidget {
  const ShowingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ShowingCubit>().state;
    final date = state.date;
    return Column(
      key: const Key('section.showing'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'home.showing.title'.tr(
            context: context,
            namedArgs: {'date': date == null ? '' : dayLabel(context, date, state.dates)},
          ),
        ),
        if (state.dates.isNotEmpty) DateStrip(dates: state.dates, selected: date),
        const SizedBox(height: Space.x1),
        AnimatedSwitcher(
          duration: context.motion(Motion.medium),
          child: KeyedSubtree(
            // Each emitted state is its own instance, so a quick failure → retry →
            // failure never puts two children with one key in the switcher.
            key: ObjectKey(state),
            child: switch (state) {
              ShowingInitial() || ShowingLoading() => const Skeleton(child: _RailSkeleton()),
              ShowingFailure(:final failure) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.screen),
                child: InlineBanner(
                  key: const Key('showing.failure'),
                  message: apiFailureText(context, failure),
                  actionLabel: 'common.retry'.tr(context: context),
                  onAction: () => context.read<ShowingCubit>().dateSelected(state.date),
                ),
              ),
              ShowingReady(:final movies, :final nextDate) when movies.isEmpty => _Empty(
                date: state.date,
                nextDate: nextDate,
                dates: state.dates,
              ),
              ShowingReady(:final movies, :final savedAt) => EntranceScope(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Rail(movies: movies, date: state.date, offline: savedAt != null),
                    // Saved times cannot be booked until the server answers again (sprint 21).
                    if (savedAt != null)
                      Padding(
                        key: const Key('showing.offline'),
                        padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, 0),
                        child: Text(
                          'home.offline.timesDisabled'.tr(context: context),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            },
          ),
        ),
      ],
    );
  }
}

/// `Today`, `Tomorrow`, then `Fri 10` for the rest of the strip.
String dayLabel(BuildContext context, DateTime date, List<DateTime> dates) {
  if (dates.isNotEmpty && date == dates.first) return 'home.dates.today'.tr(context: context);
  if (dates.length > 1 && date == dates[1]) return 'home.dates.tomorrow'.tr(context: context);
  return context.shortDay(date);
}

String _iso(DateTime d) => d.toIso8601String().substring(0, 10);

class DateStrip extends StatelessWidget {
  const DateStrip({super.key, required this.dates, required this.selected});

  final List<DateTime> dates;
  final DateTime? selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Space.minTarget,
      child: ListView(
        key: const Key('home.dates'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
        children: [
          for (final d in dates)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.x1),
              child: AppChip(
                key: Key('home.date.${_iso(d)}'),
                label: dayLabel(context, d, dates),
                selected: d == selected,
                onSelected: () => context.read<ShowingCubit>().dateSelected(d),
              ),
            ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.date, required this.nextDate, required this.dates});

  final DateTime date;
  final DateTime? nextDate;
  final List<DateTime> dates;

  @override
  Widget build(BuildContext context) {
    final next = nextDate;
    return Padding(
      key: const Key('showing.empty'),
      padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'home.showing.empty'.tr(context: context, namedArgs: {'date': dayLabel(context, date, dates)}),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (next != null)
            AppButton.ghost(
              key: const Key('showing.nextDate'),
              label: 'home.showing.nextDate'.tr(context: context, namedArgs: {'date': dayLabel(context, next, dates)}),
              onPressed: () => context.read<ShowingCubit>().dateSelected(next),
            ),
        ],
      ),
    );
  }
}

/// Card geometry shared by the rail and its skeleton.
abstract final class _Card {
  static const width = 296.0;
  static const posterWidth = 96.0;
  static const posterHeight = posterWidth * 3 / 2;

  /// The skeleton's height: title, meta, and two rows of chips at 1× text.
  static const skeletonHeight = posterHeight + 2 * Space.x1 + Space.x4;
}

/// Cards size to their content (time chips wrap onto more rows at large text
/// or in Khmer) and share the tallest card's height. A day has a handful of
/// movies, so the row is built at once rather than lazily.
class _Rail extends StatelessWidget {
  const _Rail({required this.movies, required this.date, required this.offline});

  final List<ShowingMovie> movies;
  final DateTime date;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('rail.showing'),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: Space.screen),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < movies.length; i++) ...[
              if (i > 0) const SizedBox(width: Space.posterGap),
              Entrance(
                key: ValueKey(movies[i].movie.id),
                index: i,
                child: ShowingCard(showing: movies[i], date: date, offline: offline),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ShowingCard extends StatelessWidget {
  const ShowingCard({super.key, required this.showing, required this.date, this.offline = false});

  final ShowingMovie showing;
  final DateTime date;

  /// Saved data: the time chips are shown but disabled.
  final bool offline;

  void _openMovie(BuildContext context) => Navigator.of(context).pushNamed(
    AppRoutes.movieDetail,
    arguments: MovieDetailArgs(movieId: showing.movie.id, heroSource: HeroSource.showing),
  );

  void _openSeats(BuildContext context, ShowtimeSlot slot) {
    context.read<ShowingCubit>().showtimeChosen(showing, slot);
    Navigator.of(context).pushNamed(
      AppRoutes.seatMap,
      arguments: SeatMapArgs(
        showtimeId: slot.id,
        posterUrl: showing.movie.posterUrl,
        date: date,
        options: [for (final s in showing.slots) ShowtimeOption(id: s.id, time: s.time, hallName: s.hallName)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = showing.movie;
    final textTheme = Theme.of(context).textTheme;
    final meta = posterMeta(context, movie, withGenre: true);
    return SizedBox(
      key: Key('showing.${movie.id}'),
      width: _Card.width,
      child: Material(
        color: AppColors.navyRaised,
        borderRadius: BorderRadius.circular(Radii.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: Key('showing.${movie.id}.open'),
          onTap: () => _openMovie(context),
          child: Padding(
            padding: const EdgeInsets.all(Space.x1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _Card.posterWidth,
                  height: _Card.posterHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Radii.sm),
                    child: PosterHero(
                      tag: HeroTags.poster(movie.id, HeroSource.showing),
                      radius: Radii.sm,
                      child: PosterImage(
                        url: movie.posterUrl,
                        cacheWidth: (_Card.posterWidth * MediaQuery.devicePixelRatioOf(context)).round(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Space.x2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movie.title, style: textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (meta.isNotEmpty)
                            Text(meta, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (showing.dolby || showing.screenX)
                            Padding(
                              padding: const EdgeInsets.only(top: Space.x0_5),
                              child: Wrap(
                                spacing: Space.x0_5,
                                children: [
                                  if (showing.dolby)
                                    _Badge(
                                      'home.halls.dolby'.tr(context: context),
                                      key: Key('showing.${movie.id}.dolby'),
                                    ),
                                  if (showing.screenX)
                                    _Badge(
                                      'home.halls.screenX'.tr(context: context),
                                      key: Key('showing.${movie.id}.screenX'),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: Space.x1),
                      Wrap(
                        spacing: Space.x1,
                        children: [
                          for (final slot in showing.slots)
                            Semantics(
                              label: 'home.showing.slot'.tr(
                                context: context,
                                namedArgs: {'time': slot.time, 'hall': slot.hallName, 'title': movie.title},
                              ),
                              excludeSemantics: true,
                              button: true,
                              child: AppChip(
                                key: Key('showing.slot.${slot.id}'),
                                label: slot.time,
                                selected: false,
                                onSelected: offline ? null : () => _openSeats(context, slot),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.x0_5, vertical: 1),
      decoration: BoxDecoration(color: AppColors.navyHigh, borderRadius: BorderRadius.circular(Space.x0_5)),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mist)),
    );
  }
}

class _RailSkeleton extends StatelessWidget {
  const _RailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('showing.skeleton'),
      height: _Card.skeletonHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
        itemCount: 2,
        separatorBuilder: (_, _) => const SizedBox(width: Space.posterGap),
        itemBuilder: (_, _) => const SkeletonBox(width: _Card.width),
      ),
    );
  }
}
