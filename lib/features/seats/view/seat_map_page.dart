import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/show_time.dart';
import '../../../core/motion/motion.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/seat_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/genre_chip.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../controller/seat_map_bloc.dart';
import '../model/seat_map.dart';
import '../model/seat_map_args.dart';

class SeatMapPage extends StatelessWidget {
  const SeatMapPage({super.key, this.args});

  /// The detail screen's showtime choice; null when opened with a bare id.
  final SeatMapArgs? args;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeatMapBloc, SeatMapState>(
      listenWhen: (previous, current) =>
          current is SeatMapReady &&
          current.effect != null &&
          (previous is! SeatMapReady || previous.effect != current.effect || previous.message != current.message),
      listener: (context, state) {
        final s = state as SeatMapReady;
        final messenger = ScaffoldMessenger.of(context);
        switch (s.effect!) {
          case SeatMapEffect.proceed:
            Navigator.of(context).pushNamed(AppRoutes.checkout, arguments: s.hold);
          case SeatMapEffect.expired:
            Navigator.of(context).popUntil((route) => route.settings.name == AppRoutes.seatMap);
            messenger.showSnackBar(SnackBar(content: Text('seats.expired'.tr(context: context))));
          case SeatMapEffect.pairError:
            messenger.showSnackBar(SnackBar(content: Text('seats.pairError'.tr(context: context))));
          case SeatMapEffect.conflict:
            final message = s.message;
            messenger.showSnackBar(SnackBar(
              content: Text(message == null || message.isEmpty ? 'seats.conflict'.tr(context: context) : message),
            ));
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text('seats.title'.tr(context: context))),
        body: switch (state) {
          SeatMapInitial() || SeatMapLoading() => const LoadingView(),
          SeatMapReady() => _ReadyBody(state: state, args: args),
          SeatMapFailure(:final failure) => ErrorView(
              message: switch (failure) {
                ApiFailureServer(:final message) => message,
                ApiFailureNetwork() => 'shell.offline'.tr(context: context),
                ApiFailureUnknown(:final message) => message ?? '',
              },
            ),
        },
        bottomNavigationBar: state is SeatMapReady ? _SummaryBar(state: state) : null,
      ),
    );
  }
}

class _ReadyBody extends StatelessWidget {
  const _ReadyBody({required this.state, required this.args});

  final SeatMapReady state;
  final SeatMapArgs? args;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    final rows = <int, List<SeatView>>{};
    for (final seat in data.seats) {
      rows.putIfAbsent(seat.row, () => []).add(seat);
    }
    final sortedRows = rows.keys.toList()..sort();
    for (final r in sortedRows) {
      rows[r]!.sort((a, b) => a.number.compareTo(b.number));
    }
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.screen),
          child: Text(
            '${data.movieTitle} · ${data.hallName}',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: Space.x2),
        const _ScreenCurve(),
        Text('seats.screen'.tr(context: context), style: theme.textTheme.labelSmall),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => InteractiveViewer(
              constrained: false,
              minScale: 0.5,
              maxScale: 2.5,
              boundaryMargin: const EdgeInsets.all(Space.x6),
              // At least screen-wide, so a small hall sits centered under the screen.
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(Space.x2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final r in sortedRows)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [for (final seat in rows[r]!) _SeatTile(seat: seat, state: state)],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const _Legend(),
        _ShowtimeChips(state: state, args: args),
      ],
    );
  }
}

/// Thin glowing arc for the screen.
class _ScreenCurve extends StatelessWidget {
  const _ScreenCurve();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.x4),
      child: CustomPaint(size: const Size(double.infinity, 24), painter: _ScreenPainter()),
    );
  }
}

class _ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    canvas
      ..drawPath(
        path,
        Paint()
          ..color = AppColors.blue.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      )
      ..drawPath(
        path,
        Paint()
          ..color = AppColors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// How a seat looks in each UI state. Held stays distinct from booked.
({Color? fill, Color? border, Color text}) _seatLook(SeatColors colors, SeatUiState ui) => switch (ui) {
      SeatUiState.available => (fill: null, border: colors.outline, text: AppColors.white),
      SeatUiState.selected || SeatUiState.heldByMe => (fill: colors.selected, border: null, text: AppColors.white),
      SeatUiState.booked => (fill: colors.booked, border: null, text: AppColors.navy),
      SeatUiState.heldByOthers => (fill: colors.heldFill, border: colors.heldOutline, text: colors.heldOutline),
    };

class _SeatBox extends StatelessWidget {
  const _SeatBox({required this.fill, required this.border, required this.width, this.child});

  static const height = 30.0;

  final Color? fill;
  final Color? border;
  final double width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // Fill and outline animate between states instead of snapping.
    return AnimatedContainer(
      duration: context.motion(Motion.short),
      curve: Motion.decelerate,
      width: width,
      height: height,
      margin: const EdgeInsets.all(3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(6)),
        border: border == null ? null : Border.all(color: border!, width: 1.2),
      ),
      child: child,
    );
  }
}

class _SeatTile extends StatelessWidget {
  const _SeatTile({required this.seat, required this.state});

  static const normalWidth = 30.0;
  static const coupleWidth = 44.0;

  final SeatView seat;
  final SeatMapReady state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SeatColors>()!;
    final ui = state.seatState(seat);
    final look = _seatLook(colors, ui);
    final tile = _SeatBox(
      fill: look.fill,
      border: look.border,
      width: seat.couple ? coupleWidth : normalWidth,
      child: Text(seat.code, style: TextStyle(fontSize: 9, color: look.text, fontWeight: FontWeight.w500)),
    );
    final animated = _SeatFeedback(ui: ui, child: tile);
    if (!state.isTappable(seat)) {
      return Semantics(label: seat.code, enabled: false, child: animated);
    }
    return GestureDetector(
      key: Key('seat.${seat.id}'),
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<SeatMapBloc>().add(SeatToggled(seat.id));
      },
      child: Semantics(button: true, label: seat.code, selected: state.selected.contains(seat.id), child: animated),
    );
  }
}

/// Plays only when a seat's state changes (never on first load): selecting pops
/// it 1 → 1.12 → 1; another session taking it pulses twice. Off under reduced
/// motion.
class _SeatFeedback extends StatefulWidget {
  const _SeatFeedback({required this.ui, required this.child});

  final SeatUiState ui;
  final Widget child;

  @override
  State<_SeatFeedback> createState() => _SeatFeedbackState();
}

class _SeatFeedbackState extends State<_SeatFeedback> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: Motion.medium);
  bool _pulse = false;

  @override
  void didUpdateWidget(_SeatFeedback old) {
    super.didUpdateWidget(old);
    if (old.ui == widget.ui || context.reduceMotion) return;
    final selected = widget.ui == SeatUiState.selected;
    final taken = widget.ui == SeatUiState.heldByOthers;
    if (!selected && !taken) return;
    _pulse = taken;
    _controller
      ..duration = taken ? Motion.extraLong : Motion.medium
      ..forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = _controller.value;
        if (t == 0 || t == 1) return child!;
        final wave = math.sin(math.pi * (_pulse ? 2 * t : t)).abs();
        return Opacity(
          opacity: _pulse ? 1 - 0.5 * wave : 1,
          child: Transform.scale(scale: _pulse ? 1 : 1 + 0.12 * wave, child: child),
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SeatColors>()!;
    Widget item(SeatUiState ui, String key, {bool couple = false}) {
      final look = _seatLook(colors, ui);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 0.6,
            child: _SeatBox(
              fill: look.fill,
              border: look.border,
              width: couple ? _SeatTile.coupleWidth : _SeatTile.normalWidth,
            ),
          ),
          Text(key.tr(context: context), style: Theme.of(context).textTheme.labelSmall),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x1),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: Space.x1,
        children: [
          item(SeatUiState.available, 'seats.legend.available'),
          item(SeatUiState.selected, 'seats.legend.selected'),
          item(SeatUiState.booked, 'seats.legend.reserved'),
          item(SeatUiState.heldByOthers, 'seats.legend.held'),
          item(SeatUiState.available, 'seats.legend.couple', couple: true),
        ],
      ),
    );
  }
}

/// The chosen date and the day's real showtimes from the detail screen. Picking
/// another time drops any hold here and loads that showtime's map.
class _ShowtimeChips extends StatelessWidget {
  const _ShowtimeChips({required this.state, required this.args});

  final SeatMapReady state;
  final SeatMapArgs? args;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    final locale = context.locale.toString();
    final options = args?.options ?? const <ShowtimeOption>[];
    final dateLabel = data.showDate == null ? null : formatShowDate(data.showDate!, locale: locale);
    final bloc = context.read<SeatMapBloc>();
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
        children: [
          if (dateLabel != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.x1),
              child: GenreChip(label: dateLabel, selected: true, onSelected: () {}),
            ),
          if (options.isEmpty && data.showTime != null)
            GenreChip(label: formatShowTime(data.showTime!), selected: true, onSelected: () {})
          else
            for (final o in options)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: Space.x1),
                child: GenreChip(
                  key: Key('seatTime.${o.id}'),
                  label: '${o.time} · ${o.hallName}',
                  selected: o.id == data.showtimeId,
                  onSelected: () {
                    if (o.id == data.showtimeId || state.holding) return;
                    bloc
                      ..add(const ReleaseRequested())
                      ..add(LoadRequested(o.id));
                  },
                ),
              ),
        ],
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.state});

  final SeatMapReady state;

  @override
  Widget build(BuildContext context) {
    final seats = state.selectedSeats;
    final codes = seats.map((s) => s.code).join(', ');
    final left = state.secondsLeft;
    final textTheme = Theme.of(context).textTheme;
    // No prices here: normal/couple prices come from the showtime and the checkout quote.
    return Material(
      color: AppColors.navyRaised,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.button)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.screen, Space.x2, Space.screen, Space.x2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The count crossfades rather than snapping.
                        AnimatedSwitcher(
                          duration: context.motion(Motion.short),
                          child: KeyedSubtree(
                            key: ValueKey(seats.length),
                            child: Text(
                              'seats.count'.tr(context: context, namedArgs: {'count': '${seats.length}'}),
                              key: const Key('seats.count'),
                              style: textTheme.titleSmall,
                            ),
                          ),
                        ),
                        Text(
                          codes.isEmpty ? 'seats.noneSelected'.tr(context: context) : codes,
                          key: const Key('seats.summary'),
                          style: textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (state.hold != null && left != null)
                    Text(
                      'seats.expiresIn'.tr(context: context, namedArgs: {'time': _mmss(left)}),
                      key: const Key('seats.countdown'),
                      style: textTheme.bodySmall,
                    ),
                ],
              ),
              const SizedBox(height: Space.x1 + 4),
              PrimaryButton(
                key: const Key('seats.continue'),
                label: 'catalog.bookTicket'.tr(context: context),
                loading: state.holding,
                // The hold call is the server check: only seats it still grants go to checkout.
                onPressed: state.canContinue ? () => context.read<SeatMapBloc>().add(const HoldRequested()) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _mmss(int seconds) {
    final s = seconds < 0 ? 0 : seconds;
    return '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  }
}
