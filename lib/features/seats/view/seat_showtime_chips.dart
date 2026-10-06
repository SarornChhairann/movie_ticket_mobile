part of 'seat_map_page.dart';

/// The chosen date and the day's real showtimes from the detail screen. Picking
/// another time drops any hold here and loads that showtime's map.
class _ShowtimeChips extends StatelessWidget {
  const _ShowtimeChips({required this.state, required this.args});

  final SeatMapReady state;
  final SeatMapArgs? args;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    final locale = context.locale.toString();
    final options = args?.options ?? const <ShowtimeOption>[];
    final dateLabel = data.showDate == null ? null : formatShowDate(data.showDate!, locale: locale);
    final bloc = context.read<SeatMapBloc>();
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.screen),
        children: [
          if (dateLabel != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.x1),
              child: GenreChip(label: dateLabel, selected: true, onSelected: () {}),
            ),
          if (options.isEmpty && data.showTime != null)
            GenreChip(label: formatShowTime(data.showTime!), selected: true, onSelected: () {})
          else
            for (final o in options)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: Space.x1),
                child: GenreChip(
                  key: Key('seatTime.${o.id}'),
                  label: '${o.time} · ${o.hallName}',
                  selected: o.id == data.showtimeId,
                  onSelected: () {
                    if (o.id == data.showtimeId || state.holding) return;
                    bloc
                      ..add(const ReleaseRequested())
                      ..add(LoadRequested(o.id));
                  },
                ),
              ),
        ],
      ),
    );
  }
}
