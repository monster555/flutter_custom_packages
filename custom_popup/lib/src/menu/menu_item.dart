import 'package:custom_popup/src/extensions/navigator_extensions.dart';
import 'package:custom_popup/src/hover_indicator/hover_indicator.dart';
import 'package:custom_popup/src/hover_indicator/hover_listener.dart';
import 'package:custom_popup/src/menu/content_widget.dart';
import 'package:custom_popup/src/menu/menu_element.dart';
import 'package:flutter/material.dart';

/// A widget representing an individual item within a menu.
///
/// The [MenuItem] class extends [MenuElement] and provides the visual
/// representation and behavior for a single menu item. It includes
/// properties for an icon, a label, an onPressed callback, and additional
/// styling options.
///
/// This widget is designed to be used as a child of a custom menu widget,
/// providing a consistent and interactive menu item that responds to user
/// input.
///
/// @see [MenuElement] for the base class.
class MenuItem extends MenuElement {
  /// Creates a [MenuItem] with the specified properties.
  ///
  /// [icon] is the icon to display alongside the menu item's label.
  ///
  /// [label] is the text label for the menu item.
  ///
  /// [isDestructive] indicates whether the menu item represents a destructive action.
  ///
  /// [onPressed] is the callback to invoke when the menu item is pressed.
  ///
  const MenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.isDestructive = false,
  });

  /// The icon displayed in the menu item.
  final IconData icon;

  /// The label displayed in the menu item.
  final String label;

  /// Whether the menu item is destructive.
  ///
  /// Destructive menu items are typically displayed in a different style to indicate
  /// that they perform an action that cannot be undone.
  final bool isDestructive;

  /// The callback function that is called when the menu item is pressed.
  final VoidCallback onPressed;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  // Callback function that is called when the menu item is pressed.
  void _onPressed() => context.pop(widget.onPressed);

  @override
  Widget build(BuildContext context) {
    return HoverListener(
      builder: (isHovered) {
        return HoverIndicator(
          isHovered: isHovered,
          isDestructive: widget.isDestructive,
          child: _MenuItemContent(
            icon: widget.icon,
            label: widget.label,
            isDestructive: widget.isDestructive,
            isHovered: isHovered,
            onPressed: _onPressed,
          ),
        );
      },
    );
  }
}

/// A widget that provides the visual representation of a menu item.
///
/// The [_MenuItemContent] class is a stateless widget that defines how a
/// menu item should be displayed within a menu. It includes properties for
/// an icon, a label, menu type, hover state, destructiveness, and a callback
/// for when the item is pressed.
///
/// This widget is designed to be used internally by [MenuItem] to construct
/// its visual representation, but it can also be used independently if needed.
///
/// @see [MenuItem] for the parent menu item widget.
class _MenuItemContent extends StatelessWidget {
  /// Creates a new [_MenuItemContent].
  ///
  /// [icon] is the icon to display alongside the menu item's label.
  ///
  /// [label] is the text label for the menu item.
  ///
  /// [isHovered] indicates whether the menu item is currently hovered.
  ///
  /// [isDestructive] indicates whether the menu item represents a destructive action.
  ///
  /// [onPressed] is the callback to invoke when the menu item is pressed.
  ///
  ///
  /// ```dart
  /// _MenuItemContent(
  ///   icon: Icons.settings,
  ///   label: 'Settings',
  ///   isHovered: false,
  ///   isDestructive: false,
  ///   onPressed: () {
  ///     // Handle the menu item press
  ///   },
  /// ),
  /// ```
  const _MenuItemContent({
    required this.icon,
    required this.label,
    required this.isHovered,
    required this.isDestructive,
    required this.onPressed,
  });

  /// The icon displayed in the menu item.
  final IconData icon;

  /// The label displayed in the menu item.
  final String label;

  /// Whether the menu item is currently hovered.
  final bool isHovered;

  /// Whether the menu item is destructive.
  final bool isDestructive;

  /// The callback function that is called when the menu item is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    Color color =
        isHovered ? colorScheme.primary : textTheme.labelMedium!.color!;

    if (isDestructive) color = colorScheme.error;

    return ContentWidget(
      color: color,
      icon: icon,
      label: label,
      isHovered: isHovered,
      onPressed: onPressed,
    );
  }
}
