import 'package:flutter/material.dart';

import '../../../core/assets/app_images.dart';
import '../../../core/motion/motion.dart';

/// A movie image from the network, with a bundled brand placeholder whenever
/// there is nothing to show yet: no URL, still downloading, or a failed load.
/// The real image fades in over the placeholder once it arrives.
class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder = AppImages.posterPlaceholder,
    this.cacheWidth,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// Asset shown in place of the image: [AppImages.posterPlaceholder] (2:3) for
  /// posters, [AppImages.bannerPlaceholder] (16:9) for wide banners.
  final String placeholder;

  /// Decode the network image at this pixel width (display width × device pixel
  /// ratio) instead of full size: less memory, smoother scrolling.
  final int? cacheWidth;

  Widget _placeholder() => Image.asset(
        placeholder,
        key: const Key('poster.placeholder'),
        width: width,
        height: height,
        fit: fit,
        // Decorative: the movie title next to it names the movie.
        excludeFromSemantics: true,
      );

  @override
  Widget build(BuildContext context) {
    final u = url?.trim();
    if (u == null || u.isEmpty) return _placeholder();
    return Image.network(
      u,
      cacheWidth: cacheWidth,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child; // already cached: no flash
        return Stack(
          fit: StackFit.passthrough,
          children: [
            _placeholder(),
            AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: context.motion(Motion.medium),
              curve: Motion.decelerate,
              child: child,
            ),
          ],
        );
      },
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }
}
