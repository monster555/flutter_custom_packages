import 'package:flutter/material.dart';

/// A widget that provides a visual indication of hover state with optional styling
/// for destructive actions.
///
/// [HoverIndicator] is designed to enhance user interfaces by applying a background
/// color when the user hovers over the widget. The background color can be customized
/// based on the hover state and whether the widget represents a destructive
/// action (e.g., a delete button).
///
/// The widget uses an [AnimatedContainer] to smoothly transition between states,
/// making it ideal for interactive elements where visual feedback is important.
/// The transition duration can be adjusted to control the speed of the color
/// change effect.
class HoverIndicator extends StatelessWidget {
  /// Creates a [HoverIndicator] widget.
  ///
  /// This constructor initializes the hover indicator with the specified parameters.
  /// It allows customization of the hover effect, transition duration, and whether
  /// the hover state is associated with a destructive action.
  ///
  /// [child] is the widget that is wrapped by the hover indicator. This is the
  /// primary content that will display the hover effect.
  ///
  /// [duration] is the duration of the hover effect animation. This controls how
  /// quickly the background color transitions when the hover state changes.
  /// Defaults to 100 milliseconds.
  ///
  /// [isHovered] is a boolean indicating whether the widget is currently being
  /// hovered over. If true, the background color will be applied; otherwise,
  /// it will be transparent. Defaults to false.
  ///
  /// [isDestructive] is a boolean that specifies whether the hover effect should
  /// use a color associated with destructive actions (e.g., red). If true,
  /// a color associated with error or danger will be used; otherwise, a primary
  /// color will be applied. Defaults to false.
  const HoverIndicator({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.isHovered = false,
    this.isDestructive = false,
  });

  /// The widget that is wrapped by the hover indicator.
  final Widget child;

  /// The duration of the hover effect animation.
  final Duration duration;

  /// A boolean indicating whether the widget is currently being hovered over.
  final bool isHovered;

  /// A boolean that specifies whether the hover effect should use a color
  /// associated with destructive actions.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // The color of the hover effect is determined by the hover state and
    // whether the widget represents a destructive action.
    final color = isHovered
        ? (isDestructive ? colorScheme.error : colorScheme.primary)
            .withValues(alpha: 0.1)
        : Colors.transparent;

    return AnimatedContainer(
      duration: duration,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }
}
