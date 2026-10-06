part of 'seat_map_page.dart';

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
