import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/motion/poster_hero.dart';
import '../../../core/motion/pressable.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../model/movie.dart';
import 'poster_image.dart';

/// `155 min · PG-13` (the release year when there is no duration), plus
/// `· Sci-Fi` when [withGenre]. Only fields the API sent.
String posterMeta(BuildContext context, Movie movie, {bool withGenre = false}) => [
      if (movie.durationMinutes != null)
        'catalog.duration'.tr(context: context, namedArgs: {'minutes': '${movie.durationMinutes}'})
      else if (movie.releaseDate != null)
        '${movie.releaseDate!.year}',
      if (movie.rating != null && movie.rating!.isNotEmpty) movie.rating!,
      if (withGenre && movie.genre != null) movie.genre!,
    ].join(' · ');

/// Poster (2:3, radius 16), title, `duration · rating`, then the genre, each
/// only when the API has it. There is no review count: the API does not have one.
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
    final meta = posterMeta(context, movie);
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
              if (meta.isNotEmpty) Text(meta, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (movie.genre != null)
                Text(movie.genre!, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
