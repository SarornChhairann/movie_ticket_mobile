// Brand artwork shared by the generators in this folder (app icons and the
// images under assets/images). Drawn with the app's own TicketEmblem so every
// output matches the splash and login screens.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/theme/app_colors.dart';
import 'package:movie_ticket_mobile/core/widgets/ticket_emblem.dart';

/// Which part of the icon to draw.
enum IconLayer {
  /// Navy plus spotlight, full bleed (adaptive background, maskable web).
  background,

  /// The ticket only, on transparent (adaptive foreground).
  foreground,

  /// White ticket silhouette with see-through details (Android 13 themed icon).
  monochrome,

  /// Background and ticket together, full bleed (iOS, which applies its own mask).
  full,
}

/// Brand tilt: reads as a ticket, not a generic rounded rectangle.
const brandTilt = -12 * math.pi / 180;

class IconArt extends StatelessWidget {
  const IconArt({
    super.key,
    required this.layer,
    required this.emblemScale,
    this.cornerRadius = 0,
    this.inset = 0,
    this.simple = false,
  });

  final IconLayer layer;

  /// Ticket width as a fraction of the drawn square.
  final double emblemScale;

  /// Rounded corners with transparent outside (legacy Android, web, macOS).
  final double cornerRadius;

  /// Transparent margin around the shape, as a fraction (macOS style).
  final double inset;

  /// Small sizes: simplified ticket, drawn larger.
  final bool simple;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final full = constraints.maxWidth;
      final side = full * (1 - inset * 2);
      final showBackground = layer == IconLayer.background || layer == IconLayer.full;
      final showTicket = layer != IconLayer.background;
      Widget art = SizedBox.square(
        dimension: side,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (showBackground) CustomPaint(painter: BrandBackgroundPainter()),
            if (showTicket)
              Center(
                child: Transform.rotate(
                  angle: brandTilt,
                  child: TicketEmblem(
                    width: side * emblemScale * (simple ? 1.12 : 1),
                    simple: simple,
                    color: layer == IconLayer.monochrome ? Colors.white : AppColors.blue,
                    knockout: layer == IconLayer.monochrome,
                    shadow: layer != IconLayer.monochrome,
                  ),
                ),
              ),
          ],
        ),
      );
      if (cornerRadius > 0) {
        art = ClipRRect(borderRadius: BorderRadius.circular(side * cornerRadius), child: art);
      }
      return Center(child: art);
    });
  }
}

/// Navy with the splash's spotlight: a soft beam from the top and a glow where
/// the ticket sits.
class BrandBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF22325A), AppColors.navy, Color(0xFF141C33)],
          stops: [0, 0.55, 1],
        ).createShader(rect),
    );
    final cx = size.width / 2;
    final beam = Path()
      ..moveTo(cx - size.width * 0.1, 0)
      ..lineTo(cx + size.width * 0.1, 0)
      ..lineTo(cx + size.width * 0.62, size.height)
      ..lineTo(cx - size.width * 0.62, size.height)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.blue.withValues(alpha: 0.30), AppColors.blue.withValues(alpha: 0)],
        ).createShader(rect),
    );
    final glowCenter = Offset(cx, size.height * 0.52);
    canvas.drawCircle(
      glowCenter,
      size.width * 0.48,
      Paint()
        ..shader = RadialGradient(
          colors: [AppColors.blue.withValues(alpha: 0.32), AppColors.blue.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: glowCenter, radius: size.width * 0.48)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Minimal PNG writer (8-bit RGB or RGBA). Flutter's own PNG output always has
/// alpha, and App Store icons must not. Each row uses the standard adaptive
/// filter choice (None/Sub/Up/Average/Paeth, smallest sum of absolute values),
/// which is what keeps smooth gradients small. Lossless.
Uint8List encodePng(Uint8List rgba, int width, int height, {required bool alpha}) {
  final bpp = alpha ? 4 : 3;
  final stride = width * bpp;
  // Pixels without the alpha channel when it is dropped.
  final pixels = Uint8List(stride * height);
  for (var i = 0, o = 0; i < rgba.length; i += 4) {
    for (var c = 0; c < bpp; c++) {
      pixels[o++] = rgba[i + c];
    }
  }

  int paeth(int a, int b, int c) {
    final p = a + b - c;
    final pa = (p - a).abs(), pb = (p - b).abs(), pc = (p - c).abs();
    if (pa <= pb && pa <= pc) return a;
    return pb <= pc ? b : c;
  }

  final raw = BytesBuilder();
  final candidate = Uint8List(stride);
  final best = Uint8List(stride);
  for (var y = 0; y < height; y++) {
    final row = y * stride;
    final prev = row - stride;
    var bestType = 0;
    var bestScore = -1;
    for (var type = 0; type < 5; type++) {
      var score = 0;
      for (var x = 0; x < stride; x++) {
        final cur = pixels[row + x];
        final a = x >= bpp ? pixels[row + x - bpp] : 0;
        final b = y > 0 ? pixels[prev + x] : 0;
        final c = (x >= bpp && y > 0) ? pixels[prev + x - bpp] : 0;
        final v = switch (type) {
              0 => cur,
              1 => cur - a,
              2 => cur - b,
              3 => cur - ((a + b) >> 1),
              _ => cur - paeth(a, b, c),
            } &
            0xff;
        candidate[x] = v;
        score += v < 128 ? v : 256 - v;
      }
      if (bestScore < 0 || score < bestScore) {
        bestScore = score;
        bestType = type;
        best.setAll(0, candidate);
      }
    }
    raw
      ..addByte(bestType)
      ..add(best);
  }

  final out = BytesBuilder()..add([137, 80, 78, 71, 13, 10, 26, 10]);
  void chunk(String type, List<int> data) {
    final typeBytes = type.codeUnits;
    out
      ..add(_u32(data.length))
      ..add(typeBytes)
      ..add(data)
      ..add(_u32(_crc32([...typeBytes, ...data])));
  }

  chunk('IHDR', [..._u32(width), ..._u32(height), 8, alpha ? 6 : 2, 0, 0, 0]);
  chunk('IDAT', ZLibCodec(level: 9).encode(raw.takeBytes()));
  chunk('IEND', const []);
  return out.takeBytes();
}

List<int> _u32(int v) => [(v >> 24) & 0xff, (v >> 16) & 0xff, (v >> 8) & 0xff, v & 0xff];

final List<int> _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = (c & 1) != 0 ? 0xedb88320 ^ (c >> 1) : c >> 1;
  }
  return c;
});

int _crc32(List<int> bytes) {
  var c = 0xffffffff;
  for (final b in bytes) {
    c = _crcTable[(c ^ b) & 0xff] ^ (c >> 8);
  }
  return c ^ 0xffffffff;
}


/// Renders [child] at exactly [width]×[height] physical pixels and writes a PNG.
/// [alpha] false drops the alpha channel (App Store icons).
Future<void> renderPng(
  WidgetTester tester,
  String path,
  Widget child, {
  required int width,
  required int height,
  bool alpha = true,
}) async {
  final key = GlobalKey();
  tester.view.physicalSize = Size(width.toDouble(), height.toDouble());
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: RepaintBoundary(
        key: key,
        child: SizedBox(width: width.toDouble(), height: height.toDouble(), child: child),
      ),
    ),
  ));
  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
    image.dispose();
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(encodePng(data!.buffer.asUint8List(), width, height, alpha: alpha));
  });
}

/// Loads the bundled Poppins so rendered text matches the app (tests otherwise
/// draw text with a placeholder font).
Future<void> loadBrandFonts() async {
  final loader = FontLoader('Poppins');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(Future.value(ByteData.sublistView(File('assets/fonts/Poppins-$w.ttf').readAsBytesSync())));
  }
  await loader.load();
}
