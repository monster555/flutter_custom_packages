import 'dart:math' show min;

import 'animation_strategy.dart';

/// A concrete implementation of [AnimationStrategy] that provides a parallax effect
/// for action items in a swipeable menu.
///
/// [ParallaxAnimation] creates a visual effect where action items move at different
/// speeds relative to each other as the menu is swiped, creating a sense of depth
/// and enhancing the user interface's visual appeal.
///
/// This class overrides the [calculateTranslation] method to implement the parallax
/// effect, making each action item move at a speed proportional to its position
/// in the list of actions.
class ParallaxAnimation extends AnimationStrategy {
  @override

  /// Calculates the translation for an action item to create a parallax effect.
  ///
  /// This method determines how much each action item should move based on the
  /// current swipe offset, creating a staggered movement effect.
  ///
  /// - [index] is the index of the current action item in the list of actions.
  /// - [actionCount] is the total number of action items.
  /// - [offset] is the current swipe offset.
  /// - [totalWidth] is the total width available for all action items.
  /// - [isLeading] specifies whether the actions are leading (`true`) or trailing (`false`).
  ///
  /// Returns:
  /// The calculated translation (horizontal movement) for the action item.
  ///
  /// The parallax effect is achieved by:
  /// - For leading actions: Items closer to the edge move faster.
  /// - For trailing actions: Items further from the edge move faster.
  ///
  /// The translation is capped at [totalWidth] to prevent excessive movement.
  double calculateTranslation(
    int index,
    int actionCount,
    double offset,
    double totalWidth,
    bool isLeading,
  ) {
    if (isLeading) {
      // For leading actions, items closer to the edge (higher index) move faster
      return min(
        totalWidth,
        (offset - totalWidth) * (index + 1) / actionCount,
      );
    } else {
      // For trailing actions, items further from the edge (lower index) move faster
      return min(
        totalWidth,
        (offset + totalWidth) * (actionCount - index) / actionCount,
      );
    }
  }
}
