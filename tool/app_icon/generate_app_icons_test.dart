// Generates every launcher icon from the brand TicketEmblem painter.
//
//   flutter test tool/app_icon/generate_app_icons_test.dart
//
// Runs as a widget test so it can use Flutter's renderer; it writes PNGs into the
// platform folders (Android, iOS, macOS, web). Each size is rendered directly,
// not downscaled, so small icons stay sharp. Re-run after changing the emblem.
import 'package:flutter_test/flutter_test.dart';

import 'brand_art.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final written = <String>[];

  Future<void> render(
    WidgetTester tester,
    String path,
    int px, {
    required IconLayer layer,
    required double emblemScale,
    double cornerRadius = 0,
    double inset = 0,
    bool alpha = true,
  }) async {
    await renderPng(
      tester,
      path,
      // Below 64 px the stub details blur: use the simplified ticket.
      IconArt(
        layer: layer,
        emblemScale: emblemScale,
        cornerRadius: cornerRadius,
        inset: inset,
        simple: px * (1 - inset * 2) <= 64,
      ),
      width: px,
      height: px,
      alpha: alpha,
    );
    written.add('$path ($px px)');
  }

  testWidgets('generate app icons', (tester) async {
    addTearDown(tester.view.reset);

    // ---- Android: adaptive icon layers (108dp canvas; content inside the 66dp
    // safe circle so any launcher mask keeps the whole ticket) + legacy icons.
    const res = 'android/app/src/main/res';
    const densities = {'mdpi': 1.0, 'hdpi': 1.5, 'xhdpi': 2.0, 'xxhdpi': 3.0, 'xxxhdpi': 4.0};
    for (final MapEntry(key: d, value: f) in densities.entries) {
      final adaptive = (108 * f).round();
      await render(tester, '$res/mipmap-$d/ic_launcher_background.png', adaptive,
          layer: IconLayer.background, emblemScale: 0);
      await render(tester, '$res/mipmap-$d/ic_launcher_foreground.png', adaptive,
          layer: IconLayer.foreground, emblemScale: 0.5);
      await render(tester, '$res/mipmap-$d/ic_launcher_monochrome.png', adaptive,
          layer: IconLayer.monochrome, emblemScale: 0.5);
      // Before Android 8: a rounded square drawn by us.
      await render(tester, '$res/mipmap-$d/ic_launcher.png', (48 * f).round(),
          layer: IconLayer.full, emblemScale: 0.66, cornerRadius: 0.22, inset: 1 / 24);
    }

    // ---- iOS: full bleed (the system applies the mask), no alpha channel.
    const ios = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
    final iosSizes = <String, int>{
      'Icon-App-20x20@1x.png': 20, 'Icon-App-20x20@2x.png': 40, 'Icon-App-20x20@3x.png': 60,
      'Icon-App-29x29@1x.png': 29, 'Icon-App-29x29@2x.png': 58, 'Icon-App-29x29@3x.png': 87,
      'Icon-App-40x40@1x.png': 40, 'Icon-App-40x40@2x.png': 80, 'Icon-App-40x40@3x.png': 120,
      'Icon-App-60x60@2x.png': 120, 'Icon-App-60x60@3x.png': 180,
      'Icon-App-76x76@1x.png': 76, 'Icon-App-76x76@2x.png': 152,
      'Icon-App-83.5x83.5@2x.png': 167, 'Icon-App-1024x1024@1x.png': 1024,
    };
    for (final MapEntry(key: name, value: px) in iosSizes.entries) {
      await render(tester, '$ios/$name', px, layer: IconLayer.full, emblemScale: 0.62, alpha: false);
    }

    // ---- macOS: rounded square with a margin, as macOS expects.
    const mac = 'macos/Runner/Assets.xcassets/AppIcon.appiconset';
    for (final px in [16, 32, 64, 128, 256, 512, 1024]) {
      await render(tester, '$mac/app_icon_$px.png', px,
          layer: IconLayer.full, emblemScale: 0.62, cornerRadius: 0.225, inset: 0.1);
    }

    // ---- Web: plain icons rounded; maskable full bleed with the ticket in the
    // 80% safe zone; favicon.
    await render(tester, 'web/icons/Icon-192.png', 192, layer: IconLayer.full, emblemScale: 0.64, cornerRadius: 0.22);
    await render(tester, 'web/icons/Icon-512.png', 512, layer: IconLayer.full, emblemScale: 0.64, cornerRadius: 0.22);
    await render(tester, 'web/icons/Icon-maskable-192.png', 192, layer: IconLayer.full, emblemScale: 0.5);
    await render(tester, 'web/icons/Icon-maskable-512.png', 512, layer: IconLayer.full, emblemScale: 0.5);
    await render(tester, 'web/favicon.png', 32, layer: IconLayer.full, emblemScale: 0.72, cornerRadius: 0.2);

    // ignore: avoid_print
    print('Wrote ${written.length} icons:\n  ${written.join('\n  ')}');
  });
}
