import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/haptics/app_haptics.dart';
import '../../../core/motion/motion.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/app_chip.dart';
import '../controller/favourite_halls_cubit.dart';
import '../model/hall.dart';
import 'home_section_header.dart';

/// The bloc of type [B] above [context], or null when none is provided (screens
/// built without the sprint 22 personal sections, e.g. in some tests).
B? maybeBloc<B extends StateStreamableSource<Object?>>(BuildContext context) {
  try {
    return BlocProvider.of<B>(context, listen: false);
  } on Object {
    return null;
  }
}

/// The heart on a hall row and the hall schedule page (sprint 22, D5). A light
/// haptic and a scale pop on each toggle (none under reduced motion). Hidden when
/// no [FavouriteHallsCubit] is above.
class FavouriteHeart extends StatelessWidget {
  const FavouriteHeart({super.key, required this.hallId});

  final int hallId;

  @override
  Widget build(BuildContext context) {
    final cubit = maybeBloc<FavouriteHallsCubit>(context);
    if (cubit == null) return const SizedBox.shrink();
    return BlocBuilder<FavouriteHallsCubit, FavouriteHallsState>(
      bloc: cubit,
      buildWhen: (a, b) => a.isFavourite(hallId) != b.isFavourite(hallId),
      builder: (context, state) {
        final on = state.isFavourite(hallId);
        return IconButton(
          key: Key('hall.$hallId.favourite'),
          tooltip: (on ? 'hall.favourite.remove' : 'hall.favourite.add').tr(context: context),
          isSelected: on,
          onPressed: () {
            AppHaptics.light();
            cubit.toggle(hallId);
          },
          icon: TweenAnimationBuilder<double>(
            // A new key per state restarts the pop.
            key: ValueKey(on),
            tween: Tween(begin: context.reduceMotion ? 1 : 0.6, end: 1),
            duration: context.motion(Motion.medium),
            curve: Motion.overshoot,
            builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
            child: Icon(
              on ? Icons.favorite : Icons.favorite_border,
              color: on ? Theme.of(context).colorScheme.error : null,
            ),
          ),
        );
      },
    );
  }
}

/// Home's "Your halls": a chip per favourite hall that is still listed, with its
/// next showtime today when known, above the full Halls list.
class YourHallsRow extends StatelessWidget {
  const YourHallsRow({super.key, required this.halls});

  /// Every loaded hall (unfiltered).
  final List<Hall> halls;

  @override
  Widget build(BuildContext context) {
    final cubit = maybeBloc<FavouriteHallsCubit>(context);
    if (cubit == null) return const SizedBox.shrink();
    return BlocBuilder<FavouriteHallsCubit, FavouriteHallsState>(
      bloc: cubit,
      builder: (context, state) {
        final byId = {for (final h in halls) h.id: h};
        final favourites = [for (final id in state.ids) ?byId[id]];
        if (favourites.isEmpty) return const SizedBox.shrink();
        return Column(
          key: const Key('home.yourHalls'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeSectionHeader(titleKey: 'home.yourHalls'),
            SizedBox(
              height: Space.minTarget,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: Space.screen),
                itemCount: favourites.length,
                separatorBuilder: (_, _) => const SizedBox(width: Space.x1),
                itemBuilder: (context, i) {
                  final hall = favourites[i];
                  final time = state.nextTimes[hall.id];
                  return Center(
                    child: AppChip(
                      key: Key('home.yourHalls.${hall.id}'),
                      label: time == null ? hall.name : '${hall.name} · $time',
                      selected: false,
                      icon: Icon(Icons.favorite, size: Space.x2, color: Theme.of(context).colorScheme.error),
                      onSelected: () => Navigator.of(context).pushNamed(AppRoutes.hallSchedule, arguments: hall.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
