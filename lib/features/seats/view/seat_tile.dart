part of 'seat_map_page.dart';

class _SeatTile extends StatelessWidget {
  const _SeatTile({
    required this.seat,
    required this.partner,
    required this.state,
    this.revealIndex,
    this.highlighted = false,
  });

  static const normalWidth = SeatLayout.normalWidth;
  static const coupleWidth = SeatLayout.coupleWidth;

  final SeatView seat;

  /// The other half of a couple pair; null for a normal seat.
  final SeatView? partner;
  final SeatMapReady state;

  /// Position in Best seats' reveal (left to right); the seat lights up after
  /// `index × Motion.staggerStep`, at most 8 steps (sprint 17).
  final int? revealIndex;

  /// The legend's "Couple" was tapped: ring every couple seat for a moment.
  final bool highlighted;

  /// "Row F · Seat 7 · Couple" — no price (prices are the server's).
  String _tooltip(BuildContext context) {
    final code = SeatCode.tryParse(seat.code);
    final base = 'seats.tooltip'.tr(
      context: context,
      namedArgs: {'row': code?.row ?? '${seat.row}', 'seat': '${code?.number ?? seat.number}'},
    );
    return seat.couple ? '$base · ${'seats.legend.couple'.tr(context: context)}' : base;
  }

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
    final index = revealIndex;
    final ui = _displayState();
    if (index == null || context.reduceMotion || ui != SeatUiState.selected) return _build(context, ui);
    // Best seats: show the seat as it was until its turn in the stagger.
    return _StaggerGate(
      delay: Motion.staggerStep * math.min(index, 8),
      before: _build(context, SeatUiState.available),
      after: _build(context, ui),
    );
  }

  Widget _build(BuildContext context, SeatUiState ui) {
    final colors = Theme.of(context).extension<SeatColors>()!;
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
        style: AppText.seatCode.copyWith(color: look.text),
      ),
    );
    final ringed = AnimatedContainer(
      duration: context.motion(Motion.medium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTokens.radii.sm),
        border: Border.all(color: highlighted ? context.tokens.warning : Colors.transparent, width: 2),
      ),
      child: tile,
    );
    final animated = Tooltip(
      message: _tooltip(context),
      triggerMode: TooltipTriggerMode.longPress,
      child: _SeatFeedback(ui: ui, child: ringed),
    );
    // A half-taken couple pair is not tappable either: it can't be sold whole.
    // One clear label per seat ("A1, booked"), not the code twice plus the tooltip.
    final stateWord = switch (ui) {
      SeatUiState.available => 'seats.state.available',
      SeatUiState.selected || SeatUiState.heldByMe => 'seats.state.selected',
      SeatUiState.heldByOthers => 'seats.state.held',
      SeatUiState.booked => 'seats.state.booked',
    }.tr(context: context);
    final label = '${seat.code}, $stateWord';
    if (!state.isTappable(seat) || ui == SeatUiState.booked || ui == SeatUiState.heldByOthers) {
      return Semantics(label: label, enabled: false, excludeSemantics: true, child: animated);
    }
    return GestureDetector(
      key: Key('seat.${seat.id}'),
      onTap: () {
        AppHaptics.selection();
        context.read<SeatMapBloc>().add(SeatToggled(seat.id));
      },
      child: Semantics(
        button: true,
        label: label,
        selected: state.selected.contains(seat.id),
        excludeSemantics: true,
        child: animated,
      ),
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

/// Shows [before] for [delay], then [after] (one-shot; the Best seats stagger).
class _StaggerGate extends StatefulWidget {
  const _StaggerGate({required this.delay, required this.before, required this.after});

  final Duration delay;
  final Widget before;
  final Widget after;

  @override
  State<_StaggerGate> createState() => _StaggerGateState();
}

class _StaggerGateState extends State<_StaggerGate> {
  Timer? _timer;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _open = true;
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) setState(() => _open = true);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _open ? widget.after : widget.before;
}

