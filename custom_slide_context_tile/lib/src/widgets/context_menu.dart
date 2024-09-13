import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  const ContextMenu({
    required this.child,
    required this.actions,
    super.key,
  });

  final Widget child;
  final List<MenuAction> actions;

  bool _validateAction(MenuAction action) => action.label != null;

  @override
  Widget build(BuildContext context) {
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

  Widget buildAction(MenuAction action) => CupertinoContextMenuAction(
        onPressed: action.onPressed,
        isDestructiveAction: action.isDestructive,
        child: buildMenuItemRow(action.label!, action.icon),
      );

  Widget buildMenuItemRow(String label, [IconData? icon]) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          if (icon != null) Icon(icon, size: 18),
        ],
      );
}
