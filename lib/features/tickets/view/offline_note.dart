import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';

/// "Offline copy": the screen shows what was saved on the device.
class OfflineNote extends StatelessWidget {
  const OfflineNote({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      key: const Key('tickets.offline'),
      width: double.infinity,
      color: scheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.x1),
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: Space.x2, color: scheme.onSurfaceVariant),
          const SizedBox(width: Space.x1),
          Expanded(
            child: Text(
              'tickets.offline'.tr(context: context),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
