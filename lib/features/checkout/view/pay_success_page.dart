import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../auth/controller/auth_bloc.dart';
import 'ticket_issued_animation.dart';
import '../../../core/model/booking_summary.dart';

/// Shown after a confirmed payment. It sits directly above home, so back goes home.
class PaySuccessPage extends StatefulWidget {
  const PaySuccessPage({super.key, required this.confirmation});

  final BookingSummary confirmation;

  @override
  State<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends State<PaySuccessPage> {
  @override
  void initState() {
    super.initState();
    // Points changed server-side; a guest's AuthBloc ignores this.
    context.read<AuthBloc>().add(const UserRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.confirmation;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('pay.success'.tr(context: context)), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(Space.x3),
        children: [
          const Center(child: TicketIssuedAnimation()),
          const SizedBox(height: Space.x2),
          Text(c.movieTitle, style: textTheme.titleLarge, textAlign: TextAlign.center),
          Text(
            context.showLine(hallName: c.hallName, showDate: c.showDate, showTime: c.showTime),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Space.x1),
          Text(
            context.money(c.totalAmount),
            key: const Key('pay.total'),
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          if (c.reference.isNotEmpty) ...[
            const SizedBox(height: Space.x2),
            Text('tickets.reference'.tr(context: context), style: textTheme.labelLarge, textAlign: TextAlign.center),
            SelectableText(
              c.reference,
              key: const Key('pay.reference'),
              style: textTheme.headlineSmall?.copyWith(fontFamily: 'monospace', letterSpacing: 2),
              textAlign: TextAlign.center,
            ),
            Text('pay.referenceHint'.tr(context: context), style: textTheme.bodySmall, textAlign: TextAlign.center),
          ],
          const Divider(height: Space.x4),
          for (final t in c.tickets)
            ListTile(
              key: Key('ticket.${t.code}'),
              leading: const Icon(Icons.confirmation_number_outlined),
              title: Text(t.seatCode),
              subtitle: SelectableText('${'pay.ticketCode'.tr(context: context)}: ${t.code}'),
              trailing: const Icon(Icons.qr_code_2),
              // The QR endpoint is public, so this is also the guest's ticket view.
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.ticketQr, arguments: t),
            ),
          const SizedBox(height: Space.x3),
          // Guests find it again under Bookings (saved on this phone, or by reference + phone).
          if (context.watch<AuthBloc>().state is AuthAuthenticated) ...[
            OutlinedButton(
              key: const Key('pay.viewTickets'),
              // My bookings sits directly above home, so back goes home.
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.myBookings,
                (route) => route.isFirst,
              ),
              child: Text('pay.viewTickets'.tr(context: context)),
            ),
            const SizedBox(height: Space.x1),
          ],
          FilledButton(
            key: const Key('pay.backHome'),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Text('pay.backHome'.tr(context: context)),
          ),
        ],
      ),
    );
  }
}
