part of 'seat_map_page.dart';

/// The seat step's [StickySummaryBar]: party size and Best seats on top, the
/// seat count and codes on the left, Continue on the right. No prices here:
/// they come from the server quote on the next step.
class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.state});

  final SeatMapReady state;

  @override
  Widget build(BuildContext context) {
    final seats = state.selectedSeats;
    final codes = seats.map((s) => s.code).join(', ');
    final textTheme = Theme.of(context).textTheme;
    return StickySummaryBar(
      actionKey: const Key('seats.continue'),
      actionLabel: 'seats.continue'.tr(context: context),
      loading: state.holding,
      // The hold call is the server check: only seats it still grants go on.
      onAction: state.canContinue ? () => context.read<SeatMapBloc>().add(const HoldRequested()) : null,
      top: Row(
        children: [
          // Both shrink on a narrow phone or in Khmer rather than overflow.
          Flexible(
            child: OutlinedButton.icon(
              key: const Key('seats.party'),
              icon: const Icon(Icons.group_outlined),
              label: Text(
                state.partySize == null
                    ? 'seats.partyShort'.tr(context: context)
                    : 'seats.partyCount'.tr(context: context, namedArgs: {'count': '${state.partySize}'}),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: state.holding ? null : () => SeatMapPage.askPartySize(context, state),
            ),
          ),
          const SizedBox(width: Space.x1),
          Flexible(
            child: TextButton.icon(
              key: const Key('seats.best'),
              icon: const Icon(Icons.auto_awesome),
              label: Text('seats.best'.tr(context: context), overflow: TextOverflow.ellipsis),
              onPressed: state.holding
                  ? null
                  : () async {
                      final bloc = context.read<SeatMapBloc>();
                      final size = state.partySize ?? await SeatMapPage.askPartySize(context, state);
                      if (size != null) bloc.add(const BestSeatsRequested());
                    },
            ),
          ),
        ],
      ),
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // The count crossfades rather than snapping.
          AnimatedSwitcher(
            duration: context.motion(Motion.short),
            child: KeyedSubtree(
              key: ValueKey(seats.length),
              child: Text(
                'seats.count'.tr(context: context, namedArgs: {'count': '${seats.length}'}),
                key: const Key('seats.count'),
                style: textTheme.titleSmall,
              ),
            ),
          ),
          Text(
            codes.isEmpty ? 'seats.noneSelected'.tr(context: context) : codes,
            key: const Key('seats.summary'),
            style: textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
