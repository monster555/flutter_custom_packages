import 'package:custom_popup/src/enums/arrow_direction.dart';
import 'package:custom_popup/src/popup/arrow_painter.dart';
import 'package:flutter/material.dart';

/// A widget that displays customizable popup content with an optional directional arrow.
///
/// [CustomPopupContent] is designed to render a popup box with optional styling
/// and an arrow indicator pointing towards a target. This widget can be used for
/// tooltips, context menus, or any floating element that needs to visually connect
/// with a specific point on the screen.
///
/// The widget supports various customization options including background color,
/// border radius, and arrow visibility. The direction and position of the arrow
/// can be controlled to align with the content and enhance the visual connection
/// with the target.
class CustomPopupContent extends StatelessWidget {
  /// Creates a [CustomPopupContent] widget.
  ///
  /// This constructor initializes the popup content with the given properties. It allows for extensive customization of the popup's appearance and behavior, including its child widget, the visibility and style of the arrow, and the overall decoration of the popup box.
  ///
  /// [child] is the primary content widget to be displayed inside the popup. This
  /// widget represents the main content of the popup.
  ///
  /// [childKey] is a [GlobalKey] assigned to the content widget. This key is
  /// used for precise layout management and positioning.
  ///
  /// [arrowKey] is a [GlobalKey] for the arrow widget, facilitating accurate
  /// placement and rotation based on the specified direction.
  ///
  /// [arrowDirection] specifies the direction of the arrow relative to the
  /// popup content. This affects the visual alignment of the arrow with the target.
  /// Defaults to [ArrowDirection.top].
  ///
  /// [arrowHorizontal] defines the horizontal positioning of the arrow to
  /// ensure it aligns properly with the popup content. This value adjusts the arrow's
  /// horizontal placement.
  ///
  /// [showArrow] is a boolean indicating whether the arrow should be visible.
  /// If set to true, the arrow will be displayed; otherwise, it will be hidden.
  ///
  /// [contentPadding] specifies the padding inside the popup content box.
  /// This controls the spacing between the content and the edges of the popup.
  ///
  /// [backgroundColor] is the background color of the popup content box. If not
  /// provided, defaults to [Colors.white].
  ///
  /// [arrowColor] is The color of the arrow. If not specified, defaults to [Colors.white].
  ///
  /// [contentRadius] is the radius of the popup content box's corners, allowing
  /// for rounded corners. Defaults to 8.0 if not specified.
  ///
  /// [contentDecoration] is an optional [BoxDecoration] for additional styling
  /// of the popup content box, such as borders or gradients.
  ///
  /// ```dart
  /// CustomPopupContent(
  ///   child: Text('This is a popup content'),
  ///   childKey: GlobalKey(),
  ///   arrowKey: GlobalKey(),
  ///   arrowHorizontal: 20.0,
  ///   showArrow: true,
  ///   contentPadding: EdgeInsets.all(12.0),
  ///   backgroundColor: Colors.blue,
  ///   arrowColor: Colors.white,
  ///   contentRadius: 8.0,
  ///   contentDecoration: BoxDecoration(
  ///     border: Border.all(color: Colors.blueAccent),
  ///   ),
  /// )
  /// ```
  /// This example demonstrates how to configure a [CustomPopupContent] widget with a blue background, white arrow, and rounded corners, making it suitable for tooltips or context menus.
  const CustomPopupContent({
    super.key,
    required this.child,
    required this.childKey,
    required this.arrowKey,
    required this.arrowHorizontal,
    required this.showArrow,
    required this.contentPadding,
    this.arrowDirection = ArrowDirection.top,
    this.backgroundColor,
    this.arrowColor,
    this.contentRadius,
    this.contentDecoration,
  });

  final Widget child;
  final GlobalKey childKey;
  final GlobalKey arrowKey;
  final ArrowDirection arrowDirection;
  final double arrowHorizontal;
  final Color? backgroundColor;
  final Color? arrowColor;
  final bool showArrow;
  final EdgeInsets contentPadding;
  final double? contentRadius;
  final BoxDecoration? contentDecoration;

  @override
  Widget build(BuildContext context) {
    final arrowWidget = showArrow
        ? CustomPaint(
            key: const ValueKey('popupArrow'),
            size: const Size(20, 8),
            painter: ArrowPainter(color: arrowColor ?? Colors.white),
          )
        : const SizedBox.shrink();

    return Stack(
      children: [
        SizedBox(
          child: Padding(
            key: childKey,
            padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(
              top: arrowDirection.bottomPadding,
              bottom: arrowDirection.topPadding,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 50),
              child: DecoratedBox(
                decoration: contentDecoration ??
                    BoxDecoration(
                      color: backgroundColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(contentRadius ?? 8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                child: Padding(
                  padding: contentPadding,
                  child: child,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: arrowDirection.topPadding,
          bottom: arrowDirection.bottomPadding,
          left: arrowHorizontal,
          child: RotatedBox(
            key: arrowKey,
            quarterTurns: arrowDirection.quarterTurns,
            child: arrowWidget,
          ),
        ),
      ],
    );
  }
}
