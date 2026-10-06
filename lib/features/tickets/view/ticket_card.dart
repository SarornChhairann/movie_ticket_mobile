import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/model/booking_summary.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/booking_capsule.dart';
import '../controller/ticket_bloc.dart';

/// The front of a ticket (sprint 18): capsule header, perforation, seat, and
/// reference. Tapping the card turns it to the QR.
class TicketFront extends StatelessWidget {
  const TicketFront({super.key, required this.booking, required this.ticket});

  final BookingSummary booking;
  final TicketPass ticket;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final tokens = context.tokens;
    return _Perforated(
      color: tokens.surface(2),
      child: Padding(
        padding: const EdgeInsets.all(Space.x2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BookingCapsule(
              showtimeId: booking.showtimeId ?? booking.bookingId,
              title: booking.movieTitle,
              line: context.showLine(hallName: booking.hallName, showDate: booking.showDate, showTime: booking.showTime),
              hero: false,
            ),
            const SizedBox(height: Space.x3),
            Text('tickets.seat'.tr(context: context), style: text.labelMedium?.copyWith(color: tokens.onSurfaceMuted)),
            Text(ticket.seatCode, key: const Key('ticket.front.seat'), style: AppText.display),
            const SizedBox(height: Space.x2),
            if (booking.reference.isNotEmpty) ...[
              Text('tickets.reference'.tr(context: context), style: text.labelMedium?.copyWith(color: tokens.onSurfaceMuted)),
              SelectableText(booking.reference, style: tokens.numericLarge),
              const SizedBox(height: Space.x2),
            ],
            Row(
              children: [
                Icon(ticket.cancelled ? Icons.block : Icons.qr_code_2, color: tokens.onSurfaceMuted),
                const SizedBox(width: Space.x1),
                Expanded(
                  child: Text(
                    (ticket.cancelled ? 'ticket.cancelled' : 'ticket.flipHint').tr(context: context),
                    style: text.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Door mode (sprint 18): a white, high-contrast card with the QR as large as
/// it fits and the code in big tabular digits. A cancelled ticket shows its
/// status, never a scannable code.
class TicketBack extends StatelessWidget {
  const TicketBack({super.key, required this.booking, required this.ticket});

  final BookingSummary booking;
  final TicketPass ticket;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      key: const Key('ticket.back'),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppTokens.radii.card)),
      padding: const EdgeInsets.all(Space.x2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ticket.cancelled
                ? Center(
                    child: Text(
                      'ticket.cancelled'.tr(context: context),
                      key: const Key('ticket.back.cancelled'),
                      textAlign: TextAlign.center,
                      style: text.titleLarge?.copyWith(color: AppColors.navy),
                    ),
                  )
                : BlocBuilder<TicketBloc, TicketState>(
                    builder: (context, state) => switch (state) {
                      TicketReady(:final png) => Image.memory(
                          png,
                          key: const Key('ticket.back.qr'),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          semanticLabel: 'tickets.qr'.tr(context: context),
                        ),
                      TicketFailureState() => Center(
                          child: Text('shell.offline'.tr(context: context), style: const TextStyle(color: AppColors.navy)),
                        ),
                      _ => const Center(child: CircularProgressIndicator()),
                    },
                  ),
          ),
          const SizedBox(height: Space.x1),
          // Plain text: a selectable field here would be a tiny tap target, and the
          // code is scanned, not typed (sprint 19).
          Text(
            ticket.code,
            textAlign: TextAlign.center,
            style: AppText.numeric.copyWith(color: AppColors.navy, letterSpacing: 1),
          ),
          if (booking.reference.isNotEmpty)
            Text(
              booking.reference,
              key: const Key('ticket.back.reference'),
              style: AppText.numericLarge.copyWith(color: AppColors.navy, letterSpacing: 3),
            ),
        ],
      ),
    );
  }
}

/// A ticket stub: rounded card with two half-circle notches and a dashed tear line.
class _Perforated extends StatelessWidget {
  const _Perforated({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _NotchClipper(),
      child: ColoredBox(color: color, child: child),
    );
  }
}

class _NotchClipper extends CustomClipper<Path> {
  const _NotchClipper();

  static const notch = 12.0;

  @override
  Path getClip(Size size) {
    final y = size.height * 0.36;
    final card = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(Radii.card)));
    final notches = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, y), radius: notch))
      ..addOval(Rect.fromCircle(center: Offset(size.width, y), radius: notch));
    for (var x = notch * 2; x < size.width - notch * 2; x += 10) {
      notches.addRect(Rect.fromLTWH(x, y - 0.75, 5, 1.5));
    }
    return Path.combine(PathOperation.difference, card, notches);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
