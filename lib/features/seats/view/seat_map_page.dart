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
import '../../../core/widgets/hold_banner.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../controller/seat_map_bloc.dart';
import '../model/couple_pairing.dart';
import '../model/seat_map.dart';
import '../model/seat_map_args.dart';
import 'party_size_sheet.dart';

/// The seat map shows the extend banner for the hold's last minute.
const holdWarningSeconds = 60;

class SeatMapPage extends StatelessWidget {
  const SeatMapPage({super.key, this.args});

  /// The detail screen's showtime choice; null when opened with a bare id.
  final SeatMapArgs? args;

  /// Party size choices when the server sent no cap.
  static const fallbackMaxSeats = 8;

  static int _maxChoice(SeatMapReady s) => s.data.maxSeats > 0 ? s.data.maxSeats : fallbackMaxSeats;

  /// Opens "How many seats?" and applies the answer; null (Skip) keeps the server cap.
  static Future<int?> askPartySize(BuildContext context, SeatMapReady s) async {
    final bloc = context.read<SeatMapBloc>();
    final size = await PartySizeSheet.show(context, max: _maxChoice(s), selected: s.partySize);
    bloc.add(PartySizeChosen(size ?? s.partySize));
    return size ?? s.partySize;
  }

  @override
  Widget build(BuildContext context) {
    // Asked once per visit, when the first map arrives and nothing is held yet.
    return BlocListener<SeatMapBloc, SeatMapState>(
      listenWhen: (previous, current) =>
          previous is! SeatMapReady && current is SeatMapReady && !current.partyAsked && current.hold == null,
      listener: (context, state) => askPartySize(context, state as SeatMapReady),
      child: _consumer(context),
    );
  }

  Widget _consumer(BuildContext context) {
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
          case SeatMapEffect.limit:
            final message = s.message;
            messenger.showSnackBar(
              SnackBar(
                content: Text(message == null || message.isEmpty
                    ? 'seats.limit'.tr(context: context, namedArgs: {'max': '${s.seatCap ?? s.data.maxSeats}'})
                    : message),
              ),
            );
          case SeatMapEffect.noBlock:
            messenger.showSnackBar(SnackBar(content: Text('seats.noBlock'.tr(context: context))));
          case SeatMapEffect.extended:
            messenger.showSnackBar(SnackBar(content: Text('seats.extendDone'.tr(context: context))));
          case SeatMapEffect.conflict:
            final message = s.message;
            messenger.showSnackBar(
              SnackBar(
                content: Text(message == null || message.isEmpty ? 'seats.conflict'.tr(context: context) : message),
              ),
            );
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text('seats.title'.tr(context: context))),
        body: switch (state) {
          SeatMapInitial() || SeatMapLoading() => const LoadingView(),
          SeatMapReady() => Column(
              children: [
                // The last minute of the hold: offer the one extend.
                if (state.hold != null && (state.secondsLeft ?? 0) > 0 && state.secondsLeft! <= holdWarningSeconds)
                  HoldBanner(
                    secondsLeft: state.secondsLeft!,
                    extending: state.extending,
                    onExtend: state.canExtend ? () => context.read<SeatMapBloc>().add(const HoldExtendRequested()) : null,
                  ),
                Expanded(child: _ReadyBody(state: state, args: args)),
              ],
            ),
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
    final coupleByCode = {
      for (final s in data.seats)
        if (s.couple) s.code: s,
    };
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
                  child: _GlowPulse(
                    active: state.selected.isNotEmpty,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final r in sortedRows)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final seat in rows[r]!)
                                _SeatTile(
                                  seat: seat,
                                  partner: seat.couple ? coupleByCode[CouplePairing.partnerCode(seat.code)] : null,
                                  state: state,
                                ),
                            ],
                          ),
                      ],
                    ),
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

/// One shared breath for every selected seat's glow, so all halos (and both
/// halves of a couple pair) rise and fall together. Runs only while something
/// is selected; under reduced motion it rests at full strength and never loops.
class _GlowPulse extends StatefulWidget {
  const _GlowPulse({required this.active, required this.child});

  /// Half of one breath (in, then out).
  static const period = Duration(milliseconds: 1400);

  final bool active;
  final Widget child;

  /// The pulse (0 dim … 1 full) under [context], or null outside a seat map.
  static Animation<double>? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PulseScope>()?.pulse;

  @override
  State<_GlowPulse> createState() => _GlowPulseState();
}

class _GlowPulseState extends State<_GlowPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: _GlowPulse.period, value: 1);
  late final Animation<double> _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_GlowPulse old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (widget.active && !context.reduceMotion) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else if (_controller.isAnimating || _controller.value != 1) {
      _controller
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _PulseScope(pulse: _pulse, child: widget.child);
}

class _PulseScope extends InheritedWidget {
  const _PulseScope({required this.pulse, required super.child});

  final Animation<double> pulse;

  @override
  bool updateShouldNotify(_PulseScope old) => old.pulse != pulse;
}

/// Which part of a chair a seat draws: a single armchair, or one half of a
/// couple loveseat (the odd seat is the left half, its `odd+1` partner the right).
enum _ChairShape {
  single,
  coupleLeft,
  coupleRight;

  static _ChairShape of(SeatView seat) => !seat.couple
      ? single
      : seat.number.isOdd
      ? coupleLeft
      : coupleRight;
}

class _SeatBox extends StatelessWidget {
  const _SeatBox({
    required this.fill,
    required this.border,
    required this.accent,
    required this.width,
    this.shape = _ChairShape.single,
    this.glow = false,
    this.child,
  });

  static const height = 30.0;
  static const _gap = 3.0;

  final Color? fill;
  final Color? border;
  final Color accent;
  final double width;
  final _ChairShape shape;

  /// A soft halo in the fill color behind the chair (any chosen seat).
  final bool glow;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // Couple halves sit flush so the pair reads as one loveseat.
    return Padding(
      padding: switch (shape) {
        _ChairShape.single => const EdgeInsets.all(_gap),
        _ChairShape.coupleLeft => const EdgeInsets.fromLTRB(_gap, _gap, 0, _gap),
        _ChairShape.coupleRight => const EdgeInsets.fromLTRB(0, _gap, _gap, _gap),
      },
      child: SizedBox(
        width: width,
        height: height,
        child: _AnimatedChair(
          duration: context.motion(Motion.short),
          fill: fill,
          border: border,
          accent: accent,
          shape: shape,
          glow: glow ? 1 : 0,
          // The code sits on the backrest, above the cushion.
          child: child == null ? null : Align(alignment: const Alignment(0, -0.5), child: child),
        ),
      ),
    );
  }
}

/// Fill, outline and accent animate between states instead of snapping.
class _AnimatedChair extends ImplicitlyAnimatedWidget {
  const _AnimatedChair({
    required super.duration,
    required this.fill,
    required this.border,
    required this.accent,
    required this.shape,
    required this.glow,
    this.child,
  }) : super(curve: Motion.decelerate);

  final Color? fill;
  final Color? border;
  final Color accent;
  final _ChairShape shape;
  final double glow;
  final Widget? child;

  @override
  AnimatedWidgetBaseState<_AnimatedChair> createState() => _AnimatedChairState();
}

class _AnimatedChairState extends AnimatedWidgetBaseState<_AnimatedChair> {
  ColorTween? _fill;
  ColorTween? _border;
  ColorTween? _accent;
  Tween<double>? _glow;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _fill = visitor(_fill, widget.fill, (v) => ColorTween(begin: v as Color?)) as ColorTween?;
    _border = visitor(_border, widget.border, (v) => ColorTween(begin: v as Color?)) as ColorTween?;
    _accent = visitor(_accent, widget.accent, (v) => ColorTween(begin: v as Color?)) as ColorTween?;
    _glow = visitor(_glow, widget.glow, (v) => Tween<double>(begin: v as double)) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final glow = _glow?.evaluate(animation) ?? widget.glow;
    return CustomPaint(
      painter: _ChairPainter(
        // Only glowing seats follow the pulse, so the rest never repaint with it.
        pulse: glow > 0 ? _GlowPulse.of(context) : null,
        fill: _fill?.evaluate(animation),
        border: _border?.evaluate(animation),
        accent: _accent?.evaluate(animation) ?? widget.accent,
        shape: widget.shape,
        glow: glow,
      ),
      child: widget.child,
    );
  }
}

/// A cinema chair seen from the front: backrest, cushion and armrests. A couple
/// half drops its inner armrest and runs its backrest and cushion past the edge
/// (clipped), so two halves join into one sofa with a heart on the seam.
class _ChairPainter extends CustomPainter {
  _ChairPainter({
    required this.fill,
    required this.border,
    required this.accent,
    required this.shape,
    required this.glow,
    this.pulse,
  }) : super(repaint: pulse);

  final Color? fill;
  final Color? border;
  final Color accent;
  final _ChairShape shape;

  /// 0..1 strength of the halo.
  final double glow;

  /// The shared breath (0 dim … 1 full); repaints the halo without a rebuild.
  final Animation<double>? pulse;

  static const _arm = 5.0;
  static const _bleed = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final leftArm = shape != _ChairShape.coupleRight;
    final rightArm = shape != _ChairShape.coupleLeft;
    if (glow > 0) _paintGlow(canvas, size, leftArm: leftArm, rightArm: rightArm);
    canvas.clipRect(Offset.zero & size);

    // Opaque base so overlapping parts hide each other's outlines.
    final base = Color.alphaBlend(fill ?? (border ?? AppColors.white).withValues(alpha: 0.06), AppColors.navy);
    final backColor = base;
    final cushionColor = Color.lerp(base, AppColors.white, 0.14)!;
    final armColor = Color.lerp(base, Colors.black, 0.2)!;

    final outline = border;
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = outline == null ? 0.8 : 1.2
      ..color = outline ?? Colors.black.withValues(alpha: 0.22);

    void part(RRect r, Color color) {
      canvas
        ..drawRRect(r, Paint()..color = color)
        ..drawRRect(r, edge);
    }

    const outer = Radius.circular(8);
    const soft = Radius.circular(4);

    // Backrest.
    final backL = leftArm ? _arm * 0.7 : -_bleed;
    final backR = rightArm ? w - _arm * 0.7 : w + _bleed;
    part(
      RRect.fromLTRBAndCorners(
        backL,
        0.6,
        backR,
        h * 0.7,
        topLeft: leftArm ? outer : Radius.zero,
        topRight: rightArm ? outer : Radius.zero,
        bottomLeft: const Radius.circular(2),
        bottomRight: const Radius.circular(2),
      ),
      backColor,
    );

    // Gloss along the top of the backrest.
    canvas.drawLine(
      Offset(backL + (leftArm ? 5 : 0), 3.2),
      Offset(backR - (rightArm ? 5 : 0), 3.2),
      Paint()
        ..color = AppColors.white.withValues(alpha: 0.22)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );

    // Seat cushion.
    part(
      RRect.fromLTRBAndCorners(
        leftArm ? _arm - 1 : -_bleed,
        h * 0.58,
        rightArm ? w - _arm + 1 : w + _bleed,
        h - 1.5,
        topLeft: soft,
        topRight: soft,
        bottomLeft: leftArm ? soft : Radius.zero,
        bottomRight: rightArm ? soft : Radius.zero,
      ),
      cushionColor,
    );

    // Armrests.
    const armRadius = Radius.circular(3);
    if (leftArm) part(RRect.fromLTRBR(0.6, h * 0.38, _arm + 0.6, h - 0.6, armRadius), armColor);
    if (rightArm) part(RRect.fromLTRBR(w - _arm - 0.6, h * 0.38, w - 0.6, h - 0.6, armRadius), armColor);

    // Each couple half paints its side of one heart on the seam.
    if (shape != _ChairShape.single) {
      canvas.drawPath(
        _heart(Offset(shape == _ChairShape.coupleLeft ? w : 0, h * 0.79), 7),
        Paint()..color = accent.withValues(alpha: 0.85),
      );
    }
  }

  /// The halo spills past the outer edges but stops at a couple seam, so one
  /// half's glow never tints its partner and the pair glows as one sofa.
  void _paintGlow(Canvas canvas, Size size, {required bool leftArm, required bool rightArm}) {
    const spread = 14.0;
    final w = size.width;
    final h = size.height;
    final breath = pulse?.value ?? 1;
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(leftArm ? -spread : 0, -spread, rightArm ? w + spread : w, h + spread))
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          leftArm ? 0 : -spread,
          0,
          rightArm ? w : w + spread,
          h,
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
          bottomLeft: const Radius.circular(4),
          bottomRight: const Radius.circular(4),
        ),
        Paint()
          ..color = (fill ?? accent).withValues(alpha: glow * (0.45 + 0.35 * breath))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.5 + 2 * breath),
      )
      ..restore();
  }

  static Path _heart(Offset c, double s) => Path()
    ..moveTo(c.dx, c.dy + s * 0.4)
    ..cubicTo(c.dx - s * 0.65, c.dy - s * 0.05, c.dx - s * 0.35, c.dy - s * 0.6, c.dx, c.dy - s * 0.2)
    ..cubicTo(c.dx + s * 0.35, c.dy - s * 0.6, c.dx + s * 0.65, c.dy - s * 0.05, c.dx, c.dy + s * 0.4)
    ..close();

  @override
  bool shouldRepaint(_ChairPainter old) =>
      old.fill != fill ||
      old.border != border ||
      old.accent != accent ||
      old.shape != shape ||
      old.glow != glow ||
      old.pulse != pulse;
}

class _SeatTile extends StatelessWidget {
  const _SeatTile({required this.seat, required this.partner, required this.state});

  static const normalWidth = 30.0;
  static const coupleWidth = 40.0;

  final SeatView seat;

  /// The other half of a couple pair; null for a normal seat.
  final SeatView? partner;
  final SeatMapReady state;

  /// A couple pair sells only whole, so a half-taken pair shows the taken
  /// half's state on both halves (booked wins over held).
  SeatUiState _displayState() {
    final own = state.seatState(seat);
    final other = partner;
    if (other == null) return own;
    final theirs = state.seatState(other);
    for (final blocking in const [SeatUiState.booked, SeatUiState.heldByOthers]) {
      if (own == blocking || theirs == blocking) return blocking;
    }
    return own;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SeatColors>()!;
    final ui = _displayState();
    final look = _seatLook(colors, ui);
    final tile = _SeatBox(
      fill: look.fill,
      border: look.border,
      accent: look.text,
      width: seat.couple ? coupleWidth : normalWidth,
      shape: _ChairShape.of(seat),
      glow: ui == SeatUiState.selected || ui == SeatUiState.heldByMe,
      child: Text(
        seat.code,
        style: TextStyle(fontSize: 9, color: look.text, fontWeight: FontWeight.w500),
      ),
    );
    final animated = _SeatFeedback(ui: ui, child: tile);
    // A half-taken couple pair is not tappable either: it can't be sold whole.
    if (!state.isTappable(seat) || ui == SeatUiState.booked || ui == SeatUiState.heldByOthers) {
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (couple) ...[
                  for (final shape in const [_ChairShape.coupleLeft, _ChairShape.coupleRight])
                    _SeatBox(
                      fill: look.fill,
                      border: look.border,
                      accent: look.text,
                      width: _SeatTile.coupleWidth,
                      shape: shape,
                    ),
                ] else
                  _SeatBox(fill: look.fill, border: look.border, accent: look.text, width: _SeatTile.normalWidth),
              ],
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
              const SizedBox(height: Space.x1),
              Row(
                children: [
                  // Both shrink on a narrow phone or in Khmer rather than overflow.
                  Flexible(
                    child: OutlinedButton.icon(
                      key: const Key('seats.party'),
                      icon: const Icon(Icons.group_outlined),
                      label: Text(
                        state.partySize == null
                            ? 'seats.partySize'.tr(context: context)
                            : 'seats.partyCount'.tr(context: context, namedArgs: {'count': '${state.partySize}'}),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: state.holding ? null : () => SeatMapPage.askPartySize(context, state),
                    ),
                  ),
                  const SizedBox(width: Space.x1),
                  Flexible(
                    child: TextButton.icon(
                      key: const Key('seats.best'),
                      icon: const Icon(Icons.auto_awesome),
                      label: Text('seats.best'.tr(context: context), overflow: TextOverflow.ellipsis),
                      onPressed: state.holding
                          ? null
                          : () async {
                              final bloc = context.read<SeatMapBloc>();
                              final size = state.partySize ?? await SeatMapPage.askPartySize(context, state);
                              if (size != null) bloc.add(const BestSeatsRequested());
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.x1),
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
