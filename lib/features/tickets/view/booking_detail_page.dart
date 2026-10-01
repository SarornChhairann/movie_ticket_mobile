import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/model/booking_summary.dart';
import '../../../core/motion/motion.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../controller/my_bookings_bloc.dart';
import 'booking_status_chip.dart';
import 'my_bookings_page.dart';

/// One booking from the [MyBookingsBloc] of the list route, with its tickets and cancel.
class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key, required this.bookingId, this.clock = DateTime.now});

  final int bookingId;
  final DateTime Function() clock;

  Future<void> _confirmCancel(BuildContext context) async {
    final bloc = context.read<MyBookingsBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const Key('tickets.cancelDialog'),
        title: Text('tickets.cancel'.tr(context: dialogContext)),
        content: Text('tickets.cancelConfirm'.tr(context: dialogContext)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('tickets.keep'.tr(context: dialogContext)),
          ),
          FilledButton(
            key: const Key('tickets.cancelConfirmButton'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('tickets.cancel'.tr(context: dialogContext)),
          ),
        ],
      ),
    );
    if (confirmed == true) bloc.add(CancelRequested(bookingId));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyBookingsBloc>().state;
    final booking = state.bookingById(bookingId);
    final cancelling = state is MyBookingsReady && state.cancellingId == bookingId;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('tickets.detail'.tr(context: context))),
      body: MyBookingsEffectListener(
        child: booking == null
            ? const EmptyView()
            : ListView(
                padding: const EdgeInsets.all(Space.x2),
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(booking.movieTitle, style: textTheme.titleLarge)),
                      BookingStatusChip(status: booking.status),
                    ],
                  ),
                  const SizedBox(height: Space.x0_5),
                  Text(showLine(context, booking)),
                  const SizedBox(height: Space.x1),
                  Text(
                    context.money(booking.totalAmount),
                    key: const Key('tickets.total'),
                    style: textTheme.headlineSmall,
                  ),
                  const Divider(height: Space.x4),
                  for (final t in booking.tickets) _TicketTile(booking: booking, ticket: t),
                  if (booking.canCancelAt(clock())) ...[
                    const SizedBox(height: Space.x3),
                    OutlinedButton(
                      key: const Key('tickets.cancel'),
                      onPressed: cancelling ? null : () => _confirmCancel(context),
                      child: cancelling
                          ? const SizedBox.square(dimension: Space.x2, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('tickets.cancel'.tr(context: context)),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.booking, required this.ticket});

  final BookingSummary booking;
  final TicketPass ticket;

  @override
  Widget build(BuildContext context) {
    // Cancelled tickets dim in place.
    return AnimatedOpacity(
      opacity: ticket.cancelled ? 0.55 : 1,
      duration: context.motion(Motion.medium),
      child: ListTile(
        key: Key('ticket.${ticket.code}'),
        leading: const Icon(Icons.qr_code_2),
        title: Text(ticket.seatCode),
        subtitle: Text('${'tickets.code'.tr(context: context)}: ${ticket.code}'),
        trailing: ticket.cancelled
            ? const BookingStatusChip(status: BookingStatus.cancelled)
            : const Icon(Icons.chevron_right),
        onTap: ticket.cancelled ? null : () => Navigator.of(context).pushNamed(AppRoutes.ticketQr, arguments: ticket),
      ),
    );
  }
}
