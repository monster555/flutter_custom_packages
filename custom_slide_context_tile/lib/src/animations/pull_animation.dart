import 'animation_strategy.dart';

/// A concrete implementation of [AnimationStrategy] that provides a pull-style
/// animation for action items in a swipeable menu.
///
/// [PullAnimation] creates a visual effect where all action items move together
/// as a single unit when the menu is swiped. This creates a sensation of pulling
/// or pushing the entire action set into view.
///
/// This class overrides the [calculateTranslation] method to implement the pull
/// effect, ensuring all items move uniformly regardless of their position in the list.
class PullAnimation extends AnimationStrategy {
  @override

  /// Calculates the translation for action items to create a uniform pull effect.
  ///
  /// This method determines how much each action item should move based on the
  /// current swipe offset. In the pull animation, all items move together as a unit.
  ///
  /// Parameters:
  /// - [index] is the index of the current action item in the list of actions.
  ///   (Not used in this implementation as all items move uniformly)
  /// - [actionCount] is the total number of action items.
  ///   (Not used in this implementation as all items move uniformly)
  /// - [offset] is the current swipe offset.
  /// - [totalWidth] is the total width available for all action items.
  /// - [isLeading] specifies whether the actions are leading (true) or trailing (false).
  ///
  /// Returns:
  /// The calculated translation (horizontal movement) for the action items.
  ///
  /// The pull effect is achieved by:
  /// - For leading actions: All items move together from left to right.
  /// - For trailing actions: All items move together from right to left.
  ///
  /// The translation is based on the offset and totalWidth, creating a smooth
  /// pull-in or push-out effect for the entire set of action items.
  double calculateTranslation(
    int index,
    int actionCount,
    double offset,
    double totalWidth,
    bool isLeading,
  ) {
    if (isLeading) {
      // For leading actions, all items move together from left to right
      return offset - totalWidth;
    } else {
      // For trailing actions, all items move together from right to left
      return offset + totalWidth;
    }
  }
}
