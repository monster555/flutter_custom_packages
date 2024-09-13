import 'dart:math';

import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';

import 'animation_strategy.dart';

class RevealAnimation implements AnimationStrategy {
  BoxConstraints get defaultConstraints => const BoxConstraints(
        minWidth: 64,
        minHeight: 48,
      );

  @override
  Widget buildLeadingActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpand,
  ) {
    // Calculate the overscroll amount
    final overscroll = max(offset - maxOffset, 0);

    // Calculate the total available width including overscroll
    final totalWidth = maxOffset + overscroll;

    double? width;

    return MenuActionScope(
      showLabels: showLabels,
      child: Row(
        children: actions.asMap().entries.map((entry) {
          int index = entry.key;
          Widget action = entry.value;

          if (maxOffset > 0) {
            width = totalWidth / actions.length;
          }

          return ConstrainedBox(
            constraints: defaultConstraints,
            child: SizedBox(
              key: keys[index],
              width: width,
              child: action,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget buildTrailingActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpand,
  ) {
    // Calculate the overscroll amount
    final overscroll = max(-offset - maxOffset, 0);

    // Calculate the total available width including overscroll
    final totalWidth = maxOffset + overscroll;

    double? width;

    return MenuActionScope(
      showLabels: showLabels,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions.asMap().entries.map((entry) {
          int index = entry.key;
          Widget action = entry.value;

          if (maxOffset > 0) {
            width = totalWidth / actions.length;
          }

          return ConstrainedBox(
            constraints: defaultConstraints,
            child: SizedBox(
              key: keys[index],
              width: width,
              child: action,
            ),
          );
        }).toList(),
      ),
    );
  }
}
