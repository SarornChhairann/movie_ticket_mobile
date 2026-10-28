part of 'seat_map_page.dart';

/// The hall, fitted to the space: the whole hall is always in view (never
/// enlarged), so there is no pan or zoom. Seats sit where [SeatLayout] says and
/// row letters stay on both edges.
class _SeatCanvas extends StatelessWidget {
  const _SeatCanvas({required this.state, required this.coupleHighlight});

  final SeatMapReady state;
  final ValueListenable<bool> coupleHighlight;

  /// Rows nearer the screen are this much smaller at most (depth cue).
  static const perspective = 0.06;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final viewport = constraints.biggest;
      final layout = SeatLayout.of(state.data.seats, minWidth: viewport.width);
      final fit = SeatFocus.fit(viewport, layout.size);
      // Every child is positioned, so the stack takes the viewport size explicitly.
      return SizedBox.fromSize(
        size: viewport,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: layout.size.width,
              height: layout.size.height,
              child: Transform(
                key: const Key('seats.canvas'),
                transform: fit,
                child: RepaintBoundary(child: _SeatRows(state: state, layout: layout, highlight: coupleHighlight)),
              ),
            ),
            // Row letters on both edges.
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(child: _RowLetters(layout: layout, transform: fit, viewport: viewport)),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Every seat at its [SeatLayout] place, one strip per row. Rows nearer the
/// screen are drawn slightly smaller (off under reduced motion).
class _SeatRows extends StatelessWidget {
  const _SeatRows({required this.state, required this.layout, required this.highlight});

  final SeatMapReady state;
  final SeatLayout layout;
  final ValueListenable<bool> highlight;

  @override
  Widget build(BuildContext context) {
    final seats = state.data.seats;
    final coupleByCode = {for (final s in seats) if (s.couple) s.code: s};
    final rows = SeatLayout.rowsOf(seats);
    final reveal = {for (var i = 0; i < state.revealOrder.length; i++) state.revealOrder[i]: i};
    final flat = context.reduceMotion;
    return _GlowPulse(
      active: state.selected.isNotEmpty,
      child: SizedBox.fromSize(
        size: layout.size,
        child: Stack(
          children: [
            for (var i = 0; i < rows.length; i++)
              Positioned(
                left: 0,
                right: 0,
                top: SeatLayout.padding + i * SeatLayout.rowHeight,
                height: SeatLayout.rowHeight,
                child: Transform.scale(
                  scale: flat || rows.length < 2 ? 1 : 1 - _SeatCanvas.perspective * (1 - i / (rows.length - 1)),
                  child: Stack(
                    children: [
                      for (final seat in rows[i])
                        Positioned(
                          left: layout.seatRects[seat.id]!.left -
                              (seat.couple && seat.number.isEven ? 0 : SeatLayout.gap),
                          top: 0,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: highlight,
                            builder: (context, lit, child) => _SeatTile(
                              seat: seat,
                              partner: seat.couple ? coupleByCode[CouplePairing.partnerCode(seat.code)] : null,
                              state: state,
                              revealIndex: reveal[seat.id],
                              highlighted: lit && seat.couple,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RowLetters extends StatelessWidget {
  const _RowLetters({required this.layout, required this.transform, required this.viewport});

  final SeatLayout layout;
  final Matrix4 transform;
  final Size viewport;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(color: context.tokens.onSurfaceMuted);
    const half = Space.x1;
    return Stack(
      children: [
        for (final entry in layout.rowCentres.entries)
          if (SeatFocus.screenY(transform, entry.value) case final y when y > half && y < viewport.height - half) ...[
            Positioned(left: Space.x0_5, top: y - half, child: Text(layout.rowLetters[entry.key]!, style: style)),
            Positioned(right: Space.x0_5, top: y - half, child: Text(layout.rowLetters[entry.key]!, style: style)),
          ],
      ],
    );
  }
}
