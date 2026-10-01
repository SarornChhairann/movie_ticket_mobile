// Generates the brand images under assets/ from the same artwork as the app icon.
//
//   flutter test tool/app_icon/generate_brand_images_test.dart
//
// In-app images (assets/images/...) get 1x, 2.0x/, and 3.0x/ variants so
// Image.asset picks the sharp one per device; their paths are in AppImages.
// Store artwork (assets/store/) is not bundled into the app.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/theme/app_colors.dart';
import 'package:movie_ticket_mobile/core/widgets/ticket_emblem.dart';

import 'brand_art.dart';

/// Art drawn at a logical size and scaled (as vectors) to the output size.
Widget _scaled(double width, double height, Widget art) =>
    FittedBox(child: SizedBox(width: width, height: height, child: art));

/// The ticket, tilted like the app icon, with its shadow.
Widget _tiltedTicket(double width) => Transform.rotate(
      angle: brandTilt,
      child: TicketEmblem(width: width, shadow: true),
    );

Widget _wordmark({required double emblemWidth, required double fontSize}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TicketEmblem(width: emblemWidth),
        SizedBox(width: fontSize * 0.45),
        Text(
          'Movie Tickets',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: 0.3,
            height: 1,
          ),
        ),
      ],
    );

/// Missing-image placeholder: flat raised navy (the colour PosterImage already
/// uses) and a faint ticket. Flat on purpose: gradients are dithered, and the
/// noise would make these bundled files many times larger.
Widget _placeholder({required double ticketWidth}) => ColoredBox(
      color: AppColors.navyHigh,
      child: Center(
        child: TicketEmblem(
          width: ticketWidth,
          color: AppColors.mist.withValues(alpha: 0.14),
          knockout: true,
          simple: true,
        ),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final written = <String>[];

  setUpAll(loadBrandFonts);

  /// Writes [path] plus 2.0x/ and 3.0x/ variants for a [width]×[height] logical image.
  Future<void> variants(WidgetTester tester, String path, double width, double height, Widget art) async {
    final dir = path.substring(0, path.lastIndexOf('/'));
    final name = path.substring(path.lastIndexOf('/') + 1);
    for (final (scale, out) in [(1, path), (2, '$dir/2.0x/$name'), (3, '$dir/3.0x/$name')]) {
      final w = (width * scale).round();
      final h = (height * scale).round();
      await renderPng(tester, out, _scaled(width, height, art), width: w, height: h);
      written.add('$out ($w×$h)');
    }
  }

  testWidgets('generate brand images', (tester) async {
    addTearDown(tester.view.reset);
    const brand = 'assets/images/brand';
    const placeholders = 'assets/images/placeholders';

    // ---- Brand marks (transparent).
    await variants(tester, '$brand/logo.png', 160, 128, Center(child: _tiltedTicket(118)));
    await variants(tester, '$brand/logo_flat.png', 128, 80, const Center(child: TicketEmblem(width: 124)));
    await variants(
      tester,
      '$brand/logo_mono.png',
      128,
      80,
      const Center(child: TicketEmblem(width: 124, color: Colors.white, knockout: true)),
    );
    await variants(
      tester,
      '$brand/wordmark.png',
      360,
      64,
      Center(child: _wordmark(emblemWidth: 72, fontSize: 36)),
    );
    await variants(
      tester,
      '$brand/app_icon.png',
      192,
      192,
      const IconArt(layer: IconLayer.full, emblemScale: 0.64, cornerRadius: 0.22),
    );

    // ---- Placeholders for missing posters and banners (same 2:3 as PosterCard).
    await variants(tester, '$placeholders/poster.png', 200, 300, _placeholder(ticketWidth: 110));
    await variants(tester, '$placeholders/banner.png', 400, 225, _placeholder(ticketWidth: 120));

    // ---- Store artwork: not bundled into the app.
    const store = 'assets/store';
    // Google Play feature graphic: exactly 1024×500, no alpha.
    await renderPng(
      tester,
      '$store/play_feature_graphic.png',
      Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BrandBackgroundPainter()),
          Row(
            children: [
              const SizedBox(width: 96),
              Transform.rotate(angle: brandTilt * 1.2, child: const TicketEmblem(width: 300, shadow: true)),
              const SizedBox(width: 72),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Movie Tickets',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 60, fontWeight: FontWeight.w700, color: AppColors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your seat is waiting.',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 30, color: Color(0xCCF5F5F5)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      width: 1024,
      height: 500,
      alpha: false,
    );
    written.add('$store/play_feature_graphic.png (1024×500)');
    // Google Play hi-res icon (512×512; Play applies its own mask).
    await renderPng(tester, '$store/play_icon_512.png', const IconArt(layer: IconLayer.full, emblemScale: 0.62),
        width: 512, height: 512);
    written.add('$store/play_icon_512.png (512×512)');
    // App Store icon master (1024×1024, no alpha).
    await renderPng(tester, '$store/app_store_icon_1024.png', const IconArt(layer: IconLayer.full, emblemScale: 0.62),
        width: 1024, height: 1024, alpha: false);
    written.add('$store/app_store_icon_1024.png (1024×1024)');

    // ignore: avoid_print
    print('Wrote ${written.length} images:\n  ${written.join('\n  ')}');
    expect(math.max(written.length, 0), greaterThan(0));
  });
}
