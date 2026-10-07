import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/assets/app_images.dart';
import '../../../core/motion/poster_hero.dart';
import '../../../core/motion/pressable.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../model/movie.dart';
import 'poster_card.dart';
import 'poster_image.dart';

/// Home's featured movie (sprint 20): a wide banner with title, meta, and
/// **Book**. Both the banner and Book open the movie's detail.
class FeaturedHero extends StatelessWidget {
  const FeaturedHero({super.key, required this.movie});

  final Movie movie;

  void _open(BuildContext context) => Navigator.of(context).pushNamed(
        AppRoutes.movieDetail,
        arguments: MovieDetailArgs(movieId: movie.id, heroSource: HeroSource.featured),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final meta = posterMeta(context, movie, withGenre: true);
    return Padding(
      key: const Key('home.featured'),
      padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, 0),
      child: Pressable(
        child: Semantics(
          button: true,
          label: [movie.title, meta].where((s) => s.isNotEmpty).join(', '),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.card),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ExcludeSemantics(
                    child: GestureDetector(
                      key: const Key('home.featured.open'),
                      onTap: () => _open(context),
                      child: PosterHero(
                        tag: HeroTags.poster(movie.id, HeroSource.featured),
                        child: LayoutBuilder(
                          builder: (context, constraints) => PosterImage(
                            url: movie.bannerUrl ?? movie.posterUrl,
                            placeholder: AppImages.bannerPlaceholder,
                            cacheWidth: (constraints.maxWidth * MediaQuery.devicePixelRatioOf(context)).round(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.posterShadeClear, AppColors.posterShadeBottom],
                          stops: [0.35, 1],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: Space.x2,
                    right: Space.x2,
                    bottom: Space.x2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ExcludeSemantics(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(movie.title,
                                    style: textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                                if (meta.isNotEmpty)
                                  Text(meta, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: Space.x1),
                        AppButton.primary(
                          key: const Key('home.featured.book'),
                          label: 'home.featured.book'.tr(context: context),
                          expand: false,
                          onPressed: () => _open(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
