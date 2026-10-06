import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/assets/app_images.dart';
import '../../../core/motion/poster_hero.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/platform/link_opener.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/booking_capsule.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/genre_chip.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/view/auth_gate.dart';
import '../../reminders/view/reminder_form.dart';
import '../../seats/model/seat_map_args.dart';
import '../controller/movie_detail_bloc.dart';
import '../model/movie.dart';
import 'poster_image.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, this.openLink = openExternalLink, this.heroSource});

  /// Opens the trailer; injected so tests never launch anything.
  final OpenLink openLink;

  /// Where the poster was tapped; the banner is that poster's Hero target.
  final HeroSource? heroSource;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) => switch (state) {
        MovieDetailInitial() || MovieDetailLoading() => Scaffold(appBar: AppBar(), body: const LoadingView()),
        MovieDetailReady() => _DetailScaffold(state: state, openLink: openLink, heroSource: heroSource),
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
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({required this.state, required this.openLink, this.heroSource});

  final MovieDetailReady state;
  final OpenLink openLink;
  final HeroSource? heroSource;

  static const _bannerHeight = 320.0;
  static const _overlap = 32.0;

  List<ShowtimeSlot> get _slots =>
      [for (final c in state.detail.cinemas) for (final h in c.halls) ...h.slots];

  /// Book Ticket: sign in or continue as a guest (guest checkout is supported),
  /// then go on to the seat map. Closing the login screen stays here.
  Future<void> _book(BuildContext context, int showtimeId) async {
    final result = await requireSignIn(context, reasonKey: 'auth.reason.checkout', allowGuest: true);
    if (result == AuthGateResult.dismissed || !context.mounted) return;
    await Navigator.of(context).pushNamed(
      AppRoutes.seatMap,
      arguments: SeatMapArgs(
        showtimeId: showtimeId,
        posterUrl: state.detail.movie.posterUrl,
        date: state.detail.selectedDate,
        options: [for (final s in _slots) ShowtimeOption(id: s.id, time: s.time, hallName: s.hallName)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = state.detail.movie;
    final selected = state.selectedShowtimeId;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Banner(movie: movie, height: _bannerHeight, openLink: openLink, heroSource: heroSource),
          Transform.translate(
            offset: const Offset(0, -_overlap),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.button)),
              ),
              padding: const EdgeInsets.fromLTRB(Space.screen, Space.x3, Space.screen, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Info(movie: movie),
                  const Divider(height: Space.x4),
                  if (movie.comingSoon)
                    ReminderForm(movieId: movie.id)
                  else
                    _Showtimes(state: state),
                  const SizedBox(height: Space.x3),
                ],
              ),
            ),
          ),
        ],
      ),
      // Sticky; disabled until a real showtime is picked. No price here: the
      // total is the server's quote at checkout.
      bottomNavigationBar: movie.comingSoon
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, Space.x2),
                child: PrimaryButton(
                  key: const Key('detail.book'),
                  label: 'catalog.bookTicket'.tr(context: context),
                  onPressed: selected == null || state.refreshing ? null : () => _book(context, selected),
                ),
              ),
            ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.movie, required this.height, required this.openLink, this.heroSource});

  final Movie movie;
  final double height;
  final OpenLink openLink;
  final HeroSource? heroSource;

  /// Opens the trailer; if that fails, copies the link so it is not lost.
  Future<void> _playTrailer(BuildContext context, String url) async {
    if (await openLink(url)) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('catalog.trailerOpenFailed'.tr(context: context))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final trailer = movie.trailerUrl;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // A missing banner falls back to the poster, then to the wide placeholder.
          // Opened from a card: the card's poster flies into this banner.
          if (heroSource case final source?)
            PosterHero(
              tag: HeroTags.poster(movie.id, source),
              radius: 0,
              child: PosterImage(url: movie.bannerUrl ?? movie.posterUrl, placeholder: AppImages.bannerPlaceholder),
            )
          else
            PosterImage(url: movie.bannerUrl ?? movie.posterUrl, placeholder: AppImages.bannerPlaceholder),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.posterShadeTop, AppColors.posterShadeClear, AppColors.posterShadeBottom],
                stops: [0, 0.45, 1],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.all(Space.x1),
                child: IconButton.filledTonal(
                  key: const Key('detail.back'),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  style: IconButton.styleFrom(backgroundColor: AppColors.overlayButton),
                  icon: const BackButtonIcon(),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
          ),
          if (trailer != null)
            Center(
              child: IconButton.filled(
                key: const Key('detail.trailer'),
                tooltip: 'catalog.trailer'.tr(context: context),
                iconSize: 40,
                style: IconButton.styleFrom(backgroundColor: AppColors.blue, padding: const EdgeInsets.all(Space.x2)),
                icon: const Icon(Icons.play_arrow_rounded),
                onPressed: () => _playTrailer(context, trailer),
              ),
            ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final meta = [
      if (movie.genre != null) movie.genre!,
      if (movie.durationMinutes != null)
        'catalog.duration'.tr(context: context, namedArgs: {'minutes': '${movie.durationMinutes}'}),
      if (movie.rating != null) movie.rating!,
      if (movie.language != null) movie.language!,
      if (movie.format != null) movie.format!,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: textTheme.headlineSmall),
        const SizedBox(height: Space.x1),
        Wrap(
          spacing: Space.x1,
          runSpacing: Space.x1,
          children: [
            for (final m in meta)
              Chip(label: Text(m), visualDensity: VisualDensity.compact, backgroundColor: AppColors.navyRaised),
          ],
        ),
        if (movie.description != null) ...[
          const SizedBox(height: Space.x2),
          _Synopsis(text: movie.description!),
        ],
        if (movie.releaseDate != null)
          _Labeled('catalog.releaseDate', DateFormat.yMMMd(context.locale.toString()).format(movie.releaseDate!)),
        if (movie.director != null) _Labeled('catalog.director', movie.director!),
        if (movie.cast != null) _Labeled('catalog.cast', movie.cast!),
      ],
    );
  }
}

/// Three lines, then "Read more" when the text overflows.
class _Synopsis extends StatefulWidget {
  const _Synopsis({required this.text});

  final String text;

  @override
  State<_Synopsis> createState() => _SynopsisState();
}

class _SynopsisState extends State<_Synopsis> {
  static const _collapsedLines = 3;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mist);
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: _collapsedLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              key: const Key('detail.synopsis'),
              style: style,
              maxLines: _expanded ? null : _collapsedLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            if (overflows)
              TextButton(
                key: const Key('detail.readMore'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 36)),
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text((_expanded ? 'catalog.readLess' : 'catalog.readMore').tr(context: context)),
              ),
          ],
        );
      },
    );
  }
}

class _Showtimes extends StatelessWidget {
  const _Showtimes({required this.state});

  final MovieDetailReady state;

  @override
  Widget build(BuildContext context) {
    final detail = state.detail;
    final textTheme = Theme.of(context).textTheme;
    final locale = context.locale.toString();
    final bloc = context.read<MovieDetailBloc>();
    if (detail.availableDates.isEmpty) {
      return Text('catalog.noShowtimes'.tr(context: context));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('catalog.selectDate'.tr(context: context), style: textTheme.titleMedium),
        const SizedBox(height: Space.x1),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final date in detail.availableDates)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: Space.x1),
                  child: GenreChip(
                    key: Key('date.${date.toIso8601String().substring(0, 10)}'),
                    label: DateFormat.MMMEd(locale).format(date),
                    selected: date == detail.selectedDate,
                    onSelected: () {
                      if (!state.refreshing) bloc.add(DateSelected(date));
                    },
                  ),
                ),
            ],
          ),
        ),
        if (state.refreshing) const LinearProgressIndicator(),
        const SizedBox(height: Space.x2),
        Text('catalog.selectTime'.tr(context: context), style: textTheme.titleMedium),
        for (final cinema in detail.cinemas) ...[
          const SizedBox(height: Space.x1),
          Text(cinema.cinemaName, style: textTheme.bodySmall),
          const SizedBox(height: Space.x0_5),
          Wrap(
            spacing: Space.x1,
            runSpacing: Space.x1,
            children: [
              for (final hall in cinema.halls)
                for (final slot in hall.slots)
                  // The chosen chip is where the booking capsule grows from (sprint 16).
                  HeroMode(
                    enabled: slot.id == state.selectedShowtimeId,
                    child: Hero(
                      tag: BookingCapsule.heroTag(slot.id),
                      child: GenreChip(
                        key: Key('showtime.${slot.id}'),
                        // One day can have several halls and cinemas, so the hall is on the chip.
                        label: [
                          slot.time,
                          hall.hallName,
                          if (hall.dolby) 'Dolby Atmos',
                          if (hall.screenX) 'ScreenX',
                        ].join(' · '),
                        selected: slot.id == state.selectedShowtimeId,
                        onSelected: () => bloc.add(ShowtimeSelected(slot.id)),
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ],
    );
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
        TextSpan(text: '${labelKey.tr(context: context)}: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        TextSpan(text: value, style: const TextStyle(color: AppColors.mist)),
      ])),
    );
  }
}
