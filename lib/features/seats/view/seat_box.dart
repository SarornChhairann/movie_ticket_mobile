part of 'seat_map_page.dart';

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
