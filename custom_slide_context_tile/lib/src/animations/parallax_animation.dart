import 'dart:math' show min;

import 'animation_strategy.dart';

class ParallaxAnimation extends AnimationStrategy {
  @override
  double calculateTranslation(
    int index,
    int actionCount,
    double offset,
    double totalWidth,
    bool isLeading,
  ) {
    if (isLeading) {
      return min(
        totalWidth,
        (offset - totalWidth) * (index + 1) / actionCount,
      );
    } else {
      return min(
        totalWidth,
        (offset + totalWidth) * (actionCount - index) / actionCount,
      );
    }
  }
}
