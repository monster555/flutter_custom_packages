import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';

class MenuAction extends StatefulWidget {
  const MenuAction({
    required this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.isDestructive = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final String? label;
  final bool isDestructive;

  @override
  State<MenuAction> createState() => _MenuActionState();
}

class _MenuActionState extends State<MenuAction> {
  @override
  Widget build(BuildContext context) {
    final showLabel =
        (widget.label != null && MenuActionScope.of(context).showLabels);

    final backgroundColor =
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return InkWell(
      onTap: widget.onPressed,
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
