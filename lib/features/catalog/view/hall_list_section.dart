import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/entrance.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../controller/hall_list_bloc.dart';
import '../controller/movie_list_bloc.dart';
import '../model/hall.dart';
import '../model/hall_mapper.dart';
import 'home_section_header.dart';

/// Home's **Halls**: every hall, grouped by cinema, filtered by the home search
/// and the hall filters (never by a movie filter). Loads and fails on its own, apart from the movie sections.
class HallListSection extends StatelessWidget {
  const HallListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('section.halls'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionHeader(titleKey: 'home.halls.title'),
        BlocBuilder<MovieListBloc, MovieListState>(
          buildWhen: (previous, current) => previous.search != current.search,
          builder: (context, movies) => BlocBuilder<HallListBloc, HallListState>(
            builder: (context, state) => switch (state) {
              HallListInitial() || HallListLoading() => const _HallSkeleton(),
              HallListFailure(:final failure) => ErrorView(
                  message: apiFailureText(context, failure),
                  onRetry: () => context.read<HallListBloc>().add(const LoadRequested()),
                ),
              HallListReady(:final halls) => _HallList(halls: halls, search: movies.search, filters: state),
            },
          ),
        ),
      ],
    );
  }
}

String apiFailureText(BuildContext context, ApiFailure failure) => switch (failure) {
      ApiFailureServer(:final message) => message,
      ApiFailureNetwork() => 'shell.offline'.tr(context: context),
      ApiFailureUnknown(:final message) => message ?? '',
    };

/// `ATMOS` and `STANDARD` are translated; any other type is shown as sent.
String hallTypeLabel(BuildContext context, String type) => switch (type.toUpperCase()) {
      'ATMOS' => 'home.halls.type.atmos'.tr(context: context),
      'STANDARD' => 'home.halls.type.standard'.tr(context: context),
      _ => type,
    };

/// Type, Dolby Atmos, ScreenX, seat count, and (when given) city, as one muted line of chips.
class HallFacts extends StatelessWidget {
  const HallFacts({super.key, required this.hall, this.showCity = false});

  final Hall hall;
  final bool showCity;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mist);
    Widget badge(String text, Key key) => Container(
          key: key,
          padding: const EdgeInsets.symmetric(horizontal: Space.x1, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.navyHigh,
            borderRadius: BorderRadius.circular(Space.x0_5),
          ),
          child: Text(text, style: style),
        );
    return Wrap(
      spacing: Space.x1,
      runSpacing: Space.x0_5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (hall.type != null) badge(hallTypeLabel(context, hall.type!), Key('hall.${hall.id}.type')),
        if (hall.dolby) badge('home.halls.dolby'.tr(context: context), Key('hall.${hall.id}.dolby')),
        if (hall.screenX) badge('home.halls.screenX'.tr(context: context), Key('hall.${hall.id}.screenX')),
        if (hall.totalSeats != null)
          Text('home.halls.seats'.tr(context: context, namedArgs: {'count': '${hall.totalSeats}'}), style: style),
        if (showCity && hall.city != null) Text(hall.city!, style: style),
      ],
    );
  }
}

class _HallList extends StatelessWidget {
  const _HallList({required this.halls, required this.search, required this.filters});

  final List<Hall> halls;
  final String search;

  /// City, type, Dolby, and ScreenX.
  final HallListState filters;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (halls.isEmpty) return _Note('home.halls.empty'.tr(context: context), key: const Key('halls.empty'));
    if (filterHalls(halls, search).isEmpty) {
      return _Note('home.halls.searchEmpty'.tr(context: context), key: const Key('halls.searchEmpty'));
    }
    final visible = filters.visible(halls, search);
    if (visible.isEmpty) {
      return _Note('home.halls.filterEmpty'.tr(context: context), key: const Key('halls.filterEmpty'));
    }
    var index = 0;
    return EntranceScope(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final group in HallMapper.groupByCinema(visible)) ...[
            Padding(
              key: Key('halls.cinema.${group.cinemaId}'),
              padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, Space.x0_5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.cinemaName, style: textTheme.titleSmall),
                  if (group.city != null)
                    Text(group.city!, style: textTheme.bodySmall?.copyWith(color: AppColors.mist)),
                ],
              ),
            ),
            for (final hall in group.halls)
              Entrance(
                key: ValueKey('hall-${hall.id}'),
                index: index++,
                child: _HallRow(hall: hall, showCity: group.city == null),
              ),
          ],
        ],
      ),
    );
  }
}

class _HallRow extends StatelessWidget {
  const _HallRow({required this.hall, required this.showCity});

  final Hall hall;
  final bool showCity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x0_5),
      child: Material(
        color: AppColors.navyRaised,
        borderRadius: BorderRadius.circular(Radii.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: Key('hall.${hall.id}'),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.hallSchedule, arguments: hall.id),
          child: Padding(
            padding: const EdgeInsets.all(Space.x2),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hall.name, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: Space.x0_5),
                      HallFacts(hall: hall, showCity: showCity),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x2),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      );
}

/// Hall rows in the final list layout, so nothing jumps when data arrives.
class _HallSkeleton extends StatelessWidget {
  const _HallSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Skeleton(
      key: Key('halls.skeleton'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Space.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Space.x1),
            SkeletonBox(height: 14, width: 180, radius: 4),
            SizedBox(height: Space.x1),
            SkeletonBox(height: 72),
            SizedBox(height: Space.x1),
            SkeletonBox(height: 72),
            SizedBox(height: Space.x1),
            SkeletonBox(height: 72),
          ],
        ),
      ),
    );
  }
}
