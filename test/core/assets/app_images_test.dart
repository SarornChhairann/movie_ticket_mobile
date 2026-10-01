import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/assets/app_images.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final path in AppImages.all) {
    test('$path is bundled with 2.0x/3.0x variants and decodes at the right scale', () async {
      final dir = path.substring(0, path.lastIndexOf('/'));
      final name = path.substring(path.lastIndexOf('/') + 1);

      final base = await _size(path);
      for (final (scale, variant) in [(2, '$dir/2.0x/$name'), (3, '$dir/3.0x/$name')]) {
        final size = await _size(variant);
        expect(size.width, base.width * scale, reason: variant);
        expect(size.height, base.height * scale, reason: variant);
      }
    });
  }
}

/// Loads [path] from the asset bundle (fails if pubspec does not declare it).
Future<ui.Size> _size(String path) async {
  final data = await rootBundle.load(path);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  final size = ui.Size(frame.image.width.toDouble(), frame.image.height.toDouble());
  frame.image.dispose();
  return size;
}
