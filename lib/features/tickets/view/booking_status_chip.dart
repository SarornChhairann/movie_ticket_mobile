import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/model/booking_summary.dart';
import '../../../core/motion/motion.dart';

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (key, background, foreground) = switch (status) {
      BookingStatus.confirmed => ('tickets.status.confirmed', scheme.primaryContainer, scheme.onPrimaryContainer),
      BookingStatus.cancelled => ('tickets.status.cancelled', scheme.errorContainer, scheme.onErrorContainer),
      BookingStatus.pending ||
      BookingStatus.unknown =>
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
          key: Key('tickets.chip.${status.name}'),
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
