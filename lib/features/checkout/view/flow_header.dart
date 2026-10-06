import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/booking_capsule.dart';
import '../../../core/widgets/booking_progress.dart';
import '../../../core/widgets/countdown_pill.dart';
import '../../catalog/view/poster_image.dart';
import '../controller/booking_flow_cubit.dart';

/// Progress header and booking capsule, pinned on every step of a booking
/// (sprint 16). Renders nothing outside a booking flow.
class FlowHeader extends StatelessWidget {
  const FlowHeader({super.key, this.secondsLeft, this.onStepTap});

  /// The hold's countdown from the step's own bloc (same source as `HoldBanner`).
  final int? secondsLeft;
  final ValueChanged<FlowStep>? onStepTap;

  @override
  Widget build(BuildContext context) {
    final flow = maybeFlow(context);
    if (flow == null) return const SizedBox.shrink();
    return BlocBuilder<BookingFlowCubit, BookingFlowState>(
      bloc: flow,
      builder: (context, state) {
        final showtimeId = state.showtimeId;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BookingProgress(current: state.step, snacksSkipped: state.snacksSkipped, onStepTap: onStepTap),
            if (showtimeId != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.screen, 0, Space.screen, Space.x1),
                child: BookingCapsule(
                  showtimeId: showtimeId,
                  title: state.title,
                  line: context.showLine(hallName: state.hallName, showDate: state.showDate, showTime: state.showTime),
                  poster: state.posterUrl == null ? null : PosterImage(url: state.posterUrl, cacheWidth: 120),
                  seats: state.seatCodes,
                  secondsLeft: state.holdExpiresAt == null ? null : secondsLeft,
                  timerLabel: secondsLeft == null
                      ? null
                      : 'seats.holdEnding'.tr(context: context, namedArgs: {'time': CountdownPill.mmss(secondsLeft!)}),
                  timerAnnouncement: (s) =>
                      'seats.holdEnding'.tr(context: context, namedArgs: {'time': CountdownPill.mmss(s)}),
                ),
              ),
          ],
        );
      },
    );
  }
}
