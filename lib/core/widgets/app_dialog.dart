import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import 'app_button.dart';

/// Confirm dialogs (sprint 15). The safe choice is first and is what the
/// back button means; a destructive confirm is styled as such. Pops true only
/// when the user confirms. Focus returns to the trigger when it closes.
abstract final class AppDialog {
  static Future<bool> confirm(
    BuildContext context, {
    Key? key,
    String? title,
    required String body,
    required String confirmLabel,
    required String cancelLabel,
    bool destructive = false,
    Key? confirmKey,
    Key? cancelKey,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: key,
        title: title == null ? null : Text(title),
        content: Text(body),
        actionsPadding: const EdgeInsets.fromLTRB(Space.x2, 0, Space.x2, Space.x2),
        actions: [
          AppButton.ghost(
            key: cancelKey,
            label: cancelLabel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          destructive
              ? AppButton.destructive(
                  key: confirmKey,
                  label: confirmLabel,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                )
              : AppButton.primary(
                  key: confirmKey,
                  label: confirmLabel,
                  expand: false,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
        ],
      ),
    );
    return result ?? false;
  }
}
