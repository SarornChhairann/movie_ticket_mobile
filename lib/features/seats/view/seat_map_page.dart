import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/seat_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../controller/seat_map_bloc.dart';
import '../model/seat_map.dart';

class SeatMapPage extends StatelessWidget {
  const SeatMapPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            Navigator.of(context).pushNamed(AppRoutes.checkout, arguments: s.hold);
          case SeatMapEffect.expired:
            Navigator.of(context).popUntil((route) => route.settings.name == AppRoutes.seatMap);
            messenger.showSnackBar(SnackBar(content: Text('seats.expired'.tr(context: context))));
          case SeatMapEffect.pairError:
            messenger.showSnackBar(SnackBar(content: Text('seats.pairError'.tr(context: context))));
          case SeatMapEffect.conflict:
            final message = s.message;
            messenger.showSnackBar(SnackBar(
              content: Text(message == null || message.isEmpty ? 'seats.conflict'.tr(context: context) : message),
            ));
        }
      },
      builder: (context, state) => switch (state) {
        SeatMapInitial() || SeatMapLoading() => Scaffold(appBar: AppBar(), body: const LoadingView()),
        SeatMapReady() => _ReadyView(state: state),
        SeatMapFailure(:final failure) => Scaffold(
            appBar: AppBar(),
            body: ErrorView(
              message: switch (failure) {
                ApiFailureServer(:final message) => message,
                ApiFailureNetwork() => 'shell.offline'.tr(context: context),
                ApiFailureUnknown(:final message) => message ?? '',
              },
            ),
          ),
      },
    );
  }
}

class _ReadyView extends StatelessWidget {
  const _ReadyView({required this.state});

  final SeatMapReady state;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    final rows = <int, List<SeatView>>{};
    for (final seat in data.seats) {
      rows.putIfAbsent(seat.row, () => []).add(seat);
    }
    final sortedRows = rows.keys.toList()..sort();
    for (final r in sortedRows) {
      rows[r]!.sort((a, b) => a.number.compareTo(b.number));
    }
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.movieTitle, style: theme.textTheme.titleMedium),
            Text(
              [data.hallName, data.showDate, data.showTime?.substring(0, 5)].whereType<String>().join(' · '),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: Space.x2),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: Space.x4),
            height: Space.x0_5,
            color: theme.colorScheme.outline,
          ),
          Padding(
            padding: const EdgeInsets.only(top: Space.x0_5),
            child: Text('seats.screen'.tr(context: context), style: theme.textTheme.labelSmall),
          ),
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.5,
              maxScale: 2.5,
              boundaryMargin: const EdgeInsets.all(Space.x6),
              child: Padding(
                padding: const EdgeInsets.all(Space.x2),
                child: Column(
                  children: [
                    for (final r in sortedRows)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [for (final seat in rows[r]!) _SeatTile(seat: seat, state: state)],
                      ),
                  ],
                ),
              ),
            ),
          ),
          const _Legend(),
          _SummaryBar(state: state),
        ],
      ),
    );
  }
}

class _SeatTile extends StatelessWidget {
  const _SeatTile({required this.seat, required this.state});

  final SeatView seat;
  final SeatMapReady state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SeatColors>()!;
    final ui = state.seatState(seat);
    final color = switch (ui) {
      SeatUiState.booked => colors.booked,
      SeatUiState.heldByOthers => colors.held,
      SeatUiState.selected || SeatUiState.heldByMe => colors.selected,
      SeatUiState.available => seat.couple ? colors.couple : colors.available,
    };
    final onColor = ThemeData.estimateBrightnessForColor(color) == Brightness.dark ? Colors.white : Colors.black87;
    final tile = Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: ui == SeatUiState.heldByMe ? Border.all(width: 2, color: onColor) : null,
      ),
      child: Text(seat.code, style: TextStyle(fontSize: 9, color: onColor)),
    );
    if (!state.isTappable(seat)) {
      return Semantics(label: seat.code, enabled: false, child: tile);
    }
    return GestureDetector(
      key: Key('seat.${seat.id}'),
      onTap: () => context.read<SeatMapBloc>().add(SeatToggled(seat.id)),
      child: Semantics(button: true, label: seat.code, selected: state.selected.contains(seat.id), child: tile),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SeatColors>()!;
    Widget item(Color c, String key) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 14, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: Space.x0_5),
            Text(key.tr(context: context), style: Theme.of(context).textTheme.labelSmall),
          ],
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.x1),
      child: Wrap(
        spacing: Space.x2,
        runSpacing: Space.x1,
        children: [
          item(colors.available, 'seats.legend.available'),
          item(colors.selected, 'seats.legend.selected'),
          item(colors.held, 'seats.legend.held'),
          item(colors.booked, 'seats.legend.booked'),
          item(colors.couple, 'seats.legend.couple'),
        ],
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.state});

  final SeatMapReady state;

  @override
  Widget build(BuildContext context) {
    final codes = state.selectedSeats.map((s) => s.code).join(', ');
    final left = state.secondsLeft;
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Space.x2),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      codes.isEmpty ? 'seats.noneSelected'.tr(context: context) : codes,
                      key: const Key('seats.summary'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (state.hold != null && left != null)
                      Text(
                        'seats.expiresIn'.tr(context: context, namedArgs: {'time': _mmss(left)}),
                        key: const Key('seats.countdown'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              FilledButton(
                key: const Key('seats.continue'),
                onPressed: state.canContinue ? () => context.read<SeatMapBloc>().add(const HoldRequested()) : null,
                child: state.holding
                    ? const SizedBox.square(dimension: Space.x2, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('seats.continue'.tr(context: context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _mmss(int seconds) {
    final s = seconds < 0 ? 0 : seconds;
    return '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  }
}
