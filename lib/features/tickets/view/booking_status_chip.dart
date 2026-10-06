import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/model/booking_summary.dart';
import '../../../core/motion/motion.dart';

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({super.key, required this.status, this.refund = RefundState.none});

  final BookingStatus status;

  /// Shown instead of plain "Cancelled" once a paid booking is cancelled.
  final RefundState refund;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (key, background, foreground) = switch ((status, refund)) {
      (BookingStatus.cancelled, RefundState.pending) =>
        ('tickets.refundPending', scheme.tertiaryContainer, scheme.onTertiaryContainer),
      (BookingStatus.cancelled, RefundState.refunded) =>
        ('tickets.refunded', scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      (BookingStatus.confirmed, _) => ('tickets.status.confirmed', scheme.primaryContainer, scheme.onPrimaryContainer),
      (BookingStatus.cancelled, _) => ('tickets.status.cancelled', scheme.errorContainer, scheme.onErrorContainer),
      (BookingStatus.pending || BookingStatus.unknown, _) =>
        ('tickets.status.pending', scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };
    // A status change (e.g. confirmed → cancelled) morphs in place: colour and
    // label crossfade while the width adjusts.
    return AnimatedSize(
      duration: context.motion(Motion.medium),
      curve: Motion.decelerate,
      child: AnimatedSwitcher(
        duration: context.motion(Motion.medium),
        child: Chip(
          key: Key(refund == RefundState.none || status != BookingStatus.cancelled
              ? 'tickets.chip.${status.name}'
              : 'tickets.chip.refund.${refund.name}'),
          label: Text(key.tr(context: context), style: TextStyle(color: foreground)),
          backgroundColor: background,
          side: BorderSide.none,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}

/// `Hall · date · HH:mm` in the current language.
String showLine(BuildContext context, BookingSummary b) =>
    context.showLine(hallName: b.hallName, showDate: b.showDate, showTime: b.showTime);
