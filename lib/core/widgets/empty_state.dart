import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/tokens.dart';
import 'app_button.dart';

/// "Nothing here yet" with an optional way forward (sprint 15).
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.messageKey = 'common.empty', this.icon, this.actionLabel, this.onAction});

  final String messageKey;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    // Scrolls rather than clips at large text sizes or in a short space.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.x3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              ExcludeSemantics(child: Icon(icon, size: Space.x6, color: context.tokens.onSurfaceMuted)),
              const SizedBox(height: Space.x2),
            ],
            Text(messageKey.tr(context: context), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: Space.x2),
              AppButton.tonal(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
