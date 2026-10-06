import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';

/// "Offline copy": the screen shows what was saved on the device.
class OfflineNote extends StatelessWidget {
  const OfflineNote({super.key, this.savedAt});

  /// When the copy was saved; shown as "Saved on this phone · updated 18:40".
  final DateTime? savedAt;

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
              savedAt == null
                  ? 'tickets.offline'.tr(context: context)
                  : 'ticket.savedOffline'.tr(
                      context: context,
                      namedArgs: {'time': DateFormat.Hm(context.locale.toString()).format(savedAt!)},
                    ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
