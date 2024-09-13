import 'package:custom_popup/src/animations/cupertino_bounce_curve.dart';
import 'package:custom_popup/src/enums/arrow_direction.dart';
import 'package:custom_popup/src/popup/custom_popup_content.dart';
import 'package:custom_popup/src/popup/size_change_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A custom popup route that displays a popup widget at a specific location on the screen.
///
/// The popup can optionally include an arrow pointing to a target widget, and it
/// supports customizable content, appearance, and animations. This route is used
/// to display the `CustomPopup` widget in a flexible and dynamic way, positioning
/// it relative to a target rectangle ([targetRect]) within the viewport.
///
/// The route can be dismissed by tapping outside the popup or by pressing the
/// back button.
class CustomPopupRoute extends PopupRoute<VoidCallback?> {
  /// Creates a [CustomPopupRoute] with the specified [context], [child], and positioning properties.
  ///
  /// [child] is the widget to display inside the popup.
  /// [targetRect] is the rectangle of the target widget to which the popup is anchored.
  /// [showArrow] determines whether to display an arrow pointing to the target.
  /// [contentPadding] is the padding inside the popup content.
  /// [backgroundColor] is the background color of the popup.
  /// [arrowColor] is the color of the arrow.
  /// [contentRadius] is the radius of the popup's corners.
  /// [contentDecoration] is the custom decoration for the popup content.
  /// [barrierColor] is the color of the barrier that appears behind the popup.
  CustomPopupRoute(
    this.context, {
    required this.child,
    required this.targetRect,
    required this.showArrow,
    required this.contentPadding,
    super.settings,
    super.filter,
    super.traversalEdgeBehavior,
    this.backgroundColor,
    this.arrowColor,
    this.contentRadius,
    this.contentDecoration,
    Color? barrierColor,
  }) : _barrierColor = barrierColor;

  /// The [BuildContext] of the widget that is pushing the route.
  final BuildContext context;

  /// The rectangle of the target widget to which the popup is anchored.
  final Rect targetRect;

  /// The widget to display inside the popup.
  final Widget child;

  /// The background color of the popup.
  final Color? backgroundColor;

  /// The color of the arrow pointing to the target.
  final Color? arrowColor;

  /// Determines whether to display an arrow pointing to the target.
  final bool showArrow;

  /// The padding inside the popup content.
  final EdgeInsets contentPadding;

  /// The radius of the popup's corners.
  final double? contentRadius;

  /// Custom decoration for the popup content.
  final BoxDecoration? contentDecoration;

  /// The color of the barrier that appears behind the popup.
  final Color? _barrierColor;

  /// The keys for the child and arrow widgets in the popup.
  late final GlobalKey _childKey = GlobalKey();
  late final GlobalKey _arrowKey = GlobalKey();

  /// The rectangle representing the viewport's boundaries.
  late Rect _viewportRect = _calculateViewportRect();

  /// The alignment for scaling animations
  late double _scaleAlignDx = 0.5;
  late double _scaleAlignDy = 0.5;

  /// The direction in which the arrow is pointing.
  ArrowDirection _arrowDirection = ArrowDirection.top;

  /// The horizontal position of the arrow within the child widget.
  double _arrowHorizontal = 0.0;

  /// The top and left position of the popup.
  double? _top;
  double? _left;

  /// The arrow may be set to be visible or not using the [showArrow] property.
  /// There may be some cases where [showArrow] is `true` but there's no enough
  /// space to show the arrow. In that case, we set [_shouldShowArrow] to `false`
  /// so that the arrow won't be shown.
  bool? _shouldShowArrow;

  /// The margin between the popup and the viewport edges.
  static const double _margin = 8.0;

  @override
  Color? get barrierColor => _barrierColor ?? Colors.black12;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'CustomPopupRoute';

  @override
  TickerFuture didPush() {
    super.offstage = true;

    // Schedule a callback to calculate the popup's position after the current frame.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      calculatePopupPosition();
      super.offstage = false;
    });

    // Set whether the arrow should be shown.
    _shouldShowArrow = showArrow;
    return super.didPush();
  }

  /// Calculates the rectangle representing the viewport's boundaries.
  ///
  /// This method considers the device's screen size and safe area insets
  /// to compute the viewport rectangle, which is the area available for
  /// positioning the popup, excluding margins.
  ///
  /// Returns a [Rect] representing the viewport's boundaries.
  Rect _calculateViewportRect() {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);

    // Calculate the viewport rectangle with margins applied.
    return Rect.fromLTWH(
      _margin,
      padding.top + _margin,
      size.width - _margin * 2,
      size.height - padding.top - padding.bottom - _margin * 2,
    );
  }

  /// Calculates the position of the popup relative to the target rectangle.
  ///
  /// This method computes the appropriate offset for the popup and the
  /// arrow based on the available space and the dimensions of the popup
  /// and arrow. It ensures that the popup and arrow are positioned within
  /// the viewport's boundaries.
  void calculatePopupPosition() {
    final childRect =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    final arrowRect =
        _arrowKey.currentContext?.findRenderObject() as RenderBox?;

    // Return early if the child or arrow render objects are not found.
    if (childRect == null || arrowRect == null) return;

    final childSize = childRect.size;
    final arrowSize = arrowRect.size;

    // Calculate the offsets for the child and arrow widgets.
    _calculateChildOffset(childSize);
    _calculateArrowOffset(arrowSize, childSize);
  }

  /// Calculates the horizontal position of the arrow within the popup.
  ///
  /// This method determines the horizontal position of the arrow relative
  /// to the popup, ensuring that it is properly aligned with the target
  /// rectangle and that it fits within the popup's width.
  ///
  /// [arrowSize] is the size of the arrow widget.
  /// [childSize] is the size of the popup widget.
  void _calculateArrowOffset(Size arrowSize, Size childSize) {
    assert(_margin >= 0 && arrowSize.width >= 0 && childSize.width >= 0,
        'Invalid arguments');
    // Calculate the left edge of the popup, centered on the target rectangle.
    double leftEdge = targetRect.center.dx - childSize.width / 2;
    leftEdge = leftEdge.clamp(
        _viewportRect.left, _viewportRect.right - childSize.width);

    // Calculate the horizontal center of the arrow relative to the left edge of the popup.
    double center = targetRect.center.dx - leftEdge - arrowSize.width / 2;
    _arrowHorizontal = center.clamp(_margin * 2, childSize.width - _margin * 2);

    // Calculate the horizontal alignment for scaling animations.
    _scaleAlignDx = (_arrowHorizontal + arrowSize.width / 2) / childSize.width;
  }

  /// Calculates the vertical position of the popup relative to the target rectangle.
  ///
  /// This method positions the popup either above or below the target rectangle,
  /// depending on the available space. It also determines whether the arrow
  /// should be shown and calculates the vertical alignment for scaling animations.
  ///
  /// [childSize] is the size of the popup widget.
  void _calculateChildOffset(Size childSize) {
    assert(childSize.width >= 0 && childSize.height >= 0, 'Invalid child size');

    // Calculate the available space above and below the target rectangle.
    final double topHeight = targetRect.top - _viewportRect.top;
    final double bottomHeight = _viewportRect.bottom - targetRect.bottom;

    if (topHeight > bottomHeight) {
      // More space is available above the target rectangle.
      _arrowDirection = ArrowDirection.bottom;
      if (topHeight >= childSize.height) {
        // Enough space above the target to fit the child.
        _top = targetRect.top - childSize.height;
        _scaleAlignDy = (targetRect.top - _top!) / childSize.height;
        _shouldShowArrow = true;
      } else {
        // Close to the top edge of the viewport.
        _top = _viewportRect.top;
        _scaleAlignDy = (targetRect.top - _top!) / childSize.height;
        _shouldShowArrow = false;
      }
    } else {
      // More space is available below the target rectangle.
      _arrowDirection = ArrowDirection.top;
      if (bottomHeight >= childSize.height) {
        // Enough space below the target to fit the child.
        _top = targetRect.bottom;
        _scaleAlignDy = (targetRect.top - _top!) / (childSize.height * 4);
        _shouldShowArrow = true;
      } else {
        // Close to the bottom edge of the viewport.
        _top = _viewportRect.bottom - childSize.height + 4.0;
        _scaleAlignDy = (targetRect.top - _top!) / (childSize.height * 0.75);
        _shouldShowArrow = false;
      }
    }

    // Center the popup horizontally on the target rectangle.
    double left = targetRect.center.dx - childSize.width / 2;

    // Ensure the child is within the horizontal bounds of the viewport
    _left = left.clamp(_margin, _viewportRect.right - childSize.width);
  }

  /// Handles changes to the size of the popup's content.
  ///
  /// This method recalculates the viewport rectangle and the popup's position
  /// after the current frame. It also ensures that the context can be popped
  /// if necessary.
  void _onSizeChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewportRect = _calculateViewportRect();
      calculatePopupPosition();
    });

    // if (context.mounted) {
    //   // Use the Navigator to pop the top route if it's a PopupRoute
    //   Navigator.of(context).popUntil((route) => route is! PopupRoute);
    // }
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      child;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Wrap the child widget with the custom popup content.
    child = CustomPopupContent(
      childKey: _childKey,
      arrowKey: _arrowKey,
      arrowHorizontal: _arrowHorizontal,
      arrowDirection: _arrowDirection,
      backgroundColor: backgroundColor,
      arrowColor: arrowColor,
      showArrow: showArrow && (_shouldShowArrow ?? false),
      contentPadding: contentPadding,
      contentRadius: contentRadius,
      contentDecoration: contentDecoration,
      child: child,
    );

    // If the animation is not completed, apply fade and scale transitions.
    if (!animation.isCompleted) {
      final isForward = animation.status.isForwardOrCompleted;
      final curve = isForward ? const CupertinoBounceCurve() : Curves.easeInOut;

      child = FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          alignment: FractionalOffset(_scaleAlignDx, _scaleAlignDy),
          scale: animation.drive(CurveTween(curve: curve)),
          child: child,
        ),
      );
    }

    // Get the size of the media query to use for positioning constraints.
    final size = MediaQuery.sizeOf(context);

    // Build the popup content using a stack with a positioned child.
    return SizeChangeListener(
      onSizeChanged: (size) => _onSizeChanged(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: _left,
            top: _top,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width - _margin,
              ),
              child: Material(
                color: Colors.transparent,
                type: MaterialType.transparency,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: size.height,
                      maxWidth: size.width,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 200);
}
