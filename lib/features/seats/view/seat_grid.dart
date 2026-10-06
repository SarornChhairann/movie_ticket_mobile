part of 'seat_map_page.dart';

/// The seat step's body: title, screen, the seat canvas (or the accessible row
/// list), legend, and time chips (sprint 17).
class _ReadyBody extends StatefulWidget {
  const _ReadyBody({required this.state, required this.args});

  final SeatMapReady state;
  final SeatMapArgs? args;

  @override
  State<_ReadyBody> createState() => _ReadyBodyState();
}

class _ReadyBodyState extends State<_ReadyBody> {
  /// Tapping "Couple" in the legend lights every couple seat for a moment.
  final _coupleHighlight = ValueNotifier(false);

  /// Row list instead of the canvas; on by default when a screen reader is on.
  bool? _listMode;

  @override
  void dispose() {
    _coupleHighlight.dispose();
    super.dispose();
  }

  Future<void> _highlightCouples() async {
    _coupleHighlight.value = true;
    await Future<void>.delayed(context.motion(Motion.seatGlow));
    if (mounted) _coupleHighlight.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.state.data;
    final theme = Theme.of(context);
    final listMode = _listMode ?? MediaQuery.accessibleNavigationOf(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.screen),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${data.movieTitle} · ${data.hallName}',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppButton.ghost(
                key: const Key('seats.viewToggle'),
                icon: Icon(listMode ? Icons.event_seat_outlined : Icons.view_list_outlined),
                label: (listMode ? 'seats.mapView' : 'seats.listView').tr(context: context),
                onPressed: () => setState(() => _listMode = !listMode),
              ),
            ],
          ),
        ),
        if (listMode)
          Expanded(child: _SeatListMode(state: widget.state))
        else ...[
          const _ScreenCurve(),
          Text('seats.screen'.tr(context: context), style: theme.textTheme.labelSmall),
          Expanded(child: _SeatCanvas(state: widget.state, coupleHighlight: _coupleHighlight)),
          _Legend(onCouple: _highlightCouples),
        ],
        _ShowtimeChips(state: widget.state, args: widget.args),
      ],
    );
  }
}

/// How a seat looks in each UI state. Held stays distinct from booked.
({Color? fill, Color? border, Color text}) _seatLook(SeatColors colors, SeatUiState ui) => switch (ui) {
  SeatUiState.available => (fill: null, border: colors.outline, text: AppColors.white),
  SeatUiState.selected || SeatUiState.heldByMe => (fill: colors.selected, border: null, text: AppColors.white),
  SeatUiState.booked => (fill: colors.booked, border: null, text: AppColors.navy),
  SeatUiState.heldByOthers => (fill: colors.heldFill, border: colors.heldOutline, text: colors.heldOutline),
};
