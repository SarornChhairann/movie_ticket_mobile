import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/assets/app_images.dart';
import 'package:movie_ticket_mobile/features/catalog/view/poster_image.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pump(WidgetTester tester, Widget image) => tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: SizedBox(width: 200, height: 300, child: image)),
        ),
      );

  /// The asset name shown by the placeholder, or null if none is showing.
  String? placeholderAsset(WidgetTester tester) {
    final finder = find.byKey(const Key('poster.placeholder'));
    if (finder.evaluate().isEmpty) return null;
    return (tester.widget<Image>(finder).image as AssetImage).assetName;
  }

  testWidgets('no URL shows the poster placeholder', (tester) async {
    await pump(tester, const PosterImage(url: null));

    expect(placeholderAsset(tester), AppImages.posterPlaceholder);
    expect(find.byType(Image), findsOneWidget, reason: 'no network request');
  });

  testWidgets('a blank URL is treated as missing', (tester) async {
    await pump(tester, const PosterImage(url: '  '));

    expect(placeholderAsset(tester), AppImages.posterPlaceholder);
  });

  testWidgets('banners use the wide placeholder', (tester) async {
    await pump(tester, const PosterImage(url: null, placeholder: AppImages.bannerPlaceholder));

    expect(placeholderAsset(tester), AppImages.bannerPlaceholder);
  });

  testWidgets('while downloading the placeholder shows under the hidden image', (tester) async {
    await pump(tester, const PosterImage(url: 'https://example.com/poster.jpg'));

    expect(placeholderAsset(tester), AppImages.posterPlaceholder);
    final fade = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(fade.opacity, 0);
  });

  testWidgets('a failed download falls back to the placeholder', (tester) async {
    // flutter_test answers every HTTP request with 400, so this load fails.
    await pump(tester, const PosterImage(url: 'https://example.com/missing.jpg'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();

    expect(placeholderAsset(tester), AppImages.posterPlaceholder);
    expect(find.byType(AnimatedOpacity), findsNothing, reason: 'error state replaces the loading stack');
  });
}
