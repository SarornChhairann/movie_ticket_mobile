import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// Full-screen error with the server's message and a retry action.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.x3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: Space.x6, color: theme.colorScheme.error),
            const SizedBox(height: Space.x2),
            Text('common.error'.tr(context: context), style: theme.textTheme.titleMedium),
            if (message.isNotEmpty) ...[
              const SizedBox(height: Space.x1),
              Text(message, textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: Space.x2),
              FilledButton(onPressed: onRetry, child: Text('common.retry'.tr(context: context))),
            ],
          ],
        ),
      ),
    );
  }
}
