import 'dart:math';

import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:custom_slide_context_tile/src/utils/menu_action_scope.dart';
import 'package:flutter/material.dart';

/// An abstract class that defines a strategy for animating action items in a menu.
///
/// [AnimationStrategy] provides a template for building and animating action items,
/// with customizable behavior for leading and trailing actions. It encapsulates
/// the logic for calculating sizes, positions, and animations of menu items based
/// on user interactions such as swiping or dragging.
///
/// This class is designed to be extended by concrete implementations that can
/// provide specific animation behaviors. It includes methods for building actions,
/// calculating overscroll, determining item widths, and applying translations.
///
/// The strategy uses a combination of size calculations and animations to create
/// smooth, interactive menu experiences, suitable for various types of swipe-to-action
/// or expandable menu interfaces.
abstract class AnimationStrategy {
  /// Default constraints for action items.
  ///
  /// These constraints ensure a minimum touch target size for better usability.
  /// The default values provide a minimum width of 64 logical pixels and a
  /// minimum height of 48 logical pixels, which are generally considered good
  /// sizes for touch targets on mobile devices.
  BoxConstraints get defaultConstraints => const BoxConstraints(
        minWidth: 64,
        minHeight: 48,
      );

  /// Builds the animated actions container.
  ///
  /// This method serves as the main template for constructing and animating
  /// a set of action items. It orchestrates the entire process of laying out
  /// and animating the actions based on the current state of the menu.
  ///
  /// [actions] is the list of widget actions to be displayed in the menu.
  /// [keys] is a list of GlobalKeys corresponding to each action for identification.
  /// [offset] represents the current offset of the swipe/drag gesture.
  /// [maxOffset] is the maximum allowed offset for the swipe/drag gesture.
  /// [showLabels] determines whether labels should be shown for the actions.
  /// [shouldExpandDefaultAction] indicates if the default action should be expanded.
  /// [isLeading] specifies whether these are leading (`true`) or trailing (`false`) actions.
  /// [controller] is the [CustomSlidableController] associated with the menu.
  ///
  /// This method calculates the necessary dimensions, applies animations, and
  /// returns a widget tree representing the animated action items.
  Widget buildActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpandDefaultAction,
    bool isLeading,
    CustomSlidableController? controller,
  ) {
    final overscroll = calculateOverscroll(offset, maxOffset, isLeading);
    final totalWidth = maxOffset + overscroll;
    double? width = calculateWidth(totalWidth, actions.length, maxOffset);

    return MenuActionScope(
      showLabels: showLabels,
      isLeading: isLeading,
      shouldExpandDefaultAction: shouldExpandDefaultAction,
      controller: controller,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: shouldExpandDefaultAction ? 1 : 0),
        duration: const Duration(milliseconds: 350),
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

  /// Calculates the overscroll amount based on the current offset and maximum offset.
  ///
  /// [offset] is the current drag offset.
  /// [maxOffset] is the maximum allowed offset.
  /// [isLeading] determines whether the calculation is for leading or trailing actions.
  ///
  /// Returns the amount of overscroll, which occurs when the user drags beyond
  /// the maximum allowed offset. This value is used to create a rubber-band effect
  /// in the UI, providing visual feedback that the limit has been reached.
  double calculateOverscroll(double offset, double maxOffset, bool isLeading) {
    return isLeading ? max(offset - maxOffset, 0) : max(-offset - maxOffset, 0);
  }

  /// Calculates the width for each action item.
  ///
  /// [totalWidth] is the total available width for all actions.
  /// [actionCount] is the number of action items.
  /// [maxOffset] is the maximum allowed offset.
  ///
  /// Returns the calculated width for each action item, or null if no width
  /// constraint should be applied (when maxOffset is 0).
  double? calculateWidth(double totalWidth, int actionCount, double maxOffset) {
    return maxOffset > 0 ? totalWidth / actionCount : null;
  }

  /// Builds the animated content for the actions.
  ///
  /// This method creates a Row with the action items, applying appropriate
  /// animations and transformations.
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

  /// Calculates the translation for an action item.
  ///
  /// This method can be overridden in subclasses to provide custom translation behavior.
  /// By default, it returns null, indicating no translation.
  double? calculateTranslation(
    int index,
    int actionCount,
    double offset,
    double totalWidth,
    bool isLeading,
  ) {
    return null; // Default implementation returns null (no translation)
  }

  /// Calculates the expanded width for an action item during animation.
  ///
  /// This method determines how the width of each action item changes during
  /// the expansion/contraction animation.
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

  /// Builds the leading actions.
  ///
  /// This method should be implemented in concrete subclasses to provide
  /// specific behavior for leading actions. It uses the general [buildActions]
  /// method with `isLeading` set to true.
  ///
  /// [actions], [keys], [offset], [maxOffset], [showLabels],
  /// [shouldExpandDefaultAction] and [controller] are passed through to [buildActions].
  ///
  /// Returns a widget representing the leading actions with appropriate animations.
  Widget buildLeadingActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpandDefaultAction,
    CustomSlidableController? controller,
  ) =>
      buildActions(
        actions,
        keys,
        offset,
        maxOffset,
        showLabels,
        shouldExpandDefaultAction,
        true,
        controller,
      );

  /// Builds the trailing actions.
  ///
  /// This method should be implemented in concrete subclasses to provide
  /// specific behavior for trailing actions. It uses the general [buildActions]
  /// method with `isLeading` set to false.
  ///
  /// [actions], [keys], [offset], [maxOffset], [showLabels],
  /// [shouldExpandDefaultAction] and [controller] are passed through to [buildActions].
  ///
  /// Returns a widget representing the trailing actions with appropriate animations.
  Widget buildTrailingActions(
    List<Widget> actions,
    List<GlobalKey> keys,
    double offset,
    double maxOffset,
    bool showLabels,
    bool shouldExpandDefaultAction,
    CustomSlidableController? controller,
  ) =>
      buildActions(
        actions,
        keys,
        offset,
        maxOffset,
        showLabels,
        shouldExpandDefaultAction,
        false,
        controller,
      );
}
