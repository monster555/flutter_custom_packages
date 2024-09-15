import 'animation_strategy.dart';

/// A concrete implementation of [AnimationStrategy] that provides a reveal-style
/// animation for action items in a swipeable menu.
///
/// [RevealAnimation] creates a visual effect where action items are revealed as if
/// they were always present behind the main content of the swipeable widget. This
/// strategy gives the impression that the actions are uncovered or exposed, rather
/// than sliding in from off-screen.
///
/// This class uses the default implementations provided by [AnimationStrategy]
/// without any overrides. The reveal effect is achieved through the base class's
/// behavior, which naturally exposes the actions as the main content is swiped away.
///
/// Key characteristics:
/// - Actions appear to be stationary behind the main content.
/// - As the user swipes, the actions are gradually exposed.
/// - No additional sliding or movement of the action items themselves.
///
/// Example usage:
/// ```dart
/// final animationStrategy = RevealAnimation();
/// // Use this strategy in a swipeable menu component to create a reveal effect
/// ```
///
/// This animation style is particularly suitable for interfaces where you want
/// to maintain a sense of the actions being an integral part of the widget,
/// rather than additional elements sliding in.
class RevealAnimation extends AnimationStrategy {}
