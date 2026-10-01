import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/money.dart';
import '../../../core/theme/spacing.dart';
import '../../auth/controller/auth_bloc.dart';
import '../model/confirmation.dart';

/// Shown after a confirmed payment. It sits directly above home, so back goes home.
class PaySuccessPage extends StatefulWidget {
  const PaySuccessPage({super.key, required this.confirmation});

  final Confirmation confirmation;

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
          Icon(Icons.check_circle, size: Space.x6, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: Space.x2),
          Text(c.movieTitle, style: textTheme.titleLarge, textAlign: TextAlign.center),
          Text(
            [c.hallName, c.showDate, c.showTime?.substring(0, 5)].whereType<String>().join(' · '),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Space.x1),
          Text(
            formatMoney(c.totalAmount),
            key: const Key('pay.total'),
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const Divider(height: Space.x4),
          for (final t in c.tickets)
            ListTile(
              key: Key('ticket.${t.code}'),
              leading: const Icon(Icons.confirmation_number_outlined),
              title: Text(t.seatCode),
              subtitle: SelectableText('${'pay.ticketCode'.tr(context: context)}: ${t.code}'),
            ),
          const SizedBox(height: Space.x3),
          OutlinedButton(
            key: const Key('pay.viewTickets'),
            // My tickets arrives in sprint 6.
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('pay.ticketsSoon'.tr(context: context))),
            ),
            child: Text('pay.viewTickets'.tr(context: context)),
          ),
          const SizedBox(height: Space.x1),
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
