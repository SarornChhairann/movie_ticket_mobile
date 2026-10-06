import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/tokens.dart';
import '../model/ticket_wallet.dart';

/// Booked → Paid → Show starts → Used / Cancelled → Refund (sprint 18), from
/// fields the API already returns; the current step is highlighted.
class BookingTimeline extends StatelessWidget {
  const BookingTimeline({super.key, required this.booking, required this.now});

  final BookingSummary booking;

  /// Cinema wall clock.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final (:steps, :current) = bookingTimeline(booking, now);
    final tokens = context.tokens;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final at = steps.indexOf(current);
    return Column(
      key: const Key('tickets.timeline'),
      children: [
        for (var i = 0; i < steps.length; i++)
          Semantics(
            selected: i == at,
            child: Row(
              children: [
                SizedBox(
                  width: Space.x3,
                  child: Icon(
                    i < at ? Icons.check_circle : (i == at ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                    size: Space.x2 + Space.x0_5,
                    color: i <= at ? scheme.primary : tokens.onSurfaceMuted,
                  ),
                ),
                const SizedBox(width: Space.x1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.x0_5),
                  child: Text(
                    'ticket.timeline.${steps[i].name}'.tr(context: context),
                    key: Key('tickets.timeline.${steps[i].name}'),
                    style: (i == at ? text.titleSmall : text.bodyMedium)?.copyWith(
                      color: i > at ? tokens.onSurfaceMuted : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
