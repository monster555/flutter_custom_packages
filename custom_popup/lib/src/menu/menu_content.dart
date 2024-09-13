import 'package:flutter/material.dart';

/// A widget that represents a scrollable menu content area.
///
/// [MenuContent] is designed to provide a scrollable container for a list of
/// action widgets. It supports optional constraints for minimum width and maximum
/// height. This widget is useful for creating dropdown menus or context menus
/// where the content needs to be scrollable and have a defined boundary.
class MenuContent extends StatelessWidget {
  /// Creates a [MenuContent].
  ///
  /// [actions] is a list of widgets to be displayed within the menu content area.
  ///   These are the action items that will be presented to the user.
  /// [minWidth] is the minimum width of the menu content. If not specified,
  ///   the width will adjust to the content's width or the available space.
  /// [maxHeight] is the maximum height of the menu content. If not specified,
  ///   the height will be determined by the content's height or the available space.
  ///
  /// The widget will adjust its size according to the provided constraints and
  /// the size of its content. It includes padding and a border radius for visual
  /// appearance.
  const MenuContent({
    required this.actions,
    super.key,
    this.minWidth,
    this.maxHeight,
  });

  /// A list of widgets to be displayed within the menu content area.
  final List<Widget> actions;

  /// The minimum width of the menu content. If specified, the width of the content
  /// area will not be less than this value.
  final double? minWidth;

  /// The maximum height of the menu content. If specified, the height of the content
  /// area will not exceed this value.
  final double? maxHeight;

  /// The default border radius for the menu content.
  static const BorderRadius _defaultBorderRadius = BorderRadius.all(
    Radius.circular(16.0),
  );

  /// The default padding for the menu content.
  static const EdgeInsets _defaultPadding = EdgeInsets.all(8.0);

  @override
  Widget build(BuildContext context) {
    Widget child = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight != null
            ? maxHeight! - 16.0
            : MediaQuery.sizeOf(context).height,
        minWidth: minWidth != null && minWidth! > 16.0 ? minWidth! - 16.0 : 0.0,
      ),
      child: SingleChildScrollView(
        child: IntrinsicWidth(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: _defaultPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: _defaultBorderRadius,
      child: child,
    );
  }
}
