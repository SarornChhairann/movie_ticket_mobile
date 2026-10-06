part of 'seat_map_page.dart';

/// The whole hall in miniature while zoomed in (sprint 17): seats as dots,
/// the selection in the action colour, and a frame for what is on screen.
/// Tapping it moves the view there.
class _SeatMinimap extends StatelessWidget {
  const _SeatMinimap({
    required this.state,
    required this.layout,
    required this.visible,
    required this.width,
    required this.onJump,
  });

  final SeatMapReady state;
  final SeatLayout layout;

  /// What the main view shows, in canvas units.
  final Rect visible;
  final double width;
  final ValueChanged<Offset> onJump;

  @override
  Widget build(BuildContext context) {
    final scale = width / layout.size.width;
    final height = layout.size.height * scale;
    final colors = Theme.of(context).extension<SeatColors>()!;
    return ExcludeSemantics(
      child: GestureDetector(
        key: const Key('seats.minimap'),
        onTapDown: (d) => onJump(d.localPosition / scale),
        child: Material(
          color: context.tokens.surface(2).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppTokens.radii.sm),
          clipBehavior: Clip.antiAlias,
          child: CustomPaint(
            size: Size(width, height),
            painter: _MinimapPainter(
              layout: layout,
              selected: state.selected,
              taken: state.booked.union(state.heldByOthers),
              visible: visible,
              scale: scale,
              free: colors.outline,
              chosen: colors.selected,
              busy: colors.booked,
              frame: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _MinimapPainter extends CustomPainter {
  _MinimapPainter({
    required this.layout,
    required this.selected,
    required this.taken,
    required this.visible,
    required this.scale,
    required this.free,
    required this.chosen,
    required this.busy,
    required this.frame,
  });

  final SeatLayout layout;
  final Set<int> selected;
  final Set<int> taken;
  final Rect visible;
  final double scale;
  final Color free;
  final Color chosen;
  final Color busy;
  final Color frame;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final entry in layout.seatRects.entries) {
      paint.color = selected.contains(entry.key) ? chosen : (taken.contains(entry.key) ? busy : free.withValues(alpha: 0.5));
      final r = Rect.fromLTRB(entry.value.left * scale, entry.value.top * scale, entry.value.right * scale, entry.value.bottom * scale);
      canvas.drawRect(r.deflate(0.3), paint);
    }
    final view = Rect.fromLTRB(visible.left * scale, visible.top * scale, visible.right * scale, visible.bottom * scale)
        .intersect(Offset.zero & size);
    canvas.drawRect(
      view,
      Paint()
        ..color = frame
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_MinimapPainter old) =>
      old.visible != visible || old.selected != selected || old.taken != taken || old.layout != layout;
}
