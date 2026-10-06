import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/theme/tokens.dart';

/// One component's block in the gallery: name, spec note, examples.
class GallerySection extends StatelessWidget {
  const GallerySection({super.key, required this.title, required this.note, required this.child});

  final String title;
  final String note;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: Space.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleMedium),
          const SizedBox(height: Space.x0_5),
          Text(note, style: text.bodySmall),
          const SizedBox(height: Space.x1),
          child,
        ],
      ),
    );
  }
}

/// A colour token with its name.
class Swatch extends StatelessWidget {
  const Swatch({super.key, required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Space.x6,
          height: Space.x6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppTokens.radii.sm),
            border: Border.all(color: context.tokens.onSurfaceMuted),
          ),
        ),
        const SizedBox(height: Space.x0_5),
        Text(name, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
