import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The seat canvas's fit math (sprint 17), pure so it can be unit-tested:
/// how to scale and place the hall so all of it is in view.
abstract final class SeatFocus {
  /// Scale and offset that fit [content] into [viewport] (never enlarging),
  /// centred horizontally and starting at the top.
  static Matrix4 fit(Size viewport, Size content) {
    final scale = _fitScale(viewport, content);
    final dx = (viewport.width - content.width * scale) / 2;
    return _matrix(scale, dx, 0);
  }

  /// The part of the canvas [transform] shows in [viewport], in canvas units.
  static Rect visible(Matrix4 transform, Size viewport) {
    final inverse = Matrix4.inverted(transform);
    return Rect.fromPoints(
      MatrixUtils.transformPoint(inverse, Offset.zero),
      MatrixUtils.transformPoint(inverse, Offset(viewport.width, viewport.height)),
    );
  }

  /// Screen y of canvas y [y] under [transform] (for the row letters).
  static double screenY(Matrix4 transform, double y) => MatrixUtils.transformPoint(transform, Offset(0, y)).dy;

  static double _fitScale(Size viewport, Size content) {
    if (content.isEmpty) return 1;
    return math.min(1, math.min(viewport.width / content.width, viewport.height / content.height));
  }

  static Matrix4 _matrix(double scale, double dx, double dy) => Matrix4.identity()
    ..translateByDouble(dx, dy, 0, 1)
    ..scaleByDouble(scale, scale, 1, 1);
}
