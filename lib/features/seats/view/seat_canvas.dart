part of 'seat_map_page.dart';

/// The pannable, zoomable hall (sprint 17). Seats sit where [SeatLayout] says,
/// so the camera can frame a selection: after Best seats or the first pick it
/// glides there; double-tap toggles whole hall ↔ selection. Row letters stay on
/// both edges while panning; a mini-map shows where you are when zoomed in.
class _SeatCanvas extends StatefulWidget {
  const _SeatCanvas({required this.state, required this.coupleHighlight});

  final SeatMapReady state;
  final ValueListenable<bool> coupleHighlight;

  /// Rows nearer the screen are this much smaller at most (depth cue).
  static const perspective = 0.06;

  @override
  State<_SeatCanvas> createState() => _SeatCanvasState();
}

class _SeatCanvasState extends State<_SeatCanvas> with SingleTickerProviderStateMixin {
  final _camera = TransformationController();
  late final AnimationController _glide = AnimationController(vsync: this, duration: Motion.extraLong);
  Animation<Matrix4>? _path;
  SeatLayout? _layout;
  Size _viewport = Size.zero;
  int? _fittedShowtime;

  @override
  void initState() {
    super.initState();
    _glide.addListener(() {
      final path = _path;
      if (path != null) _camera.value = path.value;
    });
  }

  @override
  void didUpdateWidget(_SeatCanvas old) {
    super.didUpdateWidget(old);
    final was = old.state;
    final now = widget.state;
    final firstPick = was.selected.isEmpty && now.selected.isNotEmpty;
    final bestPicked = now.revealOrder.isNotEmpty && !listEquals(now.revealOrder, was.revealOrder);
    if (firstPick || bestPicked) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusSelection());
    }
  }

  @override
  void dispose() {
    _glide.dispose();
    _camera.dispose();
    super.dispose();
  }

  /// Glides (or, under reduced motion, jumps) to [target].
  void _moveTo(Matrix4 target) {
    if (!mounted) return;
    if (context.reduceMotion) {
      _camera.value = target;
      return;
    }
    _path = Matrix4Tween(begin: _camera.value.clone(), end: target)
        .animate(CurvedAnimation(parent: _glide, curve: Motion.emphasized));
    _glide.forward(from: 0);
  }

  void _focusSelection() {
    final layout = _layout;
    final bounds = layout?.boundsOf(widget.state.selected);
    if (layout == null || bounds == null || _viewport.isEmpty) return;
    _moveTo(SeatFocus.focus(_viewport, layout.size, bounds));
  }

  void _toggleZoom() {
    final layout = _layout;
    if (layout == null) return;
    final zoomed = SeatFocus.zoomedIn(_camera.value, _viewport, layout.size);
    if (zoomed || widget.state.selected.isEmpty) {
      _moveTo(SeatFocus.fit(_viewport, layout.size));
    } else {
      _focusSelection();
    }
  }

  Offset? _downAt;
  Duration? _downTime;
  Offset? _lastTapAt;
  Duration? _lastTapTime;

  void _pointerDown(PointerDownEvent e) {
    _downAt = e.localPosition;
    _downTime = e.timeStamp;
  }

  /// Two quick taps on empty floor (not on a seat) toggle whole hall ↔ selection.
  void _pointerUp(PointerUpEvent e) {
    final down = _downAt;
    final downTime = _downTime;
    if (down == null || downTime == null) return;
    final isTap = (e.localPosition - down).distance < kTouchSlop && e.timeStamp - downTime < kLongPressTimeout;
    if (!isTap || _onSeat(e.localPosition)) {
      _lastTapAt = null;
      return;
    }
    final last = _lastTapAt;
    final lastTime = _lastTapTime;
    if (last != null &&
        lastTime != null &&
        e.timeStamp - lastTime < kDoubleTapTimeout &&
        (e.localPosition - last).distance < kDoubleTapSlop) {
      _lastTapAt = null;
      _toggleZoom();
    } else {
      _lastTapAt = e.localPosition;
      _lastTapTime = e.timeStamp;
    }
  }

  bool _onSeat(Offset local) {
    final layout = _layout;
    if (layout == null) return false;
    final point = MatrixUtils.transformPoint(Matrix4.inverted(_camera.value), local);
    return layout.seatRects.values.any((r) => r.inflate(SeatLayout.gap).contains(point));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final viewport = constraints.biggest;
      final layout = SeatLayout.of(widget.state.data.seats, minWidth: viewport.width);
      _layout = layout;
      _viewport = viewport;
      // Start each showtime with the whole hall in view.
      if (_fittedShowtime != widget.state.data.showtimeId) {
        _fittedShowtime = widget.state.data.showtimeId;
        _camera.value = SeatFocus.fit(viewport, layout.size);
      }
      // Every child is positioned, so the stack takes the viewport size explicitly.
      return SizedBox.fromSize(
        size: viewport,
        child: Stack(
        children: [
          Positioned.fill(
            // Raw pointers, not a double-tap recognizer: a recognizer would make
            // every seat tap wait ~300 ms to rule out a double tap.
            child: Listener(
              onPointerDown: _pointerDown,
              onPointerUp: _pointerUp,
              child: InteractiveViewer(
                key: const Key('seats.canvas'),
                transformationController: _camera,
                constrained: false,
                minScale: 0.5,
                maxScale: 2.5,
                boundaryMargin: const EdgeInsets.all(Space.x6),
                child: RepaintBoundary(child: _SeatRows(state: widget.state, layout: layout, highlight: widget.coupleHighlight)),
              ),
            ),
          ),
          // Row letters on both edges, following pan and zoom.
          Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: AnimatedBuilder(
                  animation: _camera,
                  builder: (context, _) => _RowLetters(layout: layout, transform: _camera.value, viewport: viewport),
                ),
              ),
            ),
          ),
          // Zooming out never depends on a gesture: a button does it too.
          AnimatedBuilder(
            animation: _camera,
            builder: (context, _) => SeatFocus.zoomedIn(_camera.value, viewport, layout.size)
                ? Positioned(
                    top: 0,
                    left: Space.x2,
                    child: IconButton.filledTonal(
                      key: const Key('seats.fitHall'),
                      tooltip: 'seats.fitHall'.tr(context: context),
                      icon: const Icon(Icons.zoom_out_map),
                      onPressed: () => _moveTo(SeatFocus.fit(viewport, layout.size)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          AnimatedBuilder(
            animation: _camera,
            builder: (context, _) => SeatFocus.zoomedIn(_camera.value, viewport, layout.size)
                ? Positioned(
                    top: Space.x1,
                    right: Space.x1,
                    child: _SeatMinimap(
                      state: widget.state,
                      layout: layout,
                      visible: SeatFocus.visible(_camera.value, viewport),
                      width: viewport.width * 0.25,
                      onJump: (point) => _moveTo(SeatFocus.centreOn(_camera.value, viewport, layout.size, point)),
                    ),
                  )
                : const SizedBox.shrink(),
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
