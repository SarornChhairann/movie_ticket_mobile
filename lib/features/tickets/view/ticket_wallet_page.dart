import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/model/booking_summary.dart';
import '../../../core/motion/motion.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/tokens.dart';
import '../controller/ticket_bloc.dart';
import 'offline_note.dart';
import 'ticket_card.dart';
import 'ticket_flip.dart';

/// Ticket wallet route argument: the booking and which ticket to show first.
class TicketWalletArgs {
  const TicketWalletArgs({
    required this.booking,
    this.initialIndex = 0,
    this.doorMode = false,
    this.source = 'booking_detail',
  });

  final BookingSummary booking;
  final int initialIndex;

  /// Open on the QR side (from Up next's Show ticket).
  final bool doorMode;

  /// Where it was opened from, for the funnel (`up_next`, `booking_detail`).
  final String source;
}

/// The tickets of one booking as cards (sprint 18): swipe sideways between
/// tickets, tap to turn a card to its door-mode QR, swipe down to close.
class TicketWalletPage extends StatefulWidget {
  const TicketWalletPage({super.key, required this.args, required this.qrBloc});

  final TicketWalletArgs args;

  /// One QR bloc per ticket page (created by the router; widgets never use GetIt).
  final TicketBloc Function() qrBloc;

  @override
  State<TicketWalletPage> createState() => _TicketWalletPageState();
}

class _TicketWalletPageState extends State<TicketWalletPage> {
  late final _pages = PageController(initialPage: widget.args.initialIndex);
  late int _index = widget.args.initialIndex;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.args.booking;
    final tickets = booking.tickets;
    final text = Theme.of(context).textTheme;
    return GestureDetector(
      // Swipe down closes, like a sheet.
      onVerticalDragEnd: (d) {
        if ((d.primaryVelocity ?? 0) > 600) Navigator.of(context).maybePop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('tickets.qr'.tr(context: context)),
          leading: IconButton(
            key: const Key('wallet.close'),
            icon: const Icon(Icons.close),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  key: const Key('wallet.pager'),
                  controller: _pages,
                  itemCount: tickets.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) => _TicketPage(
                    booking: booking,
                    ticket: tickets[i],
                    doorMode: widget.args.doorMode,
                    source: widget.args.source,
                    qrBloc: widget.qrBloc,
                  ),
                ),
              ),
              if (tickets.length > 1)
                Semantics(
                  label: 'ticket.of'.tr(context: context, namedArgs: {'n': '${_index + 1}', 'total': '${tickets.length}'}),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.x1),
                    child: Row(
                      key: const Key('wallet.dots'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < tickets.length; i++)
                          AnimatedContainer(
                            duration: context.motion(Motion.short),
                            margin: const EdgeInsets.symmetric(horizontal: Space.x0_5),
                            width: i == _index ? Space.x2 : Space.x1,
                            height: Space.x1,
                            decoration: BoxDecoration(
                              color: i == _index ? Theme.of(context).colorScheme.primary : context.tokens.surface(3),
                              borderRadius: BorderRadius.circular(Space.x0_5),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.screen, 0, Space.screen, Space.x2),
                child: Text(
                  'tickets.brightnessHint'.tr(context: context),
                  textAlign: TextAlign.center,
                  style: text.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketPage extends StatelessWidget {
  const _TicketPage({
    required this.booking,
    required this.ticket,
    required this.doorMode,
    required this.source,
    required this.qrBloc,
  });

  final BookingSummary booking;
  final TicketPass ticket;
  final bool doorMode;
  final String source;
  final TicketBloc Function() qrBloc;

  @override
  Widget build(BuildContext context) {
    final card = TicketFlip(
      showBack: doorMode,
      front: TicketFront(booking: booking, ticket: ticket),
      back: TicketBack(booking: booking, ticket: ticket),
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x2),
      // A cancelled ticket never fetches a QR.
      child: ticket.cancelled
          ? card
          : BlocProvider(
              create: (_) => qrBloc()..add(QrRequested(ticket.code, source: source)),
              child: Column(
                children: [
                  BlocBuilder<TicketBloc, TicketState>(
                    builder: (context, state) => state is TicketReady && state.offline
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: Space.x2),
                            child: OfflineNote(savedAt: state.savedAt),
                          )
                        : const SizedBox.shrink(),
                  ),
                  card,
                ],
              ),
            ),
    );
  }
}
