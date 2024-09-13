import 'package:flutter/material.dart';

/// A curve that emulates a refined bounce effect, suitable for iOS-style animations.
class CupertinoBounceCurve extends Curve {
  /// Creates a const instance of [CupertinoBounceCurve].
  const CupertinoBounceCurve();

  // Precalculated constant values
  static const double _p1 = 1.15;
  static const double _p2 = 1.075;

  @override
  double transform(double t) {
    final double u = 1 - t;
    final double tt = t * t;
    final double uu = u * u;
    final double ttt = tt * t;

    // Cubic Bezier calculation
    return 3 * uu * t * _p1 + 3 * u * tt * _p2 + ttt;
  }
}
