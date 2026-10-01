import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The brand mark: a ticket stub with side notches, a perforation, and a play glyph.
///
/// [draw] traces the outline (0 → 1); [fill] then floods it blue and brings in the
/// perforation and glyph. Both default to 1 for a static mark.
class TicketEmblem extends StatelessWidget {
  const TicketEmblem({
    super.key,
    this.width = 40,
    this.draw = 1,
    this.fill = 1,
    this.color = AppColors.blue,
    this.inkColor = AppColors.navy,
    this.knockout = false,
    this.shadow = false,
    this.simple = false,
  });

  /// Height is 62% of [width].
  final double width;
  final double draw;
  final double fill;

  /// Ticket colour, and the colour of the perforation, glyph, and print lines.
  final Color color;
  final Color inkColor;

  /// Cut the perforation, glyph, and lines out instead of painting them (single-
  /// colour artwork such as Android themed icons).
  final bool knockout;

  /// A soft drop shadow under the ticket (app icon).
  final bool shadow;

  /// Small-size variant: no perforation or print lines, and a larger play glyph
  /// centred on the ticket, so it stays legible at 16–64 px.
  final bool simple;

  static const aspect = 0.62;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * aspect),
      painter: _TicketPainter(
        draw: draw.clamp(0, 1),
        fill: fill.clamp(0, 1),
        color: color,
        inkColor: inkColor,
        knockout: knockout,
        shadow: shadow,
        simple: simple,
      ),
    );
  }
}

class _TicketPainter extends CustomPainter {
  _TicketPainter({
    required this.draw,
    required this.fill,
    required this.color,
    required this.inkColor,
    required this.knockout,
    required this.shadow,
    required this.simple,
  });

  final double draw;
  final double fill;
  final Color color;
  final Color inkColor;
  final bool knockout;
  final bool shadow;
  final bool simple;

  /// Where the perforation sits, as a fraction of the width.
  static const _stub = 0.70;

  Path _outline(Size s) {
    final r = s.height * 0.16;
    final notch = s.height * 0.17;
    final body = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & s, Radius.circular(r)));
    final notches = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, s.height / 2), radius: notch))
      ..addOval(Rect.fromCircle(center: Offset(s.width, s.height / 2), radius: notch))
      // Small half-notches top and bottom of the perforation, like a real stub.
      ..addOval(Rect.fromCircle(center: Offset(s.width * _stub, 0), radius: notch * 0.55))
      ..addOval(Rect.fromCircle(center: Offset(s.width * _stub, s.height), radius: notch * 0.55));
    return Path.combine(PathOperation.difference, body, notches);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final outline = _outline(size);
    final stroke = math.max(1.5, size.width * 0.035);

    if (shadow && fill > 0) {
      canvas.drawPath(
        outline.shift(Offset(0, size.height * 0.08)),
        Paint()
          ..color = const Color(0xFF000000).withValues(alpha: 0.35 * fill)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.height * 0.08),
      );
    }
    // A layer so knocked-out details can clear the ticket underneath.
    canvas.saveLayer((Offset.zero & size).inflate(stroke), Paint());
    if (fill > 0) {
      canvas.drawPath(outline, Paint()..color = color.withValues(alpha: color.a * fill));
    }

    // Outline traced progressively.
    if (draw > 0 && fill < 1) {
      final traced = Path();
      for (final metric in outline.computeMetrics()) {
        traced.addPath(metric.extractPath(0, metric.length * draw), Offset.zero);
      }
      canvas.drawPath(
        traced,
        Paint()
          ..color = color.withValues(alpha: 1 - fill * 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    if (fill <= 0) {
      canvas.restore();
      return;
    }
    Paint inkPaint(double alpha) => knockout
        ? (Paint()..blendMode = BlendMode.clear)
        : (Paint()..color = inkColor.withValues(alpha: alpha * fill));
    final ink = inkPaint(1);

    // Perforation: dashes down the stub line.
    final x = size.width * _stub;
    final dash = size.height * 0.085;
    final top = size.height * 0.2;
    final bottom = size.height * 0.8;
    final dashPaint = inkPaint(0.55)
      ..strokeWidth = math.max(1, stroke * 0.7)
      ..strokeCap = StrokeCap.round;
    for (var y = top; !simple && y < bottom; y += dash * 2) {
      canvas.drawLine(Offset(x, y), Offset(x, math.min(y + dash, bottom)), dashPaint);
    }

    // Play glyph centred in the main part, with a slight pop as it fills in.
    final c = simple ? Offset(size.width / 2, size.height / 2) : Offset(size.width * _stub / 2, size.height / 2);
    final g = size.height * (simple ? 0.27 : 0.2) * ui.lerpDouble(0.6, 1, Curves.easeOutBack.transform(fill))!;
    final play = Path()
      ..moveTo(c.dx - g * 0.75, c.dy - g)
      ..lineTo(c.dx + g, c.dy)
      ..lineTo(c.dx - g * 0.75, c.dy + g)
      ..close();
    canvas.drawPath(play, ink);

    // Three short lines on the stub, like a seat/row print.
    final linePaint = inkPaint(0.55)
      ..strokeWidth = math.max(1, stroke * 0.7)
      ..strokeCap = StrokeCap.round;
    final sx0 = x + size.width * 0.07;
    // Stop short of the right-hand notch.
    final sx1 = size.width - size.height * 0.17 - size.width * 0.05;
    for (final f in simple ? const <double>[] : const [0.36, 0.5, 0.64]) {
      final y = size.height * f;
      canvas.drawLine(Offset(sx0, y), Offset(f == 0.5 ? sx1 : (sx0 + sx1) / 2 + size.width * 0.02, y), linePaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TicketPainter old) =>
      old.draw != draw ||
      old.fill != fill ||
      old.color != color ||
      old.inkColor != inkColor ||
      old.knockout != knockout ||
      old.shadow != shadow ||
      old.simple != simple;
}
