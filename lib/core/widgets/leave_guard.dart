import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_dialog.dart';

/// Back (button, gesture, or predictive back) while seats are held asks
/// "Release 3 seats?" first (sprint 16). **Keep seats** is the default and
/// stays; **Release** runs [onRelease] and leaves. Nothing held → no question.
class LeaveGuard extends StatelessWidget {
  const LeaveGuard({super.key, required this.heldSeats, required this.onRelease, required this.child});

  /// Seats held right now; 0 lets back through.
  final int heldSeats;
  final VoidCallback onRelease;
  final Widget child;

  static Future<bool> confirm(BuildContext context, int seats) => AppDialog.confirm(
        context,
        key: const Key('flow.leaveDialog'),
        title: 'flow.leave.title'.plural(seats, context: context),
        body: 'flow.leave.body'.tr(context: context),
        confirmLabel: 'flow.leave.release'.tr(context: context),
        cancelLabel: 'flow.leave.keep'.tr(context: context),
        destructive: true,
        confirmKey: const Key('flow.leave.release'),
        cancelKey: const Key('flow.leave.keep'),
      );

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: heldSeats == 0,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await confirm(context, heldSeats)) {
          onRelease();
          navigator.pop();
        }
      },
      child: child,
    );
  }
}
