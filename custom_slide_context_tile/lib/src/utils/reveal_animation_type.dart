/// Defines the types of reveal animations available for slidable actions.
///
/// This enum represents different animation styles that can be applied when
/// revealing action items in a slidable widget. Each type provides a distinct
/// visual effect, allowing for customization of the user interface experience.
enum RevealAnimationType {
  /// Standard reveal animation.
  ///
  /// In this animation style, action items are revealed as if they were
  /// always present behind the main content. As the user swipes, the actions
  /// are gradually exposed without any additional movement of their own.
  ///
  /// This is suitable for interfaces where you want to maintain a sense of
  /// the actions being an integral part of the widget.
  reveal,

  /// Parallax animation effect.
  ///
  /// In this animation style, action items move at different speeds relative
  /// to each other as the menu is swiped, creating a sense of depth and
  /// enhancing the visual appeal.
  ///
  /// Typically, items closer to the edge move faster than those further away,
  /// creating a dynamic and engaging reveal effect.
  parallax,

  /// Pull animation effect.
  ///
  /// In this animation style, all action items move together as a single unit
  /// when the menu is swiped. This creates a sensation of pulling or pushing
  /// the entire action set into view.
  ///
  /// This style is useful for emphasizing that the actions are a cohesive set
  /// and can provide a strong visual cue for the availability of additional options.
  pull,
}
