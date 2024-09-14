import 'dart:math';

import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';

abstract class AnimationStrategy {
  /// Default constraints for action items
  BoxConstraints get defaultConstraints => const BoxConstraints(
        minWidth: 64,
        minHeight: 48,
      );

  /// Template method for building actions
  Widget buildActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpandDefaultAction,
    bool isLeading,
  ) {
    final overscroll = calculateOverscroll(offset, maxOffset, isLeading);
    final totalWidth = maxOffset + overscroll;
    double? width = calculateWidth(totalWidth, actions.length, maxOffset);

    return MenuActionScope(
      showLabels: showLabels,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: shouldExpandDefaultAction ? 1 : 0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        builder: (context, animationValue, child) {
          return _buildAnimatedContent(
            offset,
            totalWidth,
            isLeading,
            actions,
            keys,
            width,
            animationValue,
          );
        },
      ),
    );
  }

  /// Calculate overscroll based on offset and maxOffset
  double calculateOverscroll(double offset, double maxOffset, bool isLeading) {
    return isLeading ? max(offset - maxOffset, 0) : max(-offset - maxOffset, 0);
  }

  /// Calculate width for each action item
  double? calculateWidth(double totalWidth, int actionCount, double maxOffset) {
    return maxOffset > 0 ? totalWidth / actionCount : null;
  }

  /// Build animated content (to be implemented by subclasses)
  Widget _buildAnimatedContent(
    double offset,
    double totalWidth,
    bool isLeading,
    List<Widget> actions,
    List<GlobalKey> keys,
    double? width,
    double animationValue,
  ) {
    return Row(
      key: ValueKey<bool>(animationValue > 0),
      mainAxisAlignment:
          isLeading ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: buildActionItems(
        actions,
        keys,
        totalWidth,
        width,
        animationValue,
        isLeading,
        offset,
      ),
    );
  }

  // Build individual action items
  List<Widget> buildActionItems(
    List<Widget> actions,
    List<GlobalKey> keys,
    double totalWidth,
    double? width,
    double animationValue,
    bool isLeading,
    double offset,
  ) {
    return actions.asMap().entries.map((entry) {
      final index = entry.key;
      final action = entry.value;

      final expandedWidth = calculateExpandedWidth(
        index,
        actions.length,
        totalWidth,
        width,
        animationValue,
        isLeading,
      );

      final widgetSize = totalWidth > 0 ? expandedWidth : width;

      Widget actionWidget = SizedBox(
        key: keys[index],
        width: widgetSize,
        child: ConstrainedBox(
          constraints: defaultConstraints,
          child: action,
        ),
      );

      // Apply translation if needed
      double? translation = calculateTranslation(
        index,
        actions.length,
        offset,
        totalWidth,
        isLeading,
      );

      if (translation != null) {
        actionWidget = Transform.translate(
          offset: Offset(translation, 0),
          child: actionWidget,
        );
      }

      return actionWidget;
    }).toList();
  }

  // New abstract method for calculating translation
  double? calculateTranslation(
    int index,
    int actionCount,
    double offset,
    double totalWidth,
    bool isLeading,
  ) {
    return null; // Default implementation returns null (no translation)
  }

  /// Calculate expanded width for each action item
  double calculateExpandedWidth(
    int index,
    int actionCount,
    double totalWidth,
    double? width,
    double animationValue,
    bool isLeading,
  ) {
    return (isLeading && index == 0) || (!isLeading && index == actionCount - 1)
        ? totalWidth - (actionCount - 1) * (width ?? 0.0) * (1 - animationValue)
        : (width ?? 0.0) * (1 - animationValue);
  }

  /// Implement these methods in the concrete classes
  Widget buildLeadingActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpandDefaultAction,
  ) =>
      buildActions(
        actions,
        keys,
        offset,
        maxOffset,
        showLabels,
        shouldExpandDefaultAction,
        true,
      );

  Widget buildTrailingActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpandDefaultAction,
  ) =>
      buildActions(
        actions,
        keys,
        offset,
        maxOffset,
        showLabels,
        shouldExpandDefaultAction,
        false,
      );
}
