import 'dart:math' show max, min;

import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';

import 'animation_strategy.dart';

class ParallaxAnimation implements AnimationStrategy {
  ParallaxAnimation();

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
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: shouldExpand ? 1 : 0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        builder: (context, animationValue, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;

              if (maxOffset > 0) {
                width = totalWidth / actions.length;
              }

              final expandedWidth = index == 0
                  ? totalWidth -
                      (actions.length - 1) *
                          (width ?? 0.0) *
                          (1 - animationValue)
                  : (width ?? 0.0) * (1 - animationValue);

              final translation = min(
                totalWidth,
                (offset - totalWidth) * (index + 1) / actions.length,
              );

              final widgetSize = totalWidth > 0 ? expandedWidth : width;

              return Transform.translate(
                offset: Offset(translation, 0),
                child: SizedBox(
                  key: keys[index],
                  width: widgetSize,
                  child: ConstrainedBox(
                    constraints: defaultConstraints,
                    child: action,
                  ),
                ),
              );
            }).toList(),
          );
        },
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
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: shouldExpand ? 1 : 0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        builder: (context, animationValue, child) {
          return Row(
            key: ValueKey<bool>(shouldExpand),
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;

              if (maxOffset > 0) {
                width = totalWidth / actions.length;
              }

              final expandedWidth = index == actions.length - 1
                  ? totalWidth -
                      (actions.length - 1) *
                          (width ?? 0.0) *
                          (1 - animationValue)
                  : (width ?? 0.0) * (1 - animationValue);

              // Calculate translation
              final translation = min(
                totalWidth,
                (offset + totalWidth) *
                    (actions.length - index) /
                    actions.length,
              );

              final widgetSize = totalWidth > 0 ? expandedWidth : width;

              return Transform.translate(
                offset: Offset(translation, 0),
                child: SizedBox(
                  key: keys[index],
                  width: widgetSize,
                  child: ConstrainedBox(
                    constraints: defaultConstraints,
                    child: action,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
