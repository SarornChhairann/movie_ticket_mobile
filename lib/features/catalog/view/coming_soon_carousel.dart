import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/assets/app_images.dart';
import '../../../core/motion/motion.dart';
import '../../../core/motion/poster_hero.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/skeleton.dart';
import '../model/movie.dart';
import '../model/release_countdown.dart';
import 'poster_image.dart';

/// Home's hero carousel of coming-soon movies (Material 3 hero layout): one large
/// focused card with slivers of its neighbours, snapping, dots, a release
/// countdown, and Remind me.
///
/// Auto-advances every [interval] and pauses while touched (resuming
/// [resumeAfter] after the last touch), while a screen reader is on, under
/// reduced motion, and whenever Home is not on screen (its ticker is muted then).
/// From the last card it fades back to the first instead of scrolling across all.
class ComingSoonCarousel extends StatefulWidget {
  const ComingSoonCarousel({
    super.key,
    required this.movies,
    this.today = DateTime.now,
    this.interval = const Duration(seconds: 5),
    this.resumeAfter = const Duration(seconds: 8),
  });

  final List<Movie> movies;

  /// Injected for tests; only the calendar date is used.
  final DateTime Function() today;
  final Duration interval;
  final Duration resumeAfter;

  /// Weights of the hero layout: neighbour, focused, neighbour.
  static const flexWeights = [1, 7, 1];

  @override
  State<ComingSoonCarousel> createState() => _ComingSoonCarouselState();
}

class _ComingSoonCarouselState extends State<ComingSoonCarousel> with TickerProviderStateMixin {
  final _controller = CarouselController();

  /// Ticker-driven timer: pauses with the app and when Home is offstage.
  late final AnimationController _timer = AnimationController(
    vsync: this,
    duration: widget.interval,
    animationBehavior: AnimationBehavior.preserve,
  )..addStatusListener(_onTimer);

  /// Opacity for the last → first jump.
  late final AnimationController _jumpFade = AnimationController(vsync: this, duration: Motion.medium, value: 1);

  int _focused = 0;
  bool _autoAdvance = false;
  final Set<int> _subscribed = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final allowed =
        !context.reduceMotion &&
        !(MediaQuery.maybeAccessibleNavigationOf(context) ?? false) &&
        widget.movies.length > 1;
    if (allowed != _autoAdvance) {
      _autoAdvance = allowed;
      allowed ? _restart(widget.interval) : _timer.stop();
    }
  }

  @override
  void dispose() {
    _timer.dispose();
    _jumpFade.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _restart(Duration after) {
    if (!_autoAdvance) return;
    _timer
      ..duration = after
      ..forward(from: 0);
  }

  void _onTimer(AnimationStatus status) {
    if (status == AnimationStatus.completed) _advance();
  }

  Future<void> _advance() async {
    if (!mounted || widget.movies.length < 2) return;
    if (_focused >= widget.movies.length - 1) {
      // Fade out, jump to the first card, fade back in.
      await _jumpFade.reverse();
      if (!mounted) return;
      _controller.jumpTo(0);
      await _jumpFade.forward();
    } else {
      await _controller.animateToItem(_focused + 1, duration: Motion.extraLong, curve: Motion.emphasized);
    }
    if (mounted) _restart(widget.interval);
  }

  void _goTo(int index) {
    _controller.animateToItem(index, duration: context.motion(Motion.extraLong), curve: Motion.emphasized);
    _restart(widget.resumeAfter);
  }

  /// Each card measures its own width; the widest one is in focus.
  void _onFocused(int index) {
    if (index == _focused) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && index != _focused) {
        setState(() => _focused = index);
        _precacheNext();
      }
    });
  }

  void _precacheNext() {
    final next = _focused + 1;
    if (next >= widget.movies.length) return;
    final url = widget.movies[next].bannerUrl ?? widget.movies[next].posterUrl;
    if (url != null && url.trim().isNotEmpty) precacheImage(NetworkImage(url), context).ignore();
  }

  Future<void> _remind(Movie movie) async {
    _timer.stop();
    final subscribed = await Navigator.of(context).pushNamed<bool>(AppRoutes.reminderSheet, arguments: movie);
    if (!mounted) return;
    if (subscribed == true) setState(() => _subscribed.add(movie.id));
    _restart(widget.resumeAfter);
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.movies;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Full bleed: the neighbour slots double as the screen margins, so the first
        // and last cards sit centred instead of leaving an empty strip.
        final width = constraints.maxWidth;
        final weights = ComingSoonCarousel.flexWeights;
        final totalWeight = weights.reduce((a, b) => a + b);
        final maxItem = width * weights.reduce((a, b) => a > b ? a : b) / totalWeight;
        final minItem = width * weights.reduce((a, b) => a < b ? a : b) / totalWeight;
        final height = (maxItem * 0.72).clamp(180.0, 320.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height,
              child: FadeTransition(
                opacity: _jumpFade,
                child: Listener(
                  // Any touch pauses auto-advance; it resumes a while after the last one.
                  onPointerDown: (_) => _timer.stop(),
                  onPointerUp: (_) => _restart(widget.resumeAfter),
                  onPointerCancel: (_) => _restart(widget.resumeAfter),
                  child: CarouselView.weighted(
                    key: const Key('carousel'),
                    controller: _controller,
                    flexWeights: weights,
                    itemSnapping: true,
                    // Cards handle their own taps, so Remind me inside a card works.
                    enableSplash: false,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Radii.button))),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    children: [
                      for (var i = 0; i < movies.length; i++)
                        _CarouselCard(
                          key: Key('carousel.${movies[i].id}'),
                          movie: movies[i],
                          index: i,
                          count: movies.length,
                          minWidth: minItem,
                          maxWidth: maxItem,
                          countdown: ReleaseCountdown.of(movies[i].releaseDate, widget.today()),
                          subscribed: _subscribed.contains(movies[i].id),
                          onFocused: _onFocused,
                          onRemind: () => _remind(movies[i]),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (movies.length > 1) ...[
              const SizedBox(height: Space.x1),
              _Dots(count: movies.length, focused: _focused, onTap: _goTo),
            ],
          ],
        );
      },
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    super.key,
    required this.movie,
    required this.index,
    required this.count,
    required this.minWidth,
    required this.maxWidth,
    required this.countdown,
    required this.subscribed,
    required this.onFocused,
    required this.onRemind,
  });

  final Movie movie;
  final int index;
  final int count;
  final double minWidth;
  final double maxWidth;
  final ReleaseCountdown? countdown;
  final bool subscribed;
  final ValueChanged<int> onFocused;
  final VoidCallback onRemind;

  String _release(BuildContext context) => switch (countdown) {
    null => '',
    ReleaseOutNow() => 'release.outNow'.tr(context: context),
    ReleaseTomorrow() => 'release.tomorrow'.tr(context: context),
    ReleaseInDays(:final days) => 'release.inDays'.plural(days, context: context),
    ReleaseOn(:final date) => 'release.on'.tr(
      context: context,
      namedArgs: {'date': DateFormat.yMMMd(context.locale.toString()).format(date)},
    ),
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        // 0 for a sliver at the edge, 1 for the focused card; follows the finger.
        final span = maxWidth - minWidth;
        final focus = span <= 0 ? 1.0 : ((constraints.maxWidth - minWidth) / span).clamp(0.0, 1.0);
        if (focus > 0.5) onFocused(index);
        final release = _release(context);
        final dpr = MediaQuery.devicePixelRatioOf(context);
        return Stack(
          fit: StackFit.expand,
          children: [
            // The card itself: one semantics node, opens detail.
            Semantics(
              button: true,
              label: 'a11y.carouselItem'.tr(
                context: context,
                namedArgs: {'index': '${index + 1}', 'count': '$count', 'title': movie.title, 'release': release},
              ),
              child: ExcludeSemantics(
                child: GestureDetector(
                  key: Key('carousel.open.${movie.id}'),
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.movieDetail,
                    arguments: MovieDetailArgs(movieId: movie.id, heroSource: HeroSource.carousel),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PosterHero(
                        tag: HeroTags.poster(movie.id, HeroSource.carousel),
                        radius: 0,
                        child: PosterImage(
                          url: movie.bannerUrl ?? movie.posterUrl,
                          placeholder: AppImages.bannerPlaceholder,
                          cacheWidth: (maxWidth * dpr).round(),
                        ),
                      ),
                      // Legibility gradient plus dimming of out-of-focus cards.
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4 * (1 - focus)),
                              AppColors.navy.withValues(alpha: 0.15 + 0.25 * (1 - focus)),
                              AppColors.navy.withValues(alpha: 0.92),
                            ],
                            stops: const [0, 0.45, 1],
                          ),
                        ),
                      ),
                      // Text appears as the card comes into focus.
                      Positioned(
                        left: Space.x2,
                        right: Space.x2,
                        bottom: Space.x2 + 44,
                        child: Opacity(
                          opacity: const Interval(0.4, 1).transform(focus),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (release.isNotEmpty)
                                Container(
                                  key: Key('carousel.release.${movie.id}'),
                                  padding: const EdgeInsets.symmetric(horizontal: Space.x1, vertical: 2),
                                  decoration: const ShapeDecoration(shape: StadiumBorder(), color: AppColors.actionFill),
                                  child: Text(release, style: textTheme.labelSmall?.copyWith(color: AppColors.white)),
                                ),
                              const SizedBox(height: Space.x0_5),
                              Text(
                                movie.title,
                                style: textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                [movie.genre, movie.rating].whereType<String>().join(' · '),
                                style: textTheme.bodySmall,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Remind me: its own button, only usable on the focused card.
            Positioned(
              left: Space.x2,
              bottom: Space.x2,
              child: IgnorePointer(
                ignoring: focus < 0.9,
                child: Opacity(
                  opacity: const Interval(0.6, 1).transform(focus),
                  child: AnimatedSwitcher(
                    duration: context.motion(Motion.medium),
                    child: subscribed
                        ? FilledButton.tonalIcon(
                            key: Key('carousel.subscribed.${movie.id}'),
                            onPressed: null,
                            icon: const Icon(Icons.check),
                            label: Text('reminders.subscribed'.tr(context: context)),
                          )
                        : FilledButton.tonalIcon(
                            key: Key('carousel.remind.${movie.id}'),
                            onPressed: onRemind,
                            icon: const Icon(Icons.notifications_active_outlined),
                            label: Text('reminders.submit'.tr(context: context)),
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Page dots; the active one stretches to a pill. Each has a 48 dp tap target
/// (sprint 19) though the dot itself stays small.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.focused, required this.onTap});

  final int count;
  final int focused;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Semantics(
            button: true,
            selected: i == focused,
            label: 'home.comingSoonCount'.tr(context: context, namedArgs: {'index': '${i + 1}', 'count': '$count'}),
            child: GestureDetector(
              key: Key('carousel.dot.$i'),
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: SizedBox.square(
                dimension: Space.minTarget,
                child: Center(
                  child: AnimatedContainer(
                    duration: context.motion(Motion.medium),
                    curve: Motion.decelerate,
                    width: i == focused ? 20 : 8,
                    height: 8,
                    decoration: ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: i == focused ? AppColors.blue : AppColors.navyHigh,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Carousel-shaped loading placeholder.
class ComingSoonCarouselSkeleton extends StatelessWidget {
  const ComingSoonCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Same geometry as the loaded carousel's first card (centred, focused size).
        final weights = ComingSoonCarousel.flexWeights;
        final total = weights.reduce((a, b) => a + b);
        final maxItem = constraints.maxWidth * weights.reduce((a, b) => a > b ? a : b) / total;
        final height = (maxItem * 0.72).clamp(180.0, 320.0);
        return Column(
          children: [
            SizedBox(
              height: height,
              child: Center(
                child: SizedBox(
                  width: maxItem - 8,
                  child: const SkeletonBox(radius: Radii.button),
                ),
              ),
            ),
            const SizedBox(height: Space.x1 + 24),
          ],
        );
      },
    );
  }
}
