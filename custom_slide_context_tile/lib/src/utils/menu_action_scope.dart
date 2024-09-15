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

  /// Creates a [MenuActionScope] widget.
  ///
  /// The [showLabels] parameter must not be null.
  /// The [child] parameter is required and represents the widget subtree
  /// that can access this scope.
  const MenuActionScope({
    super.key,
    required this.showLabels,
    required super.child,
  });

  /// Retrieves the nearest [MenuActionScope] instance from the given build context.
  ///
  /// This method is typically used by descendant widgets to access the current
  /// menu action configuration.
  ///
  /// Usage:
  /// ```dart
  /// bool shouldShowLabels = MenuActionScope.of(context).showLabels;
  /// ```
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
  /// Returns true if [showLabels] has changed, indicating that dependent
  /// widgets need to rebuild to reflect the new configuration.
  @override
  bool updateShouldNotify(MenuActionScope oldWidget) =>
      showLabels != oldWidget.showLabels;
}
