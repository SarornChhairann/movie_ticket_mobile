part of 'seat_map_page.dart';

/// The seat map as rows of text (sprint 17): fast with TalkBack and VoiceOver.
/// "Row F, 6 seats available: 3, 4, 5, 6, 7, 8"; each row opens to its seats,
/// each labelled with its state, and selecting works exactly like a tap on the map.
class _SeatListMode extends StatelessWidget {
  const _SeatListMode({required this.state});

  final SeatMapReady state;

  String _stateLabel(BuildContext context, SeatUiState ui) => switch (ui) {
        SeatUiState.available => 'seats.state.available',
        SeatUiState.selected || SeatUiState.heldByMe => 'seats.state.selected',
        SeatUiState.heldByOthers => 'seats.state.held',
        SeatUiState.booked => 'seats.state.booked',
      }.tr(context: context);

  @override
  Widget build(BuildContext context) {
    final rows = SeatLayout.rowsOf(state.data.seats);
    final bloc = context.read<SeatMapBloc>();
    return ListView(
      key: const Key('seats.list'),
      children: [
        for (final row in rows)
          Builder(builder: (context) {
            final letter = SeatCode.tryParse(row.first.code)?.row ?? '${row.first.row}';
            final free = [for (final s in row) if (state.isTappable(s)) SeatCode.tryParse(s.code)?.number ?? s.number];
            final summary = 'seats.rowSummary'.tr(
              context: context,
              namedArgs: {'row': letter, 'count': '${free.length}', 'list': free.join(', ')},
            );
            return ExpansionTile(
              key: Key('seats.row.$letter'),
              title: Text(summary),
              children: [
                for (final seat in row)
                  Builder(builder: (context) {
                    final ui = state.seatState(seat);
                    final number = SeatCode.tryParse(seat.code)?.number ?? seat.number;
                    final partner = seat.couple ? CouplePairing.partnerCode(seat.code) : null;
                    final partnerNumber = partner == null ? null : SeatCode.tryParse(partner)?.number;
                    final label = [
                      'seats.seatLabel'.tr(context: context, namedArgs: {'seat': '$number'}),
                      _stateLabel(context, ui),
                      if (partnerNumber != null) 'seats.coupleWith'.tr(context: context, namedArgs: {'seat': '$partnerNumber'}),
                    ].join(', ');
                    final selectable = state.isTappable(seat);
                    return CheckboxListTile(
                      key: Key('seats.listSeat.${seat.id}'),
                      title: Text(label),
                      value: state.selected.contains(seat.id),
                      onChanged: selectable
                          ? (_) {
                              AppHaptics.selection();
                              bloc.add(SeatToggled(seat.id));
                            }
                          : null,
                    );
                  }),
              ],
            );
          }),
      ],
    );
  }
}
