import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_text.dart';
import '../../../core/haptics/app_haptics.dart';
import '../../../core/format/show_time.dart';
import '../../../core/motion/motion.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/seat_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/genre_chip.dart';
import '../../../core/widgets/hold_banner.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/inline_banner.dart';
import '../../../core/widgets/leave_guard.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/sticky_summary_bar.dart';
import '../../checkout/controller/booking_flow_cubit.dart';
import '../../checkout/model/checkout_args.dart';
import '../../checkout/view/flow_header.dart';
import '../controller/seat_map_bloc.dart';
import '../model/couple_pairing.dart';
import '../model/seat_layout.dart';
import '../model/seat_map.dart';
import '../model/seat_map_args.dart';
import 'seat_focus_controller.dart';

part 'seat_grid.dart';
part 'screen_painter.dart';
part 'seat_canvas.dart';
part 'seat_glow.dart';
part 'seat_box.dart';
part 'seat_chair_painter.dart';
part 'seat_tile.dart';
part 'seat_legend.dart';
part 'seat_showtime_chips.dart';
part 'seat_bottom_bar.dart';

/// The seat map shows the extend banner for the hold's last minute.
const holdWarningSeconds = 60;

class SeatMapPage extends StatelessWidget {
  const SeatMapPage({super.key, this.args});

  /// The detail screen's showtime choice; null when opened with a bare id.
  final SeatMapArgs? args;

  @override
  Widget build(BuildContext context) {
    // The booking capsule follows the map: showtime, held seats, expiry.
    return BlocListener<SeatMapBloc, SeatMapState>(
      listenWhen: (previous, current) => current is SeatMapReady,
      listener: (context, state) => _syncFlow(context, state as SeatMapReady),
      child: _ResumeRecheck(child: _consumer(context)),
    );
  }

  static void _syncFlow(BuildContext context, SeatMapReady s) {
    final flow = maybeFlow(context);
    if (flow == null) return;
    flow.seatsChanged(
      showtimeId: s.data.showtimeId,
      title: s.data.movieTitle,
      hallName: s.data.hallName,
      showDate: s.data.showDate,
      showTime: s.data.showTime,
      seatCodes: [for (final seat in s.selectedSeats) seat.code],
      holdExpiresAt: s.hold?.expiresAt,
    );
    if (s.holdLost) flow.holdLost();
  }

  static Future<void> _proceed(BuildContext context, Hold hold) async {
    final flow = maybeFlow(context);
    await Navigator.of(context).pushNamed(AppRoutes.checkout, arguments: CheckoutArgs(hold: hold, flow: flow));
    flow?.backToSeats();
  }

  Widget _consumer(BuildContext context) {
    return BlocConsumer<SeatMapBloc, SeatMapState>(
      listenWhen: (previous, current) =>
          current is SeatMapReady &&
          current.effect != null &&
          (previous is! SeatMapReady || previous.effect != current.effect || previous.message != current.message),
      listener: (context, state) {
        final s = state as SeatMapReady;
        final messenger = ScaffoldMessenger.of(context);
        switch (s.effect!) {
          case SeatMapEffect.proceed:
            _proceed(context, s.hold!);
          case SeatMapEffect.expired:
            Navigator.of(context).popUntil((route) => route.settings.name == AppRoutes.seatMap);
            messenger.showSnackBar(SnackBar(content: Text('seats.expired'.tr(context: context))));
          case SeatMapEffect.pairError:
            messenger.showSnackBar(SnackBar(content: Text('seats.pairError'.tr(context: context))));
          case SeatMapEffect.limit:
            final message = s.message;
            messenger.showSnackBar(
              SnackBar(
                content: Text(message == null || message.isEmpty
                    ? 'seats.limit'.tr(context: context, namedArgs: {'max': '${s.seatCap ?? s.data.maxSeats}'})
                    : message),
              ),
            );
          case SeatMapEffect.noBlock:
            messenger.showSnackBar(SnackBar(content: Text('seats.noBlock'.tr(context: context))));
          case SeatMapEffect.extended:
            AppHaptics.success();
            messenger.showSnackBar(SnackBar(content: Text('seats.extendDone'.tr(context: context))));
          case SeatMapEffect.conflict:
            final message = s.message;
            messenger.showSnackBar(
              SnackBar(
                content: Text(message == null || message.isEmpty ? 'seats.conflict'.tr(context: context) : message),
              ),
            );
        }
      },
      builder: (context, state) => LeaveGuard(
        heldSeats: state is SeatMapReady ? state.hold?.seatIds.length ?? 0 : 0,
        onRelease: () => context.read<SeatMapBloc>().add(const ReleaseRequested()),
        child: Scaffold(
        appBar: AppBar(title: Text('seats.title'.tr(context: context))),
        body: switch (state) {
          SeatMapInitial() || SeatMapLoading() => const LoadingView(),
          SeatMapReady() => Column(
              children: [
                FlowHeader(secondsLeft: state.hold == null ? null : state.secondsLeft),
                if (state.holdLost)
                  InlineBanner(
                    key: const Key('flow.holdLost'),
                    message: 'flow.holdLost'.tr(context: context),
                    tone: StatusTone.warning,
                    actionKey: const Key('flow.pickAgain'),
                    actionLabel: 'flow.pickAgain'.tr(context: context),
                    onAction: () => context.read<SeatMapBloc>().add(const HoldLostAcknowledged()),
                  ),
                // Someone took a seat from the pending selection (sprint 17).
                if (state.justTaken.isNotEmpty)
                  InlineBanner(
                    key: const Key('seats.justTaken'),
                    message: 'seats.justTaken'.tr(context: context, namedArgs: {'seat': state.justTaken.join(', ')}),
                    tone: StatusTone.warning,
                    actionKey: const Key('seats.pickNext'),
                    actionLabel: 'seats.pickNext'.tr(context: context),
                    onAction: () => context.read<SeatMapBloc>().add(const PickNextBestRequested()),
                    onDismiss: () => context.read<SeatMapBloc>().add(const JustTakenDismissed()),
                  ),
                // The last minute of the hold: offer the one extend.
                if (state.hold != null && (state.secondsLeft ?? 0) > 0 && state.secondsLeft! <= holdWarningSeconds)
                  HoldBanner(
                    secondsLeft: state.secondsLeft!,
                    extending: state.extending,
                    onExtend: state.canExtend ? () => context.read<SeatMapBloc>().add(const HoldExtendRequested()) : null,
                  ),
                Expanded(child: _ReadyBody(state: state, args: args)),
              ],
            ),
          SeatMapFailure(:final failure) => ErrorView(
            message: switch (failure) {
              ApiFailureServer(:final message) => message,
              ApiFailureNetwork() => 'shell.offline'.tr(context: context),
              ApiFailureUnknown(:final message) => message ?? '',
            },
            onRetry: () => context.read<SeatMapBloc>().add(const RetryRequested()),
          ),
        },
        bottomNavigationBar: state is SeatMapReady ? _SummaryBar(state: state) : null,
        ),
      ),
    );
  }
}

/// Asks the server about the hold when the app comes back to the front, so a
/// hold that ended while away is shown honestly (sprint 16).
class _ResumeRecheck extends StatefulWidget {
  const _ResumeRecheck({required this.child});

  final Widget child;

  @override
  State<_ResumeRecheck> createState() => _ResumeRecheckState();
}

class _ResumeRecheckState extends State<_ResumeRecheck> {
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onResume: () => context.read<SeatMapBloc>().add(const HoldRecheckRequested()),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
