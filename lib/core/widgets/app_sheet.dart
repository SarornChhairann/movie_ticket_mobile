import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// The app's bottom sheet (sprint 15): drag handle, sheet radius, safe area, and
/// it rides up with the keyboard. [snapSizes] makes it a draggable sheet that
/// rests at those heights (fractions of the screen).
abstract final class AppSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    List<double>? snapSizes,
    bool dismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: dismissible,
      enableDrag: dismissible,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet))),
      builder: (context) {
        final keyboard = MediaQuery.viewInsetsOf(context).bottom;
        final sizes = snapSizes;
        if (sizes == null || sizes.isEmpty) {
          return Padding(padding: EdgeInsets.only(bottom: keyboard), child: builder(context));
        }
        return Padding(
          padding: EdgeInsets.only(bottom: keyboard),
          child: DraggableScrollableSheet(
            expand: false,
            snap: true,
            initialChildSize: sizes.first,
            minChildSize: sizes.first,
            maxChildSize: sizes.last,
            snapSizes: sizes.length > 2 ? sizes.sublist(1, sizes.length - 1) : null,
            builder: (context, controller) => PrimaryScrollController(controller: controller, child: builder(context)),
          ),
        );
      },
    );
  }
}
