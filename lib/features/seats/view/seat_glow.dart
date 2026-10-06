part of 'seat_map_page.dart';

/// One shared breath for every selected seat's glow, so all halos (and both
/// halves of a couple pair) rise and fall together. Runs only while something
/// is selected; under reduced motion it rests at full strength and never loops.
class _GlowPulse extends StatefulWidget {
  const _GlowPulse({required this.active, required this.child});

  /// Half of one breath (in, then out).
  static const period = Motion.seatGlow;

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
