import 'package:flutter/material.dart';

import '../../../core/motion/poster_hero.dart';
import '../../../core/motion/pressable.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../model/movie.dart';
import 'poster_image.dart';

/// Poster (2:3, radius 16), title, then year and rating when the API has them.
/// There is no review count: the API does not have one.
class PosterCard extends StatelessWidget {
  const PosterCard({super.key, required this.movie, required this.heroSource, this.width});

  final Movie movie;

  /// Which surface this card is on; makes its Hero tag unique.
  final HeroSource heroSource;

  /// Fixed width in a rail; null fills a grid cell.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final meta = [
      if (movie.releaseDate != null) '${movie.releaseDate!.year}',
      if (movie.rating != null && movie.rating!.isNotEmpty) movie.rating!,
    ].join(' · ');
    return SizedBox(
      width: width,
      child: Pressable(
        child: InkWell(
          key: Key('movie.${movie.id}'),
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.movieDetail,
            arguments: MovieDetailArgs(movieId: movie.id, heroSource: heroSource),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: PosterHero(
                  tag: HeroTags.poster(movie.id, heroSource),
                  child: PosterImage(url: movie.posterUrl),
                ),
              ),
              const SizedBox(height: Space.x1),
              Text(movie.title, style: textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (meta.isNotEmpty) Text(meta, style: textTheme.bodySmall, maxLines: 1),
            ],
          ),
        ),
      ),
    );
  }
}
