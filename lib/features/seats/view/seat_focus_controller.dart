import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The seat canvas's camera math (sprint 17), pure so it can be unit-tested:
/// where `InteractiveViewer` should look to show the whole hall, or to frame a
/// selection at a comfortable zoom.
abstract final class SeatFocus {
  /// Never zoom further in than this when framing a selection.
  static const comfortableScale = 1.8;

  /// Room left around a framed selection, in canvas units.
  static const margin = 24.0;

  /// Scale and offset that fit [content] into [viewport] (never enlarging),
  /// centred horizontally and starting at the top.
  static Matrix4 fit(Size viewport, Size content) {
    final scale = _fitScale(viewport, content);
    final dx = (viewport.width - content.width * scale) / 2;
    return _matrix(scale, dx, 0);
  }

  /// Scale and offset that centre [target] (a selection's bounds) in [viewport],
  /// at most [comfortableScale] and at least the fit scale, kept inside the canvas.
  static Matrix4 focus(Size viewport, Size content, Rect target) {
    final fitScale = _fitScale(viewport, content);
    final wanted = math.min(
      viewport.width / (target.width + margin * 2),
      viewport.height / (target.height + margin * 2),
    );
    final scale = wanted.clamp(fitScale, math.max(fitScale, comfortableScale)).toDouble();
    final dx = _clampAxis(viewport.width / 2 - target.center.dx * scale, viewport.width, content.width * scale);
    final dy = _clampAxis(viewport.height / 2 - target.center.dy * scale, viewport.height, content.height * scale);
    return _matrix(scale, dx, dy);
  }

  /// The part of the canvas [transform] shows in [viewport], in canvas units.
  static Rect visible(Matrix4 transform, Size viewport) {
    final inverse = Matrix4.inverted(transform);
    return Rect.fromPoints(
      MatrixUtils.transformPoint(inverse, Offset.zero),
      MatrixUtils.transformPoint(inverse, Offset(viewport.width, viewport.height)),
    );
  }

  /// Whether part of [content] is outside the view (the mini-map is useful).
  static bool zoomedIn(Matrix4 transform, Size viewport, Size content) {
    final shown = visible(transform, viewport);
    const slack = 1.0;
    return shown.left > slack ||
        shown.top > slack ||
        shown.right < content.width - slack ||
        shown.bottom < content.height - slack;
  }

  /// Keeps the current zoom and moves so [point] (canvas units) is centred.
  static Matrix4 centreOn(Matrix4 transform, Size viewport, Size content, Offset point) {
    final scale = transform.getMaxScaleOnAxis();
    final dx = _clampAxis(viewport.width / 2 - point.dx * scale, viewport.width, content.width * scale);
    final dy = _clampAxis(viewport.height / 2 - point.dy * scale, viewport.height, content.height * scale);
    return _matrix(scale, dx, dy);
  }

  /// Screen y of canvas y [y] under [transform] (for the sticky row letters).
  static double screenY(Matrix4 transform, double y) => MatrixUtils.transformPoint(transform, Offset(0, y)).dy;

  static double _fitScale(Size viewport, Size content) {
    if (content.isEmpty) return 1;
    return math.min(1, math.min(viewport.width / content.width, viewport.height / content.height));
  }

  /// A scaled canvas larger than the viewport may not show past its edges; a
  /// smaller one is centred.
  static double _clampAxis(double offset, double viewport, double scaled) {
    if (scaled <= viewport) return (viewport - scaled) / 2;
    return offset.clamp(viewport - scaled, 0).toDouble();
  }

  static Matrix4 _matrix(double scale, double dx, double dy) => Matrix4.identity()
    ..translateByDouble(dx, dy, 0, 1)
    ..scaleByDouble(scale, scale, 1, 1);
}
