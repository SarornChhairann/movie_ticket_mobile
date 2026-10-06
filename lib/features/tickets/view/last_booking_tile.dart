import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../controller/my_bookings_bloc.dart';
import 'booking_status_chip.dart';

/// Profile shortcut to the newest booking (first item of my-bookings). Hidden
/// while loading, on failure, and when there are no bookings.
class LastBookingTile extends StatelessWidget {
  const LastBookingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyBookingsBloc>().state;
    final last = state is MyBookingsReady ? state.bookings.firstOrNull : null;
    if (last == null) return const SizedBox.shrink();
    return ListTile(
      key: const Key('loyalty.lastBooking'),
      leading: const Icon(Icons.history),
      title: Text('loyalty.lastBooking'.tr(context: context)),
      subtitle: Text('${last.movieTitle} · ${showLine(context, last)}'),
      trailing: BookingStatusChip(status: last.status, refund: last.refund),
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.bookingDetail,
        arguments: (context.read<MyBookingsBloc>(), last.bookingId),
      ),
    );
  }
}
