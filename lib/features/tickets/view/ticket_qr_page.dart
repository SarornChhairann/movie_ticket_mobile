import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_view.dart';
import '../controller/ticket_bloc.dart';
import '../model/tickets_failure.dart';
import 'offline_note.dart';

/// Large code plus the server's QR PNG, for scanning at the door.
class TicketQrPage extends StatelessWidget {
  const TicketQrPage({super.key, required this.ticket});

  final TicketPass ticket;

  static const _qrSize = 280.0;

  static bool _offline(TicketState state) => state is TicketReady && state.offline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('tickets.qr'.tr(context: context))),
      body: ListView(
        padding: const EdgeInsets.all(Space.x3),
        children: [
          BlocBuilder<TicketBloc, TicketState>(
            buildWhen: (previous, current) => _offline(previous) != _offline(current),
            builder: (context, state) => _offline(state)
                ? const Padding(padding: EdgeInsets.only(bottom: Space.x2), child: OfflineNote())
                : const SizedBox.shrink(),
          ),
          Text(ticket.seatCode, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: Space.x2),
          Center(
            child: SizedBox.square(
              dimension: _qrSize,
              child: BlocBuilder<TicketBloc, TicketState>(
                builder: (context, state) => switch (state) {
                  TicketInitial() || TicketLoading() => const Center(child: CircularProgressIndicator()),
                  TicketReady(:final png) => ColoredBox(
                      // QR scanners need a light quiet zone, also in dark mode.
                      color: Colors.white,
                      child: Image.memory(png, key: const Key('tickets.qrImage'), fit: BoxFit.contain),
                    ),
                  TicketFailureState(:final code, :final failure) => ErrorView(
                      message: switch (failure) {
                  TicketsNetwork() => 'shell.offline'.tr(context: context),
                  TicketsNotFound() => 'tickets.notFound'.tr(context: context),
                  _ => failure.message,
                },
                      onRetry: () => context.read<TicketBloc>().add(QrRequested(code)),
                    ),
                },
              ),
            ),
          ),
          const SizedBox(height: Space.x2),
          Text('tickets.code'.tr(context: context), style: theme.textTheme.labelLarge, textAlign: TextAlign.center),
          SelectableText(
            ticket.code,
            key: const Key('tickets.codeText'),
            style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'monospace', letterSpacing: 1),
            textAlign: TextAlign.center,
          ),
          if (ticket.bookingReference.isNotEmpty) ...[
            const SizedBox(height: Space.x1),
            Text(
              '${'tickets.reference'.tr(context: context)}: ${ticket.bookingReference}',
              key: const Key('tickets.qrReference'),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: Space.x3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.brightness_high, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: Space.x1),
              Flexible(
                child: Text(
                  'tickets.brightnessHint'.tr(context: context),
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
