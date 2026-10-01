import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// Inline error strip shown above content that is still usable.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message, this.onDismiss});

  final String message;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.x1),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: scheme.onErrorContainer),
            const SizedBox(width: Space.x1),
            Expanded(
              child: Text(message, style: TextStyle(color: scheme.onErrorContainer)),
            ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close),
                color: scheme.onErrorContainer,
                onPressed: onDismiss,
              ),
          ],
        ),
      ),
    );
  }
}
