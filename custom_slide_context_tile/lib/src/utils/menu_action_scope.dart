import 'package:custom_slide_context_tile/src/controller/custom_slidable_controller.dart';
import 'package:flutter/widgets.dart';

/// A widget that provides menu action configuration to its descendants.
///
/// [MenuActionScope] uses the [InheritedWidget] mechanism to efficiently
/// propagate menu-related configuration down the widget tree. This allows
/// descendant widgets to access shared menu action settings without explicitly
/// passing them through constructors.
///
/// Currently, it provides information about whether labels should be shown
/// for menu actions.
class MenuActionScope extends InheritedWidget {
  /// Determines whether labels should be shown for menu actions.
  ///
  /// If true, descendant widgets should display labels alongside icons
  /// or other visual representations of menu actions.
  final bool showLabels;

  /// The controller that is used to close the menu when an action is executed.
  ///
  /// If null, the menu will not be closed.
  final CustomSlidableController? controller;

  /// Indicates whether this action is a leading action.
  ///
  /// If true, the action is positioned on the leading edge of the slidable widget.
  /// If false, it's positioned on the trailing edge.
  final bool isLeading;

  /// Determines whether the default action should be expanded.
  ///
  /// When true, the action widget should adjust its layout or appearance
  /// to indicate that it's the default action that will be triggered
  /// if the slide gesture continues beyond a certain threshold.
  final bool shouldExpandDefaultAction;

  /// Creates a [MenuActionScope] widget.
  ///
  /// The [showLabels] parameter must not be null.
  /// The [child] parameter is required and represents the widget subtree
  /// that can access this scope.
  const MenuActionScope({
    super.key,
    required this.showLabels,
    this.shouldExpandDefaultAction = false,
    this.controller,
    this.isLeading = false,
    required super.child,
  });

  /// Retrieves the nearest [MenuActionScope] instance from the given build context.
  ///
  /// This method is typically used by descendant widgets to access the current
  /// menu action configuration, including whether labels should be shown,
  /// the controller for closing the menu, whether the action is leading or trailing,
  /// and if the default action should be expanded.
  ///
  /// Usage:
  /// ```dart
  /// final scope = MenuActionScope.of(context);
  /// bool shouldShowLabels = scope.showLabels;
  /// bool isLeadingAction = scope.isLeading;
  /// bool shouldExpand = scope.shouldExpandDefaultAction;
  /// CustomSlidableController? controller = scope.controller;
  /// ```
  ///
  /// You can use these properties to adjust the appearance and behavior of your menu actions.
  ///
  /// Throws an assertion error if no [MenuActionScope] is found in the widget tree.
  static MenuActionScope of(BuildContext context) {
    final MenuActionScope? result =
        context.dependOnInheritedWidgetOfExactType<MenuActionScope>();
    assert(result != null, 'No MenuActionScope found in context');
    return result!;
  }

  /// Determines whether dependent widgets should rebuild when this widget updates.
  ///
  /// This method is called by the framework to determine if widgets that depend
  /// on this [MenuActionScope] should rebuild when it changes.
  ///
  /// Returns true if [showLabels], [controller], [isLeading] or [shouldExpandDefaultAction]
  /// has changed, indicating that dependent widgets need to rebuild to reflect the
  /// new configuration.
  @override
  bool updateShouldNotify(MenuActionScope oldWidget) =>
      showLabels != oldWidget.showLabels ||
      controller != oldWidget.controller ||
      isLeading != oldWidget.isLeading ||
      shouldExpandDefaultAction != oldWidget.shouldExpandDefaultAction;
}
