part of 'seat_map_page.dart';

/// The cinema screen: a curved line with a soft glow spilling toward the seats.
class _ScreenCurve extends StatelessWidget {
  const _ScreenCurve();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.x4, Space.x1, Space.x4, 0),
      child: ExcludeSemantics(
        child: CustomPaint(size: const Size(double.infinity, 32), painter: _ScreenPainter()),
      ),
    );
  }
}

class _ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final curve = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width / 2, 0, size.width, size.height * 0.75);
    // Light falling from the screen onto the first rows.
    final spill = Path.from(curve)
      ..lineTo(size.width * 0.9, size.height)
      ..lineTo(size.width * 0.1, size.height)
      ..close();
    canvas
      ..drawPath(
        spill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.blue.withValues(alpha: 0.18), AppColors.blue.withValues(alpha: 0)],
          ).createShader(Offset.zero & size),
      )
      ..drawPath(
        curve,
        Paint()
          ..color = AppColors.blue.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      )
      ..drawPath(
        curve,
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
