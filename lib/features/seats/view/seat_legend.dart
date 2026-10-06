part of 'seat_map_page.dart';

class _Legend extends StatelessWidget {
  const _Legend({this.onCouple});

  /// Tapping "Couple" lights up every couple seat for a moment (sprint 17).
  final VoidCallback? onCouple;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SeatColors>()!;
    Widget item(SeatUiState ui, String key, {bool couple = false}) {
      final look = _seatLook(colors, ui);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 0.6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (couple) ...[
                  for (final shape in const [_ChairShape.coupleLeft, _ChairShape.coupleRight])
                    _SeatBox(
                      fill: look.fill,
                      border: look.border,
                      accent: look.text,
                      width: _SeatTile.coupleWidth,
                      shape: shape,
                    ),
                ] else
                  _SeatBox(fill: look.fill, border: look.border, accent: look.text, width: _SeatTile.normalWidth),
              ],
            ),
          ),
          Text(key.tr(context: context), style: Theme.of(context).textTheme.labelSmall),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x1),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: Space.x1,
        children: [
          item(SeatUiState.available, 'seats.legend.available'),
          item(SeatUiState.selected, 'seats.legend.selected'),
          item(SeatUiState.booked, 'seats.legend.reserved'),
          item(SeatUiState.heldByOthers, 'seats.legend.held'),
          InkWell(
            key: const Key('seats.legend.couple'),
            onTap: onCouple,
            borderRadius: BorderRadius.circular(AppTokens.radii.sm),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: Space.minTarget),
              child: item(SeatUiState.available, 'seats.legend.couple', couple: true),
            ),
          ),
        ],
      ),
    );
  }
}
