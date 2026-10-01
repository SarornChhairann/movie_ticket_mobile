import 'package:flutter/material.dart';

/// Network poster with a neutral placeholder for missing or broken images.
class PosterImage extends StatelessWidget {
  const PosterImage({super.key, required this.url, this.width, this.height, this.fit = BoxFit.cover});

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.movie_outlined),
    );
    final u = url;
    if (u == null) {
      return placeholder;
    }
    return Image.network(
      u,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}
