import 'package:custom_popup/custom_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    super.key,
    required this.value,
    this.label,
    this.actions = const [],
  });
  final String value;
  final String? label;
  final List<MenuElement> actions;
  @override
  Widget build(BuildContext context) {
    final GlobalKey iconKey = GlobalKey();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (label != null) ...[
            Text(label!),
            const SizedBox(width: 8.0),
          ],
          Flexible(
            child: CustomPopup.menu(
              anchorKey: iconKey,
              showArrow: false,
              actions: actions,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: CupertinoColors.systemBlue,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Icon(
                        key: iconKey,
                        CupertinoIcons.chevron_up_chevron_down,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
