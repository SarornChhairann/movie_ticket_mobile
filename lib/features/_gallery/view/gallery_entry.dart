import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_list_tile.dart';

/// Debug builds only: the Account tab's way into the component gallery.
class GalleryEntry extends StatelessWidget {
  const GalleryEntry({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    return AppListTile(
      key: const Key('gallery.entry'),
      leading: const Icon(Icons.widgets_outlined),
      title: const Text('Component gallery (debug)'),
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.gallery),
    );
  }
}
