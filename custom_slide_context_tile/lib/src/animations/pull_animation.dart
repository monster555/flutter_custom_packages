import 'animation_strategy.dart';

/// Concrete implementation for PullAnimation
class PullAnimation extends AnimationStrategy {
  @override
  double calculateTranslation(
    int index,
    int actionCount,
    double offset,
    double totalWidth,
    bool isLeading,
  ) {
    if (isLeading) {
      return offset - totalWidth;
    } else {
      return offset + totalWidth;
    }
  }
}
