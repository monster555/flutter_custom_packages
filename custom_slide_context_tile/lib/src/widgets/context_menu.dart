import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A widget that creates a context menu with customizable actions.
///
/// [ContextMenu] wraps a child widget and provides a context menu (typically
/// activated by long-press) with a list of custom actions. It uses the
/// [CupertinoContextMenu] internally to provide a native-looking context menu
/// on iOS, while still being usable on other platforms.
class ContextMenu extends StatelessWidget {
  /// Creates a [ContextMenu] widget.
  ///
  /// [child] is the widget that will be wrapped by the context menu.
  /// [actions] is a list of [MenuAction]s that will be displayed in the context menu.
  const ContextMenu({
    required this.child,
    required this.actions,
    super.key,
  });

  /// The widget to be wrapped by the context menu.
  final Widget child;

  /// The list of actions to be displayed in the context menu.
  final List<MenuAction> actions;

  /// Validates a [MenuAction] to ensure it has a label.
  ///
  /// Returns true if the action has a non-null label, false otherwise.
  bool _validateAction(MenuAction action) => action.label != null;

  @override
  Widget build(BuildContext context) {
    // Filter and map valid actions
    final validActions =
        actions.where(_validateAction).map(buildAction).toList();

    return CupertinoContextMenu(
      key: UniqueKey(),
      actions: validActions,
      child: Material(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width,
          ),
          child: child,
        ),
      ),
    );
  }

  /// Builds a [CupertinoContextMenuAction] from a [MenuAction].
  ///
  /// This method creates the individual action items for the context menu,
  /// applying the appropriate styling and behavior based on the [MenuAction]
  /// properties.
  Widget buildAction(MenuAction action) => CupertinoContextMenuAction(
        onPressed: action.onPressed,
        isDestructiveAction: action.isDestructive,
        child: buildMenuItemRow(action.label!, action.icon),
      );

  /// Builds a row widget for a menu item, combining label and icon.
  ///
  /// This method creates a consistent layout for each menu item, displaying
  /// the label and an optional icon.
  ///
  /// [label] is the text to display for the menu item.
  /// [icon] is an optional icon to display alongside the label.
  Widget buildMenuItemRow(String label, [IconData? icon]) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          if (icon != null) Icon(icon, size: 18),
        ],
      );
}
