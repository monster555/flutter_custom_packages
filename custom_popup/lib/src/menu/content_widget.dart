import 'package:flutter/material.dart';

/// A widget that displays a clickable content area with an icon and label.
///
/// [ContentWidget] is designed to provide a customizable content area that
/// includes an icon and a label. It supports hover effects and click interactions.
/// This widget is ideal for use in menus, toolbars, or any UI component where
/// an icon with associated text is needed.
class ContentWidget extends StatefulWidget {
  /// Constructs a new instance of [ContentWidget].
  ///
  /// This widget is specifically designed for use in menu items, providing a
  /// cohesive content area that combines an icon and a label. The icon serves as
  /// a visual indicator, while the label provides the necessary textual
  /// description, ensuring clear communication of each menu item's function.
  ///
  /// [ContentWidget] supports interactive features such as hover effects and
  /// click functionality. The hover effect is visually subtle, while the click
  /// action triggers the specified callback, facilitating user interaction
  /// within the menu context.
  ///
  /// [color] is the color of the icon and label.
  /// [isHovered] is a flag that indicates the hover state of the widget.
  /// [icon] is the icon to be displayed.
  /// [label] is the text label for the widget.
  /// [onPressed] is the callback function executed when the widget is pressed.
  ///
  /// This widget is ideal for creating intuitive and accessible menu interfaces,
  /// where each item is clearly defined by both an icon and a label.
  const ContentWidget({
    super.key,
    required this.color,
    required this.isHovered,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  /// The color of the icon and label text.
  final Color color;

  /// A boolean indicating whether the widget is currently hovered.
  final bool isHovered;

  /// The icon to be displayed.
  final IconData icon;

  /// The text label to be displayed next to the icon.
  final String label;

  /// A callback that is called when the widget is tapped.
  final VoidCallback onPressed;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  /// Returns the button theme data for the current context.
  ButtonThemeData get buttonTheme => ButtonTheme.of(context);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: widget.color.withOpacity(0.2),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(8.0),
      onTap: widget.onPressed,
      child: SizedBox(
        height: buttonTheme.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.color,
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              Flexible(
                child: Text(
                  widget.label,
                  style: TextStyle(color: widget.color),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
