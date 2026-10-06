import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import 'app_button.dart';

/// Full-screen error with the server's message and one recovery action
/// (sprint 15): no dead ends.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry, this.actionLabel});

  final String message;
  final VoidCallback? onRetry;

  /// Defaults to `common.retry`.
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Scrolls rather than clips at large text sizes or in a short space.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.x3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child: Icon(Icons.error_outline, size: Space.x6, color: theme.colorScheme.error)),
            const SizedBox(height: Space.x2),
            Text('common.error'.tr(context: context), style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            if (message.isNotEmpty) ...[
              const SizedBox(height: Space.x1),
              Text(message, textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: Space.x2),
              AppButton.primary(
                label: actionLabel ?? 'common.retry'.tr(context: context),
                onPressed: onRetry,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
