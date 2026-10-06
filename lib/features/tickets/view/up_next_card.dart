import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/format/show_time.dart';
import '../../../core/motion/pressable.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../controller/up_next_cubit.dart';
import '../model/ticket_wallet.dart';
import 'ticket_wallet_page.dart';

/// Home's "Up next" (sprint 18): the next show within a week, a live countdown,
/// and **Show ticket**, which opens the ticket straight on its QR. Hidden when
/// there is nothing coming up.
class UpNextCard extends StatelessWidget {
  const UpNextCard({super.key});

  @override
  Widget build(BuildContext context) {
    final UpNextCubit cubit;
    try {
      cubit = context.read<UpNextCubit>();
    } on Object {
      return const SizedBox.shrink(); // outside the shell (tests, previews)
    }
    return BlocBuilder<UpNextCubit, UpNextState>(
      bloc: cubit,
      builder: (context, state) {
        final booking = state.booking;
        final start = booking?.showStart;
        if (booking == null || start == null) return const SizedBox.shrink();
        final text = Theme.of(context).textTheme;
        final tokens = context.tokens;
        final time = formatShowTime(booking.showTime ?? '');
        final when = switch (upNextDay(start, state.now)) {
          UpNextDay.tonight => 'upNext.tonight'.tr(context: context, namedArgs: {'time': time}),
          UpNextDay.tomorrow => 'upNext.tomorrow'.tr(context: context, namedArgs: {'time': time}),
          UpNextDay.later => context.showLine(showDate: booking.showDate, showTime: booking.showTime),
        };
        void open() => Navigator.of(context).pushNamed(
              AppRoutes.ticketWallet,
              arguments: TicketWalletArgs(booking: booking, doorMode: true, source: 'up_next'),
            );
        return Padding(
          padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, Space.x2),
          child: Pressable(
            child: Material(
              key: const Key('upNext.card'),
              color: tokens.surface(2),
              borderRadius: BorderRadius.circular(AppTokens.radii.card),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: open,
                child: Padding(
                  padding: const EdgeInsets.all(Space.x2),
                  child: Row(
                    children: [
                      ExcludeSemantics(child: Icon(Icons.confirmation_number, size: Space.x6, color: tokens.link)),
                      const SizedBox(width: Space.x2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('upNext.title'.tr(context: context), style: text.labelMedium?.copyWith(color: tokens.link)),
                            Text(booking.movieTitle, style: text.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('$when · ${booking.hallName}', style: text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(
                              'upNext.inTime'.tr(context: context, namedArgs: {'duration': untilText(start, state.now)}),
                              key: const Key('upNext.countdown'),
                              style: tokens.numeric.copyWith(color: tokens.warning),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Space.x1),
                      AppButton.tonal(key: const Key('upNext.show'), label: 'upNext.showTicket'.tr(context: context), onPressed: open),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
