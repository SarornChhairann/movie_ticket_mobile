import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_list_tile.dart';
import '../../../core/motion/entrance.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/inline_banner.dart';
import '../../../core/widgets/skeleton.dart';
import '../controller/hall_list_bloc.dart';
import '../model/hall.dart';
import '../model/hall_mapper.dart';
import 'favourite_halls.dart';
import 'home_section_header.dart';

/// Home's **Halls**: "Your halls" (favourites, sprint 22), then every hall,
/// grouped by cinema, filtered by the hall filters (never by a movie filter or
/// the search, which has its own results view since sprint 22). Loads and fails
/// on its own, apart from the movie sections.
///
/// A sliver (sprint 21): hall rows are built only as they scroll into view.
class HallListSection extends StatelessWidget {
  const HallListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      key: const Key('section.halls'),
      slivers: [
        BlocBuilder<HallListBloc, HallListState>(
          buildWhen: (a, b) => a is! HallListReady || b is! HallListReady || a.halls != b.halls,
          builder: (context, state) => SliverToBoxAdapter(
            child: state is HallListReady ? YourHallsRow(halls: state.halls) : const SizedBox.shrink(),
          ),
        ),
        const SliverToBoxAdapter(child: HomeSectionHeader(titleKey: 'home.halls.title')),
        BlocBuilder<HallListBloc, HallListState>(
          builder: (context, state) => switch (state) {
            HallListInitial() || HallListLoading() => const SliverToBoxAdapter(child: _HallSkeleton()),
            HallListFailure(:final failure) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.screen),
                child: InlineBanner(
                  key: const Key('halls.failure'),
                  message: apiFailureText(context, failure),
                  actionLabel: 'common.retry'.tr(context: context),
                  actionKey: const Key('halls.retry'),
                  onAction: () => context.read<HallListBloc>().add(const LoadRequested()),
                ),
              ),
            ),
            HallListReady(:final halls) => _HallList(halls: halls, filters: state),
          },
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
      decoration: BoxDecoration(color: AppColors.navyHigh, borderRadius: BorderRadius.circular(Space.x0_5)),
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
          Text(
            'home.halls.seats'.tr(context: context, namedArgs: {'count': '${hall.totalSeats}'}),
            style: style,
          ),
        if (showCity && hall.city != null) Text(hall.city!, style: style),
      ],
    );
  }
}

class _HallList extends StatelessWidget {
  const _HallList({required this.halls, required this.filters});

  final List<Hall> halls;

  /// City, type, Dolby, and ScreenX.
  final HallListState filters;

  @override
  Widget build(BuildContext context) {
    if (halls.isEmpty) return _NoteSliver('home.halls.empty'.tr(context: context), key: const Key('halls.empty'));
    final visible = filters.visible(halls, '');
    if (visible.isEmpty) {
      return _NoteSliver('home.halls.filterEmpty'.tr(context: context), key: const Key('halls.filterEmpty'));
    }
    // One flat list of cinema headers and hall rows, built lazily.
    final items = <Object>[];
    for (final group in HallMapper.groupByCinema(visible)) {
      items
        ..add(group)
        ..addAll(group.halls.map((hall) => (hall: hall, showCity: group.city == null)));
    }
    return EntranceScope(
      child: SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, i) => switch (items[i]) {
          final HallGroup group => _CinemaHeader(group: group),
          (hall: final Hall hall, showCity: final bool showCity) => Entrance(
            key: ValueKey('hall-${hall.id}'),
            index: i,
            child: _HallRow(hall: hall, showCity: showCity),
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

class _CinemaHeader extends StatelessWidget {
  const _CinemaHeader({required this.group});

  final HallGroup group;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      key: Key('halls.cinema.${group.cinemaId}'),
      padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, Space.x0_5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.cinemaName, style: textTheme.titleSmall),
          if (group.city != null) Text(group.city!, style: textTheme.bodySmall?.copyWith(color: AppColors.mist)),
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
        child: PressableInkWell(
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
                FavouriteHeart(hallId: hall.id),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteSliver extends StatelessWidget {
  const _NoteSliver(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x2),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    ),
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
