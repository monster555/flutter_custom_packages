import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';

/// A widget that represents an action item in a menu.
///
/// [MenuAction] is typically used within a custom menu or action list, providing
/// a consistent look and behavior for interactive menu items. It supports an icon,
/// an optional label, custom background color, and can be styled as a destructive action.
class MenuAction extends StatefulWidget {
  /// Creates a [MenuAction] widget.
  ///
  /// [onPressed] is the callback function to be executed when the action is tapped.
  /// [icon] is the IconData to be displayed for this action.
  /// [label] is an optional text label for the action.
  /// [backgroundColor] is an optional custom background color for the action item.
  /// [isDestructive] indicates whether this action should be styled as destructive.
  const MenuAction({
    required this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.isDestructive = false,
    super.key,
  });

  /// The callback function to be called when the action is tapped.
  final VoidCallback onPressed;

  /// The icon to be displayed for this action.
  final IconData icon;

  /// The background color of the action item. If null, defaults to the scaffold background color.
  final Color? backgroundColor;

  /// The text label for the action. May be null if no label is desired.
  final String? label;

  /// Whether this action should be styled as a destructive action.
  final bool isDestructive;

  @override
  State<MenuAction> createState() => _MenuActionState();
}

class _MenuActionState extends State<MenuAction> {
  @override
  Widget build(BuildContext context) {
    final menuActionScope = MenuActionScope.of(context);
    // Determine whether to show the label based on the MenuActionScope and if a label is provided
    final showLabel = (widget.label != null && menuActionScope.showLabels);

    // Get the controller from the MenuActionScope
    final controller = menuActionScope.controller;

    // Use the provided background color or default to the scaffold background color
    final backgroundColor =
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return InkWell(
      onTap: () {
        widget.onPressed();
        controller?.close();
      },
      child: Material(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon),
                if (showLabel)
                  Text(
                    widget.label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
